import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/detail_screen/view_live/controller/view_live_campaign_calls_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ViewLiveCampaignCallsScreen extends GetView<ViewLiveCampaignCallsController> {
  const ViewLiveCampaignCallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Live Campaign Calls",
        titleStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.poppins,
          color: ColorConstants.white
        ),
        showBackButton: true,
        onTapBack: () => Get.back(),
      ),
      body: Obx(
            () => controller.isLoading.value
            ? const Center(
          child: CircularProgressIndicator(
            color: Colors.green,
            strokeWidth: 2,
          ),
        )
            : controller.errorMessage.value.isNotEmpty
            ? Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 60.sp,
                color: Colors.red.shade600,
              ),
              SizedBox(height: 12.h),
              Text(
                controller.errorMessage.value,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey.shade700,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.poppins,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
            : controller.tableData.isEmpty
            ? Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.hourglass_empty, // Changed to hourglass for "waiting" indication
                size: 60.sp,
                color: isDark ? Colors.white54 : Colors.blue.shade600,
              ),
              SizedBox(height: 12.h),
              Text(
                'Please wait, checking for live campaign calls...',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey.shade700,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.poppins,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'This may take a few seconds.',
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey.shade600,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppFonts.poppins,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
            : Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6.r,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 100,
                      ),
                      child: DataTable(
                        columnSpacing: 24.w,
                        dataRowHeight: 60.h,
                        headingRowHeight: 52.h,
                        horizontalMargin: 12.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        headingTextStyle: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                        dataTextStyle: textTheme.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                        columns: const [
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'S. No.',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Contact',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Logs',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Status',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        rows: List.generate(controller.tableData.length, (index) {
                          final item = controller.tableData[index];
                          final isEvenRow = index % 2 == 0;

                          return DataRow(
                            color: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return isDark
                                      ? Colors.blueGrey.shade800.withOpacity(0.4)
                                      : Colors.blueGrey.shade50;
                                }
                                return isEvenRow
                                    ? (isDark
                                    ? Colors.grey.shade900.withOpacity(0.5)
                                    : Colors.grey.shade50)
                                    : null;
                              },
                            ),
                            cells: [
                              DataCell(
                                Text(
                                  item['sno'] ?? 'N/A',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              ),
                              DataCell(
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'] ?? 'N/A',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      item['number'] ?? 'N/A',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.description_outlined,
                                      size: 20.sp,
                                      color: isDark ? Colors.white70 : Colors.blue.shade600,
                                    ),
                                    onPressed: () {
                                      controller.showLogs(context, item['uniqueId']);
                                    },
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: item['isLive'] == true
                                      ? _BlinkingLiveStatus(status: item['status'] ?? 'Live')
                                      : Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade600,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Text(
                                      item['status']?.capitalizeFirst ?? 'Live',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Page ${controller.currentPage.value} of ${controller.totalPages.value}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 18.sp,
                              color: controller.hasPrevPage.value
                                  ? (isDark ? Colors.white70 : Colors.black87)
                                  : Colors.grey,
                            ),
                            onPressed: controller.hasPrevPage.value
                                ? controller.goToPreviousPage
                                : null,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 18.sp,
                              color: controller.hasNextPage.value
                                  ? (isDark ? Colors.white70 : Colors.black87)
                                  : Colors.grey,
                            ),
                            onPressed: controller.hasNextPage.value
                                ? controller.goToNextPage
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for blinking "Live" status in red container
class _BlinkingLiveStatus extends StatefulWidget {
  final String status;

  const _BlinkingLiveStatus({required this.status});

  @override
  __BlinkingLiveStatusState createState() => __BlinkingLiveStatusState();
}

class __BlinkingLiveStatusState extends State<_BlinkingLiveStatus> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.2, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return FadeTransition(
      opacity: _animation,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          widget.status.capitalizeFirst ?? 'Live',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}