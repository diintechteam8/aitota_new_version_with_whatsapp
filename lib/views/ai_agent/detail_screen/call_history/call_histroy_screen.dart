import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/data/model/ai_agent/history_call_logs_model.dart';
import 'package:intl/intl.dart';

import '../../../../routes/app_routes.dart';
import 'controller/call_history_controller.dart';

class CallHistoryScreen extends GetView<CallHistoryController> {
  const CallHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Call History",
        showBackButton: true,
        onTapBack: () => Get.back(),
        titleStyle: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.poppins,
        ),
      ),
      body: Obx(
            () => RefreshIndicator(
          onRefresh: controller.fetchCallLogs,
          color: ColorConstants.appThemeColor,
          child: controller.isLogsLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.logsErrorMessage.value.isNotEmpty
              ? _buildErrorState()
              : controller.callLogs.isEmpty
              ? Center(
            child: Text(
              'No call history available',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
          )
              : ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            itemCount: controller.callLogs.length,
            itemBuilder: (context, index) {
              final log = controller.callLogs[index];
              return GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.callHistoryDetailScreen, arguments: log),
                child: _buildHistoryCard(log),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 40.sp),
          SizedBox(height: 8.h),
          Text(
            controller.logsErrorMessage.value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.poppins,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: controller.fetchCallLogs,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstants.appThemeColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Retry',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: AppFonts.poppins,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Logs log) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mobile: ${log.mobile ?? 'N/A'}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (log.leadStatus != null && log.leadStatus!.isNotEmpty)
                Text(
                  log.leadStatus!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: _getStatusColor(log.leadStatus),
                  ),
                ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Time: ${_formatTime(log.time)}',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          SizedBox(height: 4.h),
          Text(
            'Duration: ${log.duration ?? 0} sec',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          if (log.audioUrl != null) ...[
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: () {
                // Implement audio playback here
              },
              child: const Text('Play Audio'),
            ),
          ],
        ],
      ),
    );
  }


  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return 'N/A';
    try {
      // Assuming your API sends ISO8601 or similar timestamp
      final dateTime = DateTime.parse(time).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return time; // fallback to raw if parse fails
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'veryinterested':
        return Colors.green;
      case 'maybe':
        return Colors.orange;
      case 'enrolled':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
