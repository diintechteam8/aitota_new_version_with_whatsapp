import 'package:get/get.dart';
import 'package:aitota_business/views/dashboard/controller/dashboard_controller.dart';
import 'package:aitota_business/views/inbound/grid_flow/leads/controller/inbound_leads_controller.dart';
import 'package:aitota_business/views/inbound/grid_flow/reports/controller/inbound_reports_controller.dart';
import 'package:aitota_business/views/inbound/grid_flow/setting/controller/inbound_settings_controller.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/controller/outbound_campaign_controller.dart';
import 'package:aitota_business/views/outbound/grid_flow/reports/controller/outbound_reports_controller.dart';
import 'package:aitota_business/views/outbound/grid_flow/conversations/controller/outbound_conversations_controller.dart';
import 'package:aitota_business/views/outbound/grid_flow/leads/controller/outbound_leads_controller.dart';
import 'package:aitota_business/views/outbound/grid_flow/setting/controller/outbound_settings_controller.dart';
import '../../inbound/grid_flow/conversations/controller/inbound_converstations_controller.dart';
import '../../outbound/grid_flow/contact/group/controller/contact_group_controller.dart';
import '../../outbound/grid_flow/ai_leads/controller/ai_leads_controller.dart'; // Add this import

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
    // Inbound controllers
    Get.lazyPut(() => InboundReportsController());
    Get.lazyPut(() => InboundLeadsController());
    Get.lazyPut(() => InboundConversationsController());
    Get.lazyPut(() => InboundSettingsController());
    // Outbound controllers
    Get.lazyPut(() => OutboundCampaignController());
    Get.lazyPut(() => ContactGroupController());
    Get.lazyPut(() => AILeadsCampaignController()); // Added AILeadsController
    Get.lazyPut(() => OutboundReportsController());
    Get.lazyPut(() => OutboundConversationsController());
    Get.lazyPut(() => OutboundLeadsController());
    Get.lazyPut(() => OutboundSettingsController());
  }
}