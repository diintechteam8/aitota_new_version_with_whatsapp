import 'package:aitota_business/views/auth_flow/register/controller/register_step1_controller.dart';
import 'package:get/get.dart';

class RegisterStep1Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterStep1Controller());
  }
}
