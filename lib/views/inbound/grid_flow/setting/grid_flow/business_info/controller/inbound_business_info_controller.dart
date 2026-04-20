import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/services/api_services.dart';
import 'package:aitota_business/core/services/dio_client.dart';
import 'package:aitota_business/data/model/inbound/settings/business_info/get_inbound_business_info_model.dart';
import 'package:aitota_business/data/model/inbound/settings/business_info/update_business_info_model.dart';

class InboundBusinessInfoController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final textController = TextEditingController();
  final isLoading = false.obs;
  final isButtonLoading = false.obs; // Separate loading state for button
  final isEditing = true.obs; // Start in editing mode by default
  final hasChanges = false.obs;
  final errorMessage = ''.obs;
  final businessData = Rx<BusinessInfoData?>(null);
  final documentId = RxString(''); // Dynamic documentId from auth or response

  @override
  void onInit() {
    super.onInit();
    fetchBusinessInfo();
    textController.addListener(checkForChanges);
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  Future<void> fetchBusinessInfo() async {
    // Skip API call if no valid documentId is available
    if (documentId.value.isEmpty) {
      isLoading.value = false;
      businessData.value = null;
      textController.text = '';
      isEditing.value = true; // Enable editing mode for adding new info
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // final response = await apiService.getInboundBusinessInfo(documentId.value);
      // if (response.success == true && response.data != null) {
      //   businessData.value = response.data;
      //   textController.text = response.data?.text ?? '';
      //   documentId.value = response.data?.id ?? ''; // Update documentId from response
      //   hasChanges.value = false;
      //   isEditing.value = false; // Disable editing mode if data exists
      // } else {
      //   businessData.value = null;
      //   textController.text = '';
      //   isEditing.value = true; // Enable editing mode to allow adding info
      // }
    } catch (e) {
      businessData.value = null;
      textController.text = '';
      isEditing.value = true; // Enable editing mode on error
      errorMessage.value = 'Failed to fetch business info: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addBusinessInfo() async {
    if (textController.text.isEmpty) {
      return;
    }

    try {
      isButtonLoading.value = true;
      errorMessage.value = '';

      final request = {
        'text': textController.text,
      };

      // print("Addbusiness:${request.toString()}");
      // final response = await apiService.addInboundBusinessInfo(request);
      //
      // if (response.success == true) {
      //   // Update documentId from response if provided
      //   if (response.data?.id != null) {
      //     documentId.value = response.data!.id!;
      //   }
      //   await fetchBusinessInfo(); // Refresh data after adding
      //   Get.snackbar(
      //     'Success',
      //     'Business information created successfully',
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: ColorConstants.appThemeColor,
      //     colorText: ColorConstants.white,
      //   );
      // } else {
      //   throw Exception('Failed to create business info');
      // }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: ColorConstants.white,
      );
    } finally {
      isButtonLoading.value = false;
    }
  }

  Future<void> updateBusinessInfo() async {
    if (!hasChanges.value || textController.text.isEmpty) return;

    try {
      isButtonLoading.value = true;
      errorMessage.value = '';

      final request = {
        'text': textController.text,
        'clientId': businessData.value?.clientId ?? '',
        if (documentId.value.isNotEmpty) '_id': documentId.value,
      };

      final response = await apiService.updateInboundBusinessInfo(request, documentId.value);

      if (response.success == true) {
        await fetchBusinessInfo(); // Refresh data after updating
        hasChanges.value = false;
        isEditing.value = false;
        Get.snackbar(
          'Success',
          'Business information updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorConstants.appThemeColor,
          colorText: ColorConstants.white,
        );
      } else {
        throw Exception('Update failed');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: ColorConstants.white,
      );
    } finally {
      isButtonLoading.value = false;
    }
  }

  void toggleEditing() {
    if (isEditing.value) {
      checkForChanges();
    }
    isEditing.value = !isEditing.value;
  }

  void checkForChanges() {
    final originalText = businessData.value?.text ?? '';
    hasChanges.value = textController.text != originalText;
  }

  // Method to set documentId from external source (e.g., auth)
  void setDocumentId(String id) {
    documentId.value = id;
  }
}