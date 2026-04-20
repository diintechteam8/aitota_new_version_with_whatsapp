import 'package:aitota_business/core/app-export.dart';
import '../../../routes/app_routes.dart';

class OutboundScreenController extends GetxController {

  void onReportsTap() {
    // Navigate to Reports screen or handle action

  }
  
  void onCampaignTap() {
    
  }
  
  void onContactTap() {
    Get.toNamed(AppRoutes.outBoundGroupScreen);
  }

  void onCallLogsTap() {
    Get.toNamed(AppRoutes.callLogsScreen);

  }

  void onLeadsTap() {
    // Navigate to Leads screen or handle action

  }

  void onSettingsTap() {
    // Navigate to Settings screen or handle action

  }
}