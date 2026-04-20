import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/services/api_services.dart';
import 'package:aitota_business/core/services/dio_client.dart';
import '../../../../../../../data/model/inbound/settings/business_info/update_business_info_model.dart' as Data;
import '../../../../../../../data/model/inbound/settings/business_info/update_business_info_model.dart';

class OutboundBusinessInfoController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final textController = TextEditingController();
  final isLoading = false.obs;
  final isEditing = false.obs;
  final hasChanges = false.obs;
  final errorMessage = ''.obs;
  String agentId = 'default-agent-id'; // Replace with actual agentId retrieval logic
  UpdateInboundBusinessInfoModel? inboundBusinessModel;

  @override
  void onInit() {
    super.onInit();
    // fetchBusinessInfo();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  // Future<void> fetchBusinessInfo() async {
  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';
  //     final response = await apiService.getInboundBusinessInfo(agentId);
  //     inboundBusinessModel = response;
  //     if (response.success == true && response.data != null) {
  //       businessData.value = response.data;
  //       textController.text = response.data?.text ?? '';
  //       hasChanges.value = false;
  //     } else {
  //       errorMessage.value = 'No business info found';
  //       businessData.value = null;
  //     }
  //   } catch (e) {
  //     errorMessage.value = e.toString();
  //     Get.snackbar(
  //       'Error',
  //       e.toString(),
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: ColorConstants.appThemeColor,
  //       colorText: ColorConstants.white,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  void toggleEditing() {
    if (isEditing.value) {
      checkForChanges();
    }
    isEditing.value = !isEditing.value;
  }

  void checkForChanges() {
    // final originalText = businessData.value?.text ?? '';
    // hasChanges.value = textController.text != originalText;
  }

  Future<void> updateBusinessInfo() async {
    if (!hasChanges.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final request = {
        'text': textController.text,
        // 'clientId': businessData.value?.clientId ?? '',
      };
      final response = await apiService.updateInboundBusinessInfo(request, agentId);

      if (response.success == true) {
        // await fetchBusinessInfo();
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
      isLoading.value = false;
    }
  }
}