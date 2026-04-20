// views/call_analytics/call_analytics_screen.dart
import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/utils/widgets/analytics_widgets/analysis_card.dart';
import 'package:aitota_business/core/utils/widgets/analytics_widgets/summary_card.dart';
import 'package:aitota_business/routes/app_routes.dart';
import 'controller/call_analytics_controller.dart';

class CallAnalyticsScreen extends StatelessWidget {
  const CallAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GetBuilder<CallAnalyticsController>(
        init: CallAnalyticsController(),
        builder: (c) => Scaffold(
          backgroundColor: ColorConstants.homeBackgroundColor,
          body: Obx(() {
            final showLoader = c.isLoading.value;
            return Stack(
              children: [
                Column(
                  children: [
                    // ── Tab Bar ──
                    Container(
                      color: Colors.white,
                      child: const TabBar(
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.black,
                        indicatorWeight: 3,
                        tabs: [
                          Tab(text: 'Summary'),
                          Tab(text: 'Analysis'),
                        ],
                      ),
                    ),

                    // ── Filter Bar ──
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      child: Column(
                        children: [
                          Wrap(
                            spacing: 12.w,
                            runSpacing: 8.h,
                            children: [
                              FilterButton(
                                label: 'Yesterday',
                                isSelected: c.isYesterdaySelected,
                                onTap: () => c.selectFilter('Yesterday'),
                              ),
                              FilterButton(
                                label: 'Today',
                                isSelected: c.isTodaySelected,
                                onTap: () => c.selectFilter('Today'),
                              ),
                              FilterButton(
                                label: 'Last 7 Days',
                                isSelected: c.isLast7DaysSelected,
                                onTap: () => c.selectFilter('Last 7 Days'),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Dispositions',
                                    style: TextStyle(
                                      fontFamily: AppFonts.poppins,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  CalendarButton(
                                    isSelected: c.isCustomRangeSelected,
                                    onTap: () => _showDateRangePicker(context, c),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (c.isCustomRangeSelected.value)
                            Padding(
                              padding: EdgeInsets.only(top: 12.h),
                              child: _buildSelectedDateRange(c),
                            ),
                        ],
                      ),
                    ),

                    // ── Tab Content ──
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: c.refreshAnalytics,
                        color: ColorConstants.appThemeColor,
                        child: TabBarView(
                          children: [
                            _buildSummaryTab(c),
                            _buildAnalysisTab(c),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // ── Loader Overlay ──
                if (showLoader)
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
      ),
    );
  }

  // ── Selected Date Range Chip ──
  Widget _buildSelectedDateRange(CallAnalyticsController c) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: ColorConstants.appThemeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorConstants.appThemeColor.withOpacity(0.3)),
      ),
      child: Text(
        '${c.formattedDate(c.selectedRange.value.start)} to ${c.formattedDate(c.selectedRange.value.end)}',
        style: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 13.sp,
          color: ColorConstants.appThemeColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ── Date Range Picker Dialog ──
  void _showDateRangePicker(BuildContext context, CallAnalyticsController c) {
    c.initializeCalendarRange();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Select Date Range',
          style: TextStyle(fontFamily: AppFonts.poppins, fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        content: Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Start Date
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Start Date',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                suffixIcon: Icon(Icons.calendar_today, size: 16.sp),
              ),
              controller: TextEditingController(text: c.formattedDate(c.selectedRange.value.start)),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: c.selectedRange.value.start,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) c.selectStartDate(picked);
              },
            ),
            SizedBox(height: 12.h),
            // End Date
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'End Date',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                suffixIcon: Icon(Icons.calendar_today, size: 16.sp),
                errorText: c.dateError.value.isEmpty ? null : c.dateError.value,
              ),
              controller: TextEditingController(text: c.formattedDate(c.selectedRange.value.end)),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: c.selectedRange.value.end,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) c.selectEndDate(picked);
              },
            ),
          ],
        )),
        actions: [
          TextButton(
            onPressed: () {
              if (c.validateDateRange()) {
                c.confirmCustomRange();
                Get.back();
                
              }
            },
            child: Text('OK', style: TextStyle(color: ColorConstants.appThemeColor)),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: ColorConstants.grey)),
          ),
        ],
      ),
    );
  }

  // ── SUMMARY TAB ──
  Widget _buildSummaryTab(CallAnalyticsController c) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h, bottom: 12.h),
        child: Column(
          children: [
            // ── ROW 1 ──
            Row(
              children: [
                Expanded(
                  child: _summaryCard(
                    title: 'Total Calls',
                    count: c.totalCalls.value.toString(),
                    duration: _formatSeconds(c.totalTalkTime.value),
                    icon: Icons.phone_in_talk_outlined,
                    iconColor: Colors.grey[700]!,
                    bgColor: Colors.grey[200]!,
                    onTap: () => Get.toNamed(
                      AppRoutes.totalPhoneCallsScreen,
                      arguments: c.getNavigationData(title: 'Total Calls'),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _summaryCard(
                    title: 'Incoming Calls',
                    count: c.incomingCalls.value.toString(),
                    duration: _formatSeconds(c.incomingTalkTime.value),
                    icon: Icons.phone_callback_outlined,
                    iconColor: Colors.green[700]!,
                    bgColor: Colors.green[100]!,
                    onTap: () => Get.toNamed(
                      AppRoutes.incomingCallsScreen,
                      arguments: c.getNavigationData(
                        title: 'Incoming Calls',
                        direction: 'incoming',
                        status: 'connected',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // ── ROW 2 ──
            Row(
              children: [
                Expanded(
                  child: _summaryCard(
                    title: 'Outgoing Calls',
                    count: c.outgoingCalls.value.toString(),
                    duration: _formatSeconds(c.outgoingTalkTime.value),
                    icon: Icons.phone_forwarded_outlined,
                    iconColor: Colors.orange[700]!,
                    bgColor: Colors.orange[100]!,
                    onTap: () => Get.toNamed(
                      AppRoutes.incomingCallsScreen,
                      arguments: c.getNavigationData(
                        title: 'Outgoing Calls',
                        direction: 'outgoing',
                        status: 'connected',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _summaryCard(
                    title: 'Missed Calls',
                    count: c.missedCalls.value.toString(),
                    duration: null,
                    icon: Icons.phone_missed_outlined,
                    iconColor: Colors.red[700]!,
                    bgColor: Colors.red[100]!,
                    onTap: () => Get.toNamed(
                      AppRoutes.incomingCallsScreen,
                      arguments: c.getNavigationData(
                        title: 'Missed Calls',
                        direction: 'incoming',
                        status: 'missed',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // ── ROW 3 ──
            Row(
              children: [
                Expanded(
                  child: _summaryCard(
                    title: 'Rejected Calls',
                    count: c.rejectedCalls.value.toString(),
                    duration: null,
                    icon: Icons.phone_disabled_outlined,
                    iconColor: Colors.red[700]!,
                    bgColor: Colors.red[100]!,
                    onTap: () => Get.toNamed(
                      AppRoutes.incomingCallsScreen,
                      arguments: c.getNavigationData(
                        title: 'Rejected Calls',
                        direction: 'incoming',
                        status: 'rejected',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _summaryCard(
                    title: 'Never Attended Calls',
                    count: c.neverAttendedCalls.value.toString(),
                    duration: null,
                    icon: Icons.phone_paused_outlined,
                    iconColor: Colors.orange[700]!,
                    bgColor: Colors.orange[100]!,
                  // Never Attended Calls
onTap: () => Get.toNamed(
  AppRoutes.neverAttendedCallsScreen,
  arguments: c.getNavigationData(
    title: 'Never Attended Calls',
    direction: 'incoming',
    status: 'never_attended',
  ),
),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // ── ROW 4 ──
            Row(
              children: [
                Expanded(
                  child: _summaryCard(
                    title: 'Not Picked by Client',
                    count: c.notPickedByClient.value.toString(),
                    duration: null,
                    icon: Icons.phone_missed_outlined,
                    iconColor: Colors.blue[700]!,
                    bgColor: Colors.blue[100]!,
                  // Not Picked by Client
onTap: () => Get.toNamed(
  AppRoutes.neverAttendedCallsScreen,
  arguments: c.getNavigationData(
    title: 'Not Picked by Client',
    direction: 'outgoing',
    status: 'not_picked_by_client',
  ),
),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ),
      );

  // ── ANALYSIS TAB ──
  Widget _buildAnalysisTab(CallAnalyticsController c) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h, bottom: 12.h),
        child: Column(
          children: [
            // ── ROW 1 ──
            Row(
              children: [
                // Top Caller
                Expanded(
                  child: AnalysisCard(
                    title: 'Top Caller',
                    value: c.topCaller.value.isEmpty ? '-' : c.topCaller.value,
                    valueFontSize: 16.sp,
                    valueFontWeight: FontWeight.w600,
                    icon: Icons.person_outline,
                    iconColor: Colors.grey[700]!,
                    iconBgColor: Colors.grey[200]!,
// Top Caller
onTap: () => Get.toNamed(
  AppRoutes.topCallerScreen,
  arguments: c.getNavigationData(
    title: 'Top Caller',
    extra: {
      'type': 'top_caller',
      'callLogId': c.topCallerCallLogId(),   // ← FIXED
    },
  ),
),
                  ),
                ),
                SizedBox(width: 12.w),
                // Longest Call
                Expanded(
                  child: AnalysisCard(
                    title: 'Longest Call',
                    value: c.longestCallDuration.value > 0
                        ? _formatSeconds(c.longestCallDuration.value)
                        : '0s',
                    valueFontSize: 18.sp,
                    valueFontWeight: FontWeight.w600,
                    icon: Icons.timer_outlined,
                    iconColor: Colors.orange[700]!,
                    iconBgColor: Colors.orange[100]!,
               // Longest Call
onTap: () => Get.toNamed(
  AppRoutes.topCallerScreen,
  arguments: c.getNavigationData(
    title: 'Longest Call',
    extra: {
      'type': 'longest_call',
      'callLogId': c.longestCallId.value,
      'highlightDuration': c.longestCallDuration.value,
      'highlightName': c.longestCallName.value,
    },
  ),
),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // ── ROW 2 ──
            Row(
              children: [
                Expanded(
                  child: AnalysisCard(
                    title: 'Highest Total Call Duration',
                    value: c.mostTalkTimeContact.value.isNotEmpty
                        ? '${c.mostTalkTimeContact.value}\n${_formatSeconds(c.top10ByDuration.isNotEmpty ? c.top10ByDuration.first['duration'] : 0)}'
                        : '0s',
                    valueFontSize: 16.sp,
                    valueFontWeight: FontWeight.w600,
                    icon: Icons.timelapse_outlined,
                    iconColor: Colors.orange[700]!,
                    iconBgColor: Colors.orange[100]!,
                // Highest Total Duration
// Highest Total Duration
onTap: () => Get.toNamed(
  AppRoutes.topCallerScreen,
  arguments: c.getNavigationData(
    title: 'Highest Call Duration',
    extra: {
      'type': 'highest_duration',
      'callLogId': c.highestDurationCallLogId(),  // ← FIXED: Real _id
      'highlightDuration': c.top10ByDuration.isNotEmpty ? c.top10ByDuration.first['duration'] : 0,
      'highlightName': c.mostTalkTimeContact.value,
    },
  ),
),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AnalysisCard(
                    title: 'Average Call Duration',
                    value: 'Per Call & Per Day',
                    icon: Icons.av_timer_outlined,
                    iconColor: Colors.orange[700]!,
                    iconBgColor: Colors.orange[100]!,
                  onTap: () => Get.toNamed(
  AppRoutes.perCallScreen,
  arguments: c.getNavigationData(
    title: 'Average Call Duration',
    extra: {
      'callLogIds': c.filteredCallLogItems.map((e) => e.id).toList(),
    },
  ),
),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // ── ROW 3 ──
            Row(
              children: [
                Expanded(
                  child: AnalysisCard(
                    title: 'Top 10 Frequently Talked',
                    value: 'Incoming & Outgoing',
                    icon: Icons.people_outline,
                    iconColor: Colors.grey[700]!,
                    iconBgColor: Colors.grey[200]!,
                  // Top 10 Frequently Talked
onTap: () => Get.toNamed(
  AppRoutes.topTalkedScreen,
  arguments: c.getNavigationData(
    title: 'Top 10 Frequent',
    extra: {
      'type': 'frequency',
      'callLogIds': c.top10ByCount.map((e) => e['id'] as String).toList(),
    },
  ),
),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AnalysisCard(
                    title: 'Top 10 Call Duration',
                    value: 'Incoming & Outgoing',
                    icon: Icons.access_time_outlined,
                    iconColor: Colors.orange[700]!,
                    iconBgColor: Colors.orange[100]!,
                  // Top 10 Call Duration
onTap: () => Get.toNamed(
  AppRoutes.topTalkedScreen,
  arguments: c.getNavigationData(
    title: 'Top 10 Duration',
    extra: {
      'type': 'duration',
      'callLogIds': c.top10ByDuration.map((e) => e['id'] as String).toList(),
    },
  ),
),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  // ── Helper: Summary Card ──
  Widget _summaryCard({
    required String title,
    required String count,
    required String? duration,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return AnalyticsCard(
      title: title,
      count: count,
      duration: duration,
      icon: icon,
      iconColor: iconColor,
      iconBgColor: bgColor,
      onTap: onTap,
    );
  }

  // ── Helper: Format Seconds → 1h 23m 45s ──
  String _formatSeconds(num sec) {
    if (sec <= 0) return '0s';
    final s = sec.toInt();
    final h = s ~/ 3600;
    final m = (s % 3600) ~/ 60;
    final ss = s % 60;
    final parts = [];
    if (h > 0) parts.add('${h}h');
    if (m > 0) parts.add('${m}m');
    if (ss > 0 || parts.isEmpty) parts.add('${ss}s');
    return parts.join(' ');
  }
}