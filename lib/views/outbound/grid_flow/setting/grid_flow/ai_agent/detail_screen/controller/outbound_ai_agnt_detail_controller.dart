import 'dart:async';
import 'package:aitota_business/core/app-export.dart';
import 'package:intl/intl.dart';
import '../../../../../../../../core/services/api_services.dart';
import '../../../../../../../../core/services/dio_client.dart';
import '../../../../../../../../core/utils/snack_bar.dart';
import '../../../../../../../../data/model/ai_agent/history_call_logs_model.dart' as history;
import '../../../../../../../../data/model/ai_agent/live_call_logs_model.dart' as live;
import '../../../../../../../../data/model/inbound/settings/ai_agent/ai_agent_model.dart';

class OutboundAiAgentDetailController extends GetxController {
  final agentData = Rx<AgentData?>(null);
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final isLoading = false.obs;
  final errorMessage = "".obs;
  final firstMessageController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();
  final phoneNumberController = TextEditingController();
  final callLogs = <history.Logs>[].obs; // Use history.Logs for historical logs
  final isLogsLoading = false.obs;
  final logsErrorMessage = "".obs;
  final liveCallLogs = <live.Logs>[].obs; // Use live.Logs for live logs
  final callStatus = "Calling...".obs;
  Timer? _pollingTimer;
  DateTime? _callInitiationTime; // Track call initiation time

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null && arguments is AgentData) {
      agentData.value = arguments;
      firstMessageController.text = agentData.value?.firstMessage ?? '';
      fetchCallLogs();
    } else {
      errorMessage.value = "No agent data provided";
    }
  }

  @override
  void onClose() {
    _stopPolling();
    firstMessageController.dispose();
    textFieldFocusNode.dispose();
    phoneNumberController.dispose();
    super.onClose();
  }

  void _startPolling(String uniqueId) {
    _stopPolling(); // Ensure no existing timer is running
    _callInitiationTime = DateTime.now(); // Store call initiation time
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      await _fetchLiveCallLogs(uniqueId);
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _callInitiationTime = null; // Clear initiation time
    liveCallLogs.clear(); // Clear logs when polling stops
  }

  Future<void> _fetchLiveCallLogs(String uniqueId) async {
    try {
      final response = await apiService.getLiveCallLogs(uniqueId);
      if (response.logs != null &&
          response.logs!.isNotEmpty &&
          _callInitiationTime != null) {
        // Filter logs within 1 minute of call initiation time
        final newLogs = response.logs!.where((log) {
          if (log.createdAt == null) return false;
          final logTime = DateTime.tryParse(log.createdAt!);
          if (logTime == null) return false;
          final timeDifference =
          _callInitiationTime!.difference(logTime).inSeconds.abs();
          return timeDifference <= 60; // Logs within 1 minute of call start
        }).toList();

        if (newLogs.isNotEmpty) {
          liveCallLogs.assignAll(newLogs); // Update with current call logs
          if (newLogs.any((log) => log.metadata?.isActive == false)) {
            callStatus.value = "Call Ended";
            _stopPolling();
          } else {
            callStatus.value = "Connected";
          }
        } else {
          callStatus.value = "Connected";
        }
      } else {
        callStatus.value = "Calling...";
        liveCallLogs.clear();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> endCall(String uniqueId) async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      // Find the latest log with streamSid and callSid
      final latestLog = liveCallLogs.firstWhere(
            (log) => log.streamSid != null && log.callSid != null,
        orElse: () => live.Logs(),
      );

      if (latestLog.streamSid == null || latestLog.callSid == null) {
        throw Exception("No active call found to end");
      }

      final request = {
        "event": "stop",
        "sequenceNumber": 1,
        "stop": {
          "accountSid": "5104",
          "callSid": latestLog.callSid,
        },
        "streamSid": latestLog.streamSid,
      };

      final response = await apiService.endCall(request);

      if (response.success == true) {
        callStatus.value = "Call Ended";
        _stopPolling();
        customSnackBar(message: "Call ended successfully", type: "S");
      } else {
        customSnackBar(message: response.message.toString(), type: "S");
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveGreeting() async {
    final newMessage = firstMessageController.text.trim();
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final request = {
        'firstMessage': newMessage,
        'startingMessages': [
          {'text': newMessage}
        ],
      };

      final response = await apiService.updateInboundAiAgent(
        request,
        agentData.value?.id ?? '',
      );

      if (response.id != null) {
        agentData.value = AgentData(
          id: response.id,
          agentName: agentData.value?.agentName ?? 'N/A',
          language: agentData.value?.language ?? 'N/A',
          category: agentData.value?.category ?? 'N/A',
          personality: agentData.value?.personality ?? 'N/A',
          firstMessage: newMessage,
          callingNumber: agentData.value?.callingNumber ?? 'N/A',
          callingType: agentData.value?.callingType ?? 'N/A',
        );
        firstMessageController.text = newMessage;
        customSnackBar(message: "Agent updated successfully", type: "S");
      } else {
        throw Exception("Invalid response from server");
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshAgentData() async {
    isLoading.value = true;
    errorMessage.value = "";
    try {
      final arguments = Get.arguments;
      if (arguments != null && arguments is AgentData) {
        agentData.value = arguments;
        firstMessageController.text = agentData.value?.firstMessage ?? '';
        fetchCallLogs();
      } else {
        errorMessage.value = "No agent data available to refresh";
      }
    } catch (e) {
      errorMessage.value = "Failed to refresh data: $e";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCallLogs() async {
    isLogsLoading.value = true;
    logsErrorMessage.value = "";
    try {
      final response = await apiService.getHistoryCallLogs(agentData.value?.id ?? '');
      if (response.success == true && response.data?.logs != null) {
        callLogs.assignAll(response.data!.logs!.cast<history.Logs>());
      } else {
        logsErrorMessage.value = "No call logs found.";
        callLogs.clear();
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLogsLoading.value = false;
    }
  }

  Future<void> initiateClickToBotCall(String phoneNumber) async {
    try {
      isLoading.value = true;
      errorMessage.value = "";
      final uniqueId = "app-test-${DateTime.now().millisecondsSinceEpoch}";
      print("UniqueId: $uniqueId");
      final request = {
        "apiKey": "629lXqsiDk85lfMub7RsN73u4741MlOl4Dv8kJE9",
        "payload": {
          "transaction_id": "CTI_BOT_DIAL",
          "phone_num": phoneNumber,
          "callerid": "168353225",
          "uuid": agentData.value?.id ?? "abc123",
          "custom_param": {
            "a": agentData.value?.id ?? "65c7d8e9f0a1b2c3d4e5f6a7",
            "agentName": agentData.value?.agentName ?? "My Test Agent",
            "purpose": "App Initiated Call",
            "agentId": agentData.value?.id ?? "65c7d8e9f0a1b2c3d4e5f6a7",
            "uniqueid": uniqueId,
          },
          "resFormat": 3
        }
      };

      final response = await apiService.dio.post(
        'https://app.aitota.com/api/v1/client/proxy/clicktobot',
        data: request,
      );

      if (response.data['success'] == true &&
          response.data['data']['response']['status'] == "SUCCESS") {
        customSnackBar(message: "Call initiated successfully", type: "S");
        _showCallBottomSheet(Get.context!, uniqueId);
        _startPolling(uniqueId);
      } else {
        throw Exception(response.data['data']['response']['reason'] ??
            "Failed to initiate call");
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Widget _buildTranscriptView(String transcript) {
    List<Map<String, String>> messages = _parseTranscript(transcript);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 4.h),
        Container(
          constraints: BoxConstraints(maxHeight: 400.h),
          decoration: BoxDecoration(
            color: Colors.white,
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
                String timestamp = message['timestamp'] ?? '';
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Column(
                    crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        timestamp,
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[500],
                        ),
                        textAlign: isUser ? TextAlign.right : TextAlign.left,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isUser) ...[
                            Container(
                              width: 36.w,
                              height: 36.w,
                              margin: EdgeInsets.only(right: 10.w),
                              decoration: BoxDecoration(
                                color: ColorConstants.blueGradient1.withAlpha(20),
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
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(isUser ? 12.r : 4.r),
                                  topRight: Radius.circular(isUser ? 4.r : 12.r),
                                  bottomLeft: Radius.circular(12.r),
                                  bottomRight: Radius.circular(12.r),
                                ),
                                border: Border.all(
                                  color: isUser ? ColorConstants.appThemeColor.withOpacity(0.3) : Colors.grey[200]!,
                                  width: 1.w,
                                ),
                              ),
                              child: Text(
                                message['text']!,
                                style: TextStyle(
                                  fontFamily: AppFonts.poppins,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
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

  List<Map<String, String>> _parseTranscript(String transcript) {
    List<Map<String, String>> messages = [];
    if (transcript == 'N/A' || transcript.isEmpty) return messages;

    List<String> lines = transcript.split('\n');
    final regex = RegExp(r'\[(.*?)\]\s*(User|AI)\s*\((.*?)\):\s*(.*)', unicode: true);

    for (var line in lines) {
      final match = regex.firstMatch(line);
      if (match != null) {
        String timestampRaw = match.group(1)!;
        String sender = match.group(2)!;
        String text = match.group(4)!.trim();

        String formattedTimestamp = '';
        try {
          DateTime dateTime = DateTime.parse(timestampRaw).toLocal();
          formattedTimestamp = DateFormat('hh:mm a').format(dateTime);
        } catch (_) {
          formattedTimestamp = 'Invalid time';
        }

        messages.add({
          'sender': sender,
          'text': text,
          'timestamp': formattedTimestamp,
        });
      } else {
        // Handle non-matching lines (e.g., status messages) in Hindi or English
        messages.add({
          'sender': 'System',
          'text': line.trim(),
          'timestamp': '',
        });
      }
    }
    return messages;
  }

  Widget _buildConversationCard(live.Logs log) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _buildTranscriptView(log.transcript ?? 'N/A'),
    );
  }

  void _showCallBottomSheet(BuildContext context, String uniqueId) {
    DraggableScrollableController draggableController = DraggableScrollableController();
    bool isDragging = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false, // Prevent dismissing on tap outside
      enableDrag: false,   // Disable default drag-to-dismiss behavior
      backgroundColor: Colors.transparent,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          // Collapse to min size instead of dismissing
          draggableController.animateTo(
            0.1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
          return false; // Prevent closing the bottom sheet
        },
        child: DraggableScrollableSheet(
          controller: draggableController,
          initialChildSize: 0.75, // Start at 75% of screen height
          minChildSize: 0.1,      // Minimum size (10% when dragged down)
          maxChildSize: 0.9,      // Maximum size (90% when dragged up)
          snap: true,             // Enable snapping to defined sizes
          snapSizes: const [0.1, 0.2, 0.75, 0.9], // Snap points
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    // Draggable handle
                    GestureDetector(
                      onVerticalDragUpdate: (details) {
                        isDragging = true;
                        // Update the sheet position based on drag
                        final newSize = draggableController.size - details.delta.dy / MediaQuery.of(context).size.height;
                        draggableController.jumpTo(newSize.clamp(0.1, 0.9));
                      },
                      onVerticalDragEnd: (details) {
                        isDragging = false;
                        // Snap to the nearest snapSize
                        final currentSize = draggableController.size;
                        final closestSnap = [0.1, 0.2, 0.75, 0.9].reduce((a, b) => (a - currentSize).abs() < (b - currentSize).abs() ? a : b);
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
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Obx(
                                    () => Text(
                                  callStatus.value,
                                  style: TextStyle(
                                    fontFamily: AppFonts.poppins,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Obx(
                                    () => liveCallLogs.isEmpty
                                    ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircularProgressIndicator(
                                        color: ColorConstants.appThemeColor,
                                        strokeWidth: 3.w,
                                      ),
                                      SizedBox(height: 12.h),
                                      Text(
                                        'Waiting for call to connect...',
                                        style: TextStyle(
                                          fontFamily: AppFonts.poppins,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: liveCallLogs.length,
                                  itemBuilder: (context, index) {
                                    final log = liveCallLogs[index];
                                    return _buildConversationCard(log);
                                  },
                                ),
                              ),
                              SizedBox(height: 80.h), // Space for fixed button
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 20.h,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await endCall(uniqueId); // Call the endCall API
                        Get.back(); // Close the bottom sheet
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                        elevation: 2,
                      ),
                      child: Text(
                        'End Call',
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
          ),
        ),
      ),
    ).whenComplete(() {
      _stopPolling(); // Stop polling when the bottom sheet is closed
    });
  }
}