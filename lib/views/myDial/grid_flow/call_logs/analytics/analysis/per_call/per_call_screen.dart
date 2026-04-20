// views/myDial/.../per_call_screen.dart
import 'package:aitota_business/core/app-export.dart';
import 'controller/per_call_controller.dart';

class PerCallScreen extends GetView<PerCallController> {
  const PerCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(
        title: 'Average Call Duration',
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
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: ColorConstants.appThemeColor));
          }

          if (controller.numberOfDays.value == 0 && controller.totalCalls.value == 0) {
            return const Center(
              child: Text('No call data available', style: TextStyle(fontSize: 16, color: Colors.grey)),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _DurationPerDayCard(
                  numberOfDays: controller.numberOfDays.value,
                  totalDuration: controller.totalDuration.value,
                  avgDuration: controller.avgDurationPerDay.value,
                ),
                SizedBox(height: 16.h),
                _DurationPerCallCard(
                  incomingCalls: controller.incomingCalls.value,
                  incomingDuration: controller.incomingDuration.value,
                  incomingAvgDuration: controller.incomingAvgDuration.value,
                  outgoingCalls: controller.outgoingCalls.value,
                  outgoingDuration: controller.outgoingDuration.value,
                  outgoingAvgDuration: controller.outgoingAvgDuration.value,
                  totalCalls: controller.totalCalls.value,
                  totalCallsDuration: controller.totalCallsDuration.value,
                  totalCallsAvgDuration: controller.totalCallsAvgDuration.value,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// CARDS (UNCHANGED – PERFECT)
class _DurationPerDayCard extends StatelessWidget {
  final int numberOfDays;
  final String totalDuration;
  final String avgDuration;
  const _DurationPerDayCard({required this.numberOfDays, required this.totalDuration, required this.avgDuration});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))
        ]),
        padding: EdgeInsets.all(16.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Average Duration per Day', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.black87)),
          SizedBox(height: 12.h),
          const Divider(height: 1),
          SizedBox(height: 12.h),
          _row('No of Days', numberOfDays.toString()),
          SizedBox(height: 10.h),
          _row('Total Duration', totalDuration),
          SizedBox(height: 10.h),
          _row('Avg. Duration', avgDuration),
        ]),
      );

  Widget _row(String l, String v) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(l, style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: Colors.black87)),
        Text(v, style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: Colors.black54))
      ]);
}

class _DurationPerCallCard extends StatelessWidget {
  final int incomingCalls, outgoingCalls, totalCalls;
  final String incomingDuration, outgoingDuration, totalCallsDuration;
  final String incomingAvgDuration, outgoingAvgDuration, totalCallsAvgDuration;

  const _DurationPerCallCard({
    required this.incomingCalls, required this.incomingDuration, required this.incomingAvgDuration,
    required this.outgoingCalls, required this.outgoingDuration, required this.outgoingAvgDuration,
    required this.totalCalls, required this.totalCallsDuration, required this.totalCallsAvgDuration,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))
        ]),
        padding: EdgeInsets.all(16.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Average Duration per Call', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.black87)),
          SizedBox(height: 12.h),
          const Divider(height: 1),
          SizedBox(height: 12.h),
          Row(children: [
            const Expanded(flex: 3, child: SizedBox()),
            Expanded(flex: 2, child: _h('No of Calls')),
            Expanded(flex: 2, child: _h('Duration')),
            Expanded(flex: 2, child: _h('Avg.\nDuration')),
          ]),
          SizedBox(height: 10.h),
          _r(Icons.phone_callback, const Color(0xFF4CAF50), 'Incoming', incomingCalls, incomingDuration, incomingAvgDuration),
          SizedBox(height: 8.h),
          _r(Icons.phone_forwarded, const Color(0xFFFFA726), 'Outgoing', outgoingCalls, outgoingDuration, outgoingAvgDuration),
          SizedBox(height: 8.h),
          _r(null, null, 'Total Calls', totalCalls, totalCallsDuration, totalCallsAvgDuration),
        ]),
      );

  Widget _h(String t) => Text(t, textAlign: TextAlign.center, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500, color: Colors.black87), maxLines: 2);
  Widget _r(IconData? i, Color? c, String l, int n, String d, String a) => Row(children: [
        Expanded(flex: 3, child: Row(children: [
          if (i != null) ...[Icon(i, color: c, size: 16.sp), SizedBox(width: 6.w)],
          Text(l, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: c ?? Colors.black87))
        ])),
        Expanded(flex: 2, child: Text(n.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp))),
        Expanded(flex: 2, child: Text(d, textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp))),
        Expanded(flex: 2, child: Text(a, textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp))),
      ]);
}