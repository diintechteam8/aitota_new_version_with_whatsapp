import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/inbound/grid_flow/leads/controller/inbound_leads_controller.dart';
import '../../../../core/utils/widgets/common_widgets/shimmer_loading.dart';
import '../../../../core/utils/widgets/common_widgets/calendar_button.dart';
import '../../../../core/utils/widgets/common_widgets/filter_button.dart';

class InboundLeadsScreen extends GetView<InboundLeadsController> {
  const InboundLeadsScreen({super.key});

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
                                isSelected: controller.isCustomRangeSelected,
                                onTap: () => _showDateRangePicker(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (controller.isCustomRangeSelected.value) ...[
                        SizedBox(height: 12.h),
                        SelectedDateRange(
                          formattedStartDate: controller.formattedDate(controller.selectedRange.value.start),
                          formattedEndDate: controller.formattedDate(controller.selectedRange.value.end),
                        ),
                      ],
                      SizedBox(height: 8.h),
                      Obx(() => controller.isLoading.value
                          ? Column(
                              children: List.generate(
                                  3,
                                  (index) =>
                                      const BaseShimmer(child: LeadCardShimmer())),
                            )
                          : Column(
                              children: [
                                () {
                                  final leads = controller
                                          .leadData.value?.veryInterested?.data ??
                                      [];
                                  final whatsappCount = leads
                                      .where((lead) =>
                                          lead.metadata?.whatsappRequested ?? false)
                                      .length;
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
                                    value: _formatCount((controller.leadData.value
                                                ?.veryInterested?.count ??
                                            0)
                                        .toString()),
                                    icon: Icons.star_rounded,
                                    iconColor: ColorConstants.appThemeColor,
                                    onTap: controller.onVVITap,
                                    actionIcons: actionIcons,
                                  );
                                }(),
                                SizedBox(height: 8.h),
                                () {
                                  final leads =
                                      controller.leadData.value?.maybe?.data ?? [];
                                  final whatsappCount = leads
                                      .where((lead) =>
                                          lead.metadata?.whatsappRequested ?? false)
                                      .length;
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
                                    value: _formatCount((controller
                                                .leadData.value?.maybe?.count ??
                                            0)
                                        .toString()),
                                    icon: Icons.help_rounded,
                                    iconColor: ColorConstants.appThemeColor,
                                    onTap: controller.onMayBeTap,
                                    actionIcons: actionIcons,
                                  );
                                }(),
                                SizedBox(height: 8.h),
                                () {
                                  final leads =
                                      controller.leadData.value?.enrolled?.data ??
                                          [];
                                  final whatsappCount = leads
                                      .where((lead) =>
                                          lead.metadata?.whatsappRequested ?? false)
                                      .length;
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
                                    value: _formatCount((controller
                                                .leadData.value?.enrolled?.count ??
                                            0)
                                        .toString()),
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