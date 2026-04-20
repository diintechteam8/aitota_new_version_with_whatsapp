import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/services/api_services.dart';
import 'package:aitota_business/core/services/dio_client.dart';
import '../../../../../../../data/model/inbound/settings/ai_agent/ai_agent_model.dart';
import 'package:flutter/material.dart';

class OutboundAiAgentController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final agents = <Map<String, dynamic>>[].obs;
  final agentDataList = <AgentData>[].obs;
  final isLoading = false.obs;
  final errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchAgentData();
  }

  Future<void> fetchAgentData() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";
      agents.clear();
      agentDataList.clear();

      final response = await apiService.getAllAgents();
      if (response.success == true && response.data != null && response.data!.isNotEmpty) {
        // Filter only outbound or both agents
        final filteredAgents = response.data!.where((agentData) {
          final callingType = agentData.callingType?.toLowerCase() ?? '';
          return callingType == 'outbound' || callingType == 'both';
        }).toList();

        if (filteredAgents.isNotEmpty) {
          agentDataList.assignAll(filteredAgents);
          agents.assignAll(filteredAgents.map((agentData) {
            final callingType = agentData.callingType?.toLowerCase() ?? '';
            return {
              'title': agentData.agentName ?? 'N/A',
              'value': agentData.category ?? 'N/A',
              'callingType': callingType,
              'status': agentData.isActive == true ? 'Active' : 'Inactive',
              'icon': Icons.support_agent,
              'iconColor': agentData.isActive == true ? Colors.green : Colors.grey,
            };
          }).toList());
        } else {
          agents.clear();
          agentDataList.clear();
        }
      } else {
        agents.clear();
        agentDataList.clear();
      }
    } catch (e) {
      agents.clear();
      agentDataList.clear();
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshAgentData() async {
    await fetchAgentData();
  }
}