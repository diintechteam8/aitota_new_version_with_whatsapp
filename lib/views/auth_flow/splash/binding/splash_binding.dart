import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/auth_flow/splash/controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }

}