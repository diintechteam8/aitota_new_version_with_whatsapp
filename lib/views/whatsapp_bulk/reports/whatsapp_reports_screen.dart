import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/app-export.dart';
import 'controller/whatsapp_reports_controller.dart';

class WhatsAppReportsScreen extends GetView<WhatsAppReportsController> {
  const WhatsAppReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration:  BoxDecoration(
            gradient: ColorConstants.whatsappGradient,
          ),
        ),
        title: Text(
          'Campaign Reports',
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
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: controller.refreshReports,
          child: ListView.builder(
            padding: EdgeInsets.all(20.w),
            itemCount: controller.campaigns.length,
            itemBuilder: (context, index) {
              final campaign = controller.campaigns[index];
              return _buildCampaignCard(campaign);
            },
          ),
        );
      }),
    );
  }

  Widget _buildCampaignCard(Map<String, dynamic> campaign) {
    double deliveryRate = (campaign['delivered'] / campaign['total']) * 100;
    double readRate = (campaign['read'] / campaign['total']) * 100;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  campaign['name'],
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildStatusLabel(campaign['status']),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            "Template: ${campaign['template']} • ${campaign['date']}",
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem("Sent", campaign['sent'].toString(), Colors.blue),
              _buildStatItem("Delivered", campaign['delivered'].toString(), Colors.green),
              _buildStatItem("Read", campaign['read'].toString(), Colors.purple),
              _buildStatItem("Replied", campaign['replied'].toString(), Colors.orange),
            ],
          ),
          SizedBox(height: 20.h),
          _buildRateBar("Delivery Rate", deliveryRate, Colors.green),
          SizedBox(height: 12.h),
          _buildRateBar("Read Rate", readRate, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildStatusLabel(String status) {
    bool isProcessing = status == "Processing";
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isProcessing ? Colors.blue.withOpacity(0.1) : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10.sp, 
          fontWeight: FontWeight.bold, 
          color: isProcessing ? Colors.blue : Colors.green
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
      ],
    );
  }

  Widget _buildRateBar(String label, double percent, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
            Text("${percent.toStringAsFixed(1)}%", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percent / 100,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
