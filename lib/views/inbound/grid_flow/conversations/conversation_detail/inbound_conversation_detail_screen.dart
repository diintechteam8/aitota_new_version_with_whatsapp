import 'package:aitota_business/core/app-export.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'controller/inbound_conversation_detail_controller.dart';

class InboundConversationsDetailScreen extends GetView<InboundConversationsDetailController> {
  const InboundConversationsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Details",
        titleStyle: TextStyle(
          fontFamily: AppFonts.poppins,
          fontWeight: FontWeight.w500,
          color: ColorConstants.white,
          fontSize: 16.sp,
        ),
        showBackButton: true,
        onTapBack: Get.back,
      ),
      body: SafeArea(
        top: false,
        child: Obx(
              () => SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              children: [
                if (controller.conversation.value == null)
                  Container(
                    constraints: BoxConstraints(maxHeight: 300.h),
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
                    child: Center(
                      child: Text(
                        'No conversation available',
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorConstants.grey,
                        ),
                      ),
                    ),
                  )
                else ...[
                  _buildMobileStatusCard(),
                  SizedBox(height: 12.h),
                  _buildConversationCard(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileStatusCard() {
    final mobile = controller.conversation.value!.mobile ?? 'N/A';
    final time = controller.conversation.value!.formattedTime ?? 'N/A';
    final duration = _formatDuration(controller.conversation.value!.duration);

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
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mobile row
              Row(
                children: [
                  Text(
                    'Mobile: ',
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorConstants.lightTextColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      mobile,
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorConstants.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              // Time row
              Row(
                children: [
                  Text(
                    'Time: ',
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorConstants.lightTextColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      time,
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorConstants.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              // Duration row with icons
              Row(
                children: [
                  Text(
                    'Duration: ',
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorConstants.lightTextColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      duration,
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorConstants.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (mobile != 'N/A') ...[
                    IconButton(
                      icon: Icon(
                        Icons.phone,
                        color: ColorConstants.appThemeColor,
                        size: 20.sp,
                      ),
                      onPressed: () async {
                        await FlutterPhoneDirectCaller.callNumber(mobile);
                      },
                    ),
                    GestureDetector(
                      onTap: () async {
                        final whatsappUrl = 'whatsapp://send?phone=$mobile';
                        if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
                          await launchUrl(Uri.parse(whatsappUrl));
                        } else {
                          throw Exception('Could not launch WhatsApp');
                        }
                      },
                      child: SvgPicture.asset(
                        ImageConstant.whatsappIcon,
                        width: 30.w,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: _getStatusColor(controller.conversation.value!.leadStatus ?? 'Unknown'),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(6.r),
                  topRight: Radius.circular(6.r),
                ),
              ),
              child: Text(
                controller.conversation.value!.leadStatus ?? 'Unknown',
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationCard() {
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
      child: _buildTranscriptView(controller.conversation.value!.transcript ?? 'N/A'),
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
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstants.grey,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          constraints: BoxConstraints(maxHeight: 400.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: messages.map((message) {
                bool isUser = message['sender'] == 'User';
                String timestamp = message['timestamp'] ?? '';
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
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
                                    fontSize: 11.sp,
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
                                  fontFamily: message['text']!.contains(RegExp(r'[\u0900-\u097F]'))
                                      ? 'NotoSansDevanagari'
                                      : AppFonts.poppins,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstants.grey,
                                ),
                                textAlign: isUser ? TextAlign.right : TextAlign.left,
                                softWrap: true,
                                overflow: TextOverflow.visible,
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
                                    fontSize: 10.sp,
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
          ),
        ),
      ],
    );
  }

  List<Map<String, String>> _parseTranscript(String transcript) {
    List<Map<String, String>> messages = [];
    if (transcript == 'N/A' || transcript.trim().isEmpty) {
      print('Transcript is empty or N/A');
      return messages;
    }

    // Split into non-empty lines
    List<String> lines = transcript.split('\n').where((line) => line.trim().isNotEmpty).toList();
    print('Total lines to parse: ${lines.length}');

    // Regex to match [timestamp] User/AI (en/hi): text, with optional language tag
    final regex = RegExp(
      r'\[(.*?)\]\s*(User|AI)\s*(?:\((en|hi)\))?\s*:\s*(.*)',
      unicode: true, // Support Hindi (Devanagari) characters
    );

    for (var line in lines) {
      print('Parsing line: $line');
      final match = regex.firstMatch(line);
      if (match != null) {
        String timestampRaw = match.group(1)?.trim() ?? '';
        String sender = match.group(2)?.trim() ?? 'Unknown';
        String language = match.group(3)?.trim() ?? 'en'; // Default to English
        String text = match.group(4)?.trim() ?? '';

        // Skip empty messages
        if (text.isEmpty) {
          print('Skipping empty message in line: $line');
          continue;
        }

        String formattedTimestamp = '';
        if (timestampRaw.isNotEmpty) {
          try {
            DateTime dateTime = DateTime.parse(timestampRaw).toLocal();
            formattedTimestamp = DateFormat('hh:mm a').format(dateTime);
          } catch (e) {
            print('Error parsing timestamp "$timestampRaw": $e');
            formattedTimestamp = timestampRaw.isNotEmpty ? timestampRaw : 'Unknown time';
          }
        } else {
          formattedTimestamp = 'Unknown time';
        }

        messages.add({
          'sender': sender,
          'text': text,
          'timestamp': formattedTimestamp,
          'language': language,
        });
      } else {
        print('Line did not match regex: $line');
        if (line.trim().isNotEmpty) {
          messages.add({
            'sender': 'Unknown',
            'text': line.trim(),
            'timestamp': 'Unknown time',
            'language': 'unknown',
          });
        }
      }
    }

    print('Parsed messages: ${messages.length}');
    return messages;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'very interested':
      case 'v interested':
        return Colors.red;
      case 'maybe':
        return Colors.orange;
      case 'enrolled':
        return Colors.green;
      case 'junk lead':
        return Colors.grey;
      case 'not required':
        return Colors.blueGrey;
      case 'enroll other':
        return Colors.purple;
      case 'declined':
        return Colors.redAccent;
      case 'not eligible':
        return Colors.black54;
      case 'wrong number':
        return Colors.brown;
      case 'hot followup':
        return Colors.red;
      case 'cold followup':
        return Colors.blue;
      case 'scheduled':
        return Colors.green;
      default:
        return ColorConstants.grey;
    }
  }

  String _formatDuration(int? duration) {
    if (duration == null || duration <= 0) return '0 sec';
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    if (minutes == 0) return '$seconds sec';
    return '$minutes min $seconds sec';
  }
}