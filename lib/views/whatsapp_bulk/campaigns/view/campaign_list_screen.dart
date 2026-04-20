import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../core/app-export.dart';
import '../../../../../core/utils/widgets/common_widgets/shimmer_loading.dart';
import '../controller/campaign_list_controller.dart';
import '../../../../../data/model/whatsapp_bulk/whats_ai_campaign_model.dart';

class CampaignListScreen extends GetView<CampaignListController> {
  const CampaignListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: AppBar(
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'My Campaigns',
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
        if (controller.isLoading.value && controller.campaigns.isEmpty) {
          return _buildShimmerList();
        }

        if (controller.errorMessage.isNotEmpty && controller.campaigns.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 48.w),
                SizedBox(height: 16.h),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: controller.fetchCampaigns,
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        if (controller.campaigns.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.campaign_outlined, color: Colors.grey.shade400, size: 64.w),
                SizedBox(height: 16.h),
                Text(
                  "No campaigns found",
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Launch your first broadcast now!",
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchCampaigns,
          color: ColorConstants.whatsappGradientDark,
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.campaigns.length,
            itemBuilder: (context, index) {
              final campaign = controller.campaigns[index];
              return _buildCampaignCard(campaign);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.createNewCampaign,
        backgroundColor: ColorConstants.whatsappGradientDark,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildCampaignCard(WhatsAiCampaign campaign) {
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.info_outline;

    switch (campaign.status?.toLowerCase()) {
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'failed':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      case 'processing':
        statusColor = Colors.blue;
        statusIcon = Icons.sync;
        break;
      case 'scheduled':
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        break;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Future: Navigate to campaign details
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        campaign.name ?? "Unnamed Campaign",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, color: statusColor, size: 14.w),
                          SizedBox(width: 4.w),
                          Text(
                            (campaign.status ?? "Unknown").toUpperCase(),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatMini("Sent", campaign.sent?.toString() ?? "0", Colors.blue),
                    _buildStatMini("Delivered", campaign.delivered?.toString() ?? "0", Colors.green),
                    _buildStatMini("Read", campaign.read?.toString() ?? "0", Colors.purple),
                    _buildStatMini("Failed", campaign.failed?.toString() ?? "0", Colors.red),
                  ],
                ),
                SizedBox(height: 12.h),
                Divider(color: Colors.grey.shade100),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Created: ${campaign.createdAt != null ? DateFormat('dd MMM, yyyy HH:mm').format(DateTime.parse(campaign.createdAt!)) : 'N/A'}",
                      style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                    ),
                    Text(
                      "Total: ${campaign.totalContacts ?? 0}",
                      style: TextStyle(fontSize: 10.sp, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (campaign.lastError != null && campaign.lastError!.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Text(
                    "Error: ${campaign.lastError}",
                    style: TextStyle(fontSize: 10.sp, color: Colors.red.shade700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatMini(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BaseShimmer(child: ShimmerPlaceholder(width: 150.w, height: 20.h)),
                  BaseShimmer(child: ShimmerPlaceholder(width: 80.w, height: 20.h)),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) => BaseShimmer(child: ShimmerPlaceholder(width: 60.w, height: 30.h))),
              ),
            ],
          ),
        );
      },
    );
  }
}
