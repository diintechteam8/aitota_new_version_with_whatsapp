import 'package:aitota_business/views/inbound/grid_flow/setting/controller/inbound_settings_controller.dart';
import '../../../../core/app-export.dart';

class InboundSettingsScreen extends GetView<InboundSettingsController> {
  const InboundSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 8.w,
            childAspectRatio: 1,
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