import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/app-export.dart';
import '../../../core/utils/widgets/common_widgets/shimmer_loading.dart';
import '../controller/whatsapp_bulk_controller.dart';

class WhatsAppBulkLandingScreen extends GetView<WhatsAppBulkController> {
  const WhatsAppBulkLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorConstants.whatsappGradientDark,
                ColorConstants.whatsappGradientLight,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Bulk WhatsApp Hub',
          style: TextStyle(
            fontSize: 18.sp,
            fontFamily: AppFonts.playfair,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BaseShimmer(child: LandingStatsShimmer()),
                SizedBox(height: 24.h),
                ShimmerPlaceholder(width: 140.w, height: 20.h),
                SizedBox(height: 12.h),
                BaseShimmer(
                  child: Container(
                    height: 100.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    const Expanded(child: BaseShimmer(child: ActionCardShimmer())),
                    SizedBox(width: 12.w),
                    const Expanded(child: BaseShimmer(child: ActionCardShimmer())),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    const Expanded(child: BaseShimmer(child: ActionCardShimmer())),
                    SizedBox(width: 12.w),
                    const Expanded(child: BaseShimmer(child: ActionCardShimmer())),
                  ],
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchStats,
          color: ColorConstants.whatsappGradientDark,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsSection(),
                SizedBox(height: 24.h),
                _buildActionTitle("Campaign Actions"),
                SizedBox(height: 12.h),
                _buildMainActionButton(),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildSecondaryAction(
                        "Templates",
                        Icons.message_outlined,
                        Colors.orange,
                        controller.manageTemplates,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildSecondaryAction(
                        "Import Contacts",
                        Icons.contact_page_outlined,
                        Colors.blue,
                        controller.importContacts,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildSecondaryAction(
                        "Reports",
                        Icons.insights_outlined,
                        Colors.green,
                        controller.viewReports,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildSecondaryAction(
                        "Live Inbox",
                        Icons.chat_bubble_outline,
                        Colors.teal,
                        controller.openInbox,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                _buildActionTitle("Tips & Guidelines"),
                SizedBox(height: 12.h),
                _buildTipsCard(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem("Total Broadcasts", controller.totalBroadcasts.value.toString(), Icons.campaign_outlined, Colors.green),
              _verticalDivider(),
              _buildStatItem("Delivery rate", "${controller.deliveryRate.value}%", Icons.done_all, Colors.blue),
            ],
          ),
          Divider(height: 32.h, color: Colors.grey.shade100),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem("Read Rate", "${controller.readRate.value}%", Icons.remove_red_eye_outlined, Colors.purple),
              _verticalDivider(),
              _buildStatItem("Status", "Healthy", Icons.check_circle_outline, Colors.teal),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.w),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.poppins,
              color: Colors.black87,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey,
              fontFamily: AppFonts.poppins,
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 40.h,
      width: 1,
      color: Colors.grey.shade200,
    );
  }

  Widget _buildActionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        fontFamily: AppFonts.poppins,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildMainActionButton() {
    return InkWell(
      onTap: controller.viewCampaigns,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              ColorConstants.whatsappGradientDark,
              ColorConstants.whatsappGradientLight,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: ColorConstants.whatsappGradientDark.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: FaIcon(FontAwesomeIcons.paperPlane, color: Colors.white, size: 20),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Launch New Broadcast",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.poppins,
                    ),
                  ),
                  Text(
                    "Send Bulk WhatsApp Templates",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12.sp,
                      fontFamily: AppFonts.poppins,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryAction(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20.w),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.poppins,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: Colors.blue.shade700, size: 24),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              "Use official Meta templates to avoid number blocking. Personalize your messages for better engagement.",
              style: TextStyle(
                color: Colors.blue.shade900,
                fontSize: 12.sp,
                fontFamily: AppFonts.poppins,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
