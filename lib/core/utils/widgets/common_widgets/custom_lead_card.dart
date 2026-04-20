import 'package:intl/intl.dart';
import 'package:aitota_business/core/app-export.dart';

class LeadCard extends StatelessWidget {
  final String? mobile;
  final String? time;
  final int? duration;
  final String? leadStatus;
  final String? contactName;
  final VoidCallback onTap;

  const LeadCard({
    super.key,
    this.mobile,
    this.time,
    this.duration,
    this.leadStatus,
    this.contactName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
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
              children: [
                // Contact Name Row – Shows "Unknown" if null/empty
                Row(
                  children: [
                    Icon(Icons.person, size: 16.sp, color: ColorConstants.grey),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        _getContactName(), // Smart logic
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Mobile Number Row
                Row(
                  children: [
                    Icon(Icons.phone, size: 16.sp, color: ColorConstants.grey),
                    SizedBox(width: 6.w),
                    Text(
                      mobile ?? 'N/A',
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorConstants.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                // Date + Time and Duration Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 14.sp, color: ColorConstants.grey),
                        SizedBox(width: 5.w),
                        Text(
                          time != null
                              ? DateFormat('dd-MMM-yyyy, hh:mm a')
                                  .format(DateTime.parse(time!))
                              : 'N/A',
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: ColorConstants.grey,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 14.sp, color: ColorConstants.grey),
                        SizedBox(width: 5.w),
                        Text(
                          _formatDuration(duration),
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: ColorConstants.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // Lead Status Badge
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(leadStatus ?? 'Unknown'),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(6.r),
                    topRight: Radius.circular(6.r),
                  ),
                ),
                child: Text(
                  leadStatus ?? 'N/A',
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Smart method: returns "Unknown" if name is missing
  String _getContactName() {
    if (contactName == null || contactName!.trim().isEmpty) {
      return 'Unknown';
    }
    return contactName!.trim();
  }

  // Status color logic
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'no_response':
        return Colors.red.shade400;
      case 'call_busy':
        return Colors.red.shade300;
      case 'not_reachable':
        return Colors.orange.shade600;
      case 'switched_off':
        return Colors.orange.shade700;
      case 'out_of_coverage':
        return Colors.orange.shade800;
      case 'call_disconnected':
        return Colors.grey.shade600;
      case 'call_later':
        return Colors.grey.shade500;
      case 'payment_pending':
        return Colors.redAccent;
      case 'document_pending':
        return Colors.deepOrange;
      case 'call_back_schedule':
        return Colors.orangeAccent;
      case 'information_shared':
        return Colors.amber;
      case 'follow_up_required':
        return Colors.yellow.shade700;
      case 'call_back_due':
        return Colors.blueAccent;
      case 'whatsapp_sent':
        return Colors.lightBlue;
      case 'interested_waiting_confimation':
        return Colors.cyan;
      case 'admission_confirmed':
        return Colors.green;
      case 'payment_recieved':
        return Colors.teal;
      case 'course_started':
        return Colors.greenAccent;
      case 'not_interested':
        return Colors.purple.shade400;
      case 'joined_another_institute':
        return Colors.purple.shade500;
      case 'dropped_the_plan':
        return Colors.purple.shade600;
      case 'dnd':
        return Colors.purple.shade700;
      case 'unqualified_lead':
        return Colors.purple.shade300;
      case 'wrong_number':
        return Colors.pink.shade400;
      case 'invalid_number':
        return Colors.pink.shade500;
      case 'postpone':
        return Colors.indigo.shade400;
      default:
        return ColorConstants.grey;
    }
  }

  // Duration Formatter
  String _formatDuration(int? duration) {
    if (duration == null || duration == 0) return '0 min';
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    if (minutes == 0) return '$seconds sec';
    return '$minutes min${seconds > 0 ? ' $seconds sec' : ''}';
  }
}