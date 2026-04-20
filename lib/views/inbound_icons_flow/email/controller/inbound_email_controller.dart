import 'package:aitota_business/core/app-export.dart';

class InboundEmailController extends GetxController {
  final emails = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadEmails();
  }

  void loadEmails() {
    // Sample email data
    emails.addAll([
      {
        'sender': 'John Doe',
        'subject': 'Business Inquiry - Product Demo',
        'preview': 'Hi, I am interested in your business solution and would like to schedule a demo...',
        'time': '2:30 PM',
        'isRead': false,
        'hasAttachment': true,
        'body': 'Hi,\n\nI am interested in your business solution and would like to schedule a demo. Could you please provide more information about your pricing plans?\n\nBest regards,\nJohn Doe',
      },
      {
        'sender': 'Sarah Wilson',
        'subject': 'Follow-up on our conversation',
        'preview': 'Thank you for the call yesterday. As discussed, I am sending the requirements...',
        'time': '1:15 PM',
        'isRead': true,
        'hasAttachment': false,
        'body': 'Thank you for the call yesterday. As discussed, I am sending the requirements for our project. Please review and let me know if you need any clarification.\n\nRegards,\nSarah Wilson',
      },
      {
        'sender': 'Mike Johnson',
        'subject': 'Partnership Opportunity',
        'preview': 'We have an exciting partnership opportunity that might interest you...',
        'time': '11:45 AM',
        'isRead': false,
        'hasAttachment': true,
        'body': 'We have an exciting partnership opportunity that might interest you. Our company is looking for reliable partners in your region.\n\nLet\'s discuss this further.\n\nBest,\nMike Johnson',
      },
      {
        'sender': 'Emma Davis',
        'subject': 'Meeting Confirmation',
        'preview': 'This is to confirm our meeting scheduled for tomorrow at 3:00 PM...',
        'time': '10:20 AM',
        'isRead': true,
        'hasAttachment': false,
        'body': 'This is to confirm our meeting scheduled for tomorrow at 3:00 PM. Please let me know if you need to reschedule.\n\nThanks,\nEmma Davis',
      },
    ]);
  }

  Future<void> refreshEmails() async {
    await Future.delayed(const Duration(seconds: 1));
    // In real app, this would fetch fresh data from API
    Get.snackbar('Refreshed', 'Emails refreshed successfully');
  }

  void openEmail(int index) {
    // Mark as read
    emails[index]['isRead'] = true;
    emails.refresh();

    // Show email detail dialog
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Container(
          padding: EdgeInsets.all(20.w),
          constraints: BoxConstraints(maxHeight: Get.height * 0.7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      emails[index]['subject'],
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.black,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                'From: ${emails[index]['sender']}',
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 14.sp,
                  color: ColorConstants.grey,
                ),
              ),
              Text(
                'Time: ${emails[index]['time']}',
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 14.sp,
                  color: ColorConstants.grey,
                ),
              ),
              SizedBox(height: 16.h),
              Divider(color: ColorConstants.grey.withOpacity(0.3)),
              SizedBox(height: 16.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    emails[index]['body'],
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 14.sp,
                      color: ColorConstants.black,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => replyToEmail(index),
                    icon: const Icon(Icons.reply),
                    label: const Text('Reply'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.appThemeColor,
                      foregroundColor: ColorConstants.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => forwardEmail(index),
                    icon: const Icon(Icons.forward),
                    label: const Text('Forward'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.grey,
                      foregroundColor: ColorConstants.white,
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

  void composeEmail() {
    Get.snackbar('Compose Email', 'Opening email composer...');
    // Here you would open email composer or external email app
  }

  void replyToEmail(int index) {
    Get.back(); // Close dialog
    Get.snackbar('Reply', 'Replying to ${emails[index]['sender']}');
    // Here you would open reply composer
  }

  void forwardEmail(int index) {
    Get.back(); // Close dialog
    Get.snackbar('Forward', 'Forwarding email from ${emails[index]['sender']}');
    // Here you would open forward composer
  }
}