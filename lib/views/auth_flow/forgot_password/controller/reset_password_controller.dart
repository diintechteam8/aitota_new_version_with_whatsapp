import 'package:aitota_business/core/app-export.dart';
import '../../../../core/services/api_endpoints.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../data/model/auth_models/forgot_password_model.dart';
import '../../../../routes/app_routes.dart';

class ResetPasswordController extends GetxController {
  final ApiService _apiService = ApiService(dio: DioClient().dio);

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxString errorMessage = ''.obs;

  String? resetToken;
  String? email;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      resetToken = Get.arguments['resetToken'];
      email = Get.arguments['email'];
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> resetPassword() async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorConstants.redColor.withOpacity(0.1),
          colorText: ColorConstants.redColor);
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorConstants.redColor.withOpacity(0.1),
          colorText: ColorConstants.redColor);
      return;
    }

    if (resetToken == null || email == null) {
      Get.snackbar('Error', 'Invalid reset session. Please try again from the Forgot Password screen.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorConstants.redColor.withOpacity(0.1),
          colorText: ColorConstants.redColor);
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final request = ResetPasswordRequest(
        email: email,
        clientId: Constants.clientId,
        resetToken: resetToken,
        newPassword: newPassword,
      );

      print('--- Reset Password API Call ---');
      print('URL: ${ApiEndpoints.newBaseUrl}${ApiEndpoints.resetPassword}');
      print('Request Data: ${request.toJson()}');

      final response = await _apiService.resetPassword(request);

      if (response.success == true) {
        Get.snackbar(
          'Success',
          response.message ?? 'Password reset successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorConstants.appThemeColor.withOpacity(0.1),
          colorText: ColorConstants.colorHeading,
        );
        // Navigate all the way back to the Email Login screen
        Get.offAllNamed(AppRoutes.emailLoginScreen);
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to reset password.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorConstants.redColor.withOpacity(0.1),
          colorText: ColorConstants.redColor,
        );
      }
    } catch (e) {
      String error = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'Error',
        error,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorConstants.redColor.withOpacity(0.1),
        colorText: ColorConstants.redColor,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
