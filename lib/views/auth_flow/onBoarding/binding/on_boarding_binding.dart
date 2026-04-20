import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/auth_flow/onBoarding/controller/on_boarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingController());
  }

}