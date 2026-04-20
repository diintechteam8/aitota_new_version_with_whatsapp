import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/auth_flow/register/controller/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController());
  }

}