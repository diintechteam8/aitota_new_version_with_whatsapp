import 'package:aitota_business/core/app-export.dart';

class PaymentFailedController extends GetxController {
  var plan = Rx<dynamic>(null);
  var orderId = ''.obs;
  var errorCode = ''.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
  }

  void _loadArguments() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      plan.value = arguments['plan'];
      orderId.value = arguments['orderId'] ?? '';
      errorCode.value = arguments['errorCode'] ?? '';
      errorMessage.value = arguments['errorMessage'] ?? '';
      
      print("Payment Failed Controller - Loaded Arguments:");
      print("Plan: ${plan.value}");
      print("Order ID: ${orderId.value}");
      print("Error Code: ${errorCode.value}");
      print("Error Message: ${errorMessage.value}");
    }
  }

  void tryAgain() {
    Get.back(); // Go back to payment screen
  }

  void goToBottomBar() {
    Get.offAllNamed('/bottom_bar_screen');
  }

  void contactSupport() {
    Get.snackbar(
      'Contact Support',
      'Support team will contact you soon',
      backgroundColor: const Color(0xFFEF4444),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}