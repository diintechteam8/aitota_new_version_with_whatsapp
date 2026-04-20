import 'package:aitota_business/core/app-export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'controller/inbound_reports_detail_controller.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class InboundReportStatusDetailScreen
    extends GetView<InboundReportStatusDetailController> {
  const InboundReportStatusDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Detail Screen",
        titleStyle: TextStyle(
          fontFamily: AppFonts.poppins,
          color: ColorConstants.white,
          fontWeight: FontWeight.w500,
          fontSize: 18.sp,
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
                if (controller.lead.value == null)
// Card for no lead data
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
                        'No call status details available',
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
// Card 1: Mobile and Status
                  _buildMobileStatusCard(),
                  SizedBox(height: 12.h),
// Card 2: Conversation (Transcript)
                  _buildConversationCard(),
                  SizedBox(height: 12.h),
// Card 3: Audio
// _buildAudioCard(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileStatusCard() {
    final mobile = controller.lead.value!.mobile ?? 'N/A';
    final time = controller.lead.value!.time != null
        ? DateFormat('MMM dd, yyyy')
            .format(DateTime.parse(controller.lead.value!.time!))
        : 'N/A';
    final duration = _formatDuration(controller.lead.value!.duration);

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
                      icon: Icon(Icons.phone,
                          color: ColorConstants.appThemeColor, size: 20.sp),
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
                          throw Exception();
                          }
                        },
                        child: SvgPicture.asset(ImageConstant.whatsappIcon,width: 30.w,)),
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
                color: _getStatusColor(
                    controller.lead.value!.leadStatus ?? 'Unknown'),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(6.r),
                  topRight: Radius.circular(6.r),
                ),
              ),
              child: Text(
                controller.lead.value!.leadStatus ?? 'Unknown',
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
      child: _buildTranscriptView(controller.lead.value!.transcript ?? 'N/A'),
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
            fontWeight: FontWeight.w500,
            color: ColorConstants.black,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          constraints: BoxConstraints(maxHeight: 400.h), // Changed from 300.h to 400.h
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: messages.isEmpty
                  ? [
                Text(
                  'No conversation available',
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorConstants.grey,
                  ),
                ),
              ]
                  : messages.map((message) {
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
                                  'User',
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
    if (transcript == 'N/A' || transcript.trim().isEmpty) return messages;

// Split the transcript into lines
    List<String> lines =
        transcript.split('\n').where((line) => line.trim().isNotEmpty).toList();

// Updated regex to handle both English (en) and Hindi (hi), with optional language tag
    final regex = RegExp(
      r'\[(.*?)\]\s*(User|AI)\s*(?:\((en|hi)\))?\s*:\s*(.*)',
      unicode: true, // Enable Unicode support for Hindi (Devanagari) characters
    );

    for (var line in lines) {
      final match = regex.firstMatch(line);
      if (match != null) {
        String timestampRaw = match.group(1)?.trim() ?? '';
        String sender = match.group(2)?.trim() ?? 'Unknown';
        String language = match.group(3)?.trim() ??
            'en'; // Default to English if no language tag
        String text = match.group(4)?.trim() ?? '';

// Skip empty or invalid messages
        if (text.isEmpty) continue;

        String formattedTimestamp = '';
        if (timestampRaw.isNotEmpty) {
          try {
// Try parsing the timestamp, assuming ISO 8601 or similar format
            DateTime dateTime = DateTime.parse(timestampRaw).toLocal();
            formattedTimestamp = DateFormat('hh:mm a').format(dateTime);
          } catch (e) {
// Fallback for invalid or unparseable timestamps
            formattedTimestamp =
                timestampRaw.isNotEmpty ? timestampRaw : 'Unknown time';
          }
        } else {
          formattedTimestamp = 'Unknown time';
        }

        messages.add({
          'sender': sender,
          'text': text,
          'timestamp': formattedTimestamp,
          'language': language, // Store language for potential use
        });
      } else {
// Handle malformed lines (e.g., append as plain text with unknown sender)
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
    if (duration == null || duration == 0) return '0 sec';
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    if (minutes == 0) return '$seconds sec';
    return '$minutes min $seconds sec';
  }
}
