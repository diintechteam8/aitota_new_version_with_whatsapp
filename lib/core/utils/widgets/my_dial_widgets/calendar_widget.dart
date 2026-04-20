import 'package:table_calendar/table_calendar.dart';
import '../../../../core/app-export.dart';
import '../../../../data/model/myDial/call_log_model.dart';
import '../../../../views/myDial/grid_flow/call_logs/calls/controller/calls_controller.dart';

class CalendarWidget extends StatelessWidget {
  final CallLog callLog;
  final CallsController controller;
  final VoidCallback onShowTimeSelection;
  final VoidCallback onShowReasonForm;

  const CalendarWidget({
    super.key,
    required this.callLog,
    required this.controller,
    required this.onShowTimeSelection,
    required this.onShowReasonForm,
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
          height: Get.height * 0.7,
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    'Schedule Follow-up',
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.grey,
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      focusedDay: controller.focusedDay.value,
                      selectedDayPredicate: (day) =>
                          isSameDay(day, controller.selectedDate.value),
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!selectedDay.isBefore(DateTime.now())) {
                          controller.selectedReason.value =
                              controller.selectedReason.value;
                          controller.selectedDate.value = selectedDay;
                          controller.focusedDay.value = focusedDay;
                          onShowTimeSelection();
                        }
                      },
                      availableGestures: AvailableGestures.all,
                      enabledDayPredicate: (day) =>
                          !day.isBefore(DateTime.now()),
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: ColorConstants.appThemeColor.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: const BoxDecoration(
                          color: ColorConstants.appThemeColor,
                          shape: BoxShape.circle,
                        ),
                        outsideDaysVisible: false,
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      rowHeight: 40.h,
                      daysOfWeekHeight: 30.h,
                    ),
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
                            onPressed: onShowReasonForm,
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
                            onPressed: onShowTimeSelection,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstants.appThemeColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              'Next',
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
