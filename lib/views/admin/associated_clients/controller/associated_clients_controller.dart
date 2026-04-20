import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/services/role_provider.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../data/model/more/get_team_clients.dart';
import '../../../../data/model/auth_models/switch_role_response.dart';
import '../../../../routes/app_routes.dart';

class AssociatedClientsController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
final RxBool isLoading = false.obs;
  final RxList<Association> associatedClients = <Association>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAssociatedClients();
  }

  Future<void> loadAssociatedClients() async {
    try {
      isLoading.value = true;

      print('AssociatedClientsController - Calling getAssociatedClients API');
      final response = await apiService.getAssociatedClients();

      print('AssociatedClientsController - Response received:');
      print('  success: ${response.success}');
      print('  clients count: ${response.associations?.length ?? 0}');

      if (response.success == true && response.associations != null) {
        associatedClients.assignAll(response.associations!);
        print(
            'AssociatedClientsController - Loaded ${associatedClients.length} associated clients');
      } else {
        associatedClients.clear();
        throw Exception('Failed to load associated clients');
      }
    } catch (e) {
      print('AssociatedClientsController - Error: $e');
      associatedClients.clear();
      throw e; // Re-throw as requested
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> switchToClient(Association client) async {
    try {
      isLoading.value = true;

      final payload = {
        'role': 'client',
        'id': client.clientId,
        'clientId': client.clientId,
        'clientUserId': client.clientUserId,
        'clientName': client.clientName,
        'isApproved': client.isApproved,
        'isprofileCompleted': client.isProfileCompleted,
      };

      print(
          'AssociatedClientsController - Calling switchRole with payload: $payload');
      final response = await apiService.switchRole(payload);

      if (response.success == true) {
        await _handleSuccessfulRoleSwitch(response);
        Get.offAllNamed(AppRoutes.bottomBarScreen);
      } else {
        throw Exception('Failed to switch role');
      }
    } catch (e) {
      print('AssociatedClientsController - Error in switchToClient: $e');
      throw e; // Re-throw error
    } finally {
      isLoading.value = false;
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
      print(
          'AssociatedClientsController - Switching to human agent, using humanAgentProfileId: $profileIdToSave');
    } else if (response.userType == 'client') {
      profileIdToSave = response.profileId;
      print(
          'AssociatedClientsController - Switching to client, using profileId: $profileIdToSave');
    }

    if (profileIdToSave != null && profileIdToSave.isNotEmpty) {
      await secureStorage.write(
          key: Constants.profileId, value: profileIdToSave);
      print(
          'AssociatedClientsController - Updated profileId in storage: $profileIdToSave');
    } else {
      print(
          'AssociatedClientsController - Warning: No profileId found for role ${response.userType}');
    }

    storage.write(
        Constants.isProfileCompleted, response.isprofileCompleted ?? false);

    if (response.userType != null) {
      Get.find<RoleProvider>().setRole(response.userType! == 'humanAgent'
          ? 'executive'
          : response.userType!);
    }

    print('AssociatedClientsController - Role switch completed successfully');
  }
}
