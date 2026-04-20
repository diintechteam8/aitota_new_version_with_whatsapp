import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/credit_flow/history/controller/payment_history_controller.dart';

class PaymentHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentHistoryController());
  }

}