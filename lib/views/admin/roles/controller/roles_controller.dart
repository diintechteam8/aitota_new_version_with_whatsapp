import 'package:aitota_business/core/app-export.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../core/services/role_provider.dart';
import '../../../../data/model/auth_models/get_all_profiles_model.dart';
import '../../../../data/model/auth_models/switch_role_response.dart';
import '../../../../routes/app_routes.dart';

class RolesController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final RxBool isLoading = false.obs;
  final RxList<GetAllProfilesModelProfile> profiles =
      <GetAllProfilesModelProfile>[].obs;
  final Rx<GetAllProfilesModelProfile?> selectedProfile =
      Rx<GetAllProfilesModelProfile?>(null);
  final RxBool isSwitchingRole = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfiles();
  }

  Future<void> loadProfiles() async {
    try {
      isLoading.value = true;
      final response = await apiService.getAllProfiles();

      if (response.success == true && response.profiles != null) {
        profiles.assignAll(response.profiles!);
        await _setCurrentRoleAsSelected();
      } else {
        throw Exception('Failed to load profiles');
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _setCurrentRoleAsSelected() async {
    try {
      final secureStorage = const FlutterSecureStorage();
      final currentId = await secureStorage.read(key: Constants.id);

      if (currentId != null && profiles.isNotEmpty) {
        final currentProfile =
            profiles.firstWhereOrNull((profile) => profile.id == currentId);
        selectedProfile.value = currentProfile ?? profiles.first;
      } else {
        selectedProfile.value = profiles.first;
      }
    } catch (e) {
      selectedProfile.value = profiles.first;
      rethrow;
    }
  }

  void selectProfile(GetAllProfilesModelProfile profile) {
    selectedProfile.value = profile;
  }

  bool get canSwitchRole {
    if (selectedProfile.value == null) return false;
    final secureStorage = const FlutterSecureStorage();
    final currentIdFuture = secureStorage.read(key: Constants.id);
    final currentId = currentIdFuture;
    return currentId != null && selectedProfile.value!.id != currentId;
  }
// ─────────────────────────────────────────────────────────────────────────────
//  Inside RolesController  →  switchRole()
// ─────────────────────────────────────────────────────────────────────────────
Future<void> switchRole() async {
  if (selectedProfile.value == null) return;

  try {
    isSwitchingRole.value = true;

    final profile = selectedProfile.value!;
    final payload = {
      'role': profile.role,
      'id': profile.id,
      'clientId': profile.clientId,
      'clientUserId': profile.clientUserId,
      'clientName': profile.clientName,
      'email': profile.email,
      'isApproved': profile.isApproved,
      'isprofileCompleted': profile.isProfileCompleted,
    };

    final response = await apiService.switchRole(payload);

    if (response.success == true) {
      await _handleSuccessfulRoleSwitch(response);

      // ──────  NEW LOGIC  ──────
      final isAdmin = profile.role?.toLowerCase() == 'admin';

      if (isAdmin) {
        // Replace everything and go to the admin-only screen
        Get.toNamed(AppRoutes.adminClientsScreen);   // <-- add this route in AppRoutes
      } else {
        // Existing flow for every other role
        Get.offAllNamed(AppRoutes.bottomBarScreen);
      }
      // ─────────────────────────
    } else {
      throw Exception('Failed to switch role');
    }
  } catch (e) {
    rethrow;
  } finally {
    isSwitchingRole.value = false;
  }
}

  Future<void> _handleSuccessfulRoleSwitch(SwitchRoleResponse response) async {
    final secureStorage = const FlutterSecureStorage();
    final storage = GetStorage();

    if (response.token != null && response.token!.isNotEmpty) {
      await secureStorage.write(key: Constants.token, value: response.token!);
    }

    if (response.id != null && response.id!.isNotEmpty) {
      await secureStorage.write(key: Constants.id, value: response.id!);
    }

    String? profileIdToSave;
    if (response.userType == 'humanAgent') {
      profileIdToSave = response.humanAgentProfileId;
    } else if (response.userType == 'client') {
      profileIdToSave = response.profileId;
    }

    if (profileIdToSave != null && profileIdToSave.isNotEmpty) {
      await secureStorage.write(
          key: Constants.profileId, value: profileIdToSave);
    }

    storage.write(
        Constants.isProfileCompleted, response.isprofileCompleted ?? false);

    if (response.userType != null) {
      Get.find<RoleProvider>().setRole(response.userType! == 'humanAgent'
          ? 'executive'
          : response.userType!);
    }
  }
}
