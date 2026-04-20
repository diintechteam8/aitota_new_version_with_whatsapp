import '../../../../core/app-export.dart';
import '../../../../data/model/myDial/call_log_model.dart';
import '../../../../views/myDial/grid_flow/call_logs/calls/controller/calls_controller.dart';

class TimeSelectionWidget extends StatelessWidget {
  final CallLog callLog;
  final CallsController controller;
  final VoidCallback onShowCalendar;

  const TimeSelectionWidget({
    super.key,
    required this.callLog,
    required this.controller,
    required this.onShowCalendar,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SizedBox(
          height: Get.height * 0.55,
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    'Select Follow-up Time',
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    children: ['Morning', 'Afternoon', 'Evening', 'Night']
                        .map((timeSlot) {
                      return RadioListTile<String>(
                        dense: true,
                        title: Text(
                          timeSlot,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: AppFonts.poppins,
                          ),
                        ),
                        value: timeSlot,
                        groupValue: controller.selectedTimeSlot.value,
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedTimeSlot.value = value;
                            controller.updateSelectedDateWithTime();
                          }
                        },
                        activeColor: ColorConstants.appThemeColor,
                      );
                    }).toList(),
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onShowCalendar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  ColorConstants.grey.withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              'Back',
                              style: TextStyle(
                                fontFamily: AppFonts.poppins,
                                fontSize: 16.sp,
                                color: ColorConstants.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                controller.selectedTimeSlot.value.isNotEmpty
                                    ? () => controller.submitReason(callLog)
                                    : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstants.appThemeColor,
                              disabledBackgroundColor:
                                  ColorConstants.grey.withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                fontFamily: AppFonts.poppins,
                                fontSize: 16.sp,
                                color: ColorConstants.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
