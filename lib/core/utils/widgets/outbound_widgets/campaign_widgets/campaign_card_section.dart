import '../../../../../views/outbound/grid_flow/campaign/detail_screen/controller/outbound_campaign_detail_controller.dart';
import '../../../../app-export.dart';

class CampaignCardSection extends StatelessWidget {
  final OutboundCampaignDetailController controller;
  final bool isDark;

  const CampaignCardSection({super.key, required this.controller, required this.isDark});

  Color _getCategoryColor(String category) => Colors.green.shade600;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CustomCampaignCard(
          name: controller.campaignDetail.value?.data?.name,
          category: controller.campaignDetail.value?.data?.category,
          description: controller.campaignDetail.value?.data?.description,
          isDark: isDark,
          categoryColor: _getCategoryColor(
            controller.campaignDetail.value?.data?.category ?? '',
          ),
        ),
        if (controller.isCampaignRunning.value)
          Positioned(
            bottom: -20.h,
            right: 8.w,
            child: Container(
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 8.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  controller.isSectionsFolded.value ? Icons.expand_more : Icons.expand_less,
                  color: isDark ? Colors.white : Colors.black,
                  size: 24.sp,
                ),
                onPressed: () {
                  controller.isSectionsFolded.value = !controller.isSectionsFolded.value;
                  print('isSectionsFolded toggled to: ${controller.isSectionsFolded.value}');
                },
              ),
            ),
          ),
      ],
    );
  }
}