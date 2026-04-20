import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/credit_flow/payment_failed/controller/payment_failed_controller.dart';

class PaymentFailedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentFailedController());
  }

}