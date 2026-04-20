import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateTemplateController extends GetxController {
  final nameController = TextEditingController();
  final bodyController = TextEditingController();
  final headerController = TextEditingController();
  final footerController = TextEditingController();
  
  RxString selectedCategory = "MARKETING".obs;
  RxString selectedLanguage = "en_US".obs;
  
  RxList<Map<String, String>> buttons = <Map<String, String>>[].obs;
  
  RxBool isSaving = false.obs;

  final List<String> categories = ["MARKETING", "UTILITY", "AUTHENTICATION"];
  final List<String> languages = ["en_US", "hi", "en_GB", "es"];

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
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      Get.back(); // Back to list
      Get.snackbar(
        "Success", 
        "Template '${nameController.text}' created successfully (Simulation)",
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
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
