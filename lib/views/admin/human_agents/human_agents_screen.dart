import '../../../core/app-export.dart';
import 'controller/human_agents_controller.dart';
import '../../../data/model/more/get_all_human_agents.dart';

class HumanAgentsScreen extends GetView<HumanAgentsController> {
  const HumanAgentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: CustomAppBar(
        title: "Team Members",
        showBackButton: true,
        titleStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.poppins,
        ),
      ),
      body: SafeArea(
        top: false,
        child: Obx(() {
          // 1. Loading State
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Empty / Error State
          if (controller.humanAgents.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 40.w,
                    color: ColorConstants.grey,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No Team Members Found',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.poppins,
                      color: ColorConstants.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'You don\'t have any team members assigned yet.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: AppFonts.poppins,
                      color: ColorConstants.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // 3. Success: List
          return RefreshIndicator(
            onRefresh: controller.loadHumanAgents,
            color: ColorConstants.appThemeColor,
            backgroundColor: ColorConstants.white,
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: controller.humanAgents.length,
              itemBuilder: (context, index) {
                final agent = controller.humanAgents[index];
                return _buildAgentCard(agent);
              },
            ),
          );
        }),
      ),
    );
  }

  // --------------------------------------------------------------
  //  Agent Card
  // --------------------------------------------------------------
  Widget _buildAgentCard(HumanAgent agent) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ColorConstants.grey.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----- Avatar + Name + Type -----
            Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: ColorConstants.appThemeColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      agent.humanAgentName?.substring(0, 1).toUpperCase() ??
                          'A',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorConstants.appThemeColor,
                        fontFamily: AppFonts.poppins,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        agent.humanAgentName ?? 'Unknown',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.poppins,
                          color: ColorConstants.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (agent.isApproved == true) ...[
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color:
                                ColorConstants.appThemeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            agent.type?.capitalizeFirst ?? 'Unknown',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppFonts.poppins,
                              color: ColorConstants.appThemeColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // ----- Email / Phone -----
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: ColorConstants.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  if (agent.email != null && agent.email!.isNotEmpty)
                    _buildInfoRow(
                      icon: Icons.email_outlined,
                      text: agent.email!,
                    ),
                  if (agent.email != null &&
                      agent.email!.isNotEmpty &&
                      agent.mobileNumber != null &&
                      agent.mobileNumber!.isNotEmpty)
                    SizedBox(height: 8.h),
                  if (agent.mobileNumber != null &&
                      agent.mobileNumber!.isNotEmpty)
                    _buildInfoRow(
                      icon: Icons.phone_outlined,
                      text: agent.mobileNumber!,
                    ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () => controller.switchToAgent(agent),
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorConstants.appThemeColor,
      foregroundColor: ColorConstants.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.login_rounded, size: 18.sp),
            SizedBox(width: 6.w),
            // Flexible + ConstrainedBox to prevent overflow
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth - 50, // ~icon + spacing
                ),
                child: Text(
                  'Login as ${agent.humanAgentName ?? 'Agent'}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.poppins,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
            ),
          ],
        );
      },
    ),
  ),
),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------
  //  Helper: Info Row (email / phone)
  // --------------------------------------------------------------
  Widget _buildInfoRow(
      {required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: ColorConstants.grey,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.poppins,
              color: ColorConstants.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}