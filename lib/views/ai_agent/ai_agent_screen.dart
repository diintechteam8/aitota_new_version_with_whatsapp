import 'package:aitota_business/routes/app_routes.dart';
import '../../core/app-export.dart';
import '../../core/utils/widgets/app_widgets/custom_button.dart';
import '../../core/utils/widgets/inbound_widgets/custom_agent_card.dart';
import 'controller/ai_agent_controller.dart';

class AiAgentScreen extends GetView<AiAgentController> {
  final bool isFromBottomNav;

  const AiAgentScreen({super.key, this.isFromBottomNav = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Agents",
        titleStyle: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,fontFamily: AppFonts.poppins,color: ColorConstants.white),
        showBackButton: true,
        onTapBack: () => Get.back(),
      ),
      body: SafeArea(
        top: false,
        child: Obx(
          () => RefreshIndicator(
            onRefresh: controller.refreshAgentData,
            color: ColorConstants.appThemeColor,
            child: Stack(
              children: [
                ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    if (controller.isLoading.value)
                      const SizedBox(
                        height: 400,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              ColorConstants.appThemeColor,
                            ),
                          ),
                        ),
                      )
                    else if (controller.errorMessage.value.isNotEmpty)
                      SizedBox(
                        height: 400,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.errorMessage.value,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppFonts.poppins,
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16.h),
                              CustomButton(
                                text: "Retry",
                                height: 48.h,
                                width: 120.w,
                                onTap: controller.refreshAgentData,
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (controller.agents.isEmpty)
                      SizedBox(
                        height: 400,
                        child: Center(
                          child: Text(
                            'No Agents Available',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppFonts.poppins,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 20.h,
                        ),
                        itemCount: controller.agents.length,
                        itemBuilder: (context, index) {
                          final agent = controller.agents[index];
                          final agentData = controller.agentDataList[index];
                          return CustomAgentCard(
                            title: agent['title'] as String,
                            status: agent['status'] as String,
                            callingType: agent['callingType'] as String?,
                            value: agent['value'] as String?,
                            icon: agent['icon'] as IconData,
                            iconColor: agent['iconColor'] as Color,
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.aiAiAgentDetailScreen,
                                arguments: agentData,
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}