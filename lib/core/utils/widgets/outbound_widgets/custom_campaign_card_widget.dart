import 'package:aitota_business/core/app-export.dart';

import 'package:intl/intl.dart'; // Yeh add karna mat bhoolna top pe!

class CustomOutboundCampaignCardWidget extends StatelessWidget {
  final String name;
  final String description;
  final String? category;
  final String? id;
  final String? lastAssignedAt; // New field added
  final bool showVerts;
  final VoidCallback? onViewDetails;
  final VoidCallback? onUpdate;
  final VoidCallback? onDelete;

  const CustomOutboundCampaignCardWidget({
    super.key,
    required this.name,
    required this.description,
    this.category,
    this.id,
    this.lastAssignedAt, // Add this
    this.showVerts = true,
    this.onViewDetails,
    this.onUpdate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Format lastAssignedAt safely
    String formattedDate = 'Never assigned';
    if (lastAssignedAt != null && lastAssignedAt!.isNotEmpty) {
      try {
        final date = DateTime.parse(lastAssignedAt!).toLocal();
        formattedDate = DateFormat('dd-MM-yyyy, hh:mm a').format(date);
      } catch (e) {
        formattedDate = 'Invalid date';
      }
    }

    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w),
      child: GestureDetector(
        onTap: onViewDetails,
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
                  // Campaign Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          name,
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
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // Category Row
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: ColorConstants.appThemeColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.campaign_outlined,
                          size: 16.sp,
                          color: ColorConstants.appThemeColor,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          category ?? 'No category',
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Description + Last Assigned Date (Same layout as GroupCard)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          description,
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
                      Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: Text(
                          formattedDate,
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 11.sp, // Thoda chhota rakha taaki fit ho jaye
                            fontWeight: FontWeight.w400,
                            color: ColorConstants.grey,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // More vert menu (conditional)
              if (showVerts)
                Positioned(
                  top: 0,
                  right: 0,
                  child: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit' && onUpdate != null) {
                        onUpdate!();
                      } else if (value == 'delete' && onDelete != null) {
                        onDelete!();
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Text(
                          'Edit Campaign',
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Text(
                          'Delete Campaign',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.red.shade600,
                          ),
                        ),
                      ),
                    ],
                    child: Padding(
                      padding: EdgeInsets.all(6.w),
                      child: Icon(
                        Icons.more_vert,
                        size: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}