import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/services/api_services.dart';
import 'package:aitota_business/core/services/dio_client.dart';
import 'package:aitota_business/data/model/inbound/settings/ai_agent/ai_agent_model.dart';
import '../../../routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class AiAgentController extends GetxController {
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

      final response = await apiService.getAllAgents();
      if (response.success == true && response.data != null && response.data!.isNotEmpty) {
        // Sort agentData by isActive (true first, then false)
        final sortedAgentData = response.data!
          ..sort((a, b) => (b.isActive ?? false) ? 1 : -1);

        agentDataList.assignAll(sortedAgentData);

        agents.assignAll(sortedAgentData.map((agentData) {
          final agentMap = {
            'id': agentData.id, // add this
            'title': agentData.agentName ?? 'N/A',
            'value': agentData.category != null && agentData.category!.isNotEmpty ? agentData.category : null,
            'callingType': agentData.callingType != null && agentData.callingType!.isNotEmpty ? agentData.callingType : null,
            'status': agentData.isActive == true ? 'Active' : 'Inactive',
            'icon': Icons.support_agent,
            'iconColor': agentData.isActive == true ? Colors.green : Colors.grey,
          };
          print("Agent Data: $agentMap");
          return agentMap;
        }).toList());
      } else {
        errorMessage.value = "No agent data found.";
        agents.clear();
        agentDataList.clear();
      }
    } catch (e) {
       throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshAgentData() async {
    await fetchAgentData();
  }

}