// core/utils/widgets/analytics_widgets/never_attended_calls_card.dart
import 'package:aitota_business/core/app-export.dart';

class NeverAttendedCallsCard extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String callCount;
  final String dateTime;

  const NeverAttendedCallsCard({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.callCount,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          // Contact Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  phoneNumber,
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Call Count + Date/Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: ColorConstants.appThemeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  callCount,
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.appThemeColor,
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                dateTime,
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 12.sp,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}