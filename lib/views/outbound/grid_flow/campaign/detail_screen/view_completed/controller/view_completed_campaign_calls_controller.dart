import 'package:get/get.dart';
import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/services/api_services.dart';
import 'package:aitota_business/core/services/dio_client.dart';
import 'package:dio/dio.dart';

class ViewCompletedCampaignCallsController extends GetxController {
  final RxList<Map<String, dynamic>> tableData = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxBool hasNextPage = false.obs;
  final RxBool hasPrevPage = false.obs;
  final RxBool isLoadingLogs = false.obs; // New: For loading state of logs
  final RxString logsErrorMessage = ''.obs; // New: For error state of logs
  final RxString transcript = ''.obs; // New: To store transcript
  final ApiService apiService = ApiService(dio: DioClient().dio);

  String? campaignId;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments is Map<String, dynamic> && arguments['campaignId'] != null) {
      campaignId = arguments['campaignId'];
      fetchCompletedCampaignCalls();
    } else {
      errorMessage.value = 'No campaign ID provided';
    }
  }

  Future<void> fetchCompletedCampaignCalls({int page = 1}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (campaignId == null) {
        return;
      }

      final response = await apiService.getCompletedCallsTable(campaignId!, page: page);
      if (response.success == true && response.completedCalls != null) {
        tableData.assignAll(response.completedCalls!.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final item = entry.value;
          return {
            'sno': index.toString(),
            'number': item.number ?? '8147540362',
            'name': item.name ?? 'Vijay',
            'logs': 'No Logs',
            'result': item.leadStatus ?? 'Pending',
            'documentId': item.documentId ?? '', // Add documentId to tableData
          };
        }).toList());

        if (response.pagination != null) {
          currentPage.value = response.pagination!.currentPage ?? 1;
          totalPages.value = response.pagination!.totalPages ?? 1;
          hasNextPage.value = response.pagination!.hasNextPage ?? false;
          hasPrevPage.value = response.pagination!.hasPrevPage ?? false;
        } else {
          currentPage.value = 1;
          totalPages.value = 1;
          hasNextPage.value = false;
          hasPrevPage.value = false;
        }
      } else {
        errorMessage.value = 'Failed to load completed campaign calls';
        tableData.clear();
      }
    } on DioException catch (e) {
      errorMessage.value = 'API Error: ${e.response?.data ?? e.message}';
      tableData.clear();
    } catch (e) {
      throw Exception(e.toString());
      tableData.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // New: Fetch conversation logs for a specific documentId
  Future<void> fetchConversationLogs(String documentId) async {
    try {
      isLoadingLogs.value = true;
      logsErrorMessage.value = '';
      transcript.value = '';

      if (campaignId == null) {
        logsErrorMessage.value = 'No campaign ID provided';
        return;
      }

      final response = await apiService.getCompletedCallsLogs(campaignId!, documentId);
      if (response.success == true && response.transcript != null) {
        transcript.value = response.transcript!;
      } else {
        logsErrorMessage.value = 'No conversation logs found';
      }
    } on DioException catch (e) {
      logsErrorMessage.value = 'API Error: ${e.response?.data ?? e.message}';
    } catch (e) {
       throw Exception(e.toString());
    } finally {
      isLoadingLogs.value = false;
    }
  }

  void goToNextPage() {
    if (hasNextPage.value) {
      currentPage.value++;
      fetchCompletedCampaignCalls(page: currentPage.value);
    }
  }

  void goToPreviousPage() {
    if (hasPrevPage.value) {
      currentPage.value--;
      fetchCompletedCampaignCalls(page: currentPage.value);
    }
  }
}