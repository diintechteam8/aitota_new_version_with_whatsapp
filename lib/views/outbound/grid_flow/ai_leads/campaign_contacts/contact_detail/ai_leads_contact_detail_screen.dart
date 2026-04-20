import 'package:aitota_business/core/app-export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../../../data/model/outbound/ai_leads/ai_leads_campaign_contacts_model.dart';
import 'controller/ai_leads_contact_detail_controller.dart';

// ADD THIS EXTENSION (Fixes toCapitalized error)
extension StringExtension on String {
  String toCapitalized() {
    if (isEmpty) return this;
    return split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}

class MyAiLeadsContactDetailScreen extends GetView<AiLeadsContactDetailController> {
  const MyAiLeadsContactDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lead = Get.arguments?['lead'] as AiLeadsCampaignContactsData?;

    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Contact Details",
        titleStyle: TextStyle(
          fontFamily: AppFonts.poppins,
          fontWeight: FontWeight.w500,
          color: ColorConstants.white,
          fontSize: 16.sp,
        ),
        showBackButton: true,
        onTapBack: Get.back,
      ),
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final transcript = controller.conversation.value?.transcript;
        final hasTranscript = transcript?.isNotEmpty == true;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            children: [
              // Lead Info
              if (lead != null)
                _buildLeadCard(lead)
              else
                _buildEmptyCard("No contact information available"),

              SizedBox(height: 16.h),

              // Conversation Section
              if (isLoading)
                _buildLoadingCard()
              else if (hasTranscript)
                _buildConversationCard(transcript!)
              else
                _buildEmptyCard("No conversation available"),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          Icon(Icons.sentiment_neutral, size: 50.sp, color: Colors.grey.shade400),
          SizedBox(height: 12.h),
          Text(message, style: TextStyle(fontSize: 15.sp, color: ColorConstants.grey, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          CircularProgressIndicator(color: ColorConstants.appThemeColor),
          SizedBox(height: 16.h),
          Text("Loading conversation...", style: TextStyle(color: ColorConstants.grey, fontSize: 14.sp)),
        ],
      ),
    );
  }

Widget _buildLeadCard(AiLeadsCampaignContactsData lead) {
    final mobile = lead.number ?? "N/A";
    final time = _formatDate(lead.time); // Fixed function
    final duration = _formatDuration(lead.duration);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow("Name", lead.name ?? "Unknown"),
              _infoRow("Mobile", mobile),
              // _infoRow("Date", time),
              Row(
                children: [
                  Expanded(child: _infoRow("Duration", duration)),
                  if (mobile != "N/A") ...[
                    IconButton(
                      icon: Icon(Icons.phone, color: ColorConstants.appThemeColor),
                      onPressed: () => FlutterPhoneDirectCaller.callNumber(mobile),
                    ),
                    GestureDetector(
                      onTap: () => _openWhatsApp(mobile),
                      child: SvgPicture.asset(ImageConstant.whatsappIcon, width: 32.w),
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
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: _statusColor(lead.leadStatus),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.r),
                  bottomLeft: Radius.circular(8.r),
                ),
              ),
              child: Text(
                (lead.leadStatus ?? "unknown").replaceAll("_", " ").toCapitalized(),
                style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h), // Slightly tighter
    child: RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 14.sp, height: 1.4),
        children: [
          TextSpan(
            text: "$label:  ",
            style: TextStyle(
              color: ColorConstants.lightTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: ColorConstants.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildConversationCard(String transcript) {
    final messages = _parseTranscript(transcript);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Conversation", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          messages.isEmpty
              ? Text("No messages found", style: TextStyle(color: ColorConstants.grey))
              : Column(children: messages.map(_buildBubble).toList()),
        ],
      ),
    );
  }

  Widget _buildBubble(Map<String, String> msg) {
    final isUser = msg['sender'] == 'User';
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (msg['timestamp']?.isNotEmpty == true)
            Text(msg['timestamp']!, style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600)),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isUser)
                CircleAvatar(radius: 14.r, backgroundColor: Colors.grey.shade300, child: Text("AI", style: TextStyle(fontSize: 10.sp))),
              SizedBox(width: 8.w),
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: isUser ? ColorConstants.appThemeColor.withOpacity(0.12) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(msg['text'] ?? "", style: TextStyle(fontSize: 14.sp)),
                ),
              ),
              if (isUser) SizedBox(width: 8.w),
              if (isUser)
                CircleAvatar(radius: 14.r, backgroundColor: ColorConstants.appThemeColor.withOpacity(0.2), child: Text("You", style: TextStyle(fontSize: 10.sp))),
            ],
          ),
        ],
      ),
    );
  }

  void _openWhatsApp(String phone) async {
    final url = "whatsapp://send?phone=$phone";
    if (await canLaunchUrl(Uri.parse(url))) await launchUrl(Uri.parse(url));
  }

  Color _statusColor(String? status) {
    switch ((status ?? "").toLowerCase()) {
      case 'very interested':
      case 'v interested':
        return Colors.red;
      case 'maybe':
        return Colors.orange;
      case 'enrolled':
        return Colors.green;
      case 'not_connected':
        return Colors.grey;
      default:
        return ColorConstants.appThemeColor;
    }
  }

// SUPER ROBUST DATE FORMATTER – Handles all real-world cases
  String _formatDate(String? rawTime) {
    if (rawTime == null || rawTime.trim().isEmpty || rawTime.trim() == "null") {
      return "Unknown date";
    }

    String time = rawTime.trim();

    DateTime? parsed;

    // 1. Direct parse (ISO 8601 with Z or offset)
    try {
      parsed = DateTime.parse(time).toLocal();
    } catch (_) {}

    // 2. Clean common issues
    if (parsed == null) {
      try {
        // Remove milliseconds
        if (time.contains('.')) {
          time = time.replaceAll(RegExp(r'\.\d+'), '');
        }
        // Replace space with T if needed
        if (!time.contains('T') && time.contains(' ')) {
          time = time.replaceFirst(' ', 'T');
        }
        // Add Z if no timezone
        if (!time.contains(RegExp(r'[Z+]-]'))) {
          time += 'Z';
        }
        parsed = DateTime.parse(time).toLocal();
      } catch (_) {}
    }

    // 3. Try multiple patterns with DateFormat
    if (parsed == null) {
      final patterns = [
        "yyyy-MM-dd'T'HH:mm:ss'Z'",
        "yyyy-MM-dd'T'HH:mm:ss",
        "yyyy-MM-dd HH:mm:ss",
        "yyyy-MM-dd",
        "dd-MM-yyyy HH:mm:ss",
      ];
      for (final pattern in patterns) {
        try {
          final formatter = DateFormat(pattern);
          final temp = formatter.tryParse(time);
          if (temp != null) {
            parsed = temp.toLocal();
            break;
          }
        } catch (_) {}
      }
    }

    if (parsed == null) {
      return "Invalid date";
    }

    // Optional: Show "Today", "Yesterday"
    final today = DateTime.now();
    final yesterday = today.subtract(Duration(days: 1));
    final dateOnly = DateTime(parsed.year, parsed.month, parsed.day);

    if (dateOnly == DateTime(today.year, today.month, today.day)) {
      return "Today • ${DateFormat('hh:mm a').format(parsed)}";
    } else if (dateOnly == DateTime(yesterday.year, yesterday.month, yesterday.day)) {
      return "Yesterday • ${DateFormat('hh:mm a').format(parsed)}";
    }

    return DateFormat('MMM dd, yyyy • hh:mm a').format(parsed);
  }

  String _formatDuration(int? seconds) {
    if (seconds == null || seconds <= 0) return "0 sec";
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return m > 0 ? "$m min $s sec" : "$s sec";
  }

  List<Map<String, String>> _parseTranscript(String transcript) {
    final messages = <Map<String, String>>[];
    final lines = transcript.split('\n');
    final regex = RegExp(r'\[(.*?)\]\s*(User|AI).*?:\s*(.*)');

    for (var line in lines) {
      final match = regex.firstMatch(line);
      if (match != null) {
        final timeStr = match.group(1)!;
        final sender = match.group(2)!;
        final text = match.group(3)!.trim();
        String time = "";
        try {
          time = DateFormat('hh:mm a').format(DateTime.parse(timeStr).toLocal());
        } catch (_) {}
        messages.add({'sender': sender, 'text': text, 'timestamp': time});
      }
    }
    return messages;
  }
}