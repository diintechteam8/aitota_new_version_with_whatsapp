import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/ai_leads/campaign_contacts/controller/ai_leads_campaign_contacts_controller.dart';

import '../../../../../core/utils/widgets/outbound_widgets/reports/reports_card.dart';

class AiLeadsCampaignContactsScreen extends GetView<AiLeadsCampaignContactsController> {
  const AiLeadsCampaignContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: CustomAppBar(
        title: "Details",
        titleStyle: TextStyle(
          fontFamily: AppFonts.poppins,
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
        ),
        showBackButton: true,
      ),
      body: Obx(() {
        // 1. Loading State — Highest Priority
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    ColorConstants.appThemeColor,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Loading leads...',
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.grey,
                  ),
                ),
              ],
            ),
          );
        }

        // 2. Empty State — Only when NOT loading and no data
        if (controller.leads.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sentiment_dissatisfied,
                  size: 64.sp,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 16.h),
                Text(
                  'No leads available',
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.grey,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Pull down to refresh',
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 14.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        }

        // 3. Data Available — Show List
        return RefreshIndicator(
          onRefresh: controller.refreshData,
          color: ColorConstants.appThemeColor,
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.leads.length,
            itemBuilder: (context, index) {
              final lead = controller.leads[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: AiLeadsCard(
                  lead: lead,
                  onTap: () => controller.onItemTap(lead),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}