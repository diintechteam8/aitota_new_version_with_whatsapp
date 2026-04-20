import 'dart:convert';
import 'package:aitota_business/core/app-export.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../data/model/auth_models/register_step1_model.dart';
import '../../../../routes/app_routes.dart';

class RegisterStep1Controller extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxString errorMessage = ''.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> registerStep1() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Try to parse password as int if it's purely numeric
      dynamic passwordValue = passwordController.text;
      if (RegExp(r'^\d+$').hasMatch(passwordValue)) {
        passwordValue = int.tryParse(passwordValue) ?? passwordValue;
      }

      final request = RegisterStep1Request(
        email: emailController.text.trim(),
        password: passwordValue,
        clientId: Constants.clientId,
      );

      final response = await apiService.registerStep1(request);

      if (response.success == true) {
        // ✅ Save session/userId if provided
        if (response.token != null) {
          await secureStorage.write(key: Constants.token, value: response.token!);
        }
        
        final uid = response.userId ?? response.user?.id;
        if (uid != null) {
          await secureStorage.write(key: Constants.id, value: uid);
        }

        Get.snackbar('Success', response.message ?? 'Registration Step 1 successful');

        if (response.nextStep == 'step2_send_mobile_otp') {
          print('--- Saving Auth Step: ${AppRoutes.mobileVerifyScreen} ---');
          await secureStorage.write(
              key: Constants.lastAuthStep, value: AppRoutes.mobileVerifyScreen);
          await secureStorage.write(
              key: Constants.lastAuthData,
              value: jsonEncode({'email': emailController.text.trim()}));

          Get.toNamed(AppRoutes.mobileVerifyScreen,
              arguments: {'email': emailController.text.trim()});
        } else {
          print('--- Saving Auth Step: ${AppRoutes.emailOtpScreen} ---');
          await secureStorage.write(
              key: Constants.lastAuthStep, value: AppRoutes.emailOtpScreen);
          await secureStorage.write(
              key: Constants.lastAuthData,
              value: jsonEncode({'email': emailController.text.trim()}));

          Get.toNamed(AppRoutes.emailOtpScreen,
              arguments: {'email': emailController.text.trim()});
        }
      } else {
        errorMessage.value = response.message ?? 'Registration failed';
        print("RegisterStep1 Error: ${errorMessage.value}");
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      print("RegisterStep1 Exception: ${errorMessage.value}");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
