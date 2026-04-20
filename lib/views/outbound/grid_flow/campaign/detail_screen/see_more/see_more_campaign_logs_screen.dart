import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/app-export.dart';
import 'controller/see_more_campaign_logs_controller.dart';

class SeeMoreCampaignLogsScreen extends GetView<SeeMoreCampaignLogsController> {
  const SeeMoreCampaignLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Campaign Logs",
        showBackButton: true,
        onTapBack: () => Get.back(),
        titleStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.poppins,
        ),
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
              SizedBox(height: 16.h),
              Text(
                controller.errorMessage.value,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
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
                Icons.info_outline,
                size: 60.sp,
                color: Colors.grey.withOpacity(0.5),
              ),
              SizedBox(height: 16.h),
              Text(
                'No campaign logs found',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )
            : Padding(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
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
              child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith(
                      (states) => isDark ? Colors.black54 : Colors.grey.shade200,
                ),
                columnSpacing: 20.w,
                border: TableBorder(
                  horizontalInside: BorderSide(
                    width: 0.6,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
                columns: const [
                  DataColumn(label: Text('Number')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Disposition')),
                ],
                rows: controller.tableData
                    .map(
                      (item) => DataRow(
                    cells: [
                      DataCell(Text(item['number'] ?? 'N/A')),
                      DataCell(Text(item['name'] ?? 'N/A')),
                      DataCell(Text(item['status'] ?? 'N/A')),
                      DataCell(Text(item['disposition'] ?? 'N/A')),
                    ],
                  ),
                )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}