import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/services/dio_client.dart';

class CreateTemplateController extends GetxController {
  final DioClient _dioClient = DioClient();
  final nameController = TextEditingController();
  final bodyController = TextEditingController();
  final headerController = TextEditingController();
  final footerController = TextEditingController();
  
  RxString selectedCategory = "MARKETING".obs;
  RxString selectedLanguage = "en_US".obs;
  String? templateId;
  
  RxList<Map<String, String>> buttons = <Map<String, String>>[].obs;
  
  RxBool isSaving = false.obs;

  final List<String> categories = ["MARKETING", "UTILITY", "AUTHENTICATION"];
  final List<String> languages = ["en_US", "hi", "en_GB", "es"];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map<String, dynamic>;
      templateId = args['templateId'];
      if (args['name'] != null) nameController.text = args['name'];
      if (args['bodyPreview'] != null) bodyController.text = args['bodyPreview'];
      if (args['languageCode'] != null) selectedLanguage.value = args['languageCode'];
      if (args['category'] != null) selectedCategory.value = args['category'];
    }
  }

  void addButton() {
    if (buttons.length < 3) {
      buttons.add({"type": "QUICK_REPLY", "text": "Button ${buttons.length + 1}"});
    } else {
      Get.snackbar("Limit", "Max 3 buttons allowed");
    }
  }

  void removeButton(int index) {
    buttons.removeAt(index);
  }

  Future<void> saveTemplate() async {
    if (nameController.text.isEmpty || bodyController.text.isEmpty) {
      Get.snackbar("Error", "Name and Body are required");
      return;
    }

    isSaving.value = true;
    try {
      final payload = {
        "name": nameController.text,
        "whatsappTemplateName": nameController.text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_'),
        "languageCode": selectedLanguage.value,
        "bodyPreview": bodyController.text,
        "parameterFormat": "NAMED",
        "sampleParams": []
      };
      
      final res = templateId != null 
          ? await _dioClient.dio.patch('whatsai/templates/$templateId', data: payload)
          : await _dioClient.dio.post('whatsai/templates', data: payload);
      
      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.back(); // Back to list
        Get.snackbar(
          "Success", 
          templateId != null ? "Template updated successfully" : "Template '${nameController.text}' created successfully",
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      } else {
        Get.snackbar("Error", templateId != null ? "Failed to update template" : "Failed to create template");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to save: $e");
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    bodyController.dispose();
    headerController.dispose();
    footerController.dispose();
    super.onClose();
  }
}
