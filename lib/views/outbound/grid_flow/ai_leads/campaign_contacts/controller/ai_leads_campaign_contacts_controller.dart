import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/services/api_services.dart';
import 'package:aitota_business/core/services/dio_client.dart';
import '../../../../../../data/model/outbound/ai_leads/ai_leads_campaign_contacts_model.dart';
import '../../../../../../routes/app_routes.dart';

class AiLeadsCampaignContactsController extends GetxController {
  final leads = <AiLeadsCampaignContactsData>[].obs;
  final isLoading = false.obs;
  final ApiService apiService = ApiService(dio: DioClient().dio);

  // CORRECT WAY: Use RxString (observable string)
  final campaignId = RxString('');

  @override
  void onInit() {
    super.onInit();

    // Get campaignId from arguments (passed when navigating to this screen)
    String? argCampaignId = Get.arguments?['campaignId'] as String?;

    // Set initial value (fallback if not provided)
    campaignId.value = argCampaignId?.isNotEmpty == true
        ? argCampaignId!
        : '68b29af470fc0c8fb6fe0d56';

    // Start fetching leads
    fetchLeads(campaignId: campaignId.value);
  }

  Future<void> fetchLeads({required String campaignId}) async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final response = await apiService.getAiLeadsCampaignContacts(campaignId);

      print("Fetched Leads: ${response.toJson()}");

      if (response.success == true && response.data != null) {
        leads.assignAll(response.data!);

        // Update campaignId from actual API response (most reliable source)
        final realCampaignId = response.campaignInfo?.campaignId;
        if (realCampaignId != null && realCampaignId.isNotEmpty) {
          this.campaignId.value = realCampaignId; // Update with real ID
        }
      } else {
        leads.clear();
        Get.snackbar('Error', 'No leads found', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('Error fetching leads: $e');
      leads.clear();
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await fetchLeads(campaignId: campaignId.value);
  }

  void onItemTap(AiLeadsCampaignContactsData lead) {
    Get.toNamed(
      AppRoutes.aiLeadsContactsDetailScreen,
      arguments: {
        'lead': lead,
        'campaignId': campaignId.value, // Always safe and correct
      },
    );
  }
}