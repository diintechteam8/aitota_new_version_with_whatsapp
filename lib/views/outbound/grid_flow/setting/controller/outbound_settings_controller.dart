import 'package:aitota_business/core/app-export.dart';

import '../../../../../routes/app_routes.dart';

class OutboundSettingsController extends GetxController {
  void onAIAgentTap() {
    Get.toNamed(AppRoutes.outboundAiAgentScreen);
  }

  void onTollFreeTap() {
    // TODO: Implement navigation to Toll Free/DID settings screen
    // Get.toNamed(AppRoutes.tollFreeSettings);
  }

  void onGreetingsTap() {
    // TODO: Implement navigation to Greetings settings screen
    // Get.toNamed(AppRoutes.greetingsSettings);
  }

  void onBusinessInfoTap() {
    // TODO: Implement navigation to Business Information settings screen
    // Get.toNamed(AppRoutes.businessInfoSettings);
  }
}