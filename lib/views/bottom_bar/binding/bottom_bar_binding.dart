import 'package:aitota_business/views/myDial/grid_flow/call_logs/calls/controller/calls_controller.dart';
import 'package:aitota_business/views/myDial/grid_flow/call_logs/controller/call_logs_controller.dart';
import '../../../core/app-export.dart';
import '../../ai_agent/controller/ai_agent_controller.dart';
import '../../ai_agent/detail_screen/controller/ai_agent_detail_controller.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../inbound/grid_flow/conversations/controller/inbound_converstations_controller.dart';
import '../../inbound/grid_flow/leads/controller/inbound_leads_controller.dart';
import '../../inbound/grid_flow/reports/controller/inbound_reports_controller.dart';
import '../../inbound/grid_flow/setting/controller/inbound_settings_controller.dart';
import '../../more_flow/more_screen/controller/more_controller.dart';
import '../../myDial/controller/my_dial_controller.dart';
import '../../myDial/grid_flow/call_logs/analytics/controller/call_analytics_controller.dart';
import '../../myDial/grid_flow/leads/controller/my_dial_leads_controller.dart';
import '../../myDial/grid_flow/myAssign/direct/controller/direct_group_controller.dart';
import '../../myDial/grid_flow/reports/controller/my_dial_reports_controller.dart';
import '../../myDial/grid_flow/saleDone/controller/my_dial_sale_controller.dart';
import '../../my_business/controller/my_business_controller.dart';
import '../../outbound/grid_flow/campaign/controller/outbound_campaign_controller.dart';
import '../../outbound/grid_flow/contact/controller/outbound_contact_controller.dart';
import '../../outbound/grid_flow/contact/add_contact/controller/add_contact_controller.dart';
import '../../outbound/grid_flow/contact/group/controller/contact_group_controller.dart';
import '../../outbound/grid_flow/conversations/controller/outbound_conversations_controller.dart';
import '../../outbound/grid_flow/leads/controller/outbound_leads_controller.dart';
import '../../outbound/grid_flow/reports/controller/outbound_reports_controller.dart';
import '../../outbound/grid_flow/setting/controller/outbound_settings_controller.dart';
import '../../whatsapp_bulk/controller/whatsapp_bulk_controller.dart';
import '../controller/bottom_bar_controller.dart';

class BottomBarBinding extends Bindings {
  @override
  void dependencies() {
    // ───────── Core ─────────
    Get.lazyPut(() => BottomBarController(), fenix: true);
    Get.lazyPut(() => DashboardController(), fenix: true);
    Get.lazyPut(() => MyBusinessController(), fenix: true);
    Get.lazyPut(() => MoreController(), fenix: true);
    Get.lazyPut(() => AiAgentController(), fenix: true);
    Get.lazyPut(() => AiAgentDetailController(), fenix: true);
    Get.lazyPut(() => MyDialController(), fenix: true);

    // ───────── MyDial Module ─────────
    Get.lazyPut(() => DirectGroupController(), fenix: true);
    Get.lazyPut(() => CallLogsController(), fenix: true);
    Get.lazyPut(() => CallsController(), fenix: true);
    Get.lazyPut(() => CallAnalyticsController(), fenix: true);
    Get.lazyPut(() => MyDialLeadsController(), fenix: true);
    Get.lazyPut(() => MyDialReportsController(), fenix: true);
    Get.lazyPut(() => MyDialSaleController(), fenix: true);

    // ───────── Inbound Module ─────────
    Get.lazyPut(() => InboundReportsController(), fenix: true);
    Get.lazyPut(() => InboundLeadsController(), fenix: true);
    Get.lazyPut(() => InboundConversationsController(), fenix: true);
    Get.lazyPut(() => InboundSettingsController(), fenix: true);

    // ───────── Outbound Module ─────────
    Get.lazyPut(() => OutboundCampaignController(), fenix: true);
    Get.lazyPut(() => OutboundContactController(), fenix: true);
    Get.lazyPut(() => AddContactController(), fenix: true);
    Get.lazyPut(() => ContactGroupController(), fenix: true);
    Get.lazyPut(() => OutboundReportsController(), fenix: true);
    Get.lazyPut(() => OutboundConversationsController(), fenix: true);
    Get.lazyPut(() => OutboundLeadsController(), fenix: true);
    Get.lazyPut(() => OutboundSettingsController(), fenix: true);
    Get.lazyPut(() => WhatsAppBulkController(), fenix: true);
  }
}
