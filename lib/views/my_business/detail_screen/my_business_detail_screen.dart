import 'package:aitota_business/core/app-export.dart';
import 'package:share_plus/share_plus.dart';
import 'controller/my_business_detail_controller.dart';

class MyBusinessDetailsScreen extends GetView<MyBusinessDetailsController> {
  const MyBusinessDetailsScreen({super.key});

  Widget _buildImagePlaceholder(bool isDark) {
    return Container(
      height: 250.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2C2C2E), const Color(0xFF1C1C1E)]
              : [const Color(0xFFF2F2F7), const Color(0xFFE5E5EA)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 60.sp,
          color: isDark ? Color(0xFF48484A) : Color(0xFFAEAEB2),
        ),
      ),
    );
  }

  void _handleShare(BuildContext context) {
    final textToShare = controller.businessItem['sharelink']?.isNotEmpty ?? false
        ? controller.businessItem['sharelink']
        : controller.businessItem['title'] ?? 'Untitled Business';
    try {
      Share.share(textToShare);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to share: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Business Details",
        titleStyle: TextStyle(
          fontFamily: AppFonts.poppins,
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
          color: isDark ? Colors.white : Colors.black87,
        ),
        showBackButton: true,
        onTapBack: () => Get.back(),
      ),
      body: Obx(
            () => controller.isLoading.value
            ? Center(
          child: CircularProgressIndicator(
            color: Colors.green.shade600,
            strokeWidth: 2,
          ),
        )
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image
              Hero(
                tag:
                'businessImage_${controller.businessItem['id'] ?? controller.businessItem['title']}',
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(16.r)),
                  child: CachedNetworkImage(
                    imageUrl: controller.businessItem['imageUrl'] ??
                        ImageConstant.onboarding1,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250.h,
                    placeholder: (context, url) =>
                        _buildImagePlaceholder(isDark),
                    errorWidget: (context, url, error) =>
                        _buildImagePlaceholder(isDark),
                  ),
                ),
              ),
              // Details Section
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Category
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            controller.businessItem['title'] ??
                                'Untitled Business',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white : Colors.black87,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: isDark ? Color(0xFF3A3A3C) : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            controller.businessItem['category'] ?? 'N/A',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.w500,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // Price Section
                    Row(
                      children: [
                        if (controller.businessItem['offerPrice'] != null) ...[
                          Text(
                            '₹${controller.businessItem['offerPrice'].toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.green.shade600,
                            ),
                          ),
                          SizedBox(width: 8.w),
                        ],
                        if (controller.businessItem['mrp'] != null)
                          Text(
                            '₹${controller.businessItem['mrp'].toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                              decoration: TextDecoration.lineThrough,
                              decorationColor:
                              isDark ? Colors.grey[400] : Colors.grey[600],
                              decorationThickness: 2.0,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // Description with See More / See Less
                    Obx(() {
                      final isExpanded = controller.isDescriptionExpanded.value;
                      final description = controller.businessItem['description'] ??
                          'No description available';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            description,
                            maxLines: isExpanded ? null : 3,
                            overflow: isExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontFamily: AppFonts.poppins,
                              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                              height: 1.5,
                            ),
                          ),
                          if (description.length > 100)
                            GestureDetector(
                              onTap: () => controller.isDescriptionExpanded.value =
                              !isExpanded,
                              child: Text(
                                isExpanded ? 'See Less' : 'See More',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: AppFonts.poppins,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green.shade600,
                                ),
                              ),
                            ),
                          SizedBox(height: 24.h),
                        ],
                      );
                    }),
                    // Links Section
                    Text(
                      'Links',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (controller.businessItem['sharelink']?.isNotEmpty ?? false)
                      _buildLinkCard(
                        context: context,
                        icon: Icons.share,
                        title: 'Share Link',
                        onTap: () => _handleShare(context),
                        isDark: isDark,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLinkCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF2C2C2E) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: Colors.green.shade600,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }
}
