import '../../../../../core/app-export.dart';
import '../../../../../core/utils/widgets/my_dial_widgets/calendar_widget.dart';
import '../../../../../core/utils/widgets/my_dial_widgets/custom_call_logs_widget.dart';
import '../../../../../core/utils/widgets/my_dial_widgets/loading_widgets.dart';
import '../../../../../core/utils/widgets/my_dial_widgets/reason_form_widget.dart';
import '../../../../../core/utils/widgets/my_dial_widgets/time_selection_widget.dart';
import '../../../../../data/model/myDial/call_log_model.dart';
import 'controller/calls_controller.dart';

class CallsScreen extends GetView<CallsController> {
  const CallsScreen({super.key});

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: ColorConstants.white,
    body: SafeArea(
      child: Obx(() {
        final logs = controller.callLogs;

        // 🔹 Case 1: Loading state
        if (controller.isLoading.value && logs.isEmpty) {
          return const Center(child: LoadingWidget());
        }

        // 🔹 Case 2: Permission not granted
        if (!controller.isPermissionGranted.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Please allow phone permission to view your call logs.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black54,
                    fontFamily: AppFonts.poppins,
                  ),
                ),
                SizedBox(height: 12.h),
                ElevatedButton.icon(
                  onPressed: () async {
                    await openAppSettings();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.appThemeColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.settings, color: Colors.white),
                  label: const Text(
                    'Open Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: AppFonts.poppins,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // 🔹 Case 3: No logs after permission
        if (logs.isEmpty && !controller.isLoading.value) {
          return const Center(
            child: Text(
              'No call logs available.',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        // 🔹 Case 4: Normal ListView
        return RefreshIndicator(
          onRefresh: controller.refreshCallLogs,
          child: ListView.builder(
            controller: controller.scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            itemCount: logs.length + (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == logs.length && controller.hasMore.value) {
                return const Center(child: LoadingMoreWidget());
              }
              final callLog = logs[index];
              return CallLogItemWidget(
                callLog: callLog,
                controller: controller,
                onShowReasonForm: () => _showReasonForm(context, callLog),
              );
            },
          ),
        );
      }),
    ),

    floatingActionButton: FloatingActionButton(
      heroTag: 'calls_fab', // Added unique tag to fix Hero conflict
      onPressed: controller.onDialerPadTap,
      backgroundColor: ColorConstants.appThemeColor,
      child: const Icon(Icons.dialpad, color: Colors.white),
    ),
  );
}


  void _showReasonForm(BuildContext context, CallLog callLog) {
    controller.loadStoredCallStatus(callLog.phoneNumber);
    controller.currentCallLog = callLog;

    Get.bottomSheet(
      ReasonFormWidget(
        callLog: callLog,
        controller: controller,
        onShowCalendar: () => _showCalendar(context, callLog),
        onShowOtherReason: (isFollowUp, prefix) =>
            _showOtherReasonInput(context, callLog, isFollowUp, prefix),
      ),
      isScrollControlled: true,
      enableDrag: false,
    );
  }

  void _showOtherReasonInput(
      BuildContext context, CallLog callLog, bool isFollowUp, String prefix) {
    Get.bottomSheet(
      OtherReasonInputWidget(
        callLog: callLog,
        controller: controller,
        isFollowUp: isFollowUp,
        prefix: prefix,
        onShowCalendar: () => _showCalendar(context, callLog),
      ),
      isScrollControlled: true,
    );
  }

  void _showCalendar(BuildContext context, CallLog callLog) {
    Get.bottomSheet(
      CalendarWidget(
        callLog: callLog,
        controller: controller,
        onShowTimeSelection: () => _showTimeSelection(context, callLog),
        onShowReasonForm: () => _showReasonForm(context, callLog),
      ),
      isScrollControlled: true,
    );
  }

  void _showTimeSelection(BuildContext context, CallLog callLog) {
    Get.bottomSheet(
      TimeSelectionWidget(
        callLog: callLog,
        controller: controller,
        onShowCalendar: () => _showCalendar(context, callLog),
      ),
      isScrollControlled: true,
    );
  }
}
