import 'dart:convert';

import 'package:aitota_business/core/app-export.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/services/api_endpoints.dart';

import '../../../../../../core/services/api_services.dart';
import '../../../../../../core/services/dio_client.dart';
import '../../controller/outbound_campaign_controller.dart';

class AddOutboundCampaignController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final RxBool isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  // Form controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    super.onClose();
  }

  Future<void> addCampaign() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final requestBody = {
        "name": nameController.text.trim(),
        "description": descriptionController.text.trim(),
        "category": categoryController.text.trim(),
      };

      final response = await apiService.createOutboundCampaign(requestBody);

      if (response.success == true) {
        Get.back();
        Get.find<OutboundCampaignController>().fetchAllOutboundCampaigns();
      } else {
        throw Exception('Campaign creation failed');
      }
    }  catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}