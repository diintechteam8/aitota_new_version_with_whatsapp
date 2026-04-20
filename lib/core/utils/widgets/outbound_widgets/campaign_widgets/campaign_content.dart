import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../views/outbound/grid_flow/campaign/detail_screen/controller/outbound_campaign_detail_controller.dart';
import 'agents_section.dart';
import 'campaign_card_section.dart';
import 'call_status_section.dart';
import 'groups_section.dart';

class CampaignContent extends StatelessWidget {
  final OutboundCampaignDetailController controller;
  final bool isDark;

  const CampaignContent({super.key, required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CampaignCardSection(controller: controller, isDark: isDark),
          SizedBox(height: 12.h),
          Obx(
                () => Visibility(
              visible: !controller.isCampaignRunning.value || !controller.isSectionsFolded.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GroupsSection(controller: controller, isDark: isDark),
                  SizedBox(height: 8.h),
                  AgentsSection(controller: controller, isDark: isDark),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
          Obx(
                () => controller.showTable.value
                ? CallStatusSection(controller: controller, isDark: isDark)
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}