import 'package:get/get.dart';
import 'package:aitota_business/core/services/api_services.dart';
import 'package:aitota_business/core/services/dio_client.dart';

import '../../../../../../../data/model/outbound/ai_leads/ai_leads_campaign_contacts_model.dart';
import '../../../../../../../data/model/outbound/campaign/campaign_completed_call_logs_model.dart';

class AiLeadsContactDetailController extends GetxController {
  final conversation = Rxn<CampaignCompletedCallLogsModel>();
  final isLoading = false.obs;

  final ApiService apiService = ApiService(dio: DioClient().dio);

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    final lead = args?['lead'] as AiLeadsCampaignContactsData?;
    final campaignId = args?['campaignId'] as String?;

    // CORRECT ID: documentId (as per your model & backend URL)
    if (campaignId?.isNotEmpty == true && 
        lead?.documentId != null && 
        lead!.documentId!.isNotEmpty) {
      
      fetchConversationLogs(
        campaignId: campaignId!,
        documentId: lead.documentId!,
      );
    }
  }

Future<void> fetchConversationLogs({
    required String campaignId,
    required String documentId,
  }) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final response = await apiService.getCompletedCallsLogs(campaignId, documentId);

      if (response.success == true && response.transcript?.isNotEmpty == true) {
        conversation.value = response;
        print("Conversation loaded!");
      } else {
        print("No transcript or success=false");
        conversation.value = null;
      }
    } catch (e) {
      print("Error fetching conversation: $e");
      conversation.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}