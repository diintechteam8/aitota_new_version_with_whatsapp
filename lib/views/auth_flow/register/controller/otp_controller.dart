import 'dart:convert';
import 'dart:async';
import 'package:aitota_business/core/app-export.dart';
import '../../../../core/services/api_endpoints.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../data/model/auth_models/otp_models.dart';
import '../../../../data/model/auth_models/forgot_password_model.dart';
import '../../../../routes/app_routes.dart';

class OtpController extends GetxController {
  final ApiService _apiService = ApiService(dio: DioClient().dio);
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Common
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt resendTimer = 30.obs;
  final RxBool isForgotPassword = false.obs;
  Timer? _timer;

  // Email OTP
  final emailOtpController = TextEditingController();
  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> otpFocusNodes =
      List.generate(6, (index) => FocusNode());
  final RxString userEmail = ''.obs;

  // Mobile Verification
  final mobileNumberController = TextEditingController();
  final mobileOtpController = TextEditingController();
  final List<TextEditingController> mobileOtpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> mobileOtpFocusNodes =
      List.generate(6, (index) => FocusNode());
  final RxBool isMobileOtpSent = false.obs;
  final RxString selectedMethod = 'whatsapp'.obs;

  void setOtpMethod(String method) {
    selectedMethod.value = method;
  }

  void navigateToForgotPasswordEmail() {
    Get.toNamed(AppRoutes.forgotPasswordScreen);
  }

  @override
  void onInit() {
    super.onInit();
    startResendTimer();
    // Get email from arguments if available
    if (Get.arguments != null && Get.arguments['email'] != null) {
      userEmail.value = Get.arguments['email'];
    }
    if (Get.arguments != null && Get.arguments['isForgotPassword'] != null) {
      isForgotPassword.value = Get.arguments['isForgotPassword'];
    }
  }

  void startResendTimer() {
    resendTimer.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  // --- Email OTP ---

  Future<void> verifyEmailOtp() async {
    String otp = otpControllers.map((e) => e.text).join();
    if (otp.length < 6) {
      errorMessage.value = 'Please enter a valid 6-digit OTP';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (isForgotPassword.value) {
        final request = VerifyForgotPasswordOtpRequest(
          email: userEmail.value,
          clientId: Constants.clientId,
          otp: otp,
        );

        print('--- Verify Forgot Password OTP API Call ---');
        print('URL: ${ApiEndpoints.newBaseUrl}${ApiEndpoints.verifyForgotPasswordOtp}');
        print('Request Data: ${request.toJson()}');

        final response = await _apiService.verifyForgotPasswordOtp(request);

        if (response.success == true) {
          Get.snackbar('Success', response.message ?? 'OTP verified successfully');
          // Navigate to Reset Password Screen with resetToken
          Get.offNamed(AppRoutes.resetPasswordScreen, arguments: {
            'email': userEmail.value,
            'resetToken': response.resetToken,
          });
        } else {
          errorMessage.value = response.message ?? 'Failed to verify OTP';
        }
      } else {
        final request = VerifyEmailOtpRequest(
          email: userEmail.value,
          otp: otp,
          clientId: Constants.clientId,
        );

        print('--- Verify Email OTP API Call ---');
        print('URL: ${ApiEndpoints.newBaseUrl}${ApiEndpoints.verifyEmailOtp}');
        print('Request Data: ${request.toJson()}');

        final response = await _apiService.verifyEmailOtp(request);

        if (response.success == true) {
          Get.snackbar('Success', response.message ?? 'Email verified successfully');

          if (response.nextStep == 'step2_send_mobile_otp') {
            print('--- Saving Auth Step: ${AppRoutes.mobileVerifyScreen} ---');
            await _secureStorage.write(
                key: Constants.lastAuthStep, value: AppRoutes.mobileVerifyScreen);
            await _secureStorage.write(
                key: Constants.lastAuthData,
                value: jsonEncode({'email': userEmail.value}));

            Get.toNamed(AppRoutes.mobileVerifyScreen,
                arguments: {'email': userEmail.value});
          } else {
            // Fallback
            Get.toNamed(AppRoutes.compeletProfileScreen);
          }
        } else {
          errorMessage.value = response.message ?? 'Verification failed';
        }
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendEmailOtp() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (isForgotPassword.value) {
        final request = ForgotPasswordRequest(
          email: userEmail.value,
          clientId: Constants.clientId,
        );

        print('--- Forgot Password Resend OTP API Call ---');
        print('URL: ${ApiEndpoints.newBaseUrl}${ApiEndpoints.forgotPasswordResendOtp}');
        print('Request Data: ${request.toJson()}');

        final response = await _apiService.forgotPasswordResendOtp(request);

        if (response.success == true) {
          Get.snackbar('Success', response.message ?? 'OTP resent successfully');
          startResendTimer();
        } else {
          errorMessage.value = response.message ?? 'Failed to resend OTP';
        }
      } else {
        final request = ResendEmailOtpRequest(
          email: userEmail.value,
          clientId: Constants.clientId,
        );

        print('--- Resend Email OTP API Call ---');
        print('URL: ${ApiEndpoints.newBaseUrl}${ApiEndpoints.resendEmailOtp}');
        print('Request Data: ${request.toJson()}');

        final response = await _apiService.resendEmailOtp(request);

        if (response.success == true) {
          Get.snackbar('Success', response.message ?? 'OTP resent successfully');
          startResendTimer();
        } else {
          errorMessage.value = response.message ?? 'Failed to resend OTP';
        }
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  // --- Mobile OTP ---

  Future<void> sendMobileOtp() async {
    if (mobileNumberController.text.isEmpty) {
      errorMessage.value = 'Please enter a mobile number';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final request = SendMobileOtpRequest(
        email: userEmail.value,
        mobileNumber: mobileNumberController.text.trim(),
        clientId: Constants.clientId,
        otpMethode: selectedMethod.value,
      );

      final response = await _apiService.sendMobileOtp(request);

      if (response.success == true) {
        isMobileOtpSent.value = true;
        startResendTimer();
        Get.snackbar('Success', response.message ?? 'OTP sent to mobile');
      } else {
        errorMessage.value = response.message ?? 'Failed to send OTP';
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyMobileOtp() async {
    String otp = mobileOtpControllers.map((e) => e.text).join();
    if (otp.length < 6) {
      errorMessage.value = 'Please enter a valid 6-digit OTP';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final request = VerifyMobileOtpRequest(
        email: userEmail.value,
        otp: otp,
        clientId: Constants.clientId,
      );

      final response = await _apiService.verifyMobileOtp(request);

      if (response.success == true) {
        Get.snackbar(
            'Success', response.message ?? 'Mobile verified successfully');

        // Final step: Complete Profile
        print('--- Saving Auth Step: ${AppRoutes.compeletProfileScreen} ---');
        await _secureStorage.write(
            key: Constants.lastAuthStep, value: AppRoutes.compeletProfileScreen);
        await _secureStorage.write(
            key: Constants.lastAuthData,
            value: jsonEncode({
              'email': userEmail.value,
              'phone': mobileNumberController.text.trim()
            }));

        Get.offAllNamed(AppRoutes.compeletProfileScreen, arguments: {
          'email': userEmail.value,
          'phone': mobileNumberController.text.trim()
        });
      } else {
        errorMessage.value = response.message ?? 'Verification failed';
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    emailOtpController.dispose();
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var n in otpFocusNodes) {
      n.dispose();
    }
    mobileNumberController.dispose();
    mobileOtpController.dispose();
    for (var c in mobileOtpControllers) {
      c.dispose();
    }
    for (var n in mobileOtpFocusNodes) {
      n.dispose();
    }
    super.onClose();
  }
}
