import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:aitota_business/core/services/api_services.dart';
import 'package:aitota_business/core/services/dio_client.dart';
import '../../../../core/services/api_endpoints.dart';
import '../../../outbound/grid_flow/contact/add_contact/controller/add_contact_controller.dart';
import '../../../../core/app-export.dart';

class AudienceSelectionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  RxInt currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      currentTabIndex.value = tabController.index;
    });
    fetchAudienceHistory();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  RxList<Map<String, dynamic>> audienceHistory = <Map<String, dynamic>>[].obs;

  RxList<Map<String, dynamic>> displayedHistory = <Map<String, dynamic>>[].obs;

  RxBool isPicking = false.obs;
  RxBool isLoadingHistory = false.obs;

  void searchHistory(String query) {
    if (query.isEmpty) {
      displayedHistory.assignAll(audienceHistory);
      return;
    }
    final lowercaseQuery = query.toLowerCase();
    final filtered = audienceHistory.where((item) {
      final name = (item['name'] ?? '').toString().toLowerCase();
      return name.contains(lowercaseQuery);
    }).toList();
    displayedHistory.assignAll(filtered);
  }

  Future<void> importNewAudience() async {
    isPicking.value = true;
    try {
      // Pick file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx', 'xls'],
      );

      if (result != null) {
        String fileName = result.files.single.name;
        String filePath = result.files.single.path!;

        // Prepare multipart form data for API using dio's FormData
        final formData = dio.FormData.fromMap({
          'file':
              await dio.MultipartFile.fromFile(filePath, filename: fileName),
        });

        // Call API
        final dioClient = DioClient().dio;
        final response = await dioClient.post(
          'whatsai/contacts/import',
          data: formData,
        );

        if (response.statusCode == 200) {
          final data = response.data;
          if (data['success'] == true) {
            int importedCount = data['data']['imported'] ?? 0;
            int skippedCount = data['data']['skipped'] ?? 0;

            // Add to history
            final newItem = {
              "name": fileName,
              "count": importedCount,
              "date": DateTime.now().toString().split(' ')[0],
            };
            audienceHistory.insert(0, newItem);
            displayedHistory.insert(0, newItem);

            Get.snackbar(
              "Success",
              "Imported $importedCount contacts${skippedCount > 0 ? ', skipped $skippedCount' : ''}",
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );

            // Refresh history to show newly imported file
            await fetchAudienceHistory();
          } else {
            Get.snackbar(
              "Error",
              data['message'] ?? "Failed to import file",
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {
          Get.snackbar(
            "Error",
            "Failed to import file. Status: ${response.statusCode}",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } on dio.DioException catch (e) {
      print("🚨 Error in importNewAudience API: $e");
      print("🔗 Failed URL: ${e.requestOptions.uri}");
      print("💬 Response Data: ${e.response?.data}");

      Get.snackbar(
        "Error",
        e.response?.data['message'] ??
            "Failed to import file. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      print("🚨 Error in importNewAudience: $e");
      Get.snackbar(
        "Error",
        "Failed to import file. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isPicking.value = false;
    }
  }

  void selectAudience(Map<String, dynamic> audience) {
    // Navigate back to template details with the selected audience
    Get.back(result: audience);
  }

  Future<void> refreshAudienceHistory() async {
    await fetchAudienceHistory();
  }

  Future<void> fetchAudienceHistory() async {
    isLoadingHistory.value = true;
    try {
      final dioClient = DioClient().dio;
      final response = await dioClient.get('whatsai/contacts/import');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          List<dynamic> imports = data['data'] ?? [];
          List<Map<String, dynamic>> historyList = imports
              .map((item) => {
                    "_id": item['_id'] ?? '',
                    "name": item['fileName'] ?? 'Unknown',
                    "count": item['importedCount'] ?? 0,
                    "date": _formatDate(item['createdAt'] ?? DateTime.now()),
                    "skipped": item['skippedCount'] ?? 0,
                  })
              .toList();
          audienceHistory.assignAll(historyList);
          displayedHistory.assignAll(historyList);
        } else {
          print("❌ Failed to fetch history: ${data['message']}");
        }
      } else {
        print("❌ Failed to fetch history. Status: ${response.statusCode}");
      }
    } on dio.DioException catch (e) {
      print("🚨 Error fetching audience history: $e");
      print("🔗 Failed URL: ${e.requestOptions.uri}");
      print("💬 Response Data: ${e.response?.data}");
    } catch (e) {
      print("🚨 Error in fetchAudienceHistory: $e");
    } finally {
      isLoadingHistory.value = false;
    }
  }

  String _formatDate(dynamic date) {
    try {
      if (date is String) {
        return date.split('T')[0];
      } else if (date is DateTime) {
        return date.toString().split(' ')[0];
      }
      return 'Unknown';
    } catch (e) {
      return 'Unknown';
    }
  }

  Future<void> createContact(String name, String phone, String email) async {
    try {
      final String endpoint = ApiEndpoints.whatsAiContacts;
      final bool isAbsolute = endpoint.startsWith('http');
      final String fullUrl =
          isAbsolute ? endpoint : "${DioClient().dio.options.baseUrl}$endpoint";

      print("🚀 Calling API: $fullUrl");
      print("📦 Request Body: name: $name, phone: $phone, email: $email");

      final apiService = ApiService(dio: DioClient().dio);
      final response = await apiService.createWhatsAiContact({
        "name": name,
        "phone": phone,
        "email": email,
        "tags": [],
        "group": [],
        "optedOut": false,
      });

      if (response.success == true) {
        print("✅ Contact Created Successfully: ${response.message}");
        Get.snackbar("Success", "Contact added successfully",
            backgroundColor: Colors.green, colorText: Colors.white);

        if (Get.isRegistered<AddContactController>()) {
          Get.find<AddContactController>().fetchWhatsAiContacts();
        }
      } else {
        print("❌ Failed to Create Contact: ${response.message}");
        Get.snackbar("Error", response.message ?? "Failed to add contact",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("🚨 Error in createContact API: $e");

      if (e is dio.DioException) {
        print("🔗 Failed URL: ${e.requestOptions.uri}");
        print("💬 Response Data: ${e.response?.data}");
      }

      Get.snackbar("Error", "Failed to add contact. Please try again.",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
