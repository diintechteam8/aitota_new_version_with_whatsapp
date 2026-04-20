import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/utils/widgets/analytics_widgets/summary_widgets/call_stats_card_widget.dart';
import 'controller/top_caller_controller.dart';

class TopCallerScreen extends GetView<TopCallerController> {
  const TopCallerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: CustomAppBar(
        title: controller.screenTitle,
        titleStyle: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        showBackButton: true,
        onTapBack: () => Get.back(),
      ),
      body: SafeArea(
        top: false,
        child: Obx(() {
          final stats = controller.currentStats.value;

          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: ColorConstants.appThemeColor),
            );
          }

          if (stats == null || stats.name == 'No Data') {
            return const Center(
              child: Text(
                'No calls found for this period',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
            child: CallStatsCard(data: stats),
          );
        }),
      ),
    );
  }
}