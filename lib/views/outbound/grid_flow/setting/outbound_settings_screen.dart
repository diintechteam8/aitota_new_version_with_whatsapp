import 'package:aitota_business/views/inbound/grid_flow/setting/controller/inbound_settings_controller.dart';
import '../../../../core/app-export.dart';
import 'controller/outbound_settings_controller.dart';

class OutboundSettingsScreen extends GetView<OutboundSettingsController> {
  const OutboundSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16.h,
            crossAxisSpacing: 16.w,
            childAspectRatio: 1.2,
            children: [
              CustomGridItem(
                title: 'AI Agent',
                icon: Icons.smart_toy,
                onTap: controller.onAIAgentTap,
              ),
              // CustomGridItem(
              //   title: 'Business Info',
              //   icon: Icons.business,
              //   onTap: controller.onBusinessInfoTap,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
