import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/services/api_services.dart';
import 'package:aitota_business/core/services/dio_client.dart';
import 'package:aitota_business/data/model/ai_agent/history_call_logs_model.dart';
import 'package:aitota_business/data/model/inbound/settings/ai_agent/ai_agent_model.dart';

class CallHistoryController extends GetxController {
  final agentData = Rx<AgentData?>(null);
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final callLogs = <Logs>[].obs;
  final isLogsLoading = false.obs;
  final logsErrorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null && arguments is AgentData) {
      agentData.value = arguments;
      fetchCallLogs();
    } else {
      logsErrorMessage.value = "No agent data provided";
    }
  }

  Future<void> fetchCallLogs() async {
    isLogsLoading.value = true;
    logsErrorMessage.value = "";
    try {
      final response = await apiService.getHistoryCallLogs(agentData.value?.id ?? '');
      if (response.success == true && response.data != null) {
        callLogs.assignAll(response.data!.logs ?? []);
      } else {
        logsErrorMessage.value = "No call logs found.";
        callLogs.clear();
      }
    } catch (e) {
      logsErrorMessage.value = "Failed to fetch call logs: $e";
    } finally {
      isLogsLoading.value = false;
    }
  }
}