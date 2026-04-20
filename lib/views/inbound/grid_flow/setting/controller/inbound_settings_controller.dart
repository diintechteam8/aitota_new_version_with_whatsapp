import 'package:aitota_business/core/app-export.dart';

import '../../../../../routes/app_routes.dart';

class InboundSettingsController extends GetxController {
  void onAIAgentTap() {
    Get.toNamed(AppRoutes.inboundAiAgentScreen);
  }

  void onBusinessInfoTap() {
    Get.toNamed(AppRoutes.inboundBusinessInfoScreen);
  }
}