import '../../../../../../core/app-export.dart';

class CustomAgentCard extends StatelessWidget {
  final String? title;
  final String? value;
  final String? status;
  final String? callingType;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const CustomAgentCard({
    super.key,
    required this.title,
    this.value,
    required this.status,
    this.callingType,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isInbound = callingType != null && (callingType!.toLowerCase().contains('inbound') || callingType!.toLowerCase() == 'both');
    final isOutbound = callingType != null && (callingType!.toLowerCase().contains('outbound') || callingType!.toLowerCase() == 'both');

    // Debug print to verify callingType and icon display logic
    print('CustomAgentCard: title=$title, callingType=$callingType, isInbound=$isInbound, isOutbound=$isOutbound');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 4.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 3,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1.w,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon
            Container(
              height: 50.w,
              width: 50.w,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 26.sp,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // Text section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Top row: Title + Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title ?? 'Unknown Agent',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.poppins,
                            color: ColorConstants.whatsappGradientDark, // Replaced appThemeColor
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (status != null && status!.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: status == 'Active' ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: status == 'Active' ? Colors.green : Colors.grey,
                            ),
                          ),
                          child: Text(
                            status!,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppFonts.poppins,
                              color: status == 'Active' ? Colors.green : Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (value != null && value!.isNotEmpty && value != 'N/A') ...[
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            value!,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: AppFonts.poppins,
                              color: Colors.grey[700],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isInbound || isOutbound) ...[
                          Row(
                            children: [
                              if (isInbound)
                                Padding(
                                  padding: EdgeInsets.only(right: isInbound && isOutbound ? 2.w : 0),
                                  child: Icon(
                                    Icons.call_received,
                                    size: 20.sp,
                                    color: Colors.green,
                                  ),
                                ),
                              if (isOutbound)
                                Icon(
                                  Icons.call_made,
                                  size: 20.sp,
                                  color: Colors.red,
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}