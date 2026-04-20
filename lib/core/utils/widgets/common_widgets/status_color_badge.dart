import 'package:aitota_business/core/app-export.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(6.r),
          topRight: Radius.circular(6.r),
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          color: ColorConstants.white,
        ),
      ),
    );
  }
}