import 'dart:async';
import 'package:get/get.dart';
import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/services/api_services.dart';
import 'package:aitota_business/core/services/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../../data/model/outbound/campaign/live_campaign_call_log_model.dart';
import '../../../../../../../data/model/outbound/campaign/outbound_campaign_detail_model.dart';

class ViewLiveCampaignCallsController extends GetxController {
  final RxList<Map<String, dynamic>> tableData = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxBool hasNextPage = false.obs;
  final RxBool hasPrevPage = false.obs;
  final RxBool isLoadingLogs = false.obs;
  final RxString logsErrorMessage = ''.obs;
  final RxList<String> logs = <String>[].obs;
  final ApiService apiService = ApiService(dio: DioClient().dio);
  Timer? _refreshTimer;
  Timer? _logsRefreshTimer;
  String? currentUniqueId;
  String? campaignId;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments is Map<String, dynamic> && arguments['campaignId'] != null) {
      campaignId = arguments['campaignId'];
      fetchLiveCampaignCalls();
      _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        fetchLiveCampaignCalls(page: currentPage.value);
      });
    } else {
      errorMessage.value = 'No campaign ID provided';
    }
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    _logsRefreshTimer?.cancel();
    super.onClose();
  }

  Future<void> fetchLiveCampaignCalls({int page = 1}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (campaignId == null) {
        return;
      }

      final response = await apiService.getOutboundCampaignById(campaignId!);

      if (response.success == true && response.data != null) {
        final details = response.data!.details ?? [];
        final contacts = response.data!.contacts ?? [];
        final liveCalls = details.asMap().entries.where((entry) {
          final detail = entry.value;
          return detail.status?.toLowerCase() != 'completed';
        }).toList();

        if (liveCalls.isEmpty) {
          tableData.clear();
          return;
        }

// Paginate
        const pageSize = 10;
        final totalItems = liveCalls.length;
        totalPages.value = (totalItems / pageSize).ceil();
        currentPage.value = page;
        hasNextPage.value = page < totalPages.value;
        hasPrevPage.value = page > 1;

        final startIndex = (page - 1) * pageSize;
        final endIndex = (startIndex + pageSize).clamp(0, totalItems);
        final paginatedCalls = liveCalls.sublist(startIndex, endIndex);

// Map to tableData
        tableData.assignAll(paginatedCalls.asMap().entries.map((entry) {
          final pageIndex = entry.key + 1;
          final detail = entry.value.value;
          final contact = contacts.firstWhere(
            (contact) => contact.id == detail.contactId,
            orElse: () => Contact(name: 'Unknown', phone: 'N/A'),
          );

          return {
            'sno': pageIndex.toString(),
            'number': contact.phone ?? 'N/A',
            'name': contact.name ?? 'Unknown',
            'status': detail.status?.capitalizeFirst ?? 'Live',
            'isLive': detail.status?.toLowerCase() != 'completed',
            'contactId': detail.contactId,
            'uniqueId': detail.uniqueId,
            'detailId': detail.id,
          };
        }).toList());
      } else {
        tableData.clear();
      }
    } on DioException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      tableData.clear();
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void goToNextPage() {
    if (hasNextPage.value) {
      currentPage.value++;
      fetchLiveCampaignCalls(page: currentPage.value);
    }
  }

  void goToPreviousPage() {
    if (hasPrevPage.value) {
      currentPage.value--;
      fetchLiveCampaignCalls(page: currentPage.value);
    }
  }

  Future<void> fetchConversationLogs(String uniqueId) async {
    try {
      isLoadingLogs.value = true;
      logsErrorMessage.value = '';
      logs.clear();

      if (uniqueId.isEmpty) {
        logsErrorMessage.value = 'Invalid unique ID provided';
        return;
      }

// Fetch logs from API
      final response = await apiService.getCampaignLiveCallsLogs(uniqueId);

// If response contains logs
      final callLogs = response.logs ?? [];

      if (callLogs.isEmpty) {
        logsErrorMessage.value =
            'No conversation logs found for uniqueId: $uniqueId';
        return;
      }

// Map logs to the desired format
      logs.assignAll(callLogs.expand((log) {
        final time = log.time != null
            ? DateFormat('hh:mm a').format(DateTime.parse(log.time!))
            : 'N/A';
        final transcript = log.transcript ?? '';

// If no transcript, return status with time
        if (transcript.isEmpty) {
          return ['Status: ${log.leadStatus ?? 'Unknown'} at $time'];
        }

// Split transcript into lines and format
        final transcriptLines = transcript
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .map((line) {
          final regex = RegExp(r'\[(.*?)\]\s*(.*?):\s*(.*)');
          final match = regex.firstMatch(line);
          if (match != null) {
            final timestamp = match.group(1) ?? '';
            final speaker = match.group(2) ?? '';
            final message = match.group(3) ?? '';
            try {
              final parsedTime = DateTime.parse(timestamp);
              final formattedTime = DateFormat('hh:mm a').format(parsedTime);
              return '[$formattedTime] $speaker: $message';
            } catch (e) {
              return line; // fallback
            }
          }
          return line; // fallback
        }).toList();

        return transcriptLines;
      }).toList());
    } on DioException catch (e) {
      logsErrorMessage.value = 'Error fetching logs: ${e.message}';
    } catch (e) {
      logsErrorMessage.value = 'Unexpected error: $e';
    } finally {
      isLoadingLogs.value = false;
    }
  }

  void startLogsPolling(String uniqueId) {
    currentUniqueId = uniqueId;
    _logsRefreshTimer?.cancel();
    _logsRefreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (currentUniqueId != null) {
        fetchConversationLogs(currentUniqueId!);
      }
    });
  }

  void stopLogsPolling() {
    _logsRefreshTimer?.cancel();
    currentUniqueId = null;
    logs.clear();
    logsErrorMessage.value = '';
  }

  List<Map<String, String>> _parseTranscript(String transcript) {
    List<Map<String, String>> messages = [];
    if (transcript == 'N/A' || transcript.isEmpty) return messages;

    List<String> lines = transcript.split('\n').where((line) => line.trim().isNotEmpty).toList();

    // Regex to match timestamp, sender (User/AI), optional name, and message
    // Supports Hindi (Devanagari) and English characters
    final regex = RegExp(
      r'\[(.*?)\]\s*(User|AI|उपयोगकर्ता|एआई)\s*(?:\((.*?)\))?:\s*(.*)',
      unicode: true,
    );

    for (var line in lines) {
      final match = regex.firstMatch(line);
      if (match != null) {
        String timestampRaw = match.group(1)!.trim();
        String sender = match.group(2)!; // User, AI, उपयोगकर्ता, or एआई
        String name = match.group(3)?.trim() ?? ''; // Optional name
        String text = match.group(4)!.trim();

        // Map Hindi sender labels to English for consistency in UI
        if (sender == 'उपयोगकर्ता') sender = 'User';
        if (sender == 'एआई') sender = 'AI';

        // Parse timestamp
        String formattedTimestamp = '';
        try {
          DateTime dateTime = DateTime.parse(timestampRaw).toLocal();
          formattedTimestamp = DateFormat('hh:mm a').format(dateTime);
        } catch (e) {
          formattedTimestamp = 'Invalid time';
        }

        messages.add({
          'sender': sender,
          'name': name,
          'text': text,
          'timestamp': formattedTimestamp,
        });
      } else {
        // Fallback for non-matching lines (e.g., status messages or unstructured text)
        // Handle Hindi/English status messages or other formats
        messages.add({
          'sender': 'System',
          'name': '',
          'text': line.trim(),
          'timestamp': '',
        });
      }
    }

    return messages;
  }

  Widget _buildTranscriptView(String transcript, bool isDark) {
    List<Map<String, String>> messages = _parseTranscript(transcript);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 4.h),
        Container(
          constraints: BoxConstraints(maxHeight: 400.h),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade800 : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: messages.map((message) {
                bool isUser = message['sender'] == 'User';
                bool isSystem = message['sender'] == 'System';
                String timestamp = message['timestamp'] ?? '';
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Column(
                    crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      if (!isSystem) ...[
                        Text(
                          timestamp,
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: isDark ? Colors.grey[400] : Colors.grey[500],
                          ),
                          textAlign: isUser ? TextAlign.right : TextAlign.left,
                        ),
                        SizedBox(height: 4.h),
                      ],
                      Row(
                        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isUser && !isSystem) ...[
                            Container(
                              width: 36.w,
                              height: 36.w,
                              margin: EdgeInsets.only(right: 10.w),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? ColorConstants.blueGradient1.withAlpha(50)
                                    : ColorConstants.blueGradient1.withAlpha(20),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.smart_toy,
                                size: 20.sp,
                                color: ColorConstants.blueGradient1,
                              ),
                            ),
                          ],
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                              margin: EdgeInsets.only(left: isUser ? 60.w : 0.w, right: isUser ? 0.w : 60.w),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? ColorConstants.appThemeColor.withOpacity(0.15)
                                    : (isDark ? Colors.grey.shade700 : Colors.grey[100]),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(isUser ? 12.r : 4.r),
                                  topRight: Radius.circular(isUser ? 4.r : 12.r),
                                  bottomLeft: Radius.circular(12.r),
                                  bottomRight: Radius.circular(12.r),
                                ),
                                border: Border.all(
                                  color: isUser
                                      ? ColorConstants.appThemeColor.withOpacity(0.3)
                                      : (isDark ? Colors.grey.shade600 : Colors.grey[200]!),
                                  width: 1.w,
                                ),
                              ),
                              child: Text(
                                message['text']!,
                                style: TextStyle(
                                  fontFamily: AppFonts.poppins,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: isDark ? Colors.white70 : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          if (isUser) ...[
                            Container(
                              width: 36.w,
                              height: 36.w,
                              margin: EdgeInsets.only(left: 10.w),
                              decoration: BoxDecoration(
                                color: ColorConstants.appThemeColor.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person,
                                size: 20.sp,
                                color: ColorConstants.primaryGradient1,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> showLogs(BuildContext context, String? uniqueId) async {
    if (uniqueId == null || uniqueId.isEmpty) {
      Get.snackbar('Error', 'Invalid unique ID',
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    await fetchConversationLogs(uniqueId);
    startLogsPolling(uniqueId);

    DraggableScrollableController draggableController =
        DraggableScrollableController();
    bool isDragging = false;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return WillPopScope(
            onWillPop: () async {
              draggableController.animateTo(
                0.1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
              return false;
            },
            child: DraggableScrollableSheet(
              controller: draggableController,
              initialChildSize: 0.75,
              minChildSize: 0.1,
              maxChildSize: 0.9,
              snap: true,
              snapSizes: const [0.1, 0.2, 0.75, 0.9],
              builder: (_, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade900 : Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.r)),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
// Draggable handle
                          GestureDetector(
                            onVerticalDragUpdate: (details) {
                              isDragging = true;
                              final newSize = draggableController.size -
                                  details.delta.dy /
                                      MediaQuery.of(context).size.height;
                              draggableController
                                  .jumpTo(newSize.clamp(0.1, 0.9));
                            },
                            onVerticalDragEnd: (details) {
                              isDragging = false;
                              final currentSize = draggableController.size;
                              final closestSnap = [0.1, 0.2, 0.75, 0.9].reduce(
                                  (a, b) => (a - currentSize).abs() <
                                          (b - currentSize).abs()
                                      ? a
                                      : b);
                              draggableController.animateTo(
                                closestSnap,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            },
                            child: Container(
                              width: 40.w,
                              height: 4.h,
                              margin: EdgeInsets.symmetric(vertical: 8.h),
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                          ),
// Header
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16.r)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Call Logs',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: AppFonts.poppins,
                                    color:
                                        isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, size: 24.r),
                                  onPressed: () {
                                    stopLogsPolling();
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Padding(
                                padding:
                                    EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 80.h),
                                child: Obx(() {
                                  if (isLoadingLogs.value) {
                                    return Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircularProgressIndicator(
                                            color: ColorConstants.appThemeColor,
                                            strokeWidth: 3.w,
                                          ),
                                          SizedBox(height: 12.h),
                                          Text(
                                            'Loading logs...',
                                            style: TextStyle(
                                              fontFamily: AppFonts.poppins,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: isDark
                                                  ? Colors.white70
                                                  : Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  if (logsErrorMessage.value.isNotEmpty) {
                                    return Center(
                                      child: Text(
                                        logsErrorMessage.value,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.red.shade600,
                                          fontFamily: AppFonts.poppins,
                                        ),
                                      ),
                                    );
                                  }
                                  if (logs.isEmpty) {
                                    return Center(
                                      child: Text(
                                        'No logs available',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: isDark
                                              ? Colors.white70
                                              : Colors.grey.shade700,
                                          fontFamily: AppFonts.poppins,
                                        ),
                                      ),
                                    );
                                  }
                                  return _buildTranscriptView(
                                      logs.join('\n'), isDark);
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
// Close button
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 20.h,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              stopLogsPolling();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24.w, vertical: 12.h),
                              elevation: 2,
                            ),
                            child: Text(
                              'Close',
                              style: TextStyle(
                                fontFamily: AppFonts.poppins,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }).whenComplete(() {
      stopLogsPolling();
    });
  }
}
