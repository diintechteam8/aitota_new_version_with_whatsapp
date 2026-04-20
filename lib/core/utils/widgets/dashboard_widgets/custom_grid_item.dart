import '../../../app-export.dart';

class CustomGridItem extends StatelessWidget {
  final String title;
  final String? value; // Optional value for stat cards
  final IconData icon;
  final VoidCallback? onTap; // Optional tap callback
  final Color iconColor;

  const CustomGridItem({
    super.key,
    required this.title,
    this.value, // Nullable for cases where only title is needed
    required this.icon,
    this.onTap, // Nullable for cases where tap is not needed
    this.iconColor = ColorConstants.appThemeColor, // Default color
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: ColorConstants.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(8.w), // Matches _buildStatCard padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: value != null ? 15.sp : 20.sp, // Smaller icon for stat cards
                color: iconColor,
              ),
              SizedBox(height: 8.h),
              if (value != null) ...[
                Text(
                  value!,
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.appThemeColor,
                  ),
                ),
                SizedBox(height: 4.h),
              ],
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: value != null ? 10.sp : 14.sp, // Smaller font for stat cards
                  fontWeight: value != null ? FontWeight.w600 : FontWeight.w500,
                  color: ColorConstants.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class LeadsCustomGridItem extends StatelessWidget {
  final String title;
  final String? value;
  final IconData icon;
  final VoidCallback? onTap;
  final Color iconColor;

  const LeadsCustomGridItem({
    super.key,
    required this.title,
    this.value,
    required this.icon,
    this.onTap,
    this.iconColor = ColorConstants.appThemeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: ColorConstants.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row with Icon on left and Value on right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    size: 22.sp,
                    color: iconColor,
                  ),
                  if (value != null)
                    Padding(
                      padding:  EdgeInsets.only(right: 16.w),
                      child: Text(
                        value!,
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.appThemeColor,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              // Title full width below
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}