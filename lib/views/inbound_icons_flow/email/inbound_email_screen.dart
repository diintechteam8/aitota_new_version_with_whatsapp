import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/inbound_icons_flow/email/controller/inbound_email_controller.dart';

class InboundEmailScreen extends GetView<InboundEmailController> {
  const InboundEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Email",
        titleStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.poppins,
        ),
        showBackButton: true,
        onTapBack: () {
          Get.back();
        },
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: ColorConstants.appThemeColor),
            onPressed: controller.composeEmail,
          ),
        ],
      ),
      body: Obx(() => RefreshIndicator(
        onRefresh: controller.refreshEmails,
        child: controller.emails.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          itemCount: controller.emails.length,
          itemBuilder: (context, index) {
            final email = controller.emails[index];
            return _buildEmailCard(email, index);
          },
        ),
      )),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.email_outlined,
            size: 64.sp,
            color: ColorConstants.grey.withOpacity(0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            'No emails found',
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: ColorConstants.grey,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your email conversations will appear here',
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14.sp,
              color: ColorConstants.grey.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmailCard(Map<String, dynamic> email, int index) {
    final isRead = email['isRead'] as bool;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isRead ? Colors.transparent : ColorConstants.appThemeColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => controller.openEmail(index),
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: ColorConstants.appThemeColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      email['sender'].toString().substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.appThemeColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              email['sender'],
                              style: TextStyle(
                                fontFamily: AppFonts.poppins,
                                fontSize: 14.sp,
                                fontWeight: isRead ? FontWeight.w400 : FontWeight.w600,
                                color: ColorConstants.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            email['time'],
                            style: TextStyle(
                              fontFamily: AppFonts.poppins,
                              fontSize: 12.sp,
                              color: ColorConstants.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        email['subject'],
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 13.sp,
                          fontWeight: isRead ? FontWeight.w400 : FontWeight.w500,
                          color: ColorConstants.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (!isRead)
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: ColorConstants.appThemeColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              email['preview'],
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 12.sp,
                color: ColorConstants.grey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (email['hasAttachment'] == true) ...[
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    Icons.attach_file,
                    size: 16.sp,
                    color: ColorConstants.grey,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Attachment',
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 11.sp,
                      color: ColorConstants.grey,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}