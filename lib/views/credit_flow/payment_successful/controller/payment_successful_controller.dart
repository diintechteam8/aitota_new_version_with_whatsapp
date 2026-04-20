import 'package:aitota_business/core/app-export.dart';

class PaymentSuccessfulController extends GetxController {
  var plan = Rx<dynamic>(null);
  var orderId = ''.obs;
  var customerName = ''.obs;
  var customerPhone = ''.obs;
  var customerEmail = ''.obs;

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
      customerName.value = arguments['customerName'] ?? '';
      customerPhone.value = arguments['customerPhone'] ?? '';
      customerEmail.value = arguments['customerEmail'] ?? '';
      
      print("Payment Success Controller - Loaded Arguments:");
      print("Plan: ${plan.value}");
      print("Order ID: ${orderId.value}");
      print("Customer Name: ${customerName.value}");
      print("Customer Phone: ${customerPhone.value}");
      print("Customer Email: ${customerEmail.value}");
    }
  }

  void goToDashboard() {
    Get.offAllNamed('/dashboard'); // Adjust route as needed
  }

  void goToBottomBar() {
    Get.offAllNamed('/bottom_bar_screen');
  }

  void sharePaymentSuccess() {
    final message = '''
 Payment Successful! 🎉

Plan: ${plan.value?.planName ?? 'N/A'}
Credits: ${plan.value?.credits ?? 0}
Amount: ₹${plan.value?.offerPrice ?? 0}
Order ID: ${orderId.value}

Thank you for choosing our service!
    ''';
    
    Get.snackbar(
      'Share',
      'Payment success details copied to clipboard',
      backgroundColor: const Color(0xFF22C55E),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}