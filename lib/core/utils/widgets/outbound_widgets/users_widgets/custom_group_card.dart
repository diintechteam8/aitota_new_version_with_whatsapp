import 'package:intl/intl.dart';
import '../../../../../core/app-export.dart';

class CustomGroupCard extends StatelessWidget {
  final Map<String, dynamic> group;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  /// Controls whether the Edit / Delete popup menu is visible.
  final bool showEditActions;

  const CustomGroupCard({
    super.key,
    required this.group,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.showEditActions = true,
  });

  @override
  Widget build(BuildContext context) {
    // Safely get the counts
    final int touched = group['touchedCount'] ?? 0;
    final int untouched = group['untouchedCount'] ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: ColorConstants.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: ColorConstants.grey.withOpacity(0.2),
              width: 1,
            ),
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
              // ----- Main content -------------------------------------------------
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Group name + Touched & Untouched (same row)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          group['name'] ?? 'Unnamed Group',
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Get.isDarkMode
                                ? ColorConstants.white
                                : ColorConstants.blackText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Touched & Untouched (right side, same row)
                      Row(
                        children: [
                          // Touched
                          Row(
                            children: [
                              Icon(Icons.touch_app_outlined,
                                  size: 16.sp, color: Colors.green.shade600),
                              SizedBox(width: 4.w),
                              Text(
                                '$touched',
                                style: TextStyle(
                                  fontFamily: AppFonts.poppins,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green.shade600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 12.w),

                          // Untouched
                          Row(
                            children: [
                              Icon(Icons.do_not_touch_outlined,
                                  size: 16.sp, color: Colors.orange.shade700),
                              SizedBox(width: 4.w),
                              Text(
                                '$untouched',
                                style: TextStyle(
                                  fontFamily: AppFonts.poppins,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // Contacts row (exactly as before)
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: ColorConstants.appThemeColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.group,
                          size: 16.sp,
                          color: ColorConstants.appThemeColor,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Contacts: ',
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${group['contactCount'] ?? 0}',
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: ColorConstants.appThemeColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // Description + created date (exactly as before)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          group['description'] != null &&
                                  group['description'].isNotEmpty
                              ? group['description']
                              : 'No description',
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: ColorConstants.grey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        group['createdAt'] != null
                            ? DateFormat('dd-MM-yyyy, hh:mm a').format(
                                DateTime.parse(group['createdAt']).toLocal())
                            : 'Unknown',
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

              // ----- Popup menu (exactly as before) -------------------------
              if (showEditActions)
                Positioned(
                  top: -8,
                  right: 0,
                  child: PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert,
                        color: Colors.grey.shade600, size: 20),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 8,
                    offset: const Offset(0, kToolbarHeight),
                    itemBuilder: (context) => [
                      _buildPopupMenuItem(
                        icon: Icons.edit,
                        label: 'Edit',
                        color: ColorConstants.whatsappGradientDark,
                      ),
                      _buildPopupMenuItem(
                        icon: Icons.delete,
                        label: 'Delete',
                        color: ColorConstants.whatsappGradientDark,
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return PopupMenuItem<String>(
      value: label.toLowerCase().replaceAll(' ', '_'),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontFamily: AppFonts.poppins,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}