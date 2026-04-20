import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/services/api_services.dart';
import 'package:aitota_business/core/services/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class SeeMoreCampaignLogsController extends GetxController {
  final RxList<Map<String, dynamic>> tableData = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final ApiService apiService = ApiService(dio: DioClient().dio);

  String? campaignId;

  @override
  void onInit() {
    super.onInit();
    // Initialize static table data
    _initializeStaticTableData();
    // Retrieve campaignId from arguments and fetch dynamic data
    final arguments = Get.arguments;
    if (arguments is Map<String, dynamic> && arguments['campaignId'] != null) {
      campaignId = arguments['campaignId'];
      fetchCampaignLogs();
    } else {
      errorMessage.value = 'No campaign ID provided, showing static data';
    }
  }

  // Initialize static table data (same as OutboundCampaignDetailController)
  void _initializeStaticTableData() {
    tableData.assignAll([
      {'number': '1', 'name': 'Aditya', 'status': 'Active', 'disposition': 'Completed'},
      {'number': '2', 'name': 'Rahul', 'status': 'Inactive', 'disposition': 'Pending'},
      {'number': '3', 'name': 'Neha', 'status': 'Pending', 'disposition': 'In Progress'},
      {'number': '4', 'name': 'Priya', 'status': 'Active', 'disposition': 'Completed'},
      {'number': '5', 'name': 'Vikram', 'status': 'Inactive', 'disposition': 'Pending'},
      {'number': '6', 'name': 'Sneha', 'status': 'Pending', 'disposition': 'In Progress'},
      {'number': '7', 'name': 'Arjun', 'status': 'Active', 'disposition': 'Completed'},
      {'number': '8', 'name': 'Kavya', 'status': 'Inactive', 'disposition': 'Pending'},
      {'number': '9', 'name': 'Rohit', 'status': 'Pending', 'disposition': 'In Progress'},
      {'number': '10', 'name': 'Anjali', 'status': 'Active', 'disposition': 'Completed'},
    ]);
  }

  Future<void> fetchCampaignLogs() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (campaignId == null) {
        errorMessage.value = 'Invalid campaign ID';
        return;
      }

      // Placeholder API call - replace with actual endpoint
      // final response = await apiService.getCampaignLogs(campaignId!);

      // if (response.success == true && response.data != null) {
      //   tableData.assignAll(response.data!.map((log) {
      //     return {
      //       'number': log.number ?? 'N/A',
      //       'name': log.name ?? 'N/A',
      //       'status': log.status ?? 'N/A',
      //       'disposition': log.disposition ?? 'N/A',
      //     };
      //   }).toList());
      // } else {
      //   errorMessage.value = 'Failed to load campaign logs, showing static data';
      // }
    } on DioException catch (e) {
      errorMessage.value = 'API Error: ${e.response?.data ?? e.message}, showing static data';
    } catch (e) {
      errorMessage.value = 'Error: $e, showing static data';
    } finally {
      isLoading.value = false;
    }
  }
}