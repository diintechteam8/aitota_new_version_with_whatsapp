import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/routes/app_routes.dart';
import '../../../../core/utils/widgets/common_widgets/shimmer_loading.dart';
import 'controller/outbound_reports_controller.dart';
import '../../../../../views/outbound/grid_flow/leads/controller/outbound_leads_controller.dart';

class OutboundReportsScreen extends GetView<OutboundReportsController> {
  const OutboundReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OutboundLeadsController leadsController = controller.leadsController;

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
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 8.h,
                      children: [
                        _buildFilterButton(
                            'Yesterday', controller.isYesterdaySelected),
                        _buildFilterButton('Today', controller.isTodaySelected),
                        _buildFilterButton(
                            'Last 7 Days', controller.isLast7DaysSelected),
                      ],
                    ),
                    Obx(() => controller.isCustomRangeSelected.value
                        ? Column(
                            children: [
                              SizedBox(height: 12.h),
                              _buildSelectedDateRange(),
                            ],
                          )
                        : const SizedBox.shrink()),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Call Statistics',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomGridItem(
                                      title: 'Total Calls',
                                      value: controller.totalCalls.value
                                          .toString(),
                                      icon: Icons.call,
                                      iconColor: ColorConstants.appThemeColor,
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: CustomGridItem(
                                      title: 'Connected',
                                      value: controller.connectedCalls.value
                                          .toString(),
                                      icon: Icons.call_made,
                                      iconColor: ColorConstants.appThemeColor,
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: CustomGridItem(
                                      title: 'Not Connected',
                                      value: controller.notConnectedCalls.value
                                          .toString(),
                                      icon: Icons.call_missed,
                                      iconColor: ColorConstants.appThemeColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              _buildLeadCategorySection(
                                'Interested',
                                leadsController,
                                ['veryInterested', 'maybe', 'enrolled'],
                                ['V Interested', 'Maybe', 'Enrolled'],
                                [
                                  Icons.star,
                                  Icons.help_outline,
                                  Icons.check_circle
                                ],
                              ),
                              SizedBox(height: 12.h),
                              _buildLeadCategorySection(
                                'Follow-up',
                                leadsController,
                                ['hotFollowup', 'coldFollowup', 'schedule'],
                                [
                                  'Hot Followup',
                                  'Cold Followup',
                                  'Scheduled'
                                ],
                                [
                                  Icons.schedule,
                                  Icons.info_outline,
                                  Icons.phone_callback
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Divider(
                                  color:
                                      ColorConstants.lightGrey.withOpacity(0.3),
                                  thickness: 2),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomGridItem(
                                      title: 'Junk Lead',
                                      value: (leadsController.leadData.value
                                                  ?.data?.junkLead?.count ??
                                              0)
                                          .toString(),
                                      icon: Icons.delete,
                                      iconColor: ColorConstants.appThemeColor,
                                      onTap: () {
                                        Get.toNamed(
                                          AppRoutes.outboundReportStatusScreen,
                                          arguments: {
                                            'leadCategory': leadsController
                                                .leadData.value?.data?.junkLead,
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
                                      value: (leadsController.leadData.value
                                                  ?.data?.notRequired?.count ??
                                              0)
                                          .toString(),
                                      icon: Icons.cancel,
                                      iconColor: ColorConstants.appThemeColor,
                                      onTap: () {
                                        Get.toNamed(
                                          AppRoutes.outboundReportStatusScreen,
                                          arguments: {
                                            'leadCategory':
                                                leadsController.leadData.value
                                                    ?.data?.notRequired,
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
                                      value: (leadsController.leadData.value
                                                  ?.data?.enrolledOther
                                                  ?.count ??
                                              0)
                                          .toString(),
                                      icon: Icons.swap_horiz,
                                      iconColor: ColorConstants.appThemeColor,
                                      onTap: () {
                                        Get.toNamed(
                                          AppRoutes.outboundReportStatusScreen,
                                          arguments: {
                                            'leadCategory':
                                                leadsController.leadData.value
                                                    ?.data?.enrolledOther,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomGridItem(
                                      title: 'Declined',
                                      value: (leadsController.leadData.value
                                                  ?.data?.decline?.count ??
                                              0)
                                          .toString(),
                                      icon: Icons.close,
                                      iconColor: ColorConstants.appThemeColor,
                                      onTap: () {
                                        Get.toNamed(
                                          AppRoutes.outboundReportStatusScreen,
                                          arguments: {
                                            'leadCategory':
                                                leadsController.leadData.value
                                                    ?.data?.decline,
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
                                      value: (leadsController.leadData.value
                                                  ?.data?.notEligible?.count ??
                                              0)
                                          .toString(),
                                      icon: Icons.block,
                                      iconColor: ColorConstants.appThemeColor,
                                      onTap: () {
                                        Get.toNamed(
                                          AppRoutes.outboundReportStatusScreen,
                                          arguments: {
                                            'leadCategory':
                                                leadsController.leadData.value
                                                    ?.data?.notEligible,
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
                                      value: (leadsController.leadData.value
                                                  ?.data?.wrongNumber?.count ??
                                              0)
                                          .toString(),
                                      icon: Icons.phone_disabled,
                                      iconColor: ColorConstants.appThemeColor,
                                      onTap: () {
                                        Get.toNamed(
                                          AppRoutes.outboundReportStatusScreen,
                                          arguments: {
                                            'leadCategory':
                                                leadsController.leadData.value
                                                    ?.data?.wrongNumber,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, RxBool isSelected) {
    return Obx(
      () => GestureDetector(
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
              color:
                  isSelected.value ? ColorConstants.white : ColorConstants.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarButton(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () => _showDateRangePicker(context),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: controller.isCustomRangeSelected.value
                  ? ColorConstants.appThemeColor
                  : ColorConstants.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: controller.isCustomRangeSelected.value
                      ? ColorConstants.appThemeColor.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.15),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: controller.isCustomRangeSelected.value
                    ? ColorConstants.appThemeColor
                    : Colors.grey.withOpacity(0.3),
                width: 1.2,
              ),
            ),
            child: Icon(
              Icons.calendar_month_rounded,
              size: 22.sp,
              color: controller.isCustomRangeSelected.value
                  ? Colors.white
                  : ColorConstants.appThemeColor.withOpacity(0.9),
            ),
          ),
        ));
  }

  Widget _buildSelectedDateRange() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: ColorConstants.grey.withOpacity(0.3)),
        ),
        child: Text(
          'Selected: ${controller.formattedDate(controller.selectedRange.value.start)} - ${controller.formattedDate(controller.selectedRange.value.end)}',
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: ColorConstants.appThemeColor,
          ),
        ),
      ),
    );
  }

  Widget _buildLeadCategorySection(
    String sectionTitle,
    OutboundLeadsController leadsController,
    List<String> keys,
    List<String> titles,
    List<IconData> icons,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(keys.length, (index) {
            final key = keys[index];
            final title = titles[index];
            final icon = icons[index];
            final value = _getLeadCount(leadsController, key);
            final leadCategory = _getLeadCategory(leadsController, key);

            return Expanded(
              child: CustomGridItem(
                title: title,
                value: value.toString(),
                icon: icon,
                iconColor: ColorConstants.appThemeColor,
                onTap: leadCategory == null
                    ? null
                    : () {
                        Get.toNamed(
                          AppRoutes.outboundReportStatusScreen,
                          arguments: {
                            'leadCategory': leadCategory,
                            'title': title
                          },
                        );
                      },
              ),
            );
          }).expand((widget) => [widget, SizedBox(width: 16.w)]).toList()
            ..removeLast(),
        ),
      ],
    );
  }

  int _getLeadCount(OutboundLeadsController leadsController, String key) {
    final leadData = leadsController.leadData.value?.data;
    switch (key) {
      case 'veryInterested':
        return leadData?.veryInterested?.count ?? 0;
      case 'maybe':
        return leadData?.maybe?.count ?? 0;
      case 'enrolled':
        return leadData?.enrolled?.count ?? 0;
      case 'hotFollowup':
        return leadData?.hotFollowup?.count ?? 0;
      case 'coldFollowup':
        return leadData?.coldFollowup?.count ?? 0;
      case 'schedule':
        return leadData?.schedule?.count ?? 0;
      case 'junkLead':
        return leadData?.junkLead?.count ?? 0;
      case 'notRequired':
        return leadData?.notRequired?.count ?? 0;
      case 'enrolledOther':
        return leadData?.enrolledOther?.count ?? 0;
      case 'decline':
        return leadData?.decline?.count ?? 0;
      case 'notEligible':
        return leadData?.notEligible?.count ?? 0;
      case 'wrongNumber':
        return leadData?.wrongNumber?.count ?? 0;
      default:
        return 0;
    }
  }

  dynamic _getLeadCategory(
      OutboundLeadsController leadsController, String key) {
    final leadData = leadsController.leadData.value?.data;
    switch (key) {
      case 'veryInterested':
        return leadData?.veryInterested;
      case 'maybe':
        return leadData?.maybe;
      case 'enrolled':
        return leadData?.enrolled;
      case 'hotFollowup':
        return leadData?.hotFollowup;
      case 'coldFollowup':
        return leadData?.coldFollowup;
      case 'schedule':
        return leadData?.schedule;
      case 'junkLead':
        return leadData?.junkLead;
      case 'notRequired':
        return leadData?.notRequired;
      case 'enrolledOther':
        return leadData?.enrolledOther;
      case 'decline':
        return leadData?.decline;
      case 'notEligible':
        return leadData?.notEligible;
      case 'wrongNumber':
        return leadData?.wrongNumber;
      default:
        return null;
    }
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
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  ),
                  controller: TextEditingController(
                    text: controller
                        .formattedDate(controller.selectedRange.value.start),
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
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    errorText: controller.dateError.value.isEmpty
                        ? null
                        : controller.dateError.value,
                  ),
                  controller: TextEditingController(
                    text: controller
                        .formattedDate(controller.selectedRange.value.end),
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
