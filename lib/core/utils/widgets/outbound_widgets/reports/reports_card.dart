import 'package:aitota_business/core/app-export.dart';
import 'package:intl/intl.dart';
import '../../common_widgets/status_color_badge.dart';

class ReportCard extends StatelessWidget {
  final dynamic lead;
  final VoidCallback onTap;

  const ReportCard({super.key, required this.lead, required this.onTap});

  String _formatDuration(int? duration) {
    if (duration == null || duration == 0) return '0 min';
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    if (minutes == 0) return '$seconds sec';
    return '$minutes min${seconds > 0 ? ' $seconds sec' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(14.r), // Updated to match CustomContactCard
          border: Border.all(
            color: Colors.grey.shade200, // Updated to match CustomContactCard
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), // Updated to match CustomContactCard
              blurRadius: 6, // Updated to match CustomContactCard
              offset: const Offset(0, 2), // Updated to match CustomContactCard
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Mobile: ',
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorConstants.grey,
                        ),
                      ),
                      Text(
                        '${lead.mobile ?? 'Unknown'}',
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Date: ',
                            style: TextStyle(
                              fontFamily: AppFonts.poppins,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: ColorConstants.grey,
                            ),
                          ),
                          Text(
                            lead.time != null
                                ? '${DateFormat.jm().format(DateTime.parse(lead.time!))}, ${DateFormat('MMM dd, yyyy').format(DateTime.parse(lead.time!))}'
                                : 'Unknown',
                            style: TextStyle(
                              fontFamily: AppFonts.poppins,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorConstants.black,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16.sp,
                            color: ColorConstants.grey,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            _formatDuration(lead.duration),
                            style: TextStyle(
                              fontFamily: AppFonts.poppins,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorConstants.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: StatusBadge(status: lead.leadStatus ?? 'Unknown'),
            ),
          ],
        ),
      ),
    );
  }
}


class AiLeadsCard extends StatelessWidget {
  final dynamic lead;
  final VoidCallback onTap;

  const AiLeadsCard({super.key, required this.lead, required this.onTap});

  String _formatDuration(int? duration) {
    if (duration == null || duration <= 0) return '0 sec';
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    if (minutes == 0) return '$seconds sec';
    return '$minutes min${seconds > 0 ? ' $seconds sec' : ''}';
  }

  String _formatCallTime(String? timeString) {
    if (timeString == null || timeString.isEmpty || timeString == 'null') {
      return 'Unknown time';
    }

    try {
      String cleaned = timeString.replaceAll(RegExp(r'\s*\(.*?\)$'), '').trim();
      final parts = cleaned.split(' ');
      if (parts.length < 6) return 'Invalid date';

      final monthStr = parts[1];
      final day = parts[2].padLeft(2, '0');
      final year = parts[3];
      final time = parts[4];

      const months = {
        'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04',
        'May': '05', 'Jun': '06', 'Jul': '07', 'Aug': '08',
        'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12'
      };

      final month = months[monthStr] ?? '01';
      final formattedDate = '$day/$month/$year, $time';

      final inputFormat = DateFormat('dd/MM/yyyy, HH:mm:ss');
      final outputFormat = DateFormat('dd/MM/yyyy, hh:mm a');

      final dateTime = inputFormat.parse(formattedDate);
      return outputFormat.format(dateTime);
    } catch (e) {
      print('Error parsing time: $timeString, Error: $e');
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String displayTime = _formatCallTime(lead.time);
    final String durationText = _formatDuration(lead.duration);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name with Person Icon
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 16.sp, color: Colors.grey.shade600),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          lead.name?.toString().trim().isNotEmpty == true
                              ? lead.name.toString().trim()
                              : 'Unknown',
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: ColorConstants.blackText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Mobile Number with Phone Icon
                  Row(
                    children: [
                      Icon(Icons.phone_android, size: 16.sp, color: Colors.grey.shade600),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          lead.number ?? 'Unknown Number',
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

                  // Time + Duration Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time, size: 16.sp, color: Colors.grey.shade600),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          displayTime,
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: ColorConstants.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Duration (right side)
                      Text(
                        durationText,
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.appThemeColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Top-right Status Badge (safe & untouched)
            Positioned(
              top: 0,
              right: 0,
              child: StatusBadge(status: lead.leadStatus ?? 'Unknown'),
            ),
          ],
        ),
      ),
    );
  }
}