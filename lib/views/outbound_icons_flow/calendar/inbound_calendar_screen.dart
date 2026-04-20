import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/inbound_icons_flow/calendar/controller/inbound_calendar_controller.dart';

class InboundCalendarScreen extends GetView<InboundCalendarController> {
  const InboundCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Meetings",
        titleStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.poppins,
        ),
        showBackButton: true,
        onTapBack: () {
          Get.back();
        },
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: ColorConstants.appThemeColor),
            onPressed: controller.scheduleMeeting,
          ),
        ],
      ),
      body: Obx(() => RefreshIndicator(
        onRefresh: controller.refreshMeetings,
        child: controller.meetings.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          itemCount: controller.meetings.length,
          itemBuilder: (context, index) {
            final meeting = controller.meetings[index];
            return _buildMeetingCard(meeting, index);
          },
        ),
      )),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64.sp,
            color: ColorConstants.grey.withOpacity(0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            'No meetings scheduled',
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: ColorConstants.grey,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your scheduled meetings will appear here',
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14.sp,
              color: ColorConstants.grey.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingCard(Map<String, dynamic> meeting, int index) {
    final isUpcoming = meeting['status'] == 'upcoming';
    final isLive = meeting['status'] == 'live';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isLive
              ? Colors.green.withOpacity(0.5)
              : isUpcoming
              ? ColorConstants.appThemeColor.withOpacity(0.3)
              : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => controller.openMeeting(index),
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(meeting['status']),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    meeting['status'].toString().toUpperCase(),
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.white,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.video_call,
                  color: ColorConstants.appThemeColor,
                  size: 20.sp,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              meeting['topic'],
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: ColorConstants.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16.sp,
                  color: ColorConstants.grey,
                ),
                SizedBox(width: 6.w),
                Text(
                  '${meeting['date']} at ${meeting['time']}',
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 13.sp,
                    color: ColorConstants.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16.sp,
                  color: ColorConstants.grey,
                ),
                SizedBox(width: 6.w),
                Text(
                  'Duration: ${meeting['duration']}',
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 13.sp,
                    color: ColorConstants.grey,
                  ),
                ),
              ],
            ),
            if (meeting['participants'] != null) ...[
              SizedBox(height: 6.h),
              Row(
                children: [
                  Icon(
                    Icons.people,
                    size: 16.sp,
                    color: ColorConstants.grey,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Participants: ${meeting['participants']}',
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 13.sp,
                      color: ColorConstants.grey,
                    ),
                  ),
                ],
              ),
            ],
            if (meeting['joinLink'] != null) ...[
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: ColorConstants.appThemeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.link,
                      color: ColorConstants.appThemeColor,
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Join Link Available',
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 12.sp,
                          color: ColorConstants.appThemeColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (isLive || isUpcoming)
                      GestureDetector(
                        onTap: () => controller.joinMeeting(meeting['joinLink']),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: isLive ? Colors.green : ColorConstants.appThemeColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            isLive ? 'JOIN NOW' : 'JOIN',
                            style: TextStyle(
                              fontFamily: AppFonts.poppins,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorConstants.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'live':
        return Colors.green;
      case 'upcoming':
        return ColorConstants.appThemeColor;
      case 'completed':
        return ColorConstants.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return ColorConstants.grey;
    }
  }
}


