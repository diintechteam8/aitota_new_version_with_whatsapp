import '../../../app-export.dart';

class PaymentHistoryCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onViewInvoice;

  const PaymentHistoryCard({
    super.key,
    required this.item,
    required this.onViewInvoice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey[100]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['date'],
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.appThemeColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item['orderId'],
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorConstants.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: ColorConstants.successGradient1.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: ColorConstants.successGradient1.withOpacity(0.4),
                    ),
                  ),
                  child: Text(
                    item['status'],
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.successGradient1,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Order details
            _buildDetailRow('Transaction ID', item['transId']),
            _buildDetailRow('Amount', item['amount'], isBoldValue: true),
            _buildDetailRow('Credits', item['credits']),
            SizedBox(height: 12.h),
            // View Invoice button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onViewInvoice,
                style: TextButton.styleFrom(
                  backgroundColor: ColorConstants.appThemeColor.withOpacity(0.1),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'View Invoice',
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.appThemeColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBoldValue = false}) {
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
              fontWeight: isBoldValue ? FontWeight.w600 : FontWeight.w500,
              color: ColorConstants.blackText,
            ),
          ),
        ],
      ),
    );
  }
}
