import '../../core/app-export.dart';
import 'controller/outbound_controller.dart';

class OutboundScreen extends GetView<OutboundScreenController> {
  const OutboundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF0F2F5), // Light background like groups screen
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorConstants.whatsappGradientDark,
              ColorConstants.whatsappGradientLight,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.w,
              childAspectRatio: 1.2,
              children: [
                CustomGridItem(
                  title: 'Campaign',
                  icon: Icons.campaign_outlined,
                  onTap: controller.onCampaignTap,
                ),
                CustomGridItem(
                  title: 'Contact',
                  icon: Icons.contact_page,
                  onTap: controller.onContactTap,
                ),
                CustomGridItem(
                  title: 'Reports',
                  icon: Icons.analytics,
                  onTap: controller.onReportsTap,
                ),
                CustomGridItem(
                  title: 'Call Logs',
                  icon: Icons.call,
                  onTap: controller.onCallLogsTap,
                ),
                CustomGridItem(
                  title: 'Leads',
                  icon: Icons.person_add,
                  onTap: controller.onLeadsTap,
                ),
                CustomGridItem(
                  title: 'Settings',
                  icon: Icons.settings,
                  onTap: controller.onSettingsTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
