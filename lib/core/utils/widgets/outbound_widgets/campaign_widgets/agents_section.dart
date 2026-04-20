import '../../../../../views/outbound/grid_flow/campaign/detail_screen/controller/outbound_campaign_detail_controller.dart';
import '../../../../app-export.dart';

class AgentsSection extends StatelessWidget {
  final OutboundCampaignDetailController controller;
  final bool isDark;

  const AgentsSection({super.key, required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Agents (${controller.agents.length})',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.poppins,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.add_circle,
                color: Colors.green.shade600,
                size: 26.sp,
              ),
              onPressed: () => controller.showAgentBottomSheet(context),
              splashRadius: 20.r,
              tooltip: 'Add Agent',
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Obx(() {
          if (controller.agents.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.support_agent,
                    size: 32.sp,
                    color: Colors.grey.withOpacity(0.6),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'To start your campaign,\n first add at least one agent.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppFonts.poppins,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return SizedBox(
              height: 110.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                itemCount: controller.agents.length,
                itemBuilder: (context, index) {
                  final agent = controller.agents[index];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 160.w,
                    margin: EdgeInsets.only(right: 12.w, bottom: 8.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: isDark ? Colors.black.withOpacity(0.15) : Colors.grey.withOpacity(0.1),
                          blurRadius: 8.r,
                          offset: const Offset(0, 2),
                          spreadRadius: 1,
                        ),
                      ],
                      border: Border.all(
                        color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade200,
                        width: 1.w,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomStatusBadge(
                          status: agent['status'] ?? 'unknown',
                          isDark: isDark,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                agent['name']?.toString() ?? 'Unknown', // Changed from 'N/A' to 'Unknown'
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppFonts.poppins,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                agent['status']?.toString() ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: AppFonts.poppins,
                                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        }),
      ],
    );
  }
}