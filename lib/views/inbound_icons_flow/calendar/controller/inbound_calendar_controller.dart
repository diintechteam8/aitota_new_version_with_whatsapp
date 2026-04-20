import 'package:aitota_business/core/app-export.dart';
import 'package:url_launcher/url_launcher.dart';

class InboundCalendarController extends GetxController {
  final meetings = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMeetings();
  }

  void loadMeetings() {
    // Sample meeting data
    meetings.addAll([
      {
        'topic': 'Product Demo - AITota Business Solutions',
        'date': 'Today',
        'time': '3:30 PM',
        'duration': '45 minutes',
        'status': 'live',
        'participants': '5 people',
        'joinLink': 'https://meet.google.com/abc-defg-hij',
        'description': 'Demonstration of our AI-powered business communication platform for potential clients.',
      },
      {
        'topic': 'Weekly Team Standup',
        'date': 'Tomorrow',
        'time': '10:00 AM',
        'duration': '30 minutes',
        'status': 'upcoming',
        'participants': '8 people',
        'joinLink': 'https://zoom.us/j/123456789',
        'description': 'Weekly team sync to discuss progress and upcoming tasks.',
      },
      {
        'topic': 'Client Onboarding Session',
        'date': 'Dec 28',
        'time': '2:00 PM',
        'duration': '1 hour',
        'status': 'upcoming',
        'participants': '3 people',
        'joinLink': 'https://teams.microsoft.com/l/meetup-join/xyz',
        'description': 'Onboarding session for new client - TechCorp Solutions.',
      },
      {
        'topic': 'Sales Review Meeting',
        'date': 'Dec 26',
        'time': '4:00 PM',
        'duration': '1 hour',
        'status': 'completed',
        'participants': '6 people',
        'joinLink': null,
        'description': 'Monthly sales performance review and planning for next quarter.',
      },
      {
        'topic': 'Partnership Discussion',
        'date': 'Dec 25',
        'time': '11:00 AM',
        'duration': '45 minutes',
        'status': 'cancelled',
        'participants': '4 people',
        'joinLink': null,
        'description': 'Discussion about potential partnership opportunities with regional distributors.',
      },
    ]);
  }

  Future<void> refreshMeetings() async {
    await Future.delayed(const Duration(seconds: 1));
    // In real app, this would fetch fresh data from API
    Get.snackbar('Refreshed', 'Meetings refreshed successfully');
  }

  void openMeeting(int index) {
    final meeting = meetings[index];

    // Show meeting detail dialog
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Container(
          padding: EdgeInsets.all(20.w),
          constraints: BoxConstraints(maxHeight: Get.height * 0.8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      meeting['topic'],
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
              SizedBox(height: 16.h),
              _buildDetailRow(Icons.access_time, 'Date & Time', '${meeting['date']} at ${meeting['time']}'),
              _buildDetailRow(Icons.schedule, 'Duration', meeting['duration']),
              if (meeting['participants'] != null)
                _buildDetailRow(Icons.people, 'Participants', meeting['participants']),
              _buildDetailRow(Icons.info_outline, 'Status', meeting['status'].toString().toUpperCase()),
              SizedBox(height: 16.h),
              if (meeting['description'] != null) ...[
                Text(
                  'Description:',
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.black,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  meeting['description'],
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 13.sp,
                    color: ColorConstants.grey,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 16.h),
              ],
              if (meeting['joinLink'] != null) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: ColorConstants.appThemeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Meeting Link:',
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.appThemeColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        meeting['joinLink'],
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 11.sp,
                          color: ColorConstants.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (meeting['joinLink'] != null &&
                      (meeting['status'] == 'live' || meeting['status'] == 'upcoming'))
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => joinMeeting(meeting['joinLink']),
                        icon: const Icon(Icons.video_call),
                        label: Text(meeting['status'] == 'live' ? 'JOIN NOW' : 'JOIN'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: meeting['status'] == 'live'
                              ? Colors.green
                              : ColorConstants.appThemeColor,
                          foregroundColor: ColorConstants.white,
                        ),
                      ),
                    ),
                  if (meeting['joinLink'] != null &&
                      (meeting['status'] == 'live' || meeting['status'] == 'upcoming'))
                    SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => copyMeetingLink(meeting['joinLink']),
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy Link'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.grey,
                        foregroundColor: ColorConstants.white,
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16.sp,
            color: ColorConstants.grey,
          ),
          SizedBox(width: 8.w),
          Text(
            '$label: ',
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: ColorConstants.black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 13.sp,
                color: ColorConstants.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void scheduleMeeting() {
    Get.snackbar('Schedule Meeting', 'Opening meeting scheduler...');
    // Here you would open meeting scheduler or external calendar app
  }

  Future<void> joinMeeting(String? joinLink) async {
    if (joinLink != null && joinLink.isNotEmpty) {
      try {
        final Uri url = Uri.parse(joinLink);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          Get.snackbar('Error', 'Could not launch meeting link');
        }
      } catch (e) {
        Get.snackbar('Error', 'Invalid meeting link');
      }
    } else {
      Get.snackbar('Error', 'No meeting link available');
    }
  }

  void copyMeetingLink(String? joinLink) {
    if (joinLink != null && joinLink.isNotEmpty) {
      // Copy to clipboard functionality would go here
      Get.snackbar('Copied', 'Meeting link copied to clipboard');
    } else {
      Get.snackbar('Error', 'No meeting link to copy');
    }
  }
}


