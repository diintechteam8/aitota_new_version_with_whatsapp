import 'package:intl/intl.dart';
import '../../../../data/model/myDial/call_log_model.dart';
import '../../../../views/myDial/grid_flow/call_logs/calls/controller/calls_controller.dart';
import '../../../app-export.dart';

class CallLogItemWidget extends StatelessWidget {
  final CallLog callLog;
  final CallsController controller;
  final VoidCallback onShowReasonForm;

  const CallLogItemWidget({
    super.key,
    required this.callLog,
    required this.controller,
    required this.onShowReasonForm,
  });

// New fixed colors (works perfectly even if appThemeColor is green)
  ({IconData icon, Color color}) _getCallIconAndColor() {
    // Missed Call → Red (always unmistakable)
    if (callLog.isIncoming && callLog.duration.inSeconds == 0) {
      return (icon: Icons.call_missed, color: Colors.red.shade600);
    }
    // Outgoing Call → Deep Green (different from theme if theme is light green)
    else if (!callLog.isIncoming) {
      return (icon: Icons.call_made, color: const Color(0xFF00C853)); // Vibrant Green
    }
    // Incoming Answered → Blue (completely different from green)
    else {
      return (icon: Icons.call_received, color: const Color(0xFF2962FF)); // Bright Blue
    }
  }

  @override
  Widget build(BuildContext context) {
    final callInfo = _getCallIconAndColor();

    final followUp = controller.followUpSchedules[callLog.phoneNumber];
    final isScheduledForToday = followUp != null &&
        DateFormat('yyyy-MM-dd').format(followUp.scheduledDate) ==
            DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(                    // ← This line added
      color: Colors.grey.shade300,          // Light grey border
      width: 0.5,                           // Thin & elegant
    ),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
          
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Only this Icon line is changed — everything else is 100% same
              Icon(
                callInfo.icon,
                color: callInfo.color,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      callLog.contactName,
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorConstants.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      callLog.phoneNumber,
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 12.sp,
                        color: ColorConstants.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          'Date: ',
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 10.sp,
                            color: ColorConstants.grey.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          DateFormat('MMM dd, yyyy HH:mm')
                              .format(callLog.dateTime),
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 12.sp,
                            color: ColorConstants.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          'Duration: ',
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 10.sp,
                            color: ColorConstants.grey.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          '${callLog.duration.inMinutes}m ${callLog.duration.inSeconds % 60}s',
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 12.sp,
                            color: ColorConstants.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.call,
                    color: ColorConstants.appThemeColor, size: 24.sp),
                onPressed: () => controller.makeCall(callLog.phoneNumber),
              ),
              IconButton(
           icon: Icon(
                    Icons.add_circle_outline,
                    color: ColorConstants.appThemeColor,
                    size: 24.sp,
                  ),
                onPressed: onShowReasonForm,
              ),
            ],
          ),
          // Optional Follow-Up Indicator (unchanged)
          if (isScheduledForToday)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                'Follow-up scheduled for today',
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.appThemeColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
