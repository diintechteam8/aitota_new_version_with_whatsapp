import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/app-export.dart';
import '../../../../../core/services/whatsapp_service.dart';
import '../../../../../data/model/outbound/icons/whatsapp/get_templates_model.dart';
import '../../../../../routes/app_routes.dart';

class WhatsAppTemplateDetailsController extends GetxController {
  final WhatsAppService _whatsappService = WhatsAppService();
  
  late GetTemplateModelTemplates template;
  RxMap selectedAudience = {}.obs;
  RxBool isSending = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is GetTemplateModelTemplates) {
      template = Get.arguments;
    } else {
      Get.back();
      Get.snackbar("Error", "No template data found");
    }
  }

  Future<void> navigateToAudienceSelection() async {
    final result = await Get.toNamed(AppRoutes.audienceSelectionScreen);
    if (result != null && result is Map) {
      selectedAudience.value = result;
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
      await Future.delayed( Duration(seconds: 2));
      
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
