import 'package:aitota_business/core/app-export.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../data/model/auth_models/google_profiles_response.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/services/role_provider.dart';

class ProfileSelectController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final RxBool isLoading = false.obs;

  final RxList<SelectableProfile> profiles = <SelectableProfile>[].obs;
  final Rxn<SelectableProfile> selected = Rxn<SelectableProfile>();

  late final String googleIdToken;

  @override
  void onInit() {
    super.onInit();
    googleIdToken = Get.arguments?['googleIdToken'] ?? '';
    loadProfiles();
  }

  Future<void> loadProfiles() async {
    try {
      isLoading.value = true;

      print(
          'ProfileSelectController - Calling getGoogleProfiles with token: $googleIdToken');
      final res = await apiService.getGoogleProfiles(googleIdToken);

      print('ProfileSelectController - Response received:');
      print('  success: ${res.success}');
      print('  singleProfile: ${res.singleProfile}');
      print('  autoOnboard: ${res.autoOnboard}');
      print('  userType: ${res.userType}');
      print('  profiles count: ${res.profiles?.length ?? 0}');

      if (res.profiles != null) {
        for (int i = 0; i < res.profiles!.length; i++) {
          final profile = res.profiles![i];
          print('  Profile $i:');
          print('    userType: ${profile.userType}');
          print('    role: ${profile.role}');
          print('    name: ${profile.name}');
          print('    email: ${profile.email}');
          print('    isApproved: ${profile.isApproved}');
          print('    isprofileCompleted: ${profile.isprofileCompleted}');
        }
      }

      if (res.singleProfile == true || res.autoOnboard == true) {
        await _handleTokenAndNavigate(res);
        return;
      }

      profiles.assignAll(res.profiles ?? []);
      selected.value = null;
    } catch (e) {
      print('ProfileSelectController - Error: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void selectProfile(SelectableProfile item) {
    print(
        'ProfileSelectController - Selecting profile: ${item.userType} - ${item.role}');
    selected.value = item;
    print(
        'ProfileSelectController - Selected profile updated: ${selected.value?.userType} - ${selected.value?.role}');
  }

  Future<void> confirmSelection() async {
    final current = selected.value;
    if (current == null) {
      return;
    }
    try {
      isLoading.value = true;

      final payload = {
        'token': googleIdToken,
        ...current.toJson(),
      };

      print(
          'ProfileSelectController - Calling selectGoogleProfile with payload: $payload');
      final res = await apiService.selectGoogleProfile(payload);
      
      print('ProfileSelectController - selectGoogleProfile Response:');
      print('  success: ${res.success}');
      print('  token exists: ${res.token != null && res.token!.isNotEmpty}');
      print('  token body: ${res.token}');
      
      await _handleTokenAndNavigate(res);
    } catch (e) {
      print('ProfileSelectController - Error in confirmSelection: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleTokenAndNavigate(GoogleProfilesResponse res) async {
    final secureStorage = const FlutterSecureStorage();
    final storage = GetStorage();

    // Determine UserType
    final String? effectiveUserType = res.userType ?? selected.value?.userType;

    // ✅ First try res.token, otherwise check res.tokens for the specific role
    String? tokenToSave = res.token;
    if (tokenToSave == null || tokenToSave.isEmpty) {
      if (effectiveUserType == 'humanAgent') {
        tokenToSave = res.tokens?.humanAgentToken;
      } else if (effectiveUserType == 'client') {
        tokenToSave = res.tokens?.clientToken;
      } else if (effectiveUserType == 'admin') {
        tokenToSave = res.tokens?.adminToken;
      }
    }

    // ✅ Fallback to Google ID Token if backend gives NO token at all
    if (tokenToSave == null || tokenToSave.isEmpty) {
      tokenToSave = googleIdToken;
      print('⚠️ Backend returned no token. Falling back to googleIdToken.');
    }

    if (tokenToSave != null && tokenToSave.isNotEmpty) {
      await secureStorage.write(key: Constants.token, value: tokenToSave);
      print('💾 Saved token: $tokenToSave');
    } else {
      print('⚠️ WARNING: No token found in response to save!');
    }

    // Use selected profile ID as fallback
    final String? effectiveId = res.id ?? selected.value?.id;
    if (effectiveId != null && effectiveId.isNotEmpty) {
      await secureStorage.write(key: Constants.id, value: effectiveId);
    }

    String? profileIdToSave;
    if (effectiveUserType == 'humanAgent') {
      profileIdToSave = res.humanAgentProfileId ?? selected.value?.id;
      print(
          'ProfileSelectController - Human agent selected, using humanAgentProfileId: $profileIdToSave');
    } else {
      profileIdToSave = res.clientProfileId ?? res.profileId ?? selected.value?.id;
      print(
          'ProfileSelectController - Client selected, using fallback profileId: $profileIdToSave');
    }

    if (profileIdToSave != null && profileIdToSave.isNotEmpty) {
      await secureStorage.write(
          key: Constants.profileId, value: profileIdToSave);
      print(
          'ProfileSelectController - Updated profileId in storage: $profileIdToSave');
    } else {
      print(
          'ProfileSelectController - Warning: No profileId found for role $effectiveUserType');
    }

    if (effectiveUserType != null) {
      final roleToSave =
          effectiveUserType == 'humanAgent' ? 'executive' : effectiveUserType;
      await secureStorage.write(key: 'userRole', value: roleToSave);
      Get.find<RoleProvider>().setRole(roleToSave);
    }

    // Persist availability of admin token for UI (More screen section)
    final String? adminToken = res.tokens?.adminToken;
    final bool hasAdminToken = adminToken != null && adminToken.isNotEmpty;
    storage.write(Constants.hasAdminToken, hasAdminToken);
    if (hasAdminToken) {
      storage.write(Constants.adminToken, adminToken);
    }

    // ✅ Determine Approval Status
    final bool isApproved = res.isApproved ?? selected.value?.isApproved ?? false;

    if (isApproved) {
      await secureStorage.write(key: 'isLoggedIn', value: 'true');
      print('💾 Saved isLoggedIn: true');
    } else {
      await secureStorage.write(key: 'isLoggedIn', value: 'false');
    }

    // Use response value, but fallback to the selected profile's value if it's null
    final isCompleted = res.isprofileCompleted ?? selected.value?.isprofileCompleted ?? false;
    
    storage.write(Constants.isProfileCompleted, isCompleted);

    // ✅ Clear any pending registration steps since login is successful
    await secureStorage.delete(key: Constants.lastAuthStep);
    await secureStorage.delete(key: Constants.lastAuthData);

    if (res.userType == 'admin') {
      print(
          'ProfileSelectController - Admin user selected, navigating to admin clients screen');
      Get.offAllNamed(AppRoutes.adminClientsScreen, arguments: {
        'googleIdToken': googleIdToken,
      });
      return;
    }

    if (isCompleted) {
      if (res.isApproved == true || selected.value?.isApproved == true) {
        Get.offAllNamed(AppRoutes.bottomBarScreen);
      } else {
        Get.offAllNamed(AppRoutes.pendingApprovalScreen);
      }
    } else {
      Get.offAllNamed(AppRoutes.compeletProfileScreen);
    }
  }
}
