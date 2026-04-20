import 'package:aitota_business/core/app-export.dart';
import '../controller/payment_successful_controller.dart';

class PaymentSuccessfulBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentSuccessfulController());
  }

}