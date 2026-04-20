import '../../../../../core/app-export.dart';

import '../../../../../core/app-export.dart';

class CustomCampaignCard extends StatelessWidget {
  final String? name;
  final String? category;
  final String? description;
  final bool isDark;
  final Color categoryColor;

  const CustomCampaignCard({
    super.key,
    this.name,
    this.category,
    this.description,
    required this.isDark,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: Matrix4.identity()..scale(1.0),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.15 : 0.1),
            blurRadius: 12.r,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade200,
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  name ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.poppins,
                    color: isDark ? Colors.white : Colors.black,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: categoryColor.withOpacity(0.5),
                    width: 1.w,
                  ),
                ),
                child: Text(
                  category ?? 'Unknown', // Changed from 'N/A' to 'Unknown'
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.poppins,
                    color: categoryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            description ?? 'No description available',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              fontFamily: AppFonts.poppins,
              color: isDark ? const Color(0xFFAEAEB2) : const Color(0xFF636366),
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class CustomStatusBadge extends StatelessWidget {
  final String status;
  final bool isDark;

  const CustomStatusBadge({
    super.key,
    required this.status,
    required this.isDark,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green.shade600;
      case 'inactive':
        return Colors.red.shade600;
      case 'pending':
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 44.w,
          height: 44.h,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: statusColor.withOpacity(0.7),
              width: 1.5.w,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.1),
                blurRadius: 6.r,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.person,
            color: statusColor,
            size: 26.sp,
          ),
        ),
        Positioned(
          right: 2.w,
          bottom: 2.h,
          child: Container(
            width: 12.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? Colors.black : Colors.white,
                width: 1.5.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4.r,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomRemoveGroupDialog extends StatelessWidget {
  final String groupName;
  final String groupId;
  final VoidCallback onRemove;

  const CustomRemoveGroupDialog({
    super.key,
    required this.groupName,
    required this.groupId,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      backgroundColor: isDarkMode(context) ? const Color(0xFF2C2C2E) : Colors.white,
      title: Text(
        'Remove Group',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.poppins,
          color: isDarkMode(context) ? Colors.white : Colors.black,
        ),
      ),
      content: Text(
        'Are you sure you want to remove "$groupName"? This action cannot be undone.',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          fontFamily: AppFonts.poppins,
          color: isDarkMode(context) ? const Color(0xFFAEAEB2) : const Color(0xFF636366),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.poppins,
              color: isDarkMode(context) ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            onRemove();
          },
          child: Text(
            'Remove',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.poppins,
              color: Colors.red.shade600,
            ),
          ),
        ),
      ],
    );
  }

  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}