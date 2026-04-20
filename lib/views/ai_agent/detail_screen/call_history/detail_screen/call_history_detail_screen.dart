import 'package:intl/intl.dart';
import '../../../../../core/app-export.dart';
import '../../../../../data/model/ai_agent/history_call_logs_model.dart';
import 'controller/call_histroy_detail_controller.dart';

class CallHistoryDetailScreen extends GetView<CallHistoryDetailController> {
  const CallHistoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
            backgroundColor: ColorConstants.homeBackgroundColor,
        appBar: CustomAppBar(
          title: "Call Details",
          showBackButton: true,
          onTapBack: () => Get.back(),
          titleStyle: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.poppins,
          ),
        ),
        body: controller.log.value == null
            ? Center(
          child: Text(
            'No call data available',
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: AppFonts.poppins,
              color: Colors.grey,
            ),
          ),
        )
            : SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCallInfo(controller.log.value!),
              SizedBox(height: 24.h),
              _buildTranscriptView(controller.log.value!.transcript ?? 'N/A'),
              // if (controller.log.value!.audioUrl != null) ...[
              //   SizedBox(height: 16.h),
              //   ElevatedButton(
              //     onPressed: controller.playAudio,
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: ColorConstants.appThemeColor,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8.r),
              //       ),
              //       padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              //     ),
              //     child: Text(
              //       'Play Audio',
              //       style: TextStyle(
              //         fontSize: 14.sp,
              //         fontFamily: AppFonts.poppins,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallInfo(Logs log) {
    // Format the date and time if available
    String formattedTime = 'N/A';
    if (log.time != null) {
      try {
        DateTime dateTime = DateTime.parse(log.time!).toLocal();
        formattedTime = DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
      } catch (e) {
        formattedTime = 'Invalid time';
      }
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mobile: ${log.mobile ?? 'N/A'}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.poppins,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Status: ${log.leadStatus ?? 'N/A'}',
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: AppFonts.poppins,
              color: _getStatusColor(log.leadStatus),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Time: $formattedTime',
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: AppFonts.poppins,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Duration: ${log.duration ?? 0} sec',
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: AppFonts.poppins,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
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
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: ColorConstants.grey,
          ),
        ),
        SizedBox(height: 12.h),
        if (messages.isEmpty)
          Text(
            'No conversation available',
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: messages.map((message) {
              bool isUser = message['sender'] == 'User';
              String timestamp = message['timestamp'] ?? '';
              String language = message['language'] ?? 'en'; // Default to English if not specified
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Column(
                  crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                      mainAxisAlignment:
                      isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
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
                                  fontWeight: FontWeight.w500,
                                  color: ColorConstants.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                            margin: EdgeInsets.only(
                              left: isUser ? 50.w : 8.w,
                              right: isUser ? 8.w : 50.w,
                            ),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? ColorConstants.appThemeColor.withOpacity(0.1)
                                  : ColorConstants.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              message['text']!,
                              style: TextStyle(
                                fontFamily: language == 'hi' ? 'NotoSansDevanagari' : AppFonts.poppins,
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
                                'User',
                                style: TextStyle(
                                  fontFamily: AppFonts.poppins,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
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
      ],
    );
  }

  List<Map<String, String>> _parseTranscript(String transcript) {
    List<Map<String, String>> messages = [];
    if (transcript == 'N/A') return messages;

    List<String> lines = transcript.split('\n');
    // Updated regex to match both (en) and (hi) or any language tag
    final regex = RegExp(r'\[(.*?)\]\s*(User|AI)\s*\((en|hi)\):\s*(.*)');

    for (var line in lines) {
      final match = regex.firstMatch(line);
      if (match != null) {
        String timestampRaw = match.group(1)!;
        String sender = match.group(2)!;
        String language = match.group(3)!; // Captures 'en' or 'hi'
        String text = match.group(4)!;

        String formattedTimestamp = '';
        try {
          DateTime dateTime = DateTime.parse(timestampRaw).toLocal();
          formattedTimestamp = DateFormat('hh:mm a').format(dateTime);
        } catch (e) {
          formattedTimestamp = 'Invalid time';
        }

        messages.add({
          'sender': sender,
          'text': text,
          'timestamp': formattedTimestamp,
          'language': language, // Optionally store language for future use
        });
      }
    }

    return messages;
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'veryinterested':
        return Colors.green;
      case 'maybe':
        return Colors.orange;
      case 'enrolled':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}