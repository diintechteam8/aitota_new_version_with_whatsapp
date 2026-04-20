import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/services/api_services.dart';
import 'package:aitota_business/core/services/dio_client.dart';
import 'package:dio/dio.dart';
import '../../../../../../core/utils/widgets/outbound_widgets/campaign_widgets/agent_bottom_sheet.dart';
import '../../../../../../core/utils/widgets/outbound_widgets/campaign_widgets/contact_bottom_sheet.dart';
import '../../../../../../core/utils/widgets/outbound_widgets/campaign_widgets/group_bottom_sheet.dart';
import '../../../../../../data/model/outbound/campaign/campaign_call_stats_model.dart';
import '../../../../../../data/model/outbound/campaign/outbound_campaign_detail_model.dart';
import '../../../../../ai_agent/controller/ai_agent_controller.dart';
import '../../../contact/group/controller/contact_group_controller.dart';

class OutboundCampaignDetailController extends GetxController {
  final Rx<GetOutboundCampaignDetailModel?> campaignDetail =
      Rx<GetOutboundCampaignDetailModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final ApiService apiService = ApiService(dio: DioClient().dio);

  final RxList<Map<String, dynamic>> groups = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> agents = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> contacts = <Map<String, dynamic>>[].obs;

  final RxList<Map<String, dynamic>> selectedGroups =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> selectedAgents =
      <Map<String, dynamic>>[].obs;

  final RxList<Map<String, dynamic>> availableGroups =
      <Map<String, dynamic>>[].obs;

  final RxBool showTable = false.obs;
  final RxList<Map<String, dynamic>> tableData = <Map<String, dynamic>>[].obs;
  final Rx<CampaignCallStatsModel?> campaignStats =
      Rx<CampaignCallStatsModel?>(null);

  final RxString runButtonText = 'Run'.obs;
  final Rx<Color> runButtonColor = Colors.green.obs;
  final RxBool isCampaignRunning = false.obs;
  final RxBool isSectionsFolded = false.obs;
  String? campaignId;
  final RxInt totalContacts = 0.obs;
  final RxInt completedCalls = 0.obs;
  final RxInt successfulCalls = 0.obs;
  final RxInt failedCalls = 0.obs;
  final RxInt liveCalls = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic>? campaignItem = Get.arguments;
    if (campaignItem != null && campaignItem['id'] != null) {
      campaignId = campaignItem['id'];
      fetchCampaignDetails();
      fetchCampaignGroups(campaignId!);
      apiService.syncContactGroups(campaignId!);
    } else {
      errorMessage.value = 'Invalid campaign data';
    }
  }

  @override
  void onReady() {
    super.onReady();
    if (campaignId != null) {
      fetchCampaignDetails();
      fetchCampaignGroups(campaignId!);
      apiService.syncContactGroups(campaignId!);
    }
  }

  void updateUIStateBasedOnRunning() {
    if (campaignDetail.value?.data?.isRunning == true) {
      isCampaignRunning.value = true;
      isSectionsFolded.value = true;
      runButtonText.value = 'Stop';
      runButtonColor.value = Colors.red;
      showTable.value = true;
    } else {
      isCampaignRunning.value = false;
      isSectionsFolded.value = false;
      runButtonText.value = 'Run';
      runButtonColor.value = Colors.green;
      showTable.value = false;
    }
  }

  Future<void> fetchCampaignDetails() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (campaignId == null) {
        errorMessage.value = 'Invalid campaign ID';
        return;
      }

      final response = await apiService.getOutboundCampaignById(campaignId!);

      if (response.success == true && response.data != null) {
        campaignDetail.value = response;
        updateUIStateBasedOnRunning();
      } else {
        errorMessage.value = 'Failed to load campaign details';
      }
    } on DioException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCampaignGroups(String campaignId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiService.getCampaignsAllGroup(campaignId);
      if (response.success == true && response.data != null) {
        groups.assignAll(response.data!.map((group) {
          return {
            'sId': group.sId,
            'name': group.name ?? 'Unnamed Group',
            'contacts': group.contacts?.length ?? 0,
            'color': Colors.blue,
          };
        }).toList());
      } else {
        groups.clear();
      }
    } on DioException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllGroups() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final contactGroupController = Get.find<ContactGroupController>();
      await contactGroupController.fetchAllGroups();

      availableGroups.assignAll(contactGroupController.groups.map((group) {
        return {
          'sId': group['_id'],
          'name': group['name'] ?? 'Unnamed Group',
          'contacts': group['contactCount'] ?? 0,
          'color': Colors.blue,
        };
      }).toList());

      if (availableGroups.isEmpty) {
        errorMessage.value = 'No groups available';
      }
    } on DioException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addGroupsToCampaign(
      String campaignId, List<String> groupIds) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final request = {'groupIds': groupIds};
      final response =
          await apiService.addGroupsInCampaign(request, campaignId);

      if (response.success == true) {
        await fetchCampaignGroups(campaignId);
        final syncResponse = await apiService.syncContactGroups(campaignId);
        if (syncResponse.success == true) {
          // Handle success
        } else {
          errorMessage.value = 'Failed to sync contacts';
        }
      } else {
        errorMessage.value = 'Failed to add groups';
      }
    } on DioException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCampaignGroup(String groupId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (campaignId == null) {
        errorMessage.value = 'Invalid campaign ID';
        return;
      }

      final response =
          await apiService.deleteCampaignGroup(campaignId!, groupId);

      if (response.success == true) {
        groups.removeWhere((group) => group['sId'] == groupId);
      } else {
        errorMessage.value = 'Failed to delete group';
      }
    } on DioException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchGroupContacts(String groupId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiService.getCampaignContactsByGroupId(groupId);
      if (response.success == true &&
          response.data != null &&
          response.data!.contacts != null) {
        contacts.assignAll(response.data!.contacts!.map((contact) {
          return {
            'sId': contact.sId,
            'name': contact.name ?? 'Unnamed Contact',
            'phone': contact.phone ?? 'N/A',
            'email': contact.email ?? 'N/A',
            'color': Colors.blue,
          };
        }).toList());
      } else {
        errorMessage.value = 'No contacts found for this group';
        contacts.clear();
      }
    } on DioException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onRunCampaign() async {
    if (campaignId == null) {
      _showCustomDialog(
        title: 'Campaign Error',
        message: 'Unable to proceed due to an invalid campaign ID.',
        type: 'E',
      );
      return;
    }

    // Validate required data before running
    if (groups.isEmpty && agents.isEmpty) {
      _showCustomDialog(
        title: 'Campaign Requirements',
        message: 'Please add both a group and an agent to start the campaign.',
        type: 'E',
      );
      return;
    }
    if (groups.isEmpty) {
      _showCustomDialog(
        title: 'Group Required',
        message: 'Please add a group to start the campaign.',
        type: 'E',
      );
      return;
    }
    if (agents.isEmpty) {
      _showCustomDialog(
        title: 'Agent Required',
        message: 'Please select an agent to start the campaign.',
        type: 'E',
      );
      return;
    }

    // Pick the selected Agent (first added from bottom sheet)
    final String? agentId =
        agents.isNotEmpty ? (agents.first['agentId'] as String?) : null;

    // If trying to start, ensure we have a valid agentId
    if (!isCampaignRunning.value && (agentId == null || agentId.isEmpty)) {
      _showCustomDialog(
        title: 'Agent Selection',
        message: 'Please select a valid agent to start the campaign.',
        type: 'E',
      );
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final Map<String, dynamic> request = {
        if (agentId != null && agentId.isNotEmpty) "agentId": agentId,
      };

      if (!isCampaignRunning.value) {
        final response = await apiService.startCampaign(request, campaignId!);
        if (response.success == true) {
          campaignDetail.value?.data?.isRunning = true;
          updateUIStateBasedOnRunning();
          await fetchCampaignStats();
          _showCustomDialog(
            title: 'Campaign Started',
            message: 'The campaign has been successfully started.',
            type: 'S',
          );
        } else {
          errorMessage.value = 'Failed to start campaign';
          _showCustomDialog(
            title: 'Campaign Error',
            message: 'Unable to start the campaign. Please try again.',
            type: 'E',
          );
        }
      } else {
        final response = await apiService.stopCampaign(request, campaignId!);
        if (response.success == true) {
          campaignDetail.value?.data?.isRunning = false;
          updateUIStateBasedOnRunning();
          _showCustomDialog(
            title: 'Campaign Stopped',
            message: 'The campaign has been stopped successfully.',
            type: 'I',
          );
        } else {
          errorMessage.value = 'Failed to stop campaign';
          _showCustomDialog(
            title: 'Campaign Error',
            message: 'Unable to stop the campaign. Please try again.',
            type: 'E',
          );
        }
      }
    } on DioException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _showCustomDialog({
    required String title,
    required String message,
    required String type,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 350),
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontFamily: AppFonts.poppins,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0.h),
              // Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0.sp,
                  fontFamily: AppFonts.poppins,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24.0),
              // Action Button
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: type == 'S'
                      ? Colors.green
                      : type == 'E'
                          ? Colors.blue.shade600
                          : Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 12.0),
                  elevation: 0,
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text(
                  'OK',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.poppins,
                      fontSize: 16.sp),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Future<void> fetchCampaignStats() async {
    if (campaignId == null) {
      errorMessage.value = 'Invalid campaign ID';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiService.getCampaignCallStats(campaignId!);
      if (response.success == true && response.data != null) {
        campaignStats.value = response;
        totalContacts.value = response.data?.totalContacts ?? 0;
        completedCalls.value = response.data?.progress?.completedCalls ?? 0;
        successfulCalls.value = response.data?.progress?.successfulCalls ?? 0;
        failedCalls.value = response.data?.progress?.failedCalls ?? 0;
        liveCalls.value = (response.data?.totalContacts ?? 0) -
            (response.data?.progress?.completedCalls ?? 0);
      } else {
        campaignStats.value = null;
      }
    } on DioException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

void showGroupBottomSheet(BuildContext context) async {
  // Reset previous state
  selectedGroups.clear();
  errorMessage.value = '';
  isLoading.value = true;

  // Open bottom sheet immediately
  Get.bottomSheet(
    GroupBottomSheet(controller: this),
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
  );

  // Wait for bottom sheet to be fully rendered, then fetch
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await fetchAllGroups();
    // isLoading will be set to false inside fetchAllGroups()
  });
}

void showAgentBottomSheet(BuildContext context) {
  // Reset state
  selectedAgents.clear();
 isLoading.value = true;

  final aiAgentController = Get.put(AiAgentController(), tag: 'AiAgentController');

  // Open bottom sheet immediately
  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (ctx) => AgentBottomSheet(controller: this, context: context),
  );

  // Fetch agents after bottom sheet opens
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await aiAgentController.fetchAgentData();
    isLoading.value = false; // Important: turn off loading
  });
}

  void showContactsBottomSheet(
      BuildContext context, String groupId, String groupName) {
    if (!context.mounted) {
      return;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorConstants.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) => ContactsBottomSheet(
        controller: this,
        context: context,
        groupId: groupId,
        groupName: groupName,
      ),
    );
  }
}
