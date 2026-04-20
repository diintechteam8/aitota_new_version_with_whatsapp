// ai_leads_controller.dart
import 'package:aitota_business/core/app-export.dart';
import '../../../../../core/services/api_services.dart';
import '../../../../../core/services/dio_client.dart';
import '../../../../../data/model/outbound/ai_leads/ai_leads_campaigns_model.dart';

class AILeadsCampaignController extends GetxController {
  final RxList<Map<String, dynamic>> leadItems = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;      
  final RxBool isRetrying = false.obs;   

  final ApiService apiService = ApiService(dio: DioClient().dio);

  @override
  void onInit() {
    super.onInit();
    fetchAllLeads(); // First load
  }

  Future<void> fetchAllLeads({bool isRetry = false}) async {
    try {
      // Set loading state
      if (isRetry) {
        isRetrying.value = true;
      } else {
        isLoading.value = true;
      }

      leadItems.clear();

      final response = await apiService.getAiLeadsCampaign();

      final leadsModel = AILeadsCampaignModel.fromJson(response.toJson());

      if (leadsModel.success == true && leadsModel.data != null) {
        leadItems.addAll(
          leadsModel.data!.map((lead) => {
                'campaignId': lead.campaignId,
                'campaignName': lead.campaignName,
                'description': lead.description,
                'totalAssignedContacts': lead.totalAssignedContacts,
                'connectedContacts': lead.connectedContacts,
                'notConnectedContacts': lead.notConnectedContacts,
                'connectionRate': lead.connectionRate,
                'lastAssignedAt': lead.lastAssignedAt,
                'totalRuns': lead.totalRuns,
                'campaignCreatedAt': lead.campaignCreatedAt,
              }),
        );
      }
    } catch (e, st) {
      print('Error fetching leads: $e\n$st');
    } finally {
      isLoading.value = false;
      isRetrying.value = false;
    }
  }
}