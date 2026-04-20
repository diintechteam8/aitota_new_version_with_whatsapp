import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/myDial/grid_flow/leads/controller/my_dial_leads_controller.dart';
import 'package:aitota_business/views/myDial/grid_flow/reports/controller/my_dial_reports_controller.dart';
import 'package:aitota_business/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyDialReportsScreen extends GetView<MyDialReportsController> {
  const MyDialReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MyDialLeadsController leadsController =
        Get.find<MyDialLeadsController>();

    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      body: RefreshIndicator(
        onRefresh: controller.refreshReports,
        color: ColorConstants.appThemeColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter Buttons
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  height: 40.h,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterButton(
                            'Yesterday', controller.isYesterdaySelected),
                        SizedBox(width: 8.w),
                        _buildFilterButton('Today', controller.isTodaySelected),
                        SizedBox(width: 8.w),
                        _buildFilterButton(
                            'Last 7 Days', controller.isLast7DaysSelected),
                      ],
                    ),
                  ),
                ),

                // Custom Range Display
                Obx(() => controller.isCustomRangeSelected.value
                    ? Column(
                        children: [
                          SizedBox(height: 12.h),
                          _buildSelectedDateRange(),
                        ],
                      )
                    : const SizedBox.shrink()),

                SizedBox(height: 16.h),

                // Call Stats Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Call Stats',
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    _buildCalendarButton(context),
                  ],
                ),
                SizedBox(height: 12.h),

                // Call Stats Grid
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    // Inside Call Stats Grid
Expanded(
  child: CustomGridItem(
    title: 'Total Calls',
    value: controller.totalCalls.value.toString(),
    icon: Icons.call,
    iconColor: Colors.blue.shade600,
  ),
),
 SizedBox(width: 12.w),
Expanded(
  child: CustomGridItem(
    title: 'Connected',
    value: controller.connectedCalls.value.toString(),
    icon: Icons.call_received,
    iconColor: Colors.green.shade600,
  ),
),
 SizedBox(width: 12.w),
Expanded(
  child: CustomGridItem(
    title: 'Not Connected',
    value: controller.notConnectedCalls.value.toString(),
    icon: Icons.call_missed_outgoing,
    iconColor: Colors.red.shade600,
  ),
),
                      ],
                    )),

                SizedBox(height: 16.h),

                // Talk Time Grid
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomGridItem(
                            title: 'Avg Talk Time',
                            value:
                                '${(controller.avgTalkTime.value / 60).toStringAsFixed(1)} min',
                           icon: Icons.timer,
iconColor: Colors.purple.shade600,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: CustomGridItem(
                            title: 'Total Talk Time',
                            value:
                                '${(controller.totalConversationTime.value / 60).toStringAsFixed(0)} min',
                           icon: Icons.access_time_filled,
iconColor: Colors.teal.shade600,
                          ),
                        ),
                      ],
                    )),

                // Divider added after Call Stats section
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Divider(
                    color: ColorConstants.lightGrey,
                    thickness: 1,
                    height: 1.h,
                  ),
                ),

                // Connected Stats Title
                Text(
                  'Connected Stats',
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12.h),

                // Category Tabs: Connected FIRST, Not Connected SECOND
                Obx(() => Row(
                      children: [
                        Expanded(
                          child: _buildCategoryTab(
                            'Connected',
                            'connected',
                            controller.selectedCategory.value == 'connected',
                            () =>
                                controller.selectedCategory.value = 'connected',
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _buildCategoryTab(
                            'Not Connected',
                            'not_connected',
                            controller.selectedCategory.value ==
                                'not_connected',
                            () => controller.selectedCategory.value =
                                'not_connected',
                          ),
                        ),
                      ],
                    )),

                SizedBox(height: 12.h),

                // Dynamic Content Based on Category
                _buildCategoryContent(leadsController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widgets

  Widget _buildCategoryTab(
      String label, String value, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color:
              isSelected ? ColorConstants.appThemeColor : ColorConstants.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected
                ? ColorConstants.appThemeColor
                : ColorConstants.grey.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isSelected ? ColorConstants.white : ColorConstants.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryContent(MyDialLeadsController leadsController) {
    return Obx(() {
      return controller.selectedCategory.value == 'not_connected'
          ? _buildNotConnectedContent(leadsController)
          : _buildConnectedContent(leadsController);
    });
  }

  Widget _buildNotConnectedContent(MyDialLeadsController leadsController) {
    return Obx(() {
      final leadData = leadsController.leadData.value;

      const Map<String, List<String>> groups = {
        'DNP': ['no_response', 'call_busy'],
        'CNC': ['not_reachable', 'switched_off', 'out_of_coverage'],
        'Other': ['call_disconnected', 'call_later'],
      };

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: groups.entries.map((groupEntry) {
          final groupName = groupEntry.key;
          final statuses = groupEntry.value;

          return Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Text(
                    groupName,
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.black,
                    ),
                  ),
                ),
                _buildStatusWrapGrid(statuses, leadData),
              ],
            ),
          );
        }).toList(),
      );
    });
  }

  // CONNECTED CONTENT
  Widget _buildConnectedContent(MyDialLeadsController leadsController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTextTab(
                  label: 'Interested',
                  value: 'interested',
                  isSelected:
                      controller.selectedConnectedTab.value == 'interested',
                  onTap: () =>
                      controller.selectedConnectedTab.value = 'interested',
                ),
                SizedBox(width: 32.w),
                _buildTextTab(
                  label: 'Not Interested',
                  value: 'not_interested',
                  isSelected:
                      controller.selectedConnectedTab.value == 'not_interested',
                  onTap: () =>
                      controller.selectedConnectedTab.value = 'not_interested',
                ),
              ],
            )),
        SizedBox(height: 16.h),
        _buildConnectedTabContent(leadsController),
      ],
    );
  }

  Widget _buildTextTab({
    required String label,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? ColorConstants.appThemeColor
                  : ColorConstants.grey,
            ),
          ),
          SizedBox(height: 6.h),
          Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? ColorConstants.appThemeColor
                  : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectedTabContent(MyDialLeadsController leadsController) {
    return Obx(() {
      final leadData = leadsController.leadData.value;
      final tab = controller.selectedConnectedTab.value;

      final Map<String, List<String>> statusGroups = tab == 'interested'
          ? {
              'Hot Lead': ['payment_pending', 'Document_pending'],
              'Warm Lead': [
                'call_back_schedule',
                'information_shared',
                'follow_up_required'
              ],
              'Follow Up': [
                'call_back_due',
                'whatsapp_sent',
                'interested_waiting_confimation'
              ],
              'Converted / Won': [
                'admission_confirmed',
                'payment_recieved',
                'course_started'
              ],
            }
          : {
              'Close / Lost': [
                'not_interested',
                'joined_another_institute',
                'dropped_the_plan',
                'dnd',
                'unqualified_lead',
                'wrong_number',
                'invalid_number',
              ],
              'Future Prospect': ['postpone'],
            };

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: statusGroups.entries.map((groupEntry) {
          final groupName = groupEntry.key;
          final statuses = groupEntry.value;

          return Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupName,
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                _buildStatusWrapGrid(statuses, leadData),
              ],
            ),
          );
        }).toList(),
      );
    });
  }

 Widget _buildStatusWrapGrid(List<String> statuses, dynamic leadData) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final double itemWidth = (constraints.maxWidth - 32.w) / 3;

      return Wrap(
        spacing: 16.w,
        runSpacing: 16.h,
        alignment: WrapAlignment.start,
        children: statuses.map((status) {
          final data = leadData?.leadStatusMap?[status];
          final count = data?.count ?? 0;
          final leads = data?.data ?? <dynamic>[];

          final displayName = _getDisplayName(status);
          final icon = _getIconForStatus(status);
          final iconColor = _getIconColorForStatus(status); // Dynamic color

          return SizedBox(
            width: itemWidth,
            child: CustomGridItem(
              title: displayName,
              value: count.toString(),
              icon: icon,
              iconColor: iconColor, // Now dynamic!
              onTap: () {
                Get.toNamed(
                  AppRoutes.myDialLeadsDetailScreen,
                  arguments: {
                    'status': displayName,
                    'leads': leads,
                  },
                );
              },
            ),
          );
        }).toList(),
      );
    },
  );
}

  String _getDisplayName(String key) {
    const map = {
      'no_response': 'No Response',
      'call_busy': 'Call Busy',
      'not_reachable': 'Not Reachable',
      'switched_off': 'Switched Off',
      'out_of_coverage': 'Out of Coverage',
      'call_disconnected': 'Call Disconnected',
      'call_later': 'Call Later',
      'payment_pending': 'Payment Pending',
      'Document_pending': 'Document Pending',
      'call_back_schedule': 'Call Back Scheduled',
      'information_shared': 'Information Shared',
      'follow_up_required': 'Follow-up Required',
      'call_back_due': 'Call Back Due',
      'whatsapp_sent': 'WhatsApp Sent',
      'interested_waiting_confimation': 'Waiting Confirmation',
      'admission_confirmed': 'Admission Confirmed',
      'payment_recieved': 'Payment Received',
      'course_started': 'Course Started',
      'not_interested': 'Not Interested',
      'joined_another_institute': 'Joined Another',
      'dropped_the_plan': 'Dropped Plan',
      'dnd': 'DND',
      'unqualified_lead': 'Unqualified Lead',
      'wrong_number': 'Wrong Number',
      'invalid_number': 'Invalid Number',
      'postpone': 'Postpone',
    };
    return map[key] ?? _capitalize(key.replaceAll('_', ' '));
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

IconData _getIconForStatus(String key) {
  const map = {
    // NOT CONNECTED - Red/Grey tones
    'no_response': Icons.phone_missed,
    'call_busy': Icons.phone_in_talk,
    'not_reachable': Icons.signal_cellular_alt,
    'switched_off': Icons.power_off,
    'out_of_coverage': Icons.wifi_off,
    'call_disconnected': Icons.call_end,
    'call_later': Icons.schedule_send,

    // CONNECTED - INTERESTED (Green/Blue tones)
    'payment_pending': Icons.payments_rounded,
    'Document_pending': Icons.description_outlined,
    'call_back_schedule': Icons.event_available,
    'information_shared': Icons.share_rounded,
    'follow_up_required': Icons.repeat_rounded,
    'call_back_due': Icons.notification_important,
    'whatsapp_sent': Icons.mark_chat_read_rounded,
    'interested_waiting_confimation': Icons.hourglass_bottom,
    'admission_confirmed': Icons.verified,
    'payment_recieved': Icons.paid,
    'course_started': Icons.school,

    // NOT INTERESTED - Red tones
    'not_interested': Icons.thumb_down,
    'joined_another_institute': Icons.swap_horiz,
    'dropped_the_plan': Icons.cancel_schedule_send,
    'dnd': Icons.do_not_disturb_on,
    'unqualified_lead': Icons.person_off,
    'wrong_number': Icons.phone_disabled,
    'invalid_number': Icons.error_outline,
    'postpone': Icons.watch_later,
  };
  return map[key] ?? Icons.info_outline_rounded;
}

// NEW: Smart Icon Color Based on Status
Color _getIconColorForStatus(String key) {
  // Positive / Interested / Converted
  if ([
    'payment_pending',
    'Document_pending',
    'call_back_schedule',
    'information_shared',
    'follow_up_required',
    'call_back_due',
    'whatsapp_sent',
    'interested_waiting_confimation',
    'admission_confirmed',
    'payment_recieved',
    'course_started',
  ].contains(key)) {
    return Colors.green.shade600;
  }

  // Negative / Lost / Rejected
  if ([
    'not_interested',
    'joined_another_institute',
    'dropped_the_plan',
    'dnd',
    'unqualified_lead',
    'wrong_number',
    'invalid_number',
  ].contains(key)) {
    return Colors.red.shade600;
  }

  // Not Connected / Neutral
  if ([
    'no_response',
    'call_busy',
    'not_reachable',
    'switched_off',
    'out_of_coverage',
    'call_disconnected',
    'call_later',
  ].contains(key)) {
    return Colors.orange.shade700;
  }

  // Future Prospect
  if (key == 'postpone') {
    return Colors.blue.shade600;
  }

  // Default
  return ColorConstants.appThemeColor;
}

  Widget _buildFilterButton(String label, RxBool isSelected) {
    return Obx(() => GestureDetector(
          onTap: () => controller.selectFilter(label),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected.value
                  ? ColorConstants.appThemeColor
                  : ColorConstants.white,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: ColorConstants.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isSelected.value
                    ? ColorConstants.white
                    : ColorConstants.grey,
              ),
            ),
          ),
        ));
  }

  Widget _buildCalendarButton(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () => _showDateRangePicker(context),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: controller.isCustomRangeSelected.value
                  ? ColorConstants.appThemeColor
                  : ColorConstants.white,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: controller.isCustomRangeSelected.value
                      ? ColorConstants.appThemeColor.withOpacity(0.35)
                      : ColorConstants.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(
                color: controller.isCustomRangeSelected.value
                    ? ColorConstants.appThemeColor
                    : ColorConstants.grey.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.calendar_month_rounded,
              size: 20.sp,
              color: controller.isCustomRangeSelected.value
                  ? ColorConstants.white
                  : ColorConstants.appThemeColor.withOpacity(0.85),
            ),
          ),
        ));
  }

  Widget _buildSelectedDateRange() {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: ColorConstants.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorConstants.grey.withOpacity(0.3)),
          ),
          child: Text(
            'Selected: ${_formatDateSafe(controller.selectedRange.value.start)} - '
            '${_formatDateSafe(controller.selectedRange.value.end)}',
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: ColorConstants.appThemeColor,
            ),
          ),
        ));
  }

  String _formatDateSafe(DateTime date) {
    if (controller.formattedDate != null) {
      return controller.formattedDate!(date);
    }
    return DateFormat('dd MMM yyyy').format(date);
  }

  void _showDateRangePicker(BuildContext context) {
    controller.initializeCalendarRange();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Select Date Range',
          style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500),
        ),
        content: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dateField(
                  label: 'Start Date',
                  date: controller.selectedRange.value.start,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: controller.selectedRange.value.start,
                      firstDate: DateTime.utc(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) controller.selectStartDate(picked);
                  },
                ),
                SizedBox(height: 12.h),
                _dateField(
                  label: 'End Date',
                  date: controller.selectedRange.value.end,
                  errorText: controller.dateError.value.isEmpty
                      ? null
                      : controller.dateError.value,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: controller.selectedRange.value.end,
                      firstDate: DateTime.utc(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) controller.selectEndDate(picked);
                  },
                ),
              ],
            )),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.validateDateRange()) {
                controller.confirmCustomRange();
                Get.back();
              }
            },
            child: Text('OK',
                style: TextStyle(color: ColorConstants.appThemeColor)),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: ColorConstants.grey)),
          ),
        ],
      ),
    );
  }

  Widget _dateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
    String? errorText,
  }) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 14.sp,
            color: ColorConstants.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        suffixIcon: Icon(Icons.calendar_today, size: 16.sp),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        errorText: errorText,
      ),
      controller: TextEditingController(text: _formatDateSafe(date)),
      onTap: onTap,
    );
  }
}
