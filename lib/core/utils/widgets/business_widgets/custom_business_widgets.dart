import 'package:aitota_business/core/app-export.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';

class ModernBusinessCard extends StatelessWidget {
  final String title;
  final String category;
  final String image;
  final String sharelink;
  final int? mrp;
  final int? offerPrice;
  final VoidCallback? onViewDetails;
  final VoidCallback? onUpdate;
  final VoidCallback? onDelete;

  const ModernBusinessCard({
    super.key,
    required this.title,
    required this.category,
    required this.image,
    required this.sharelink,
    this.mrp,
    this.offerPrice,
    this.onViewDetails,
    this.onUpdate,
    this.onDelete,
  });

  String _getSafeImageUrl(String url) {
    if (url.isEmpty) return ImageConstant.onboarding1;

    try {
      final uri = Uri.tryParse(url);
      if (uri == null || (!uri.isAbsolute && !uri.hasScheme)) {
        return ImageConstant.onboarding1;
      }

      if (uri.scheme == 'data') {
        final parts = url.split(',');
        if (parts.length != 2 || !parts[0].startsWith('data:image/')) {
          return ImageConstant.onboarding1;
        }
        try {
          base64Decode(parts[1].substring(0, parts[1].length.clamp(0, 100)));
        } catch (e) {
          print('Invalid base64 data: $e');
          return ImageConstant.onboarding1;
        }
        return url;
      }

      final path = uri.path.toLowerCase();
      if (path.endsWith('.avif')) {
        final newPath =
            path.replaceFirst(RegExp(r'\.avif$', caseSensitive: false), '.png');
        return uri.replace(path: newPath).toString();
      }

      return url;
    } catch (e) {
      print('Error parsing image URL: $url, error: $e');
      return ImageConstant.onboarding1;
    }
  }

  Widget _buildImagePlaceholder(bool isDark) {
    return Container(
      height: 160.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Color(0xFF2C2C2E), Color(0xFF1C1C1E)]
              : [Color(0xFFF2F2F7), Color(0xFFE5E5EA)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 40.sp,
          color: isDark ? Color(0xFF48484A) : Color(0xFFAEAEB2),
        ),
      ),
    );
  }

  void _handleShare(BuildContext context) {
    final textToShare = sharelink.isNotEmpty ? sharelink : title;
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
    final safeImageUrl = _getSafeImageUrl(image);

    return InkWell(
      onTap: onViewDetails,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF2C2C2E) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark ? Color(0xFF3A3A3C) : Color(0xFFE5E5EA), // Light grey border
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 12.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  child: CachedNetworkImage(
                    imageUrl: safeImageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 160.h,
                    placeholder: (context, url) => _buildImagePlaceholder(isDark),
                    errorWidget: (context, url, error) => _buildImagePlaceholder(isDark),
                  ),
                ),
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Material(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
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
                            'Edit Business',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text(
                            'Delete Business',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Icon(
                          Icons.more_vert,
                          size: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white : Colors.black,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: isDark ? const Color(0xFFAEAEB2) : const Color(0xFF636366),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (offerPrice != null) ...[
                              Text(
                                '₹${offerPrice!.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green.shade600,
                                ),
                              ),
                              SizedBox(width: 8.w),
                            ],
                            if (mrp != null)
                              Text(
                                '₹${mrp!.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: isDark ? Colors.grey[400] : Colors.grey[600],
                                  decorationThickness: 2.0,
                                ),
                              ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => _handleShare(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: isDark ? Color(0xFF3A3A3C) : Color(0xFFF2F2F7),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Share',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green.shade600,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Icon(
                                  Icons.share_outlined,
                                  size: 16.sp,
                                  color: Colors.green.shade600,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}