import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/inbound/grid_flow/leads/controller/inbound_leads_controller.dart';
import 'package:aitota_business/routes/app_routes.dart';
import 'package:aitota_business/views/inbound/grid_flow/reports/controller/inbound_reports_controller.dart';

import '../../../../core/utils/widgets/common_widgets/shimmer_loading.dart';

class InboundReportsScreen extends GetView<InboundReportsController> {
  const InboundReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InboundLeadsController leadsController = controller.leadsController;

    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      body: SafeArea(
        top: true,
        child: RefreshIndicator(
          onRefresh: controller.refreshReports,
          color: ColorConstants.appThemeColor,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 12.w,
                        runSpacing: 8.h,
                        children: [
                          FilterButton(
                            label: 'Yesterday',
                            isSelected: controller.isYesterdaySelected,
                            onTap: () => controller.selectFilter('Yesterday'),
                          ),
                          FilterButton(
                            label: 'Today',
                            isSelected: controller.isTodaySelected,
                            onTap: () => controller.selectFilter('Today'),
                          ),
                          FilterButton(
                            label: 'Last 7 Days',
                            isSelected: controller.isLast7DaysSelected,
                            onTap: () => controller.selectFilter('Last 7 Days'),
                          ),
                        ],
                      ),
                      Obx(() => controller.isCustomRangeSelected.value
                          ? Column(
                        children: [
                          SizedBox(height: 12.h),
                          SelectedDateRange(
                            formattedStartDate: controller.formattedDate(controller.selectedRange.value.start),
                            formattedEndDate: controller.formattedDate(controller.selectedRange.value.end),
                          ),
                        ],
                      )
                          : const SizedBox.shrink()),
                      SizedBox(height: 16.h),
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
                          CalendarButton(
                            isSelected: controller.isCustomRangeSelected,
                            onTap: () => _showDateRangePicker(context),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Obx(() => controller.isLoading.value
                          ? Column(
                              children: [
                                Row(
                                  children: List.generate(
                                      3,
                                      (index) => const Expanded(
                                          child: BaseShimmer(
                                              child: GridItemShimmer()))),
                                ),
                                SizedBox(height: 16.h),
                                Row(
                                  children: List.generate(
                                      2,
                                      (index) => const Expanded(
                                          child: BaseShimmer(
                                              child: GridItemShimmer()))),
                                ),
                                SizedBox(height: 20.h),
                                Row(
                                  children: List.generate(
                                      3,
                                      (index) => const Expanded(
                                          child: BaseShimmer(
                                              child: GridItemShimmer()))),
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  children: List.generate(
                                      3,
                                      (index) => const Expanded(
                                          child: BaseShimmer(
                                              child: GridItemShimmer()))),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomGridItem(
                                        title: 'Total Calls',
                                        value: controller.totalCalls.value.toString(),
                                        icon: Icons.call,
                                        iconColor: ColorConstants.appThemeColor,
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: CustomGridItem(
                                        title: 'Connected',
                                        value: controller.connectedCalls.value.toString(),
                                        icon: Icons.call_made,
                                        iconColor: ColorConstants.appThemeColor,
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: CustomGridItem(
                                        title: 'Not Connected',
                                        value: controller.notConnectedCalls.value.toString(),
                                        icon: Icons.call_missed,
                                        iconColor: ColorConstants.appThemeColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomGridItem(
                                        title: 'Avg Talk Time',
                                        value:
                                            '${(controller.avgTalkTime.value / 60).toStringAsFixed(1)} min',
                                        icon: Icons.timer,
                                        iconColor: ColorConstants.appThemeColor,
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: CustomGridItem(
                                        title: 'Total Talk Time',
                                        value:
                                            '${(controller.totalConversationTime.value / 60).toStringAsFixed(0)} min',
                                        icon: Icons.access_time,
                                        iconColor: ColorConstants.appThemeColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                Text(
                                  'Connected Stats',
                                  style: TextStyle(
                                    fontFamily: AppFonts.poppins,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Interested',
                                  style: TextStyle(
                                    fontFamily: AppFonts.poppins,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomGridItem(
                                        title: 'V Interested',
                                        value: (leadsController.leadData.value?.veryInterested?.count ?? 0)
                                            .toString(),
                                        icon: Icons.star,
                                        iconColor: ColorConstants.appThemeColor,
                                        onTap: () {
                                          Get.toNamed(
                                            AppRoutes.inboundReportStatusScreen,
                                            arguments: {
                                              'leadCategory': leadsController.leadData.value?.veryInterested,
                                              'title': 'V Interested'
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: CustomGridItem(
                                        title: 'Maybe',
                                        value: (leadsController.leadData.value?.maybe?.count ?? 0).toString(),
                                        icon: Icons.help_outline,
                                        iconColor: ColorConstants.appThemeColor,
                                        onTap: () {
                                          Get.toNamed(
                                            AppRoutes.inboundReportStatusScreen,
                                            arguments: {
                                              'leadCategory': leadsController.leadData.value?.maybe,
                                              'title': 'Maybe'
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: CustomGridItem(
                                        title: 'Enrolled',
                                        value: (leadsController.leadData.value?.enrolled?.count ?? 0).toString(),
                                        icon: Icons.check_circle,
                                        iconColor: ColorConstants.appThemeColor,
                                        onTap: () {
                                          Get.toNamed(
                                            AppRoutes.inboundReportStatusScreen,
                                            arguments: {
                                              'leadCategory': leadsController.leadData.value?.enrolled,
                                              'title': 'Enrolled'
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'Follow-up',
                                  style: TextStyle(
                                    fontFamily: AppFonts.poppins,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomGridItem(
                                        title: 'Hot Followup',
                                        value: (leadsController.leadData.value?.hotFollowup?.count ?? 0)
                                            .toString(),
                                        icon: Icons.schedule,
                                        iconColor: ColorConstants.appThemeColor,
                                        onTap: () {
                                          Get.toNamed(
                                            AppRoutes.inboundReportStatusScreen,
                                            arguments: {
                                              'leadCategory': leadsController.leadData.value?.hotFollowup,
                                              'title': 'Hot Followup'
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: CustomGridItem(
                                        title: 'Cold Followup',
                                        value: (leadsController.leadData.value?.coldFollowup?.count ?? 0)
                                            .toString(),
                                        icon: Icons.info_outline,
                                        iconColor: ColorConstants.appThemeColor,
                                        onTap: () {
                                          Get.toNamed(
                                            AppRoutes.inboundReportStatusScreen,
                                            arguments: {
                                              'leadCategory': leadsController.leadData.value?.coldFollowup,
                                              'title': 'Cold Followup'
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: CustomGridItem(
                                        title: 'Scheduled',
                                        value: (leadsController.leadData.value?.schedule?.count ?? 0).toString(),
                                        icon: Icons.phone_callback,
                                        iconColor: ColorConstants.appThemeColor,
                                        onTap: () {
                                          Get.toNamed(
                                            AppRoutes.inboundReportStatusScreen,
                                            arguments: {
                                              'leadCategory': leadsController.leadData.value?.schedule,
                                              'title': 'Scheduled'
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                Divider(
                                  color: ColorConstants.lightGrey.withOpacity(0.3),
                                  thickness: 2,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'Not Interested',
                                  style: TextStyle(
                                    fontFamily: AppFonts.poppins,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomGridItem(
                                        title: 'Junk Lead',
                                        value: (leadsController.leadData.value?.junkLead?.count ?? 0).toString(),
                                        icon: Icons.delete,
                                        iconColor: ColorConstants.appThemeColor,
                                        onTap: () {
                                          Get.toNamed(
                                            AppRoutes.inboundReportStatusScreen,
                                            arguments: {
                                              'leadCategory': leadsController.leadData.value?.junkLead,
                                              'title': 'Junk Lead'
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: CustomGridItem(
                                        title: 'Not Required',
                                        value: (leadsController.leadData.value?.notRequired?.count ?? 0)
                                            .toString(),
                                        icon: Icons.cancel,
                                        iconColor: ColorConstants.appThemeColor,
                                        onTap: () {
                                          Get.toNamed(
                                            AppRoutes.inboundReportStatusScreen,
                                            arguments: {
                                              'leadCategory': leadsController.leadData.value?.notRequired,
                                              'title': 'Not Required'
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: CustomGridItem(
                                        title: 'Enroll Other',
                                        value: (leadsController.leadData.value?.enrolledOther?.count ?? 0)
                                            .toString(),
                                        icon: Icons.swap_horiz,
                                        iconColor: ColorConstants.appThemeColor,
                                        onTap: () {
                                          Get.toNamed(
                                            AppRoutes.inboundReportStatusScreen,
                                            arguments: {
                                              'leadCategory': leadsController.leadData.value?.enrolledOther,
                                              'title': 'Enroll Other'
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomGridItem(
                                        title: 'Declined',
                                        value: (leadsController.leadData.value?.decline?.count ?? 0).toString(),
                                        icon: Icons.close,
                                        iconColor: ColorConstants.appThemeColor,
                                        onTap: () {
                                          Get.toNamed(
                                            AppRoutes.inboundReportStatusScreen,
                                            arguments: {
                                              'leadCategory': leadsController.leadData.value?.decline,
                                              'title': 'Declined'
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: CustomGridItem(
                                        title: 'Not Eligible',
                                        value: (leadsController.leadData.value?.notEligible?.count ?? 0)
                                            .toString(),
                                        icon: Icons.block,
                                        iconColor: ColorConstants.appThemeColor,
                                        onTap: () {
                                          Get.toNamed(
                                            AppRoutes.inboundReportStatusScreen,
                                            arguments: {
                                              'leadCategory': leadsController.leadData.value?.notEligible,
                                              'title': 'Not Eligible'
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: CustomGridItem(
                                        title: 'Wrong Number',
                                        value: (leadsController.leadData.value?.wrongNumber?.count ?? 0)
                                            .toString(),
                                        icon: Icons.phone_disabled,
                                        iconColor: ColorConstants.appThemeColor,
                                        onTap: () {
                                          Get.toNamed(
                                            AppRoutes.inboundReportStatusScreen,
                                            arguments: {
                                              'leadCategory': leadsController.leadData.value?.wrongNumber,
                                              'title': 'Wrong Number'
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDateRangePicker(BuildContext context) {
    controller.initializeCalendarRange();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Start Date',
                labelStyle: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 14.sp,
                  color: ColorConstants.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                suffixIcon: Icon(Icons.calendar_today, size: 16.sp),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              ),
              controller: TextEditingController(
                text: controller.formattedDate(controller.selectedRange.value.start),
              ),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: controller.selectedRange.value.start,
                  firstDate: DateTime.utc(2020, 1, 1),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  controller.selectStartDate(picked);
                }
              },
            ),
            SizedBox(height: 12.h),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'End Date',
                labelStyle: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 14.sp,
                  color: ColorConstants.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                suffixIcon: Icon(Icons.calendar_today, size: 16.sp),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                errorText: controller.dateError.value.isEmpty ? null : controller.dateError.value,
              ),
              controller: TextEditingController(
                text: controller.formattedDate(controller.selectedRange.value.end),
              ),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: controller.selectedRange.value.end,
                  firstDate: DateTime.utc(2020, 1, 1),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  controller.selectEndDate(picked);
                }
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
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 14.sp,
                color: ColorConstants.appThemeColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 14.sp,
                color: ColorConstants.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}