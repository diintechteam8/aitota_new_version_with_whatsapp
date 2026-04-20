import 'package:aitota_business/views/inbound/controller/inbound_controller.dart';
import '../../core/app-export.dart';

class InboundScreen extends GetView<InboundScreenController> {
  const InboundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Light background like groups screen
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16.h,
            crossAxisSpacing: 16.w,
            childAspectRatio: 1.2,
            children: [
              CustomGridItem(
                title: 'Reports',
                icon: Icons.analytics,
                onTap: controller.onReportsTap,
              ),
              CustomGridItem(
                title: 'Conversations',
                icon: Icons.chat_bubble_outline_sharp,
                onTap: controller.onConversationsTap,
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
    );
  }
}