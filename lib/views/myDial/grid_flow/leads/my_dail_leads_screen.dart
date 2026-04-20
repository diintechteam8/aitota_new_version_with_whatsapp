import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/myDial/grid_flow/leads/controller/my_dial_leads_controller.dart';
import '../../../../data/model/myDial/my_dial_leads_model.dart';
import '../../../../routes/app_routes.dart';

class MyDialLeadsScreen extends GetView<MyDialLeadsController> {
  const MyDialLeadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      body: RefreshIndicator(
        onRefresh: controller.refreshLeads,
        color: ColorConstants.appThemeColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── FILTER BUTTONS ───────────────────────────────────────
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  height: 40.h,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterButton(
                          label: 'Yesterday',
                          isSelected: controller.isYesterdaySelected,
                          onTap: () => controller.selectFilter('Yesterday'),
                        ),
                        SizedBox(width: 8.w),
                        FilterButton(
                          label: 'Today',
                          isSelected: controller.isTodaySelected,
                          onTap: () => controller.selectFilter('Today'),
                        ),
                        SizedBox(width: 8.w),
                        FilterButton(
                          label: 'Last 7 Days',
                          isSelected: controller.isLast7DaysSelected,
                          onTap: () => controller.selectFilter('Last 7 Days'),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── CUSTOM RANGE CHIP ───────────────────────────────────
                Obx(() => controller.isCustomRangeSelected.value
                    ? Column(
                        children: [
                          SizedBox(height: 12.h),
                          _buildCustomRangeChip(),
                        ],
                      )
                    : const SizedBox.shrink()),

                SizedBox(height: 8.h),

                // ── LEAD CATEGORIES TITLE + CALENDAR ───────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Interested',
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    CalendarButton(
                      isSelected: controller.isCustomRangeSelected,
                      onTap: () => _showDateRangePicker(context),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // ── MAIN CONTENT (Loading / Empty / 4 Grids) ─────────────
                Obx(() {
                  if (controller.isLoading.value) {
                    return SizedBox(
                      height: 200.h,
                      child: Center(
                        child: Text(
                          'Loading...',
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: ColorConstants.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  final map = controller.leadData.value?.leadStatusMap;
                  if (map == null || map.values.every((e) => e.count == 0)) {
                    return _buildEmptyState();
                  }

                  return _buildFourMainGrids(map);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // Helper Widgets
  // ─────────────────────────────────────────────────────────────────────

  Widget _buildCustomRangeChip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorConstants.grey.withOpacity(0.3)),
      ),
      child: Text(
        'Selected: ${controller.formattedDate(controller.selectedRange.value.start)} - '
        '${controller.formattedDate(controller.selectedRange.value.end)}',
        style: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: ColorConstants.appThemeColor,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: MediaQuery.of(Get.context!).size.height - 300.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No leads available',
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: ColorConstants.grey,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: controller.refreshLeads,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.appThemeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              ),
              child: Text(
                'Refresh',
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 4 MAIN GRIDS WITH UNIQUE ICON COLORS ────────────────────────
  Widget _buildFourMainGrids(Map<String, LeadCategoryData> map) {
    final groups = {
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
    };

    int getGroupCount(List<String> statuses) {
      return statuses.fold(0, (sum, s) => sum + (map[s]?.count ?? 0));
    }

    List<dynamic> getGroupLeads(List<String> statuses) {
      List<dynamic> leads = [];
      for (var s in statuses) {
        final data = map[s]?.data;
        if (data != null) leads.addAll(data);
      }
      return leads;
    }

    // Helper to get icon + color for each group
    Map<String, dynamic> _getIconAndColor(String group) {
      switch (group) {
        case 'Hot Lead':
          return {
            'icon': Icons.whatshot,
            'color': const Color(0xFFE53935), // Deep Red
          };
        case 'Warm Lead':
          return {
            'icon': Icons.local_fire_department,
            'color': const Color(0xFFFB8C00), // Deep Orange
          };
        case 'Follow Up':
          return {
            'icon': Icons.update,
            'color': const Color(0xFF1E88E5), // Blue
          };
        case 'Converted / Won':
          return {
            'icon': Icons.emoji_events,
            'color': const Color(0xFF43A047), // Green
          };
        default:
          return {
            'icon': Icons.info,
            'color': ColorConstants.grey,
          };
      }
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16.h,
      crossAxisSpacing: 16.w,
      childAspectRatio: 1.4,
      children: groups.entries.map((e) {
        final title = e.key;
        final statuses = e.value;
        final count = getGroupCount(statuses);
        final leads = getGroupLeads(statuses);
        final iconData = _getIconAndColor(title);

        return LeadsCustomGridItem(
          title: title,
          value: count.toString(),
          icon: iconData['icon'] as IconData,
          iconColor: iconData['color'] as Color,
          onTap: () {
            Get.toNamed(
              AppRoutes.myDialLeadsDetailScreen,
              arguments: {
                'status': title,
                'leads': leads,
              },
            );
          },
        );
      }).toList(),
    );
  }

  // ── DATE RANGE PICKER ───────────────────────────────────────────
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
            fontWeight: FontWeight.w500,
          ),
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
            child: Text(
              'OK',
              style: TextStyle(color: ColorConstants.appThemeColor),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: ColorConstants.grey),
            ),
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
      controller: TextEditingController(text: controller.formattedDate(date)),
      onTap: onTap,
    );
  }
}
