import 'dart:async';
import 'package:aitota_business/core/app-export.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../../../data/model/ai_agent/history_call_logs_model.dart' as history;
import '../../../../data/model/inbound/settings/ai_agent/ai_agent_model.dart';
import '../../../../data/model/ai_agent/live_call_logs_model.dart' as live;

class AiAgentDetailController extends GetxController {
  final agentData = Rx<AgentData?>(null);
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final isLoading = false.obs;
  final errorMessage = "".obs;
  final firstMessageController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();
  final phoneNumberController = TextEditingController();
  final callLogs = <history.Logs>[].obs;
  final isLogsLoading = false.obs;
  final logsErrorMessage = "".obs;
  final liveCallLogs = <live.Logs>[].obs;
  final callStatus = "Calling...".obs;
  Timer? _pollingTimer;
  DateTime? _callInitiationTime;

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
    _stopPolling();
    _callInitiationTime = DateTime.now();
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      await _fetchLiveCallLogs(uniqueId);
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _callInitiationTime = null;
    liveCallLogs.clear();
  }

  Future<void> _fetchLiveCallLogs(String uniqueId) async {
    try {
      final response = await apiService.getLiveCallLogs(uniqueId);
      if (response.logs != null && response.logs!.isNotEmpty && _callInitiationTime != null) {
        final newLogs = response.logs!.where((log) {
          if (log.createdAt == null) return false;
          final logTime = DateTime.tryParse(log.createdAt!);
          if (logTime == null) return false;
          final timeDifference = _callInitiationTime!.difference(logTime).inSeconds.abs();
          return timeDifference <= 60;
        }).toList();

        if (newLogs.isNotEmpty) {
          liveCallLogs.assignAll(newLogs);
          if (newLogs.any((log) => log.metadata?.isActive == true)) {
            callStatus.value = "Connected";
          } else if (newLogs.any((log) => log.metadata?.isActive == false)) {
            callStatus.value = "Call Ended";
            _stopPolling();
          } else {
            callStatus.value = "Calling...";
          }
        } else {
          callStatus.value = "Calling...";
          liveCallLogs.clear();
        }
      } else {
        callStatus.value = "Calling...";
        liveCallLogs.clear();
      }
    } catch (e) {
      callStatus.value = "Calling...";
      throw Exception(e.toString());
    }
  }

  Future<void> endCall(String uniqueId) async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

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
          agentName: agentData.value?.agentName,
          language: agentData.value?.language,
          category: agentData.value?.category,
          personality: agentData.value?.personality,
          firstMessage: newMessage,
          callingNumber: agentData.value?.callingNumber,
          callingType: agentData.value?.callingType,
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
      if (response.success == true && response.data != null) {
        callLogs.assignAll(response.data!.logs ?? []);
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

  Future<void> makePhoneCall() async {
    final phoneNumber = agentData.value?.callingNumber?.toString();
    if (phoneNumber == null || phoneNumber.isEmpty) {
      customSnackBar(message: "No phone number available for this agent", type: "E");
      return;
    }

    var status = await Permission.phone.request();
    if (status.isGranted) {
      bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
      if (res == false) {
        customSnackBar(message: "Could not initiate call", type: "E");
      }
    } else if (status.isDenied) {
      customSnackBar(message: "Phone call permission is required to make calls", type: "E");
    } else if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
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
          "uniqueid": uniqueId,
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

      if (response.data['success'] == true && response.data['data']['response']['status'] == "SUCCESS") {
        customSnackBar(message: "Call initiated successfully", type: "S");
        _showCallBottomSheet(Get.context!, uniqueId);
        _startPolling(uniqueId);
      } else {
        throw Exception(response.data['data']['response']['reason'] ?? "Failed to initiate call");
      }
    } catch (e) {
      errorMessage.value = "Failed to initiate call: $e";
      customSnackBar(message: errorMessage.value, type: "E");
    } finally {
      isLoading.value = false;
    }
  }

  Widget _buildTranscriptView(String transcript) {
    List<Map<String, String>> messages = _parseTranscript(transcript);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Conversation',
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstants.grey,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          constraints: BoxConstraints(maxHeight: 300.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: messages.map((message) {
                bool isUser = message['sender'] == 'User';
                String timestamp = message['timestamp'] ?? '';
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Column(
                    crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        timestamp,
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorConstants.grey.withOpacity(0.6),
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
                              width: 32.w,
                              height: 32.w,
                              margin: EdgeInsets.only(right: 8.w),
                              decoration: BoxDecoration(
                                color: ColorConstants.grey.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  'AI',
                                  style: TextStyle(
                                    fontFamily: AppFonts.poppins,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstants.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                              margin: EdgeInsets.only(left: isUser ? 50.w : 8.w, right: isUser ? 8.w : 50.w),
                              decoration: BoxDecoration(
                                color: isUser ? ColorConstants.appThemeColor.withOpacity(0.1) : ColorConstants.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                message['text']!,
                                style: TextStyle(
                                  fontFamily: AppFonts.poppins,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstants.grey,
                                ),
                                textAlign: isUser ? TextAlign.right : TextAlign.left,
                              ),
                            ),
                          ),
                          if (isUser) ...[
                            Container(
                              width: 32.w,
                              height: 32.w,
                              margin: EdgeInsets.only(left: 8.w),
                              decoration: BoxDecoration(
                                color: ColorConstants.appThemeColor.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  'U',
                                  style: TextStyle(
                                    fontFamily: AppFonts.poppins,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstants.appThemeColor,
                                  ),
                                ),
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
    if (transcript.isEmpty) return messages;

    List<String> lines = transcript.split('\n');
    final regex = RegExp(r'\[(.*?)\]\s*(User|AI)\s*\((.*?)\):\s*(.*)');

    for (var line in lines) {
      final match = regex.firstMatch(line);
      if (match != null) {
        String timestampRaw = match.group(1)!;
        String sender = match.group(2)!;
        String text = match.group(4)!;

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
      }
    }
    return messages;
  }

  Widget _buildConversationCard(live.Logs log) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: _buildTranscriptView(log.transcript ?? ''),
    );
  }

  void _showCallBottomSheet(BuildContext context, String uniqueId) {
    showModalBottomSheet(
      backgroundColor: ColorConstants.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.75, // 75% of screen height
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                    () => Text(
                  callStatus.value,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.poppins,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Obx(
                    () => liveCallLogs.isEmpty
                    ? Center(
                  child: Text(
                    'Waiting for call to connect...',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: AppFonts.poppins,
                      color: Colors.grey[600],
                    ),
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
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () async {
                  await endCall(uniqueId);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                ),
                child: Text(
                  'End Call',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: AppFonts.poppins,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(() {
      _stopPolling();
    });
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 30.sp,
                color: Colors.red,
              ),
              SizedBox(height: 8.h),
              Text(
                'Permission Denied',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.poppins,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Please enable phone call permission in app settings to make calls.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: AppFonts.poppins,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: AppFonts.poppins,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  ElevatedButton(
                    onPressed: () {
                      openAppSettings();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.appThemeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Open Settings',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: AppFonts.poppins,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}