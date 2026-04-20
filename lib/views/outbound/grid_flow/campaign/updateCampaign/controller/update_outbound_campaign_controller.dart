import 'dart:convert';
import 'package:aitota_business/core/app-export.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/services/api_endpoints.dart';
import '../../../../../../core/services/api_services.dart';
import '../../../../../../core/services/dio_client.dart';
import '../../controller/outbound_campaign_controller.dart';

class UpdateOutboundCampaignController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final RxBool isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  // Form controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  late Map<String, dynamic> campaignData;

  @override
  void onInit() {
    super.onInit();
    campaignData = Get.arguments ?? {};
    nameController.text = campaignData['name'] ?? '';
    descriptionController.text = campaignData['description'] ?? '';
    categoryController.text = campaignData['category'] ?? '';
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    super.onClose();
  }

  Future<void> updateCampaign() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final Map<String, dynamic> requestBody = {
        "name": nameController.text.trim(),
        "description": descriptionController.text.trim(),
        "category": categoryController.text.trim(),
      };

      print('Calling URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.updateOutboundCampaign}/${campaignData['id']}');
      print('Request Body: ${jsonEncode(requestBody)}');

      final response = await apiService.updateOutboundCampaign(requestBody, campaignData['id']);

      if (response.success == true) {
        Get.back();
        Get.find<OutboundCampaignController>().fetchAllOutboundCampaigns();
      } else {
        throw Exception('Campaign update failed');
      }
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update campaign: ${e.message}',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}