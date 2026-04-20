import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/services/role_provider.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../data/model/more/get_all_human_agents.dart';
import '../../../../data/model/auth_models/switch_role_response.dart';
import '../../../../routes/app_routes.dart';

class HumanAgentsController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final RxBool isLoading = false.obs;
  final RxList<HumanAgent> humanAgents = <HumanAgent>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHumanAgents();
  }

  Future<void> loadHumanAgents() async {
    try {
      isLoading.value = true;

      print('HumanAgentsController - Calling getHumanAgents API');
      final response = await apiService.getHumanAgents();

      print('HumanAgentsController - Response received:');
      print('  success: ${response.success}');
      print('  agents count: ${response.data?.length ?? 0}');

      if (response.success == true && response.data != null) {
        humanAgents.assignAll(response.data!);
        print(
            'HumanAgentsController - Loaded ${humanAgents.length} human agents');
      } else {
        throw Exception('Failed to load human agents');
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> switchToAgent(HumanAgent agent) async {
    try {
      isLoading.value = true;

      // ✅ Debug: Print the agent data to see what fields are available
      print('HumanAgentsController - Agent data:');
      print('  id: ${agent.id}');
      print('  clientId: ${agent.clientId}');
      // print('  clientUserId: ${agent.clientUserId}');
      print('  email: ${agent.email}');
      print('  role: ${agent.type}');

      // ✅ Send the complete agent object as payload
      final payload = agent.toJson();

      print(
          'HumanAgentsController - Calling switchRole with payload: $payload');
      final response = await apiService.switchRole(payload);

      if (response.success == true) {
        await _handleSuccessfulRoleSwitch(response);
        Get.offAllNamed(AppRoutes.bottomBarScreen);
      } else {
        throw Exception('Failed to switch role');
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleSuccessfulRoleSwitch(SwitchRoleResponse response) async {
    final secureStorage = const FlutterSecureStorage();
    final storage = GetStorage();

    // Update token
    if (response.token != null && response.token!.isNotEmpty) {
      await secureStorage.write(key: Constants.token, value: response.token!);
    }

    // Update user ID
    if (response.id != null && response.id!.isNotEmpty) {
      await secureStorage.write(key: Constants.id, value: response.id!);
    }

    // ✅ FIX: Update profileId based on the role being switched to
    String? profileIdToSave;

    if (response.userType == 'humanAgent') {
      // If switching to human agent, use humanAgentProfileId
      profileIdToSave = response.humanAgentProfileId;
      print(
          'HumanAgentsController - Switching to human agent, using humanAgentProfileId: $profileIdToSave');
    } else if (response.userType == 'client') {
      // If switching to client, use profileId from response
      profileIdToSave = response.profileId;
      print(
          'HumanAgentsController - Switching to client, using profileId: $profileIdToSave');
    }

    // Save the appropriate profileId
    if (profileIdToSave != null && profileIdToSave.isNotEmpty) {
      await secureStorage.write(
          key: Constants.profileId, value: profileIdToSave);
      print(
          'HumanAgentsController - Updated profileId in storage: $profileIdToSave');
    } else {
      print(
          'HumanAgentsController - Warning: No profileId found for role ${response.userType}');
    }

    // Update profile completion status
    storage.write(
        Constants.isProfileCompleted, response.isprofileCompleted ?? false);

    // Update role in RoleProvider
    if (response.userType != null) {
      Get.find<RoleProvider>().setRole(response.userType! == 'humanAgent'
          ? 'executive'
          : response.userType!);
    }

    print('HumanAgentsController - Role switch completed successfully');
  }
}
