import 'package:aitota_business/core/app-export.dart';
import '../../../../../../core/utils/widgets/analytics_widgets/summary_widgets/never_attended_calls_card.dart';
import 'controller/never_attended_calls_controller.dart';

class NeverAttendedCallsScreen extends GetView<NeverAttendedCallsController> {
  const NeverAttendedCallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
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
        child: Container(
          color: Colors.white,
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: ColorConstants.appThemeColor),
              );
            }

            if (controller.calls.isEmpty) {
              return Center(
                child: Text(
                  'No calls found',
                  style: TextStyle(fontFamily: AppFonts.poppins, fontSize: 16.sp, color: Colors.grey),
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: controller.calls.length,
              separatorBuilder: (_, __) => const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
              itemBuilder: (_, i) {
                final item = controller.calls[i];
                return NeverAttendedCallsCard(
                  name: item.name,
                  phoneNumber: item.phoneNumber,
                  callCount: '${item.callCount} calls',
                  dateTime: '${item.date} ${item.time}',
                );
              },
            );
          }),
        ),
      ),
    );
  }
}