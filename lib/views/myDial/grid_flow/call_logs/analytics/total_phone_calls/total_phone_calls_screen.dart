// total_phone_calls_screen.dart
import 'package:aitota_business/views/myDial/grid_flow/call_logs/analytics/total_phone_calls/controller/total_phone_call_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../../../core/app-export.dart';

class TotalPhoneCallsScreen extends GetView<TotalPhoneCallsController> {
  const TotalPhoneCallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(
        title: 'Total Calls & Duration',
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
          return Stack(
            children: [
              const SummaryTab(), // Only Summary tab now
              if (controller.isLoading.value)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(ColorConstants.appThemeColor),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

// -----------------------------
// SUMMARY TAB (Only)
// -----------------------------
class SummaryTab extends GetView<TotalPhoneCallsController> {
  const SummaryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildPieChartCard(),
          const SizedBox(height: 20),
          _buildStatsTable(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPieChartCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 6,
            children: [
              _buildLegend('Incoming', const Color(0xFF8BC34A), () => controller.incomingCount),
              _buildLegend('Outgoing', const Color(0xFFFF9800), () => controller.outgoingCount),
              _buildLegend('Missed', const Color(0xFFE57373), () => controller.missedCount),
              _buildLegend('Rejected', const Color(0xFF8B0000), () => controller.rejectedCount),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 230,
            child: Obx(() => PieChart(
                  PieChartData(
                    centerSpaceRadius: 45,
                    sectionsSpace: 4,
                    borderData: FlBorderData(show: false),
                    sections: [
                      _pieSection(controller.incomingCount.value, const Color(0xFF8BC34A)),
                      _pieSection(controller.outgoingCount.value, const Color(0xFFFF9800)),
                      _pieSection(controller.missedCount.value, const Color(0xFFE57373)),
                      _pieSection(controller.rejectedCount.value, const Color(0xFF8B0000)),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  PieChartSectionData _pieSection(int value, Color color) {
    final percentage = controller.getPercentage(value);
    return PieChartSectionData(
      color: color,
      value: value.toDouble(),
      title: value > 0 ? '${percentage.toStringAsFixed(0)}%' : '',
      radius: 60,
      titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
    );
  }

  Widget _buildLegend(String label, Color color, RxInt Function() count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Obx(() => Text('$label (${count().value})', style: TextStyle(fontSize: 12, fontFamily: AppFonts.poppins))),
      ],
    );
  }

  Widget _buildStatsTable() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _buildStatRow('Calls', 'Count', duration: 'Duration', isHeader: true),
          const Divider(height: 1),
          Obx(() => _buildStatRow('Incoming', '${controller.incomingCount.value}',
              duration: controller.formatDuration(controller.incomingDuration.value),
              color: const Color(0xFF8BC34A))),
          Obx(() => _buildStatRow('Outgoing', '${controller.outgoingCount.value}',
              duration: controller.formatDuration(controller.outgoingDuration.value),
              color: const Color(0xFFFF9800))),
          Obx(() => _buildStatRow('Missed', '${controller.missedCount.value}', duration: '-', color: const Color(0xFFE57373))),
          Obx(() => _buildStatRow('Rejected', '${controller.rejectedCount.value}', duration: '-', color: const Color(0xFF8B0000))),
          SizedBox(height: 8.h),
          const Divider(height: 1, thickness: 2),
          Obx(() => _buildStatRow('TOTAL', '${controller.totalCalls.value}',
              duration: controller.formatDuration(controller.totalDuration.value), isBold: true)),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String calls,
      {String? duration, Color? color, bool isHeader = false, bool isBold = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: isHeader ? FontWeight.w500 : isBold ? FontWeight.bold : FontWeight.w400,
                    color: isHeader ? Colors.black87 : color ?? Colors.black87,
                    fontFamily: AppFonts.poppins)),
          ),
          Expanded(
            child: Text(calls,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: isHeader || isBold ? FontWeight.w500 : FontWeight.w400,
                    fontFamily: AppFonts.poppins)),
          ),
          Expanded(
            child: Text(duration ?? '',
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: isHeader || isBold ? FontWeight.w500 : FontWeight.w400,
                    fontFamily: AppFonts.poppins)),
          ),
        ],
      ),
    );
  }
}