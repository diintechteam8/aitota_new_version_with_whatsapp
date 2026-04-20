import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/credit_flow/add_amount_plan/controller/add_recharge_controller.dart';

class AddRechargeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddRechargeController());
  }

}