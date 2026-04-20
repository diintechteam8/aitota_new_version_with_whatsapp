import 'package:aitota_business/core/app-export.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/services/api_endpoints.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../core/services/role_provider.dart';
import '../../../../data/model/auth_models/google_profiles_response.dart';
import '../../../../data/model/auth_models/email_login_model.dart';
import '../../../../data/model/auth_models/check_email_model.dart';
import '../../../../data/model/auth_models/forgot_password_model.dart';
import '../../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final GoogleSignIn _googleSignIn = Get.find<GoogleSignIn>();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxString errorMessage = ''.obs;
  final GetStorage storage = GetStorage();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailLoginFormKey = GlobalKey<FormState>();
  String _currentGoogleIdToken = '';

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      await _googleSignIn.signOut();
      GoogleSignInAccount? googleUser;
      try {
        googleUser = await _googleSignIn.signIn();
      } catch (e, stackTrace) {
        print("========= GOOGLE SIGN-IN INTERACTION ERROR =========");
        print("Error: $e");
        print("Stack Trace: $stackTrace");
        print("====================================================");
        return;
      }

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      
      // 🟢 DEBUG: Print Google Credentials
      print("========= GOOGLE SIGN-IN CREDENTIALS =========");
      print("Google User ID: ${googleUser.id}");
      print("Google User Email: ${googleUser.email}");
      print("Google User Display Name: ${googleUser.displayName}");
      print("Google ID Token: ${googleAuth.idToken}");
      print("Google Access Token: ${googleAuth.accessToken}");
      print("==============================================");

      if (googleAuth.idToken == null)
        throw Exception('Google authentication failed');

      // ✅ Store the token for later use
      _currentGoogleIdToken = googleAuth.idToken!;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      print("Checking email status for: ${googleUser.email}");
      // ✅ Call checkEmail first to see if registration needs to continue or OTP is required
      final checkEmailResponse = await apiService.checkEmail(CheckEmailRequest(
        email: googleUser.email,
        clientId: Constants.clientId,
      ));

      if (checkEmailResponse.success == true) {
        if (checkEmailResponse.nextStep == 'step1_verify_email_otp') {
          print("Redirecting to Email OTP verification based on checkEmail response");
          Get.snackbar('Verification Required',
              checkEmailResponse.message ?? 'Verify your email using the OTP sent to your inbox.');
          Get.toNamed(AppRoutes.emailOtpScreen, arguments: {
            'email': googleUser.email,
            'clientId': Constants.clientId,
          });
          return;
        } else if (checkEmailResponse.nextStep == 'step2_send_mobile_otp') {
          print("Redirecting to Mobile verification based on checkEmail response");
          Get.snackbar('Verification Required',
              checkEmailResponse.message ?? 'Continue with mobile number verification.');
          Get.toNamed(AppRoutes.mobileVerifyScreen, arguments: {
            'email': googleUser.email,
            'clientId': Constants.clientId,
          });
          return;
        } else if (checkEmailResponse.action == 'login') {
          print("Direct login from checkEmail based on response action");
          // Handle like a direct login if token exists
          if (checkEmailResponse.token != null) {
            await secureStorage.write(key: Constants.token, value: checkEmailResponse.token!);
            
            final roleToSave = checkEmailResponse.userType == 'humanAgent' ? 'executive' : checkEmailResponse.userType ?? 'client';
            await secureStorage.write(key: 'userRole', value: roleToSave);
            Get.find<RoleProvider>().setRole(roleToSave);

            // Ensure profileId is saved for MoreController and others
            String? profileIdToSave = checkEmailResponse.user?.id;

            if (profileIdToSave != null) {
              await secureStorage.write(key: Constants.profileId, value: profileIdToSave);
              print('💾 Saved profileId from checkEmail: $profileIdToSave');
            } else {
              print('⚠️ WARNING: Could not find a profileId to save from checkEmail!');
            }

            // Mark as logged in
            await secureStorage.write(key: 'isLoggedIn', value: 'true');
            print('💾 Saved isLoggedIn: true');

            // Save profile completed status for SplashController
            await storage.write(
              Constants.isProfileCompleted,
              checkEmailResponse.user?.profileCompleted ?? false,
            );

            // ✅ Clear any pending registration steps since login is successful
            await secureStorage.delete(key: Constants.lastAuthStep);
            await secureStorage.delete(key: Constants.lastAuthData);

            if (checkEmailResponse.user?.profileCompleted == true) {
              if (checkEmailResponse.clientApproved == true) {
                if (checkEmailResponse.userType == 'admin') {
                   Get.offAllNamed(AppRoutes.adminClientsScreen);
                } else {
                   Get.offAllNamed(AppRoutes.bottomBarScreen);
                }
              } else {
                Get.offAllNamed(AppRoutes.pendingApprovalScreen);
              }
              return;
            }
          }
        }
      }

      print("Sending request with token: ${googleAuth.idToken}");
      final response = await apiService.getGoogleProfiles(googleAuth.idToken!);
      if (response.success == true) {
        await _handleGoogleProfilesResponse(response, googleUser.id);
      } else {
        throw Exception('Google login failed or token missing');
      }
    } catch (e, stackTrace) {
      print("========= GOOGLE SIGN-IN PROCESS ERROR =========");
      print("Error during Google Sign In: $e");
      print("Stack Trace: $stackTrace");
      print("================================================");
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleGoogleProfilesResponse(
      GoogleProfilesResponse response, String googleId) async {
    // ✅ Save basic session data
    await _saveBasicSession(response, googleId);

    // ✅ Check if single profile or auto-onboard
    if (response.singleProfile == true || response.autoOnboard == true) {
      // Direct login flow for single profile
      await _handleDirectLogin(response);
    } else if (response.profiles != null && response.profiles!.isNotEmpty) {
      // Multiple profiles - navigate to profile selection
      // ✅ Pass the actual Google ID token, not the Google user ID
      Get.toNamed(
        AppRoutes.profileSelectScreen,
        arguments: {
          'googleIdToken': _currentGoogleIdToken
        }, // Pass the actual token
      );
    } else {
      throw Exception('No profiles found');
    }
  }

  Future<void> _handleDirectLogin(GoogleProfilesResponse response) async {
    await storage.write(
      Constants.isProfileCompleted,
      response.isprofileCompleted ?? false,
    );

    print(
        'isProfileCompleted: ${response.isprofileCompleted}, isApproved: ${response.isApproved}');

    // ✅ FIX: Store the access token from Google response when singleProfile is true
    if (response.token != null && response.token!.isNotEmpty) {
      await secureStorage.write(key: Constants.token, value: response.token!);
      print('LoginController - Stored access token: ${response.token}');
    }

    // ✅ FIX: Use the appropriate profileId based on the role for direct login too
    String? profileIdToSave;

    if (response.userType == 'humanAgent') {
      profileIdToSave = response.humanAgentProfileId;
      print(
          'LoginController - Direct login as human agent, using humanAgentProfileId: $profileIdToSave');
    } else {
      profileIdToSave = response.profileId ?? response.profileId;
      print(
          'LoginController - Direct login as client, using clientProfileId: ${response.profileId} or fallback profileId: ${response.profileId}');
    }

    if (profileIdToSave != null && profileIdToSave.isNotEmpty) {
      await secureStorage.write(
          key: Constants.profileId, value: profileIdToSave);
      print('LoginController - Updated profileId in storage: $profileIdToSave');
    }

    // ✅ Only mark as logged in if approved
    if (response.isApproved == true) {
      await secureStorage.write(key: 'isLoggedIn', value: 'true');
    } else {
      await secureStorage.write(key: 'isLoggedIn', value: 'false');
    }

    // ✅ Persistence: Save role to storage for Splash screen
    if (response.userType != null) {
      final roleToSave = response.userType! == 'humanAgent' ? 'executive' : response.userType!;
      await secureStorage.write(key: 'userRole', value: roleToSave);
      Get.find<RoleProvider>().setRole(roleToSave);
    }

    // ✅ Navigation flow
    if (response.isprofileCompleted == true) {
      if (response.isApproved == true) {
        // ✅ Role-Based Navigation: Admin goes to Client selection
        if (response.userType == 'admin') {
          print('LoginController - Admin approved, navigating to admin clients');
          Get.offAllNamed(AppRoutes.adminClientsScreen);
        } else {
          Get.offAllNamed(AppRoutes.bottomBarScreen); // Approved Client/Executive
        }
      } else {
        Get.offAllNamed(AppRoutes.pendingApprovalScreen); // Awaiting approval
      }
    } else {
      Get.toNamed(AppRoutes.compeletProfileScreen); // Profile incomplete
    }
  }

  Future<void> _saveBasicSession(
      GoogleProfilesResponse response, String googleId) async {
    await secureStorage.write(key: Constants.googleId, value: googleId);

    if (response.id != null) {
      await secureStorage.write(key: Constants.id, value: response.id!);
    }

    if (response.profileId != null) {
      await secureStorage.write(
          key: Constants.profileId, value: response.profileId);
    }

    // ✅ Store the access token from Google response when available
    if (response.token != null && response.token!.isNotEmpty) {
      await secureStorage.write(key: Constants.token, value: response.token!);
      print(
          'LoginController - Stored access token in basic session: ${response.token}');
    }

    // ✅ Set role based on userType from Google profiles response (only for single profile)
    if (response.userType != null && response.singleProfile == true) {
      final roleToSave = response.userType! == 'humanAgent' ? 'executive' : response.userType!;
      await secureStorage.write(key: 'userRole', value: roleToSave);
      Get.find<RoleProvider>().setRole(roleToSave);
    }
  }

  // 📧 New navigation for Email Login/Signup
  void navigateToEmailLogin() {
    Get.toNamed(AppRoutes.emailLoginScreen);
  }

  Future<void> loginWithEmail() async {
    if (!(emailLoginFormKey.currentState?.validate() ?? false)) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Try to parse password as int if it's purely numeric
      dynamic passwordValue = passwordController.text;
      if (RegExp(r'^\d+$').hasMatch(passwordValue)) {
        passwordValue = int.tryParse(passwordValue) ?? passwordValue;
      }

      final request = EmailLoginRequest(
        email: emailController.text.trim(),
        password: passwordValue,
        clientId: Constants.clientId,
      );

      final response = await apiService.loginWithEmail(request);

      print('====== EMAIL LOGIN RESPONSE ======');
      print('Response Data: ${response.toJson()}');
      print('==================================');

      if (response.success == true) {
        // ✅ Save session
        if (response.token != null) {
          await secureStorage.write(key: Constants.token, value: response.token!);
        }
        if (response.user?.id != null) {
          await secureStorage.write(key: Constants.id, value: response.user!.id!);
        }
        
        // Ensure profileId is saved for MoreController and others
        String? profileIdToSave;
        if (response.user?.profile != null) {
          profileIdToSave = response.user!.profile!['id'] ?? response.user!.profile!['_id'];
        }
        if (profileIdToSave == null && response.userId != null) {
          profileIdToSave = response.userId;
        }

        if (profileIdToSave != null) {
          await secureStorage.write(key: Constants.profileId, value: profileIdToSave);
        }

        // Mark user as logged in for SplashController
        await secureStorage.write(key: 'isLoggedIn', value: 'true');
        
        // Save profile completed status for SplashController
        await storage.write(
          Constants.isProfileCompleted,
          response.user?.profileCompleted ?? false,
        );

        // ✅ Clear any pending registration steps since login is successful
        await secureStorage.delete(key: Constants.lastAuthStep);
        await secureStorage.delete(key: Constants.lastAuthData);

        // ✅ Set role based on userType from Email response
        if (response.userType != null) {
          final roleToSave = response.userType! == 'humanAgent' ? 'executive' : response.userType!;
          await secureStorage.write(key: 'userRole', value: roleToSave);
          Get.find<RoleProvider>().setRole(roleToSave);
        }

        // ✅ Handle navigation based on nextStep
        if (response.nextStep == 'step1_verify_email_otp') {
          Get.snackbar('Success', response.message ?? 'Login successful. Please verify your email.');
          // Navigate to OTP screen
          Get.toNamed(AppRoutes.emailOtpScreen, arguments: {
            'email': emailController.text.trim(),
            'clientId': Constants.clientId,
          });
        } else if (response.user?.profileCompleted == true) {
          Get.snackbar('Success', response.message ?? 'Login successful');
          
          // ✅ Role-Based Navigation: Admin goes to Client selection
          if (response.userType == 'admin') {
            print('LoginController (Email) - Admin approved, navigating to admin clients');
            Get.offAllNamed(AppRoutes.adminClientsScreen);
          } else {
            Get.offAllNamed(AppRoutes.bottomBarScreen); // Approved Client/Executive
          }
        } else {
          Get.snackbar('Success', response.message ?? 'Login successful');
          Get.toNamed(AppRoutes.compeletProfileScreen);
        }
      } else {
        errorMessage.value = '';
        Get.snackbar(
          'Error',
          response.message ?? 'Login failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorConstants.redColor.withOpacity(0.1),
          colorText: ColorConstants.redColor,
        );
        print("Login Error: ${response.message}");
      }
    } catch (e) {
      errorMessage.value = '';
      String error = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'Error',
        error,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorConstants.redColor.withOpacity(0.1),
        colorText: ColorConstants.redColor,
      );
      print("Login Exception: $error");
    } finally {
      isLoading.value = false;
    }
  }

  void onForgotPassword() {
    Get.toNamed(AppRoutes.forgotPasswordScreen);
  }

  Future<void> forgotPasswordRequest() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email to continue.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorConstants.redColor.withOpacity(0.1),
        colorText: ColorConstants.redColor,
      );
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final request = ForgotPasswordRequest(
        email: email,
        clientId: Constants.clientId,
      );

      print('--- Forgot Password Request API Call ---');
      print('URL: ${ApiEndpoints.newBaseUrl}${ApiEndpoints.forgotPasswordRequest}');
      print('Request Data: ${request.toJson()}');

      final response = await apiService.forgotPasswordRequest(request);

      if (response.success == true) {
        Get.snackbar(
          'Success',
          response.message ?? 'Password reset code sent to your email.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorConstants.appThemeColor.withOpacity(0.1),
          colorText: ColorConstants.colorHeading,
        );
        // Navigate to OTP verification screen with isForgotPassword flag
        Get.toNamed(AppRoutes.emailOtpScreen, arguments: {
          'email': email,
          'isForgotPassword': true,
        });
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to send password reset code.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorConstants.redColor.withOpacity(0.1),
          colorText: ColorConstants.redColor,
        );
      }
    } catch (e) {
      String error = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'Error',
        error,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorConstants.redColor.withOpacity(0.1),
        colorText: ColorConstants.redColor,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToRegister() {
    Get.toNamed(AppRoutes.registerStep1Screen);
  }
}
