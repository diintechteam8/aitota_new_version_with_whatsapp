import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../views/outbound/grid_flow/campaign/detail_screen/controller/outbound_campaign_detail_controller.dart';

class RunCampaignButton extends StatelessWidget {
  final OutboundCampaignDetailController controller;

  const RunCampaignButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Padding(
        padding: EdgeInsets.only(right: 8.w),
        child: ElevatedButton(
          onPressed: controller.onRunCampaign,
          style: ElevatedButton.styleFrom(
            backgroundColor: controller.runButtonColor.value,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            minimumSize: Size(80, 40.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            elevation: 0,
          ),
          child: Text(
            controller.runButtonText.value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}