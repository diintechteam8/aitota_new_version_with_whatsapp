import '../../../../../../core/app-export.dart';
import 'controller/view_completed_campaign_calls_controller.dart';

class ViewCompletedCampaignCallsScreen extends GetView<ViewCompletedCampaignCallsController> {
  const ViewCompletedCampaignCallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Calls Details",
        titleStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, fontFamily: AppFonts.poppins),
        showBackButton: true,
        onTapBack: () {
          Get.back();
        },
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
                size: 60,
                color: Colors.red.shade600,
              ),
              const SizedBox(height: 8),
              Text(
                controller.errorMessage.value,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
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
                size: 60,
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'No completed campaign calls found',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )
            : Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
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
                        columnSpacing: 24,
                        dataRowHeight: 60,
                        headingRowHeight: 52,
                        horizontalMargin: 12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        headingTextStyle: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                        dataTextStyle: textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
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
                                'Result',
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
                                  style: TextStyle(fontSize: 12),
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
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      item['number'] ?? 'N/A',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      _showConversationBottomSheet(context, item);
                                    },
                                    child: Icon(
                                      Icons.chat_bubble_outline,
                                      size: 18,
                                      color: isDark ? Colors.white70 : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: _buildResultBadge(item['result'] ?? 'N/A'),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Page ${controller.currentPage.value} of ${controller.totalPages.value}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 18,
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
                          size: 18,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultBadge(String result) {
    Color backgroundColor;
    Color textColor;

    switch (result.toLowerCase()) {
      case 'success':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case 'failed':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;
      case 'pending':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
      default:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        result,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showConversationBottomSheet(BuildContext context, Map<String, dynamic> item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String documentId = item['documentId'] ?? '';

    // Fetch logs when bottom sheet is opened
    controller.fetchConversationLogs(documentId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow dynamic height
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8, // Limit max height
          ),
          child: Obx(
                () => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Conversation for ${item['name'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.poppins,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                // Handle loading state
                if (controller.isLoadingLogs.value)
                  const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                      strokeWidth: 2,
                    ),
                  )
                // Handle error state
                else if (controller.logsErrorMessage.value.isNotEmpty)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 40,
                        color: Colors.red.shade600,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.logsErrorMessage.value,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                // Handle no transcript
                else if (controller.transcript.value.isEmpty)
                    Center(
                      child: Text(
                        'No conversation transcript available',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  // Display transcript
                  else
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          controller.transcript.value,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontFamily: AppFonts.poppins,
                          ),
                        ),
                      ),
                    ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}