import 'package:aitota_business/views/admin/clients/binding/clients_binding.dart';
import 'package:aitota_business/views/admin/clients/clients_screen.dart';
import 'package:aitota_business/views/admin/roles/binding/roles_binding.dart';
import 'package:aitota_business/views/admin/roles/roles_screen.dart';
import 'package:aitota_business/views/ai_agent/detail_screen/ai_agent_detail_screen.dart';
import 'package:aitota_business/views/ai_agent/detail_screen/binding/ai_agent_detail_binding.dart';
import 'package:aitota_business/views/ai_agent/detail_screen/call_history/binding/call_history_binding.dart';
import 'package:aitota_business/views/ai_agent/detail_screen/call_history/call_histroy_screen.dart';
import 'package:aitota_business/views/ai_agent/detail_screen/call_history/detail_screen/binding/call_histroy_detail_binding.dart';
import 'package:aitota_business/views/ai_agent/detail_screen/call_history/detail_screen/call_history_detail_screen.dart';
import 'package:aitota_business/views/auth_flow/onBoarding/binding/on_boarding_binding.dart';
import 'package:aitota_business/views/auth_flow/onBoarding/on_boarding_screen.dart';
import 'package:aitota_business/views/auth_flow/pending_approval/binding/pending_approval_binding.dart';
import 'package:aitota_business/views/auth_flow/pending_approval/pending_approval_screen.dart';
import 'package:aitota_business/views/auth_flow/register/binding/register_binding.dart';
import 'package:aitota_business/views/auth_flow/profile_select/binding/profile_select_binding.dart';
import 'package:aitota_business/views/auth_flow/profile_select/profile_select_screen.dart';
import 'package:aitota_business/views/auth_flow/splash/binding/splash_binding.dart';
import 'package:aitota_business/views/auth_flow/splash/splash_screen.dart';
import 'package:aitota_business/views/bottom_bar/binding/bottom_bar_binding.dart';
import 'package:aitota_business/views/bottom_bar/bottom_bar_screen.dart';
import 'package:aitota_business/views/credit_flow/add_amount_plan/add_recharge_screen.dart';
import 'package:aitota_business/views/credit_flow/add_amount_plan/binding/add_recharge_binding.dart';
import 'package:aitota_business/views/credit_flow/history/binding/payment_history_binding.dart';
import 'package:aitota_business/views/credit_flow/history/payment_history_screen.dart';
import 'package:aitota_business/views/credit_flow/payment_failed/binding/payment_failed_binding.dart';
import 'package:aitota_business/views/credit_flow/payment_failed/payment_failed_screen.dart';
import 'package:aitota_business/views/credit_flow/payment_successful/binding/payment_successful_binding.dart';
import 'package:aitota_business/views/credit_flow/payment_successful/payment_successful_screen.dart';
import 'package:aitota_business/views/inbound/grid_flow/conversations/binding/inbound_conversations_binding.dart';
import 'package:aitota_business/views/inbound/grid_flow/conversations/conversation_detail/binding/inbound_conversation_detail_binding.dart';
import 'package:aitota_business/views/inbound/grid_flow/conversations/inbound_conversations_screen.dart';
import 'package:aitota_business/views/inbound/grid_flow/leads/binding/inbound_leads_binding.dart';
import 'package:aitota_business/views/inbound/grid_flow/leads/inbound_leads_screen.dart';
import 'package:aitota_business/views/inbound/grid_flow/leads/leads_detail/binding/inbound_leads_detail_binding.dart';
import 'package:aitota_business/views/inbound/grid_flow/leads/leads_detail/inbound_leads_detail_screen.dart';
import 'package:aitota_business/views/inbound/grid_flow/leads/leads_detail/lead_status_detail/inbound_lead_status_detail_screen.dart';
import 'package:aitota_business/views/inbound/grid_flow/reports/binding/inbound_report_binding.dart';
import 'package:aitota_business/views/inbound/grid_flow/reports/inbound_reports_screen.dart';
import 'package:aitota_business/views/inbound/grid_flow/reports/inbound_summary/binding/inbound_report_status_binding.dart';
import 'package:aitota_business/views/inbound/grid_flow/reports/inbound_summary/detail_screen/inbound_report_status_detail_screen.dart';
import 'package:aitota_business/views/inbound/grid_flow/reports/inbound_summary/inbound_report_status_screen.dart';
import 'package:aitota_business/views/inbound/grid_flow/setting/binding/inbound_settings_binding.dart';
import 'package:aitota_business/views/inbound/grid_flow/setting/grid_flow/ai_agent/binding/inbound_ai_agent_binding.dart';
import 'package:aitota_business/views/inbound/grid_flow/setting/grid_flow/ai_agent/detail/binding/inbound_ai_agent_detail_binding.dart';
import 'package:aitota_business/views/inbound/grid_flow/setting/grid_flow/ai_agent/detail/inbound_ai_agent_detail_screen.dart';
import 'package:aitota_business/views/inbound/grid_flow/setting/grid_flow/ai_agent/inbound_ai_agent_screen.dart';
import 'package:aitota_business/views/inbound/grid_flow/setting/grid_flow/business_info/binding/inbound_business_info_binding.dart';
import 'package:aitota_business/views/inbound/grid_flow/setting/inbound_settings_screen.dart';
import 'package:aitota_business/views/inbound_icons_flow/whatsapp/binding/inbound_whatsapp_chat_binding.dart';
import 'package:aitota_business/views/inbound_icons_flow/whatsapp/inbound_whatsapp_chat_screen.dart';
import 'package:aitota_business/views/more_flow/more_screen/biniding/more_biniding.dart';
import 'package:aitota_business/views/more_flow/more_screen/help&support/binding/help_support_binding.dart';
import 'package:aitota_business/views/more_flow/more_screen/help&support/help_support_screen.dart';
import 'package:aitota_business/views/more_flow/more_screen/users_profile_screen.dart';
import 'package:aitota_business/views/myDial/dialer_pad/binding/dialer_pad_binding.dart';
import 'package:aitota_business/views/myDial/dialer_pad/dialer_pad_screen.dart';
import 'package:aitota_business/views/myDial/grid_flow/call_logs/calls/binding/calls_binding.dart';
import 'package:aitota_business/views/myDial/grid_flow/call_logs/calls/calls_scree.dart';
import 'package:aitota_business/views/myDial/grid_flow/leads/leads_detail/lead_status_detail/binding/my_dial_lead_status_detail_binding.dart';
import 'package:aitota_business/views/myDial/grid_flow/leads/leads_detail/lead_status_detail/my_dial_lead_status_detail_screen.dart';
import 'package:aitota_business/views/myDial/grid_flow/leads/leads_detail/my_dial_leads_detail_screen.dart';
import 'package:aitota_business/views/myDial/grid_flow/leads/my_dail_leads_screen.dart';
import 'package:aitota_business/views/myDial/grid_flow/myAssign/direct/detail/binding/myassign_group_detail_binding.dart';
import 'package:aitota_business/views/myDial/grid_flow/myAssign/direct/detail/contact_detail/binding/contact_detail_binding.dart';
import 'package:aitota_business/views/myDial/grid_flow/myAssign/direct/detail/contact_detail/contact_detail_screen.dart';
import 'package:aitota_business/views/myDial/grid_flow/myAssign/direct/detail/myassign_group_detail_screen.dart';
import 'package:aitota_business/views/myDial/grid_flow/reports/binding/my_dial_reports_binding.dart';
import 'package:aitota_business/views/myDial/grid_flow/reports/my_dial_reports_screen.dart';
import 'package:aitota_business/views/myDial/grid_flow/saleDone/binding/my_dial_sale_binding.dart';
import 'package:aitota_business/views/myDial/grid_flow/saleDone/my_dial_sale_screen.dart';
import 'package:aitota_business/views/my_business/add_business/binding/add_my_business_binding.dart';
import 'package:aitota_business/views/my_business/binding/my_business_binding.dart';
import 'package:aitota_business/views/my_business/detail_screen/binding/my_business_detail_binding.dart';
import 'package:aitota_business/views/my_business/detail_screen/my_business_detail_screen.dart';
import 'package:aitota_business/views/my_business/my_business_screen.dart';
import 'package:aitota_business/views/my_business/update_business/update_my_business_screen.dart';
import 'package:aitota_business/views/outbound/grid_flow/ai_leads/ai_leads_screen.dart';
import 'package:aitota_business/views/outbound/grid_flow/ai_leads/binding/ai_leads_binding.dart';
import 'package:aitota_business/views/outbound/grid_flow/ai_leads/campaign_contacts/ai_leads_campaign_contacts_screen.dart';
import 'package:aitota_business/views/outbound/grid_flow/ai_leads/campaign_contacts/binding/ai_leads_campaign_contacts_binding.dart';
import 'package:aitota_business/views/outbound/grid_flow/ai_leads/campaign_contacts/contact_detail/ai_leads_contact_detail_screen.dart';
import 'package:aitota_business/views/outbound/grid_flow/ai_leads/campaign_contacts/contact_detail/binding/ai_leads_contact_detail_binding.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/addCampaign/add_outbound_campaign_screen.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/addCampaign/binding/add_outbound_campaign_binding.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/detail_screen/binding/outbound_campaign_detail_binding.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/detail_screen/outbound_campaign_detail_screen.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/detail_screen/see_more/binding/see_more_campaign_logs_binding.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/detail_screen/see_more/see_more_campaign_logs_screen.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/detail_screen/view_completed/binding/view_completed_campaign_binding.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/detail_screen/view_completed/view_completed_campaign_calls_screen.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/detail_screen/view_live/binding/view_live_campaign_calls_binding.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/detail_screen/view_live/view_live_campaign_calls_screen.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/updateCampaign/binding/update_outbound_campaign_binding.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/updateCampaign/update_outbound_campaign_screen.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/add_contact/add_contact_screen.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/add_contact/binding/add_contact_binding.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/enter_detail/binding/enter_details_binding.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/enter_detail/enter_details_screen.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/group/contact_group_screen.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/group/detail_screen/binding/outbound_group_detail_binding.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/group/detail_screen/outbound_group_detail_screen.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/import_file/binding/import_file_binding.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/import_file/import_file_screen.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/open_phonebook/binding/open_phonebook_binding.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/open_phonebook/open_phonebook_screen.dart';
import 'package:aitota_business/views/outbound/grid_flow/conversations/conversation_detail/outbound_conversation_detail_screen.dart';
import 'package:aitota_business/views/outbound/grid_flow/leads/leads_detail/outbound_leads_detail_screen.dart';
import 'package:aitota_business/views/outbound/grid_flow/reports/outbound_summary/binding/outbound_report_status_binding.dart';
import 'package:aitota_business/views/outbound/grid_flow/reports/outbound_summary/detail_screen/binding/outbound_reports_detail_binding.dart';
import 'package:aitota_business/views/outbound/grid_flow/reports/outbound_summary/outbound_report_status_screen.dart';
import 'package:aitota_business/views/outbound/grid_flow/setting/grid_flow/ai_agent/binding/outbound_ai_agent_binding.dart';
import 'package:aitota_business/views/outbound/grid_flow/setting/grid_flow/ai_agent/detail_screen/binding/outbound_ai_agent_detail_binding.dart';
import 'package:aitota_business/views/outbound/grid_flow/setting/grid_flow/ai_agent/detail_screen/outbound_ai_agent_detail_screen.dart';
import 'package:aitota_business/views/outbound/grid_flow/setting/grid_flow/ai_agent/outbound_ai_agent_screen.dart';
import 'package:aitota_business/views/outbound/grid_flow/setting/grid_flow/business_info/outbound_business_info_screen.dart';
import 'package:aitota_business/views/whatsapp_bulk/templates/details/whatsapp_template_details_screen.dart';
import 'package:aitota_business/views/whatsapp_bulk/templates/details/controller/whatsapp_template_details_controller.dart';
import 'package:aitota_business/views/whatsapp_bulk/reports/whatsapp_reports_screen.dart';
import 'package:aitota_business/views/whatsapp_bulk/reports/controller/whatsapp_reports_controller.dart';
import 'package:aitota_business/views/whatsapp_bulk/inbox/whatsapp_inbox_screen.dart';
import 'package:aitota_business/views/whatsapp_bulk/inbox/controller/whatsapp_inbox_controller.dart';
import 'package:aitota_business/views/whatsapp_bulk/audience/audience_selection_screen.dart';
import 'package:aitota_business/views/whatsapp_bulk/templates/create/create_template_screen.dart';
import 'package:aitota_business/views/whatsapp_bulk/templates/create/controller/create_template_controller.dart';
import 'package:aitota_business/views/whatsapp_bulk/templates/view/whatsapp_templates_screen.dart';
import 'package:aitota_business/views/whatsapp_bulk/view/whatsapp_bulk_landing_screen.dart';
import 'package:aitota_business/views/whatsapp_bulk/controller/whatsapp_bulk_controller.dart';
import 'package:aitota_business/views/whatsapp_bulk/binding/whatsapp_nav_binding.dart';
import 'package:aitota_business/views/whatsapp_bulk/view/whatsapp_main_navigator.dart';
import '../core/app-export.dart';
import '../views/auth_flow/login/binding/login_binding.dart';
import '../views/auth_flow/login/auth_methode_screen.dart';
import '../views/auth_flow/login/email_login_screen.dart';
import '../views/auth_flow/register/complete_profile_screen.dart';
import '../views/auth_flow/register/register_step1_screen.dart';
import '../views/auth_flow/register/verify_otp_screen.dart';
import '../views/auth_flow/forgot_password/forgot_password_email_screen.dart';
import '../views/auth_flow/forgot_password/reset_password_screen.dart';
import '../views/auth_flow/forgot_password/binding/reset_password_binding.dart';
import '../views/auth_flow/register/mobile_verify_screen.dart';
import '../views/auth_flow/register/binding/register_step1_binding.dart';
import '../views/auth_flow/register/binding/otp_binding.dart';
import '../views/dashboard/binding/dashboard_binding.dart';
import '../views/dashboard/dashboard_screen.dart';
import '../views/inbound/grid_flow/conversations/conversation_detail/inbound_conversation_detail_screen.dart';
import '../views/inbound/grid_flow/leads/leads_detail/lead_status_detail/binding/lead_status_detail_binding.dart';
import '../views/inbound/grid_flow/reports/inbound_summary/detail_screen/binding/inbound_reports_detail_binding.dart';
import '../views/inbound/grid_flow/setting/grid_flow/business_info/inbound_business_info_screen.dart';
import '../views/inbound_icons_flow/telegram/telegram_chat_screen.dart';
import '../views/myDial/grid_flow/call_logs/analytics/analysis/per_call/binding/per_call_binding.dart';
import '../views/myDial/grid_flow/call_logs/analytics/analysis/per_call/per_call_screen.dart';
import '../views/myDial/grid_flow/call_logs/analytics/analysis/top_caller/binding/top_caller_binding.dart';
import '../views/myDial/grid_flow/call_logs/analytics/analysis/top_caller/top_caller_screen.dart';
import '../views/myDial/grid_flow/call_logs/analytics/analysis/top_talked/binding/top_talked_binding.dart';
import '../views/myDial/grid_flow/call_logs/analytics/analysis/top_talked/top_talked_screen.dart';
import '../views/myDial/grid_flow/call_logs/analytics/incoming_calls/binding/incoming_calls_binding.dart';
import '../views/myDial/grid_flow/call_logs/analytics/incoming_calls/incoming_calls_screen.dart';
import '../views/myDial/grid_flow/call_logs/analytics/never_attended_calls/binding/never_attended_calls_binding.dart';
import '../views/myDial/grid_flow/call_logs/analytics/never_attended_calls/never_attended_calls_screen.dart';
import '../views/myDial/grid_flow/call_logs/analytics/total_phone_calls/binding/total_phone_calls_binding.dart';
import '../views/myDial/grid_flow/call_logs/analytics/total_phone_calls/total_phone_calls_screen.dart';
import '../views/myDial/grid_flow/call_logs/binding/call_logs_binding.dart';
import '../views/myDial/grid_flow/call_logs/call_logs_screen.dart';
import '../views/myDial/grid_flow/leads/binding/my_dial_leads_binding.dart';
import '../views/myDial/grid_flow/leads/leads_detail/binding/my_dial_leads_detail_binding.dart';
import '../views/my_business/add_business/add_my_business_screen.dart';
import '../views/my_business/update_business/binding/update_my_business_binding.dart';
import '../views/outbound/grid_flow/contact/binding/outbound_contact_binding.dart';
import '../views/outbound/grid_flow/contact/group/binding/contact_group_binding.dart';
import '../views/outbound/grid_flow/contact/outbound_contact_screen.dart';
import '../views/outbound/grid_flow/conversations/conversation_detail/binding/outbound_conversation_detail_binding.dart';
import '../views/outbound/grid_flow/leads/leads_detail/binding/outbound_leads_detail_binding.dart';
import '../views/outbound/grid_flow/leads/leads_detail/lead_status_detail/binding/lead_status_detail_binding.dart';
import '../views/outbound/grid_flow/leads/leads_detail/lead_status_detail/outbound_lead_status_detail_screen.dart';
import '../views/outbound/grid_flow/reports/outbound_summary/detail_screen/outbound_report_status_detail_screen.dart';
import 'package:aitota_business/views/inbound_icons_flow/telegram/binding/inbound_telegram_chat_binding.dart';
import 'package:aitota_business/views/inbound_icons_flow/email/binding/inbound_email_binding.dart';
import 'package:aitota_business/views/inbound_icons_flow/email/inbound_email_screen.dart';
import 'package:aitota_business/views/inbound_icons_flow/calendar/binding/inbound_calendar_binding.dart';
import 'package:aitota_business/views/inbound_icons_flow/calendar/inbound_calendar_screen.dart';
import '../views/outbound_icons_flow/whatsapp/binding/outbound_whatsapp_chat_binding.dart';
import '../views/outbound_icons_flow/whatsapp/outbound_whatsapp_chat_screen.dart';
import 'package:aitota_business/views/whatsapp_groups/binding/groups_binding.dart';
import 'package:aitota_business/views/whatsapp_groups/views/entry_button_screen.dart';
import 'package:aitota_business/views/whatsapp_groups/views/groups_landing_screen.dart';
import 'package:aitota_business/views/whatsapp_groups/views/group_detail_screen.dart';
import 'package:aitota_business/views/whatsapp_groups/views/team_chats_list_screen.dart';
import 'package:aitota_business/views/admin/human_agents/binding/human_agents_binding.dart';
import 'package:aitota_business/views/admin/human_agents/human_agents_screen.dart';
import 'package:aitota_business/views/admin/associated_clients/binding/associated_clients_binding.dart';
import 'package:aitota_business/views/admin/associated_clients/associated_clients_screen.dart';
import 'package:aitota_business/views/admin/admin_clients/admin_clients_screen.dart';
import 'package:aitota_business/views/admin/admin_clients/binding/admin_clients_binding.dart';

import '../views/profile/binding/profile_binding.dart';
import '../views/profile/profile_screen.dart';
import '../views/whatsapp_bulk/audience/controller/audience_selection_controller.dart';
import '../views/whatsapp_bulk/templates/controller/whatsapp_templates_controller.dart';

class AppRoutes {
  static const String initialRoute = '/splash_screen';
  static const String onBoardingScreen = '/on_boarding_screen';
  static const String loginScreen = '/login_screen';
  static const String forgotPasswordScreen = '/forgot_password_screen';
  static const String resetPasswordScreen = '/reset_password_screen';
  static const String emailLoginScreen = '/email_login_screen';
  static const String profileSelectScreen = '/profile_select_screen';
  static const String compeletProfileScreen = '/compelet_profile_screen';
  static const String registerStep1Screen = '/register_step1_screen';
  static const String emailOtpScreen = '/email_otp_screen';
  static const String mobileVerifyScreen = '/mobile_verify_screen';
  static const String pendingApprovalScreen = '/pending_approval_screen';
  static const String bottomBarScreen = '/bottom_bar_screen';
  static const String dashboardScreen = '/dashboard_screen';
  static const String callLogsScreen = '/call_logs_screen';
  static const String outBoundGroupScreen = '/contact_group_screen';
  static const String addContactScreen = '/add_contact_screen';
  static const String enterDetailScreen = '/enter_details_screen.dart';
  static const String openPhonebookScreen = '/open_phonebook_screen.dart';
  static const String importFileScreen = '/import_file_screen';
  static const String profileScreen = '/profile_screen';
  static const String moreScreen = '/more_screen';
  static const String inboundReportsScreen = '/inbound_reports_screen';
  static const String inboundLeadsScreen = '/inbound_leads_screen';
  static const String inboundLeadsDetailScreen = '/inbound_leads_detail_screen';
  static const String inboundConversationsScreen =
      '/inbound_conversations_screen';
  static const String inboundConversationsDetailScreen =
      '/inbound_conversation_detail_screen';
  static const String inboundSettingsScreen = '/inbound_settings_screen';
  static const String myBusinessScreen = '/ai_calls_screen';
  static const String inboundReportStatusScreen =
      '/inbound_report_status_screen';
  static const String inboundReportsStatusDetailScreen =
      '/inbound_report_status_detail_screen';
  static const String inboundAiAgentScreen = '/inbound_ai_agent_screen';
  static const String outboundAiAgentScreen = '/outbound_ai_agent_screen';
  static const String myDailLeadsScreen = '/my_dail_leads_screen.dart';
  static const String myDialReportsScreen = '/my_dial_reports_screen.dart';
  static const String myDialSaleDoneScreen = '/my_dial_sale_screen.dart';
  static const String inboundLeadsStatusDetailScreen =
      '/outbound_lead_status_detail_screen.dart';
  static const String myDialerPadScreen = '/dialer_pad_screen';
  static const String outboundGroupDetailScreen =
      '/outbound_group_detail_screen';
  static const String outboundContactScreen = '/outbound_contact_screen';
  static const String outboundAddContactScreen = '/add_contact_screen';
  static const String inboundAiAgentDetailScreen =
      '/inbound_ai_agent_detail_screen';
  static const String myDialLeadsDetailScreen =
      '/my_dial_leads_detail_screen'; // new
  static const String myDialLeadsStatusDetailScreen =
      '/my_dial_lead_status_detail_screen'; // new
  static const String addMyBusinessScreen = '/add_my_business_screen';
  static const String aiAiAgentDetailScreen = '/ai_agent_detail_screen';
  static const String updateMyBusinessScreen = '/update_my_business_screen';
  static const String callHistoryScreen = '/call_histroy_screen';
  static const String callHistoryDetailScreen =
      '/call_history_detail_screen.dart';
  static const String outboundAiAgentDetailScreen =
      '/outbound_ai_agent_detail_screen';
  static const String myBusinessDetailsScreen = '/my_business_detail_screen';
  static const String addOutboundCampaignScreen =
      '/add_outbound_campaign_screen';
  static const String updateOutboundCampaignScreen =
      '/update_outbound_campaign_screen';
  static const String outboundCampaignDetailsScreen =
      '/outbound_campaign_detail_screen';
  static const String seeMoreCampaignLogsScreen =
      '/see_more_campaign_logs_screen';
  static const String viewLiveCampaignCallsScreen =
      '/view_live_campaign_calls_screen';
  static const String viewCompletedCampaignCallsScreen =
      '/view_completed_campaign_calls_screen';
  static const String outboundReportStatusScreen =
      '/outbound_report_status_screen';
  static const String outboundReportStatusDetailScreen =
      '/outbound_report_status_detail_screen';
  static const String outboundLeadsDetailScreen =
      '/outbound_leads_detail_screen';
  static const String outboundLeadsStatusDetailScreen =
      '/outbound_lead_status_detail_screen';
  static const String outboundConversationsDetailScreen =
      '/outbound_conversation_detail_screen';
  static const String inboundBusinessInfoScreen =
      '/inbound_business_info_screen';
  static const String outboundBusinessInfoScreen =
      '/inbound_business_info_screen';
  static const String addRechargeScreen = '/add_recharge_screen';
  static const String paymentSuccessfulScreen = '/payment_successful_screen';
  static const String paymentFailedScreen = '/payment_failed_screen';
  static const String paymentHistoryScreen = '/payment_history_screen';
  static const String inboundWhatsappChatScreen =
      '/inbound_whatsapp_chat_screen';
  static const String inboundTelegramChatScreen =
      '/inbound_telegram_chat_screen';
  static const String inboundEmailScreen = '/inbound_email_screen';
  static const String inboundCalendarScreen = '/inbound_calendar_screen';
  static const String clientScreen = '/clients_screen';
  static const String outboundWhatsappChatScreen =
      '/outbound_whatsapp_chat_screen';
  static const String groupsEntryScreen = '/groups_entry_screen';
  static const String groupsLandingScreen = '/groups_landing_screen';
  static const String groupDetailScreen = '/group_detail_screen';
  static const String teamChatsListScreen = '/team_chats_list_screen';
  static const String helpSupportScreen = '/help_support_screen';
  static const String aiLeadsScreen = '/ai_leads_screen';
  static const String aiLeadsCampaignContactsScreen =
      '/ai_leads_campaign_contacts_screen';
  static const String aiLeadsContactsDetailScreen =
      '/ai_leads_contact_detail_screen';
  static const String rolesScreen = '/roles_screen';
  static const String humanAgentsScreen = '/human_agents_screen';
  static const String associatedClientsScreen = '/associated_clients_screen';
  static const String adminClientsScreen = '/admin-clients-screen';
  static const String whatsappBulkLandingScreen = '/whatsapp_bulk_landing_screen';
  static const String whatsappMainNavigator = '/whatsapp_main_navigator';

  static const String totalPhoneCallsScreen = '/total_phone_calls_screen';
  static const String incomingCallsScreen = '/incoming_calls_screen';
  static const String neverAttendedCallsScreen = '/never_attended_calls_screen';
  static const String topCallerScreen = '/top_caller_screen';
  static const String perCallScreen = '/per_call_screen';
  static const String topTalkedScreen = '/top_talked_screen';
  static const String callsScreen = '/calls_screen';
  static const String myAssignGroupDetailScreen =
      '/myassign_group_detail_screen';
  static const String contactDetailScreen = '/contact_detail_screen';
  static const String whatsappTemplatesScreen = '/whatsapp_templates_screen';
  static const String whatsappTemplateDetailsScreen = '/whatsapp_template_details_screen';
  static const String audienceSelectionScreen = '/audience_selection_screen';
  static const String createTemplateScreen = '/create_template_screen';
  static const String whatsappReportsScreen = '/whatsapp_reports_screen';
  static const String whatsappInboxScreen = '/whatsapp_inbox_screen';
  
  static List<GetPage> pages = [
    GetPage(
      name: AppRoutes.initialRoute,
      page: () => const SplashScreen(),
      bindings: [
        SplashBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.onBoardingScreen,
      page: () => const OnBoardingScreen(),
      bindings: [
        OnboardingBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.loginScreen,
      page: () => const AuthMethodeScreen(), // login Screen
      bindings: [
        LoginBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.forgotPasswordScreen,
      page: () => const ForgotPasswordEmailScreen(),
      bindings: [
        LoginBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.resetPasswordScreen,
      page: () => const ResetPasswordScreen(),
      bindings: [
        ResetPasswordBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.emailLoginScreen,
      page: () => const EmailLoginScreen(),
      bindings: [
        LoginBinding(),
      ],
    ),
    GetPage(
      name: profileSelectScreen,
      page: () => const ProfileSelectScreen(),
      bindings: [
        ProfileSelectBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.compeletProfileScreen,
      page: () => const CompleteProfileScreen(),
      bindings: [
        RegisterBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.registerStep1Screen,
      page: () => const RegisterStep1Screen(),
      bindings: [
        RegisterStep1Binding(),
      ],
    ),
    GetPage(
      name: AppRoutes.emailOtpScreen,
      page: () => const VerifyOtpScreen(),
      bindings: [
        OtpBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.mobileVerifyScreen,
      page: () => const MobileVerifyScreen(),
      bindings: [
        OtpBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.bottomBarScreen,
      page: () => const BottomBarScreen(),
      bindings: [
        BottomBarBinding(),
        DashboardBinding(), // Add this
      ],
    ),
    GetPage(
      name: dashboardScreen,
      page: () => const DashboardScreen(),
      bindings: [
        DashboardBinding(),
      ],
    ),
    GetPage(
      name: callLogsScreen,
      page: () => const CallLogsScreen(),
      bindings: [
        CallLogsBinding(),
      ],
    ),
    GetPage(
      name: outBoundGroupScreen,
      page: () => const ContactGroupScreen(),
      bindings: [
        ContactGroupBinding(),
      ],
    ),
    GetPage(
      name: addContactScreen,
      page: () => const AddContactScreen(),
      bindings: [
        AddContactBinding(),
      ],
    ),
    GetPage(
      name: enterDetailScreen,
      page: () => const EnterDetailsScreen(),
      bindings: [
        EnterDetailBinding(),
      ],
    ),
    GetPage(
      name: openPhonebookScreen,
      page: () => OpenPhonebookScreen(),
      bindings: [
        OpenPhoneBookBinding(),
      ],
    ),
    GetPage(
      name: importFileScreen,
      page: () => const ImportFileScreen(),
      bindings: [
        ImportFileBinding(),
      ],
    ),
    GetPage(
      name: pendingApprovalScreen,
      page: () => const ApprovalPendingScreen(),
      bindings: [
        ApprovalPendingBinding(),
      ],
    ),
    GetPage(
      name: profileScreen,
      page: () =>  ProfileScreen(),
      bindings: [
        ProfileBinding(),
      ],
    ),
    GetPage(
      name: moreScreen,
      page: () => const UsersProfileScreen(),
      bindings: [
        UsersProfileBinding(),
      ],
    ),
    GetPage(
      name: inboundReportsScreen,
      page: () => const InboundReportsScreen(),
      bindings: [
        InboundReportsBinding(),
      ],
    ),
    GetPage(
      name: inboundLeadsScreen,
      page: () => const InboundLeadsScreen(),
      bindings: [
        InboundLeadsBinding(),
      ],
    ),
    GetPage(
      name: inboundLeadsDetailScreen,
      page: () => const InboundLeadsDetailScreen(),
      bindings: [
        InboundLeadsDetailBinding(),
      ],
    ),
    GetPage(
      name: inboundConversationsScreen,
      page: () => const InboundConversationsScreen(),
      bindings: [
        InboundConversationsBinding(),
      ],
    ),
    GetPage(
      name: inboundConversationsDetailScreen,
      page: () => const InboundConversationsDetailScreen(),
      bindings: [
        InboundConversationDetailBinding(),
      ],
    ),
    GetPage(
      name: inboundSettingsScreen,
      page: () => const InboundSettingsScreen(),
      bindings: [
        InboundSettingsBinding(),
      ],
    ),
    GetPage(
      name: outboundContactScreen,
      page: () => const OutboundContactScreen(),
      binding: OutboundContactBinding(),
    ),
    GetPage(
      name: myBusinessScreen,
      page: () => const MyBusinessScreen(),
      bindings: [
        MyBusinessBinding(),
      ],
    ),
    GetPage(
      name: inboundReportStatusScreen,
      page: () => const InboundReportStatusScreen(),
      bindings: [
        InboundReportStatusBinding(),
      ],
    ),
    GetPage(
      name: inboundReportsStatusDetailScreen,
      page: () => const InboundReportStatusDetailScreen(),
      bindings: [
        InboundReportStatusDetailBinding(),
      ],
    ),
    GetPage(
      name: inboundAiAgentScreen,
      page: () => const InboundAiAgentScreen(),
      bindings: [
        InboundAiAgentBinding(),
      ],
    ),
    GetPage(
      name: myDailLeadsScreen,
      page: () => const MyDialLeadsScreen(),
      bindings: [
        MyDialLeadsBinding(),
      ],
    ),
    GetPage(
      name: myDialReportsScreen,
      page: () => const MyDialReportsScreen(),
      bindings: [
        MyDialReportsBinding(),
      ],
    ),
    GetPage(
      name: myDialSaleDoneScreen,
      page: () => const MyDialSaleScreen(),
      bindings: [
        MyDialSaleBinding(),
      ],
    ),
    GetPage(
      name: inboundLeadsStatusDetailScreen,
      page: () => const InboundLeadStatusDetailScreen(),
      bindings: [
        InboundLeadStatusDetailBinding(),
      ],
    ),
    GetPage(
      name: myDialerPadScreen,
      page: () => const DialerPadScreen(),
      bindings: [
        DialerPadBinding(),
      ],
    ),
    GetPage(
      name: outboundGroupDetailScreen,
      page: () => const OutboundGroupDetailScreen(),
      bindings: [
        OutboundGroupDetailBinding(),
      ],
    ),
    GetPage(
      name: inboundAiAgentDetailScreen,
      page: () => const InboundAiAgentDetailScreen(),
      bindings: [
        InboundAiAgentDetailBinding(),
      ],
    ),
    GetPage(
      name: myDialLeadsDetailScreen,
      page: () => const MyDialLeadsDetailScreen(),
      bindings: [
        MyDialLeadsDetailBinding(),
      ],
    ),
    GetPage(
      name: myDialLeadsStatusDetailScreen,
      page: () => const MyDialLeadStatusDetailScreen(),
      bindings: [
        MyDialLeadStatusDetailBinding(),
      ],
    ),
    GetPage(
      name: outboundAiAgentScreen,
      page: () => const OutboundAiAgentScreen(),
      bindings: [
        OutboundAiAgentBinding(),
      ],
    ),
    GetPage(
        name: AppRoutes.addMyBusinessScreen,
        page: () => const AddMyBusinessScreen(),
        bindings: [AddMyBusinessBinding()]),
    GetPage(
        name: AppRoutes.aiAiAgentDetailScreen,
        page: () => const AiAgentDetailScreen(),
        bindings: [AiAgentDetailBinding()]),
    GetPage(
        name: AppRoutes.updateMyBusinessScreen,
        page: () => const UpdateMyBusinessScreen(),
        bindings: [UpdateMyBusinessBinding()]),
    GetPage(
        name: AppRoutes.callHistoryScreen,
        page: () => const CallHistoryScreen(),
        bindings: [CallHistoryBinding()]),
    GetPage(
        name: AppRoutes.callHistoryDetailScreen,
        page: () => const CallHistoryDetailScreen(),
        bindings: [CallHistoryDetailBinding()]),
    GetPage(
        name: AppRoutes.outboundAiAgentDetailScreen,
        page: () => const OutboundAiAgentDetailScreen(),
        bindings: [OutboundAiAgentDetailBinding()]),
    GetPage(
        name: AppRoutes.myBusinessDetailsScreen,
        page: () => const MyBusinessDetailsScreen(),
        bindings: [MyBusinessDetailBinding()]),
    GetPage(
        name: AppRoutes.addOutboundCampaignScreen,
        page: () => const AddOutboundCampaignScreen(),
        bindings: [AddOutboundCampaignBinding()]),
    GetPage(
        name: AppRoutes.updateOutboundCampaignScreen,
        page: () => const UpdateOutboundCampaignScreen(),
        bindings: [UpdateOutboundCampaignBinding()]),
    GetPage(
        name: AppRoutes.outboundCampaignDetailsScreen,
        page: () => const OutboundCampaignDetailScreen(),
        bindings: [OutboundCampaignDetailBinding()]),
    GetPage(
        name: AppRoutes.seeMoreCampaignLogsScreen,
        page: () => const SeeMoreCampaignLogsScreen(),
        bindings: [SeeMoreCampaignLogsBinding()]),
    GetPage(
        name: AppRoutes.viewLiveCampaignCallsScreen,
        page: () => const ViewLiveCampaignCallsScreen(),
        bindings: [ViewLiveCampaignCallsBinding()]),
    GetPage(
        name: AppRoutes.viewCompletedCampaignCallsScreen,
        page: () => const ViewCompletedCampaignCallsScreen(),
        bindings: [ViewCompletedCampaignCallsBinding()]),
    GetPage(
        name: AppRoutes.outboundReportStatusScreen,
        page: () => const OutboundReportStatusScreen(),
        bindings: [OutboundReportStatusBinding()]),
    GetPage(
        name: AppRoutes.outboundReportStatusDetailScreen,
        page: () => const OutboundReportStatusDetailScreen(),
        bindings: [OutboundReportStatusDetailBinding()]),
    GetPage(
        name: AppRoutes.outboundLeadsDetailScreen,
        page: () => const OutboundLeadsDetailScreen(),
        bindings: [OutboundLeadsDetailBinding()]),
    GetPage(
        name: AppRoutes.outboundLeadsStatusDetailScreen,
        page: () => const OutboundLeadStatusDetailScreen(),
        bindings: [OutboundLeadStatusDetailBinding()]),
    GetPage(
        name: AppRoutes.outboundConversationsDetailScreen,
        page: () => const OutboundConversationsDetailScreen(),
        bindings: [OutboundConversationDetailBinding()]),
    GetPage(
        name: AppRoutes.inboundBusinessInfoScreen,
        page: () => const InboundBusinessInfoScreen(),
        bindings: [InboundBusinessInfoBinding()]),
    GetPage(
        name: AppRoutes.outboundBusinessInfoScreen,
        page: () => const OutboundBusinessInfoScreen(),
        bindings: [OutboundConversationDetailBinding()]),
    GetPage(
        name: AppRoutes.addRechargeScreen,
        page: () => const AddRechargeScreen(),
        bindings: [
          AddRechargeBinding(),
        ]),
    GetPage(
        name: AppRoutes.paymentSuccessfulScreen,
        page: () => const PaymentSuccessfulScreen(),
        bindings: [
          PaymentSuccessfulBinding(),
        ]),
    GetPage(
        name: AppRoutes.paymentFailedScreen,
        page: () => const PaymentFailedScreen(),
        bindings: [
          PaymentFailedBinding(),
        ]),
    GetPage(
        name: AppRoutes.paymentHistoryScreen,
        page: () => const PaymentHistoryScreen(),
        bindings: [
          PaymentHistoryBinding(),
        ]),
    GetPage(
        name: AppRoutes.inboundWhatsappChatScreen,
        page: () => const InboundWhatsappChatScreen(),
        bindings: [
          InboundWhatsappChatBinding(),
        ]),
    GetPage(
        name: AppRoutes.inboundTelegramChatScreen,
        page: () => const InboundTelegramChatScreen(),
        bindings: [
          InboundTelegramChatBinding(),
        ]),
    GetPage(
        name: AppRoutes.inboundEmailScreen,
        page: () => const InboundEmailScreen(),
        bindings: [
          InboundEmailBinding(),
        ]),
    GetPage(
        name: AppRoutes.inboundCalendarScreen,
        page: () => const InboundCalendarScreen(),
        bindings: [
          InboundCalendarBinding(),
        ]),
    GetPage(
        name: AppRoutes.clientScreen,
        page: () => const ClientsScreen(),
        bindings: [
          ClientsBinding(),
        ]),
    GetPage(
        name: AppRoutes.outboundWhatsappChatScreen,
        page: () => const OutboundWhatsappChatScreen(),
        bindings: [
          OutboundWhatsappChatBinding(),
        ]),
    GetPage(
        name: AppRoutes.groupsEntryScreen,
        page: () => const GroupsEntryButtonScreen(),
        bindings: [
          GroupsBinding(),
        ]),
    GetPage(
        name: AppRoutes.groupsLandingScreen,
        page: () => const GroupsLandingScreen(),
        bindings: [
          GroupsBinding(),
        ]),
    GetPage(
        name: AppRoutes.groupDetailScreen,
        page: () => GroupDetailScreen(groupId: Get.parameters['groupId'] ?? ''),
        bindings: [
          GroupsBinding(),
        ]),
    GetPage(
        name: AppRoutes.teamChatsListScreen,
        page: () => const TeamChatsListScreen(),
        bindings: [
          GroupsBinding(),
        ]),
    GetPage(
        name: AppRoutes.helpSupportScreen,
        page: () => const HelpSupportScreen(),
        bindings: [
          HelpSupportBinding(),
        ]),
    GetPage(
        name: AppRoutes.aiLeadsScreen,
        page: () => const AiLeadsCampaignScreen(),
        bindings: [
          AILeadsBinding(),
        ]),
    GetPage(
        name: AppRoutes.aiLeadsCampaignContactsScreen,
        page: () => const AiLeadsCampaignContactsScreen(),
        bindings: [
          AiLeadsCampaignContactsBinding(),
        ]),
    GetPage(
        name: AppRoutes.aiLeadsContactsDetailScreen,
        page: () => const MyAiLeadsContactDetailScreen(),
        bindings: [
          AiLeadsContactDetailBinding(),
        ]),
    GetPage(
      name: rolesScreen,
      page: () => const RolesScreen(),
      binding: RolesBinding(),
    ),
    GetPage(
      name: humanAgentsScreen,
      page: () => const HumanAgentsScreen(),
      bindings: [
        HumanAgentsBinding(),
      ],
    ),
    GetPage(
      name: associatedClientsScreen,
      page: () => const AssociatedClientsScreen(),
      bindings: [
        AssociatedClientsBinding(),
      ],
    ),
    GetPage(
      name: adminClientsScreen,
      page: () => const AdminClientsScreen(),
      bindings: [
        AdminClientsBinding(),
      ],
    ),
    GetPage(
      name: totalPhoneCallsScreen,
      page: () => const TotalPhoneCallsScreen(), // login Screen
      bindings: [TotalPhoneCallsBinding()],
    ),
    GetPage(
      name: incomingCallsScreen,
      page: () => const IncomingCallsScreen(), // login Screen
      bindings: [IncomingCallsBinding()],
    ),
    GetPage(
      name: neverAttendedCallsScreen,
      page: () => const NeverAttendedCallsScreen(), // login Screen
      bindings: [NeverAttendedCallsBinding()],
    ),
    GetPage(
      name: topCallerScreen,
      page: () => const TopCallerScreen(), // login Screen
      bindings: [TopCallerBinding()],
    ),
    GetPage(
      name: perCallScreen,
      page: () => const PerCallScreen(), // login Screen
      bindings: [PerCallBinding()],
    ),
    GetPage(
      name: topTalkedScreen,
      page: () => const TopTalkedScreen(), // login Screen
      bindings: [TopTalkedBinding()],
    ),
    GetPage(
      name: callsScreen,
      page: () => const CallsScreen(), // login Screen
      bindings: [CallsBinding()],
    ),
    GetPage(
      name: myAssignGroupDetailScreen,
      page: () => const MyAssignGroupDetailScreen(), // login Screen
      bindings: [MyAssignGroupDetailBinding()],
    ),
    GetPage(
      name: AppRoutes.contactDetailScreen,
      page: () => const ContactDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.whatsappBulkLandingScreen,
      page: () => const WhatsAppBulkLandingScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => WhatsAppBulkController());
      }),
    ),
    GetPage(
      name: AppRoutes.whatsappTemplatesScreen,
      page: () =>  WhatsAppTemplatesScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => WhatsAppTemplatesController());
      }),
    ),
    GetPage(
      name: AppRoutes.whatsappTemplateDetailsScreen,
      page: () => const WhatsAppTemplateDetailsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => WhatsAppTemplateDetailsController());
      }),
    ),
    GetPage(
      name: AppRoutes.createTemplateScreen,
      page: () => const CreateTemplateScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => CreateTemplateController());
      }),
    ),
    GetPage(
      name: AppRoutes.audienceSelectionScreen,
      page: () =>  AudienceSelectionScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AudienceSelectionController());
      }),
    ),
    GetPage(
      name: AppRoutes.whatsappReportsScreen,
      page: () => const WhatsAppReportsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => WhatsAppReportsController());
      }),
    ),
    GetPage(
      name: AppRoutes.whatsappInboxScreen,
      page: () => const WhatsAppInboxScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => WhatsAppInboxController());
      }),
    ),
    GetPage(
      name: AppRoutes.whatsappMainNavigator,
      page: () => const WhatsAppMainNavigator(),
      bindings: [
        WhatsAppNavBinding(),
      ],
    ),
  ];
}
