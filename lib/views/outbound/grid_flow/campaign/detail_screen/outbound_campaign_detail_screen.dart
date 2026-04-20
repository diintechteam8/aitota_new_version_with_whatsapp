import '../../../../../core/app-export.dart';
import '../../../../../core/utils/widgets/outbound_widgets/campaign_widgets/campaign_content.dart';
import '../../../../../core/utils/widgets/outbound_widgets/campaign_widgets/error_display.dart';
import '../../../../../core/utils/widgets/outbound_widgets/campaign_widgets/run_campaign_button.dart';
import 'controller/outbound_campaign_detail_controller.dart';

class OutboundCampaignDetailScreen
    extends GetView<OutboundCampaignDetailController> {
  const OutboundCampaignDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Details",
        showBackButton: true,
        onTapBack: () => Get.back(),
        titleStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.poppins,
          color: ColorConstants.white,
        ),
        actions: [
          RunCampaignButton(controller: controller),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                  strokeWidth: 2,
                ),
              )
            : controller.errorMessage.value.isNotEmpty
                ? ErrorDisplay(errorMessage: controller.errorMessage.value)
                : controller.campaignDetail.value?.data == null
                    ? const SizedBox.shrink()
                    : CampaignContent(controller: controller, isDark: isDark),
      ),
    );
  }
}
