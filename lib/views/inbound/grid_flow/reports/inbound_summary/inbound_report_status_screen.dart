import 'package:aitota_business/core/app-export.dart';
import '../../../../../core/utils/widgets/outbound_widgets/reports/reports_card.dart';
import 'controller/inbound_reports_status_controller.dart';

class InboundReportStatusScreen extends GetView<InboundReportStatusController> {
  const InboundReportStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: controller.title,
        titleStyle: TextStyle(
          fontFamily: AppFonts.poppins,
          fontWeight: FontWeight.w500,
          color: ColorConstants.white,
          fontSize: 16.sp,
        ),
        showBackButton: true,
        onTapBack: () => Get.back(),
      ),
      body: SafeArea(
        top: false,
        child: Obx(() => Stack(
          children: [
            controller.leads.isEmpty
                ? Center(
              child: Text(
                'No data available',
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorConstants.grey,
                ),
              ),
            )
                : RefreshIndicator(
              onRefresh: controller.refreshData,
              color: Colors.transparent, // Matches AiLeadsScreen
              strokeWidth: 0.0, // Matches AiLeadsScreen
              child: ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: controller.leads.length,
                itemBuilder: (context, index) {
                  final lead = controller.leads[index];
                  return ReportCard( // Replaced LeadCard with ReportCard
                    lead: lead,
                    onTap: () => controller.onItemTap(lead),
                  );
                },
              ),
            ),
            if (controller.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.3), // Matches AiLeadsScreen
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            ColorConstants.appThemeColor),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Loading...',
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        )),
      ),
    );
  }
}