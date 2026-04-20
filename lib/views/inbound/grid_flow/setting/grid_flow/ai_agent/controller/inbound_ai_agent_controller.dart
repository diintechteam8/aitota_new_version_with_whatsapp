import '../../../../../../../core/app-export.dart';
import '../../../../../../../core/services/api_services.dart';
import '../../../../../../../core/services/dio_client.dart';
import '../../../../../../../data/model/inbound/settings/ai_agent/ai_agent_model.dart';

class InboundAiAgentController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final agents = <Map<String, dynamic>>[].obs;
  final agentDataList = <AgentData>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAgentData();
  }

  Future<void> fetchAgentData() async {
    try {
      isLoading.value = true;

      final response = await apiService.getAllAgents();

      if (response.success == true &&
          response.data != null &&
          response.data!.isNotEmpty) {
        // Filter inbound / both
        final filteredAgents = response.data!.where((agentData) {
          final callingType = (agentData.callingType ?? '').toLowerCase();
          return callingType == 'inbound' || callingType == 'both';
        }).toList();

        if (filteredAgents.isNotEmpty) {
          agentDataList.assignAll(filteredAgents);
          agents.assignAll(filteredAgents
              .map((agentData) => {
                    'title': agentData.agentName ?? 'N/A',
                    'value': agentData.category ?? 'N/A',
                    'callingType': agentData.callingType ?? 'N/A',
                    'status':
                        agentData.isActive == true ? 'Active' : 'Inactive',
                    'icon': Icons.support_agent,
                    'iconColor':
                        agentData.isActive == true ? Colors.green : Colors.grey,
                  })
              .toList());
          return;
        }
      }

      // ---- No data (or no inbound) ----
      agents.clear();
      agentDataList.clear();
    } catch (e) {
      // ---- Exception ----
      agents.clear();
      agentDataList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshAgentData() async => await fetchAgentData();
}
