import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/app-export.dart';
import '../../../../../core/services/dio_client.dart';
import '../../../../../data/model/outbound/icons/whatsapp/get_templates_model.dart';
import '../../../../../routes/app_routes.dart';
import '../../controller/whatsapp_templates_controller.dart';

class WhatsAppTemplateDetailsController extends GetxController {
  final DioClient _dioClient = DioClient();

  late GetTemplateModelTemplates template;
  RxMap selectedAudience = {}.obs;
  RxBool isSending = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is GetTemplateModelTemplates) {
      template = Get.arguments;
      // Fetch full template details from API
      fetchTemplateDetails(template.sId ?? "");
    } else {
      Get.back();
      Get.snackbar("Error", "No template data found");
    }
  }

  Future<void> fetchTemplateDetails(String templateId) async {
    try {
      final res = await _dioClient.dio.get('whatsai/templates/$templateId');

      if (res.statusCode == 200) {
        if (res.data is Map<String, dynamic>) {
          final responseData = res.data as Map<String, dynamic>;

          // Handle nested data.template structure
          if (responseData.containsKey('data') && responseData['data'] is Map) {
            final dataMap = responseData['data'] as Map<String, dynamic>;

            if (dataMap.containsKey('template') && dataMap['template'] is Map) {
              template = GetTemplateModelTemplates.fromJson(
                  dataMap['template'] as Map<String, dynamic>);
            }
          }
        }
      } else {
        print("Failed to fetch template details: ${res.statusCode}");
      }
    } catch (e) {
      print("Error fetching template details: $e");
    }
  }

  Future<void> navigateToAudienceSelection() async {
    final result = await Get.toNamed(AppRoutes.audienceSelectionScreen);
    if (result != null && result is Map) {
      selectedAudience.value = result;
    }
  }

  Future<void> deleteTemplate() async {
    try {
      final res = await _dioClient.dio.delete('whatsai/templates/${template.sId}');
      if (res.statusCode == 200) {
        if (Get.isRegistered<WhatsAppTemplatesController>()) {
          final listController = Get.find<WhatsAppTemplatesController>();
          listController.allTemplates.removeWhere((t) => t.sId == template.sId);
          listController.filteredTemplates.removeWhere((t) => t.sId == template.sId);
        }

        Get.back(); // Go back to the templates list
        Get.snackbar(
          "Success",
          "Template deleted successfully",
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      } else {
        Get.snackbar("Error", "Failed to delete template");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  Future<void> sendTemplate() async {
    if (selectedAudience.isEmpty) {
      Get.snackbar("Error", "Please select an audience first");
      return;
    }

    isSending.value = true;
    try {
      // Mock Success Simulation for Bulk Campaign
      await Future.delayed(Duration(seconds: 2));

      Get.snackbar(
        "Campaign Launched",
        "Bulk campaign '${template.name}' started for ${selectedAudience['count']} contacts.",
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );

      selectedAudience.clear();
      Get.back(); // Return to templates list
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onClose() {
    // phoneController.dispose();
    super.onClose();
  }
}
