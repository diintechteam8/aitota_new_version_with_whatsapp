import '../app-export.dart';

void customSnackBar({
  required String message,
  String type = 'I', // I = Info, S = Success, E = Error
  SnackPosition position = SnackPosition.TOP,
  VoidCallback? onTap,
}) {
  Color backgroundColor = ColorConstants.white; // Always white background
  Color textAndIconColor =
      ColorConstants.appThemeColor; // Theme color for text & icon
  IconData icon;

  // Choose icon based on type
  switch (type) {
    case 'S':
      icon = Icons.check_circle;
      break;
    case 'E':
      icon = Icons.error;
      break;
    case 'I':
    default:
      icon = Icons.info_outline;
  }

  Get.snackbar(
    '',
    '',
    titleText: const SizedBox.shrink(),
    messageText: GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(
            icon,
            color: textAndIconColor,
            size: 20.sp,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textAndIconColor,
                fontFamily: AppFonts.poppins,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
    snackPosition: position,
    backgroundColor: backgroundColor,
    borderRadius: 12.r,
    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    duration: const Duration(seconds: 3),
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
    borderColor: textAndIconColor.withOpacity(0.3),
    borderWidth: 1,
  );
}
