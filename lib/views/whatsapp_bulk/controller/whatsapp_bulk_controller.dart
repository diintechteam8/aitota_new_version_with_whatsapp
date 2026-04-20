import 'package:get/get.dart';
import '../../../../core/app-export.dart';
import '../../../routes/app_routes.dart';

class WhatsAppBulkController extends GetxController {
  // Stats
  RxInt totalBroadcasts = 0.obs;
  RxDouble deliveryRate = 0.0.obs;
  RxDouble readRate = 0.0.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStats();
  }

  Future<void> fetchStats() async {
    isLoading.value = true;
    try {
      // Logic to fetch stats from API or OutboundCampaignController
      // For now, using mock data for "AiSensy" look
      await Future.delayed(const Duration(seconds: 1));
      totalBroadcasts.value = 1240;
      deliveryRate.value = 98.2;
      readRate.value = 85.5;
    } finally {
      isLoading.value = false;
    }
  }

  void viewCampaigns() {
        // Get.toNamed(AppRoutes.addOutboundCampaignScreen);
    Get.toNamed(AppRoutes.whatsappCampaignsScreen);
  }

  void manageTemplates() {
    Get.toNamed(AppRoutes.whatsappTemplatesScreen);
  }

  void importContacts() {
    Get.toNamed(AppRoutes.audienceSelectionScreen);
  }

  void viewReports() {
    Get.toNamed(AppRoutes.whatsappReportsScreen);
  }

  void openInbox() {
    Get.toNamed(AppRoutes.whatsappInboxScreen);
  }
}
