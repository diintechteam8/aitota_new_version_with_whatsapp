import '../../../app-export.dart';

class CreditUsageCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onViewTranscript;

  const CreditUsageCard({
    super.key,
    required this.item,
    required this.onViewTranscript,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item['mobile'],
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.blackText,
                    ),
                  ),
                ),
                Text(
                  item['datetime'],
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorConstants.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _buildDetailRow('Credits Used', '${item['creditUsed']} credits'),
            SizedBox(height: 12.h),
            // Transcript preview
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: ColorConstants.greyBgs,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Text(
                      item['transcript'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: item['language'] == 'hi' ? 'NotoSansDevanagari' : AppFonts.poppins,
                        fontSize: 14.sp,
                        color: ColorConstants.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                GestureDetector(
                  onTap: onViewTranscript,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: ColorConstants.appThemeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.visibility,
                      color: ColorConstants.appThemeColor,
                      size: 20.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: ColorConstants.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: ColorConstants.blackText,
            ),
          ),
        ],
      ),
    );
  }
}
