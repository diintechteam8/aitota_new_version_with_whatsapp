import 'package:aitota_business/routes/app_routes.dart';
import '../../../../../../core/app-export.dart';
import '../../../../../../core/utils/widgets/inbound_widgets/custom_agent_card.dart';
import 'controller/inbound_ai_agent_controller.dart';

class InboundAiAgentScreen extends GetView<InboundAiAgentController> {
  const InboundAiAgentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Agents",
        showBackButton: true,
        onTapBack: () => Get.back(),
        titleStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.poppins,
          color: ColorConstants.white,
        ),
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: controller.refreshAgentData,
          color: ColorConstants.appThemeColor,
          child: Stack(
            children: [
              // ----------- MAIN CONTENT -----------
              ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  // ---------- LOADING ----------
                  if (controller.isLoading.value)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.3,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                ColorConstants.appThemeColor,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Loading agents...',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: AppFonts.poppins,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )

                  // ---------- EMPTY STATE ----------
                  else if (controller.agents.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.3,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.sentiment_dissatisfied,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'No agents found',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppFonts.poppins,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )

                  // ---------- LIST ----------
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
                          callingType: agent['callingType'] as String,
                          value: agent['value'] as String?,
                          icon: agent['icon'] as IconData,
                          iconColor: agent['iconColor'] as Color,
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.inboundAiAgentDetailScreen,
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
    );
  }
}
