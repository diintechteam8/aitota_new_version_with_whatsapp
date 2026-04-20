import 'package:aitota_business/core/app-export.dart';
import '../../../../core/utils/widgets/common_widgets/shimmer_loading.dart';
import 'controller/outbound_leads_controller.dart';

class OutboundLeadsScreen extends GetView<OutboundLeadsController> {
  const OutboundLeadsScreen({super.key});

  String _formatCount(String count) {
    try {
      int value = int.parse(count);
      if (value >= 1000) {
        double kValue = value / 1000;
        if (kValue == kValue.toInt()) {
          return '${kValue.toInt()}k';
        }
        return '${kValue.toStringAsFixed(1)}k';
      }
      return count;
    } catch (e) {
      return count;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      body: SafeArea(
        top: true,
        child: RefreshIndicator(
          onRefresh: controller.refreshLeads,
          color: ColorConstants.appThemeColor,
          child: Obx(() => Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 12.w,
                            runSpacing: 8.h,
                            children: [
                              _buildFilterButton(
                                  'Yesterday', controller.isYesterdaySelected),
                              _buildFilterButton(
                                  'Today', controller.isTodaySelected),
                              _buildFilterButton(
                                  'Last 7 Days', controller.isLast7DaysSelected),
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
                                  _buildCalendarButton(context),
                                ],
                              ),
                            ],
                          ),
                          if (controller.isCustomRangeSelected.value) ...[
                            SizedBox(height: 12.h),
                            _buildSelectedDateRange(),
                          ],
                          SizedBox(height: 8.h),
                          Obx(() => controller.isLoading.value
                              ? Column(
                                  children: List.generate(
                                      3, (index) => const BaseShimmer(child: LeadCardShimmer())),
                                )
                              : Column(
                                  children: [
                                    () {
                                      final leads = controller.leadData.value?.data?.veryInterested?.data ?? [];
                                      final whatsappCount = leads.where((lead) => lead.metadata?.whatsappRequested ?? false).length;
                                      final actionIcons = <Map<String, dynamic>>[];
                                      if (whatsappCount > 0) {
                                        actionIcons.add({
                                          'imagePath': ImageConstant.whatsapp,
                                          'tooltip': 'WhatsApp',
                                          'badgeCount': 0,
                                        });
                                      }
                                      return LeadStatCard(
                                        title: 'Interested',
                                        value: _formatCount((controller.leadData.value?.data?.veryInterested?.count ?? 0).toString()),
                                        icon: Icons.star_rounded,
                                        iconColor: ColorConstants.appThemeColor,
                                        onTap: controller.onVVITap,
                                        actionIcons: actionIcons,
                                      );
                                    }(),
                                    SizedBox(height: 8.h),
                                    () {
                                      final leads = controller.leadData.value?.data?.maybe?.data ?? [];
                                      final whatsappCount = leads.where((lead) => lead.metadata?.whatsappRequested ?? false).length;
                                      final actionIcons = <Map<String, dynamic>>[];
                                      if (whatsappCount > 0) {
                                        actionIcons.add({
                                          'imagePath': ImageConstant.whatsapp,
                                          'tooltip': 'WhatsApp',
                                          'badgeCount': 0,
                                        });
                                      }
                                      return LeadStatCard(
                                        title: 'May Be',
                                        value: _formatCount((controller.leadData.value?.data?.maybe?.count ?? 0).toString()),
                                        icon: Icons.help_rounded,
                                        iconColor: ColorConstants.appThemeColor,
                                        onTap: controller.onMayBeTap,
                                        actionIcons: actionIcons,
                                      );
                                    }(),
                                    SizedBox(height: 8.h),
                                    () {
                                      final leads = controller.leadData.value?.data?.enrolled?.data ?? [];
                                      final whatsappCount = leads.where((lead) => lead.metadata?.whatsappRequested ?? false).length;
                                      final actionIcons = <Map<String, dynamic>>[];
                                      if (whatsappCount > 0) {
                                        actionIcons.add({
                                          'imagePath': ImageConstant.whatsapp,
                                          'tooltip': 'WhatsApp',
                                          'badgeCount': 0,
                                        });
                                      }
                                      return LeadStatCard(
                                        title: 'Enrolled',
                                        value: _formatCount((controller.leadData.value?.data?.enrolled?.count ?? 0).toString()),
                                        icon: Icons.verified_rounded,
                                        iconColor: ColorConstants.appThemeColor,
                                        onTap: controller.onEnrolledTap,
                                        actionIcons: actionIcons,
                                      );
                                    }(),
                                  ],
                                )),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
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
                      ? ColorConstants.appThemeColor.withOpacity(0.3)
                      : ColorConstants.grey.withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.calendar_month,
              size: 22.sp,
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
            'Selected: ${controller.formattedDate(controller.selectedRange.value.start)} - ${controller.formattedDate(controller.selectedRange.value.end)}',
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: ColorConstants.appThemeColor,
            ),
          ),
        ));
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
