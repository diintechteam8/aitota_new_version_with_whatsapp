// ai_leads_campaign_screen.dart
import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/ai_leads/controller/ai_leads_controller.dart';
import '../../../../routes/app_routes.dart';

class AiLeadsCampaignScreen extends GetView<AILeadsCampaignController> {
  const AiLeadsCampaignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color themeGreen = Colors.green.shade600;

    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      body: Obx(() {
        final bool isAnyLoading = controller.isLoading.value || controller.isRetrying.value;

        // Full screen loading (only on first load or retry when list is empty)
        if (isAnyLoading && controller.leadItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: themeGreen, strokeWidth: 3),
                const SizedBox(height: 16),
                Text(
                  "Loading your ai leads...",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15.sp,fontFamily: AppFonts.poppins),
                ),
              ],
            ),
          );
        }

        // No Data → Show Retry Button with Loading State
        if (controller.leadItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person_search_outlined,
                  size: 40.w,
                  color: Colors.grey.withOpacity(0.6),
                ),
                const SizedBox(height: 12),
                Text(
                  "No leads found",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.poppins,
                  ),
                ),
                const SizedBox(height: 12),

                // Beautiful Loading Retry Button
                SizedBox(
                  width: 150,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: controller.isRetrying.value
                        ? null // Disable when loading
                        : () => controller.fetchAllLeads(isRetry: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeGreen,
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shadowColor: themeGreen.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: controller.isRetrying.value
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.8,
                            ),
                          )
                        : const Icon(Icons.refresh, size: 26),
                    label: Text(
                      controller.isRetrying.value ? "Loading..." : "Retry",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Success → Show List
        return RefreshIndicator(
          onRefresh: () => controller.fetchAllLeads(isRetry: true),
          color: themeGreen,
          backgroundColor: Colors.white,
          displacement: 40,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 12.h,),
            itemCount: controller.leadItems.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final item = controller.leadItems[index];
              return CustomOutboundCampaignCardWidget(
                id: item['campaignId'] ?? '',
                name: item['campaignName'] ?? 'Unnamed Campaign',
                showVerts: false,
                description: item['description'] ?? 'No description',
                category: item['totalAssignedContacts']?.toString() ?? '0',
                lastAssignedAt: item['lastAssignedAt'],
                onViewDetails: () {
                  Get.toNamed(AppRoutes.aiLeadsCampaignContactsScreen,
                    arguments: {
                    'campaignId':item['campaignId'] ?? '',
                  });
                },
              );
            },
          ),
        );
      }),
    );
  }
}