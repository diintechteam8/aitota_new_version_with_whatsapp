import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/myDial/grid_flow/saleDone/controller/my_dial_sale_controller.dart';
import 'package:intl/intl.dart';

class MyDialSaleScreen extends GetView<MyDialSaleController> {
  const MyDialSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      body: RefreshIndicator(
        onRefresh:
            controller.refreshSales, // Uses the separate refresh function
        color: ColorConstants.appThemeColor,
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // Ensures pull-to-refresh works
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter buttons wrapped in a horizontal scrollable row
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
                if (controller.isCustomRangeSelected.value) ...[
                  SizedBox(height: 12.h),
                  _buildSelectedDateRange(),
                ],
                SizedBox(height: 4.h),
                // Row for "Sales" text and calendar button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sales',
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    _buildCalendarButton(context),
                  ],
                ),
                SizedBox(height: 12.h),
                // Handle loading, empty, and data states
                Obx(() => controller.isLoading.value
                    ? SizedBox(
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
                      )
                    : controller.salesData.value?.data?.isEmpty ?? true
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height - 200.h,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'No sales available',
                                    style: TextStyle(
                                      fontFamily: AppFonts.poppins,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: ColorConstants.grey,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  ElevatedButton(
                                    onPressed: controller
                                        .refreshSales, // Calls the separate refresh function
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          ColorConstants.appThemeColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 8.h,
                                      ),
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
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                controller.salesData.value?.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              final sale =
                                  controller.salesData.value!.data![index];
                              return _buildSaleCard(
                                number: sale.phoneNumber ?? 'Unknown',
                                time: sale.createdAt != null
                                    ? DateFormat('MMM d, yyyy h:mm a').format(
                                        DateTime.parse(sale.createdAt!)
                                            .toLocal())
                                    : 'Unknown',
                                name: sale.contactName ?? 'Unknown',
                                onTap: () {
                                  // Add navigation logic if needed
                                  // Example: Get.toNamed(AppRoutes.saleDetailScreen, arguments: sale);
                                },
                              );
                            },
                          )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, RxBool isSelected) {
    return Obx(() => GestureDetector(
          onTap: () => controller.selectFilter(label),
          child: Container(
            alignment: Alignment.center,
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
                  offset: const Offset(0, 2),
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
                  : ColorConstants.appThemeColor.withOpacity(0.8),
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

  Widget _buildSaleCard({
    required String number,
    required String time,
    required String name,
    required VoidCallback onTap,
  }) {
    // 🕒 Format date & time as "dd-MM-yyyy, hh:mm a"
    String formattedTime = '';
    try {
      DateTime parsedTime = DateTime.parse(time);
      formattedTime = DateFormat('dd-MM-yyyy, hh:mm a').format(parsedTime);
    } catch (_) {
      formattedTime = time; // fallback if invalid date string
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: ColorConstants.grey.withOpacity(0.2), // 👈 light grey border
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorConstants.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIconValueRow(
              icon: Icons.person,
              iconBg: ColorConstants.appThemeColor.withOpacity(0.1),
              text: name,
              isBold: true,
            ),
            SizedBox(height: 4.h),
            _buildIconValueRow(
              icon: Icons.phone,
              iconBg: Colors.green.withOpacity(0.1),
              text: number,
            ),
            SizedBox(height: 4.h),
            _buildIconValueRow(
              icon: Icons.access_time,
              iconBg: Colors.orange.withOpacity(0.1),
              text: formattedTime,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconValueRow({
    required IconData icon,
    required Color iconBg,
    required String text,
    bool isBold = false,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 16.sp,
            color: ColorConstants.appThemeColor,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
              fontFamily: AppFonts.poppins,
              color: ColorConstants.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildLabelValue({required String label, required String value}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: ColorConstants.grey.withOpacity(0.7),
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: ColorConstants.black,
            ),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
