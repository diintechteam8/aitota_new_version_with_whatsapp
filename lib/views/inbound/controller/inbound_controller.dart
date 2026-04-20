import 'package:aitota_business/core/app-export.dart';
import '../../../routes/app_routes.dart';



class InboundScreenController extends GetxController {
  void onReportsTap() {
   Get.toNamed(AppRoutes.inboundReportsScreen);

  }

  void onConversationsTap() {
    Get.toNamed(AppRoutes.inboundConversationsScreen);

  }

  void onLeadsTap() {
    Get.toNamed(AppRoutes.inboundLeadsScreen);
  }

  void onSettingsTap() {
    Get.toNamed(AppRoutes.inboundSettingsScreen);

  }
}