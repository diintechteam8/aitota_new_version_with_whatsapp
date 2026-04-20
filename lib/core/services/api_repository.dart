import 'package:aitota_business/data/model/CommonModel/common_model.dart';
import 'package:aitota_business/data/model/whatsapp_bulk/whats_ai_contact_model.dart';
import 'package:aitota_business/data/model/whatsapp_bulk/whats_ai_contacts_list_model.dart';
import 'package:aitota_business/data/model/whatsapp_bulk/whats_ai_campaign_model.dart';
import 'package:aitota_business/data/model/ai_agent/end_call_model.dart';
import 'package:aitota_business/data/model/ai_agent/history_call_logs_model.dart';
import 'package:aitota_business/data/model/ai_agent/live_call_logs_model.dart';
import 'package:aitota_business/data/model/auth_models/get_profile_model.dart';
import 'package:aitota_business/data/model/auth_models/pending_approval_model.dart';
import 'package:aitota_business/data/model/auth_models/complete_profile_model.dart';
import 'package:aitota_business/data/model/auth_models/update_user_profile_model.dart';
import 'package:aitota_business/data/model/inbound/inbound_call_statics_model.dart';
import 'package:aitota_business/data/model/inbound/inbound_conversation_model.dart';
import 'package:aitota_business/data/model/inbound/inbound_lead_conversations_model.dart';
import 'package:aitota_business/data/model/inbound/settings/business_info/update_business_info_model.dart';
import 'package:aitota_business/data/model/myBusiness/add_my_business_model.dart';
import 'package:aitota_business/data/model/myBusiness/my_business_model.dart';
import 'package:aitota_business/data/model/myBusiness/update_my_business_model.dart';
import 'package:aitota_business/data/model/myBusiness/upload_image_model.dart';
import 'package:aitota_business/data/model/myDial/add_disposition_model.dart';
import 'package:aitota_business/data/model/myDial/my_dial_leads_model.dart';
import 'package:aitota_business/data/model/myDial/my_dial_reports_model.dart';
import 'package:aitota_business/data/model/myDial/sale_done_model.dart';
import 'package:aitota_business/data/model/outbound/ai_leads/ai_leads_campaign_contacts_model.dart';
import 'package:aitota_business/data/model/outbound/ai_leads/ai_leads_campaigns_model.dart';
import 'package:aitota_business/data/model/outbound/ai_leads/get_ai_leads_campaign_contacts_logs_model.dart';
import 'package:aitota_business/data/model/outbound/campaign/add_group_in_campaign_model.dart';
import 'package:aitota_business/data/model/outbound/campaign/campaign_completed_call_logs_model.dart';
import 'package:aitota_business/data/model/outbound/campaign/get_all_groups_in_campaign_model.dart';
import 'package:aitota_business/data/model/outbound/campaign/start_campaign_model.dart';
import 'package:aitota_business/data/model/outbound/campaign/stop_campaign_model.dart';
import 'package:aitota_business/data/model/outbound/users/add_contact_model.dart';
import 'package:aitota_business/data/model/outbound/users/create_group_model.dart';
import 'package:aitota_business/data/model/outbound/campaign/get_all_campaing_model.dart';
import 'package:aitota_business/data/model/outbound/users/outbound_all_group_model.dart';
import 'package:aitota_business/data/model/outbound/users/sync_contacts_model.dart';
import 'package:aitota_business/data/model/outbound/users/update_group_model.dart';
import 'package:aitota_business/data/model/payment/add_recharge_model.dart';
import 'package:aitota_business/data/team_models/outbound/users/group_contacts_model.dart';
import 'package:aitota_business/data/team_models/outbound/users/team_groups_model.dart';
import 'package:dio/dio.dart' as dio;
import '../../data/model/AgentChatHistory/agent_chat_history_model.dart';
import '../../data/model/AgentChatHistory/get_by_agent_id_chat_history_model.dart';
import '../../data/model/auth_models/admin_clients_model.dart';
import '../../data/model/auth_models/google_login_model.dart';
import '../../data/model/inbound/settings/ai_agent/ai_agent_model.dart';
import '../../data/model/inbound/settings/ai_agent/update_ai_agent_model.dart';
import '../../data/model/outbound/campaign/add_campaign_model.dart';
import '../../data/model/outbound/campaign/campaign_call_stats_model.dart';
import '../../data/model/outbound/campaign/campaign_completed_call_table_model.dart';
import '../../data/model/outbound/campaign/get_contacts_in_group_model.dart';
import '../../data/model/outbound/campaign/live_campaign_call_log_model.dart';
import '../../data/model/outbound/campaign/outbound_campaign_detail_model.dart';
import '../../data/model/outbound/campaign/sync_groups_model.dart';
import '../../data/model/outbound/campaign/update_campaign_campaign_model.dart';
import '../../data/model/outbound/outbound_call_statics_reports_model.dart';
import '../../data/model/outbound/outbound_conversations_model.dart';
import '../../data/model/outbound/outbound_leads_model.dart';
import '../../data/model/auth_models/client_token_model.dart';
import '../../data/model/myDial/upload_call_logs_model.dart';
import '../../data/model/myDial/analysis_models/call_analytics_summary_model.dart';
import '../../data/model/myDial/analysis_models/call_analytics_analysis_model.dart';
import '../../data/model/auth_models/email_login_model.dart';
import '../../data/model/auth_models/register_step1_model.dart';
import '../../data/model/auth_models/otp_models.dart';
import '../../data/model/auth_models/check_email_model.dart';
import '../../data/model/auth_models/register_step3_model.dart';
import '../../data/model/auth_models/forgot_password_model.dart';

abstract class ApiRepository {
  Future<GoogleLoginModel> googleLogin(Map<String, dynamic> request);
  Future<CheckEmailResponse> checkEmail(CheckEmailRequest request);
  Future<RegisterStep3Response> registerStep3(RegisterStep3Request request);
  Future<EmailLoginResponse> loginWithEmail(EmailLoginRequest request);
  Future<RegisterStep1Response> registerStep1(RegisterStep1Request request);
  Future<OtpResponse> verifyEmailOtp(VerifyEmailOtpRequest request);
  Future<OtpResponse> sendMobileOtp(SendMobileOtpRequest request);
  Future<OtpResponse> verifyMobileOtp(VerifyMobileOtpRequest request);
  Future<ForgotPasswordResponse> forgotPasswordRequest(ForgotPasswordRequest request);
  Future<ForgotPasswordResponse> forgotPasswordResendOtp(ForgotPasswordRequest request);
  Future<VerifyForgotPasswordOtpResponse> verifyForgotPasswordOtp(VerifyForgotPasswordOtpRequest request);
  Future<ForgotPasswordResponse> resetPassword(ResetPasswordRequest request);
  Future<OtpResponse> resendEmailOtp(ResendEmailOtpRequest request);
  Future<CompleteProfileModel> userRegister(Map<String, dynamic> request);
  Future<PendingApprovalModel> getPendingApproval();
  Future<GetProfileModel> getUserProfile(String profileId);
  Future<InboundCallStaticsReportModel> getInboundCallStaticsReports({
    String? filter,
    String? startDate,
    String? endDate,
  });
  Future<InboundConversationModel> getInboundConversations({
    String? filter,
    String? startDate,
    String? endDate,
    int page = 1,
  });
  Future<InboundLeadConversationsModel> getInboundLeads({
    String? filter,
    String? startDate,
    String? endDate,
  });
  Future<GetAllAgentsModel> getAllAgents();
  Future<UpdateInboundAiAgentModel> updateInboundAiAgent(
      Map<String, dynamic> request, String agentId);
  Future<UpdateInboundBusinessInfoModel> updateInboundBusinessInfo(
      Map<String, dynamic> request, String agentId);
  Future<SyncContactsModel> syncUserContacts(List<Map<String, String>> request);
  Future<OutboundCreateGroupModel> createGroup(Map<String, dynamic> request);
  Future<OutboundAllGroupModel> getOutboundGroups();
  Future<CommonResponseModel> deleteOutboundGroup(String userId);
  Future<UpdateOutboundGroupModel> updateOutboundGroups(
      String groupId, Map<String, dynamic> request);
  Future<AddContactModel> addContactInGroup(
      Map<String, dynamic> request, String groupId);
  Future<CommonResponseModel> deleteContactInGroup(
      String groupId, String contactId);
  Future<MyBusinessModel> getMyBusinesses();
  Future<AddDispositionCallLogsModel> addDispositionCallLogs(
      Map<String, dynamic> request);
  Future<GetDialLeadsModel> getDialLeads({
    String? filter,
    String? startDate,
    String? endDate,
  });
  Future<GetDialReportsModel> getDialReports({
    String? filter,
    String? startDate,
    String? endDate,
  });
  Future<AddMyBusinessModel> addMyBusiness(Map<String, dynamic> request);

  Future<UpdateMyBusinessModel> updateMyBusiness(
      dio.FormData request, String id);
  Future<UploadImageModel> uploadUrlInMyBusiness({
    required String fileName,
    required String fileType,
  });
  Future<HistoryCallLogsModel> getHistoryCallLogs(String agentId);
  Future<LiveCallLogsModel> getLiveCallLogs(String uniqueId);
  Future<SaleDoneModel> getSaleDone({
    String? filter,
    String? startDate,
    String? endDate,
  });
  Future<EndCallModel> endCall(Map<String, dynamic> request);
  Future<GetAllOutboundCampaignsModel> getAllOutboundCampaigns();
  Future<AddCampaignCampaignModel> createOutboundCampaign(
      Map<String, dynamic> request);
  Future<UpdateCampaignModel> updateOutboundCampaign(
      Map<String, dynamic> request, String campaignId);
  Future<CommonResponseModel> deleteOutboundCampaign(String campaignId);
  Future<GetOutboundCampaignDetailModel> getOutboundCampaignById(
      String campaignId);
  Future<AddGroupInCampaignModel> addGroupsInCampaign(
      Map<String, dynamic> request, String campaignId);
  Future<GetAllGroupsCampaignModel> getCampaignsAllGroup(String campaignId);
  Future<CommonResponseModel> deleteCampaignGroup(
      String campaignId, String groupId);
  // Future<GetContactsInGroupsCampaignModel> getCampaignContacts(String campaignId);
  Future<GetContactsInGroupModel> getCampaignContactsByGroupId(String groupId);
  Future<SyncGroupsModel> syncContactGroups(String campaignId);
  Future<StartCampaignModel> startCampaign(
      Map<String, dynamic> request, String campaignId);
  Future<StopCampaignModel> stopCampaign(
      Map<String, dynamic> request, String campaignId);
  Future<CampaignCompletedCallTableModel> getCompletedCallsTable(
      String campaignId,
      {int page = 1});
  Future<CampaignCompletedCallLogsModel> getCompletedCallsLogs(
      String campaignId, String documentId);
  Future<CampaignCallStatsModel> getCampaignCallStats(String campaignId);
  Future<OutboundCallStaticsReportModel> getOutboundCallStaticsReports({
    String? filter,
    String? startDate,
    String? endDate,
  });
  Future<OutboundLeadsModel> getOutboundLeads({
    String? filter,
    String? startDate,
    String? endDate,
  });
  Future<OutboundConversationsModel> getOutboundConversations({
    String? filter,
    String? startDate,
    String? endDate,
    int page = 1,
  });

  // Future<GetInboundBusinessInfoModel> getInboundBusinessInfo(String documentId);
  // Future<CreateBusinessInfoModel> addInboundBusinessInfo(Map<String, dynamic> request);
  Future<CommonResponseModel> deleteMyBusiness(String businessId);
  Future<GetLiveCampaignCallLogsModel> getCampaignLiveCallsLogs(
      String uniqueId);
  Future<CommonResponseModel> getAgentName(String agentId);
  Future<AgentChatHistoryModel> getAiAgentChatHistory(String clientId);
  Future<GetByAgentIdChatHistoryModel> getByAiAgentChatHistoryDetail(
      String clientId, String agentId);
  Future<AddRechargeModel> addRechargePlan(Map<String, dynamic> request);
  Future<UpdateUserProfileModel> updateUserProfile(
      String userId, Map<String, dynamic> request);

  ///team
  Future<GetTeamGroupsModel> getAllTeamsGroups({String? owner});
  Future<GetTeamGroupContactsModel> getTeamGroupContacts(
  String groupId, {
  required int page,
  required int limit,
});

  Future<AILeadsCampaignModel> getAiLeadsCampaign();
  Future<AiLeadsCampaignContactsModel> getAiLeadsCampaignContacts(
      String campaignId);
  Future<GetAiLeadsCampaignContactsLogsModel> getAiLeadsCampaignContactLogs(
      String campaignId, String documentId);

  /// Get admin clients (GET)
  Future<AdminClientsModel> getAdminClients();

  /// Get client token by client ID (GET)
  Future<ClientTokenModel> getClientToken(String clientId);

  Future<UploadCallLogsResponse> uploadCallLogs(UploadCallLogsRequest request);

  // Call Analytics
  Future<CallAnalyticsSummaryModel> getCallLogsSummary({
    required String range,
    String? start,
    String? end,
    String? direction,
  });

  Future<CallAnalyticsAnalysisModel> getCallLogsAnalysis({
    required String range,
    required String type,
    String? start,
    String? end,
    String? direction,
  });
  Future<CallLogDetailModel> getCallLogDetail(String callLogId);
  Future<WhatsAiContactResponseModel> createWhatsAiContact(Map<String, dynamic> request);
  Future<WhatsAiContactsListModel> getWhatsAiContacts({
    int page = 1,
    int limit = 20,
    String search = "",
  });
  Future<WhatsAiContactResponseModel> updateWhatsAiContact(String id, Map<String, dynamic> request);
  Future<CommonResponseModel> deleteWhatsAiContact(String id);
  Future<WhatsAiCampaignListModel> getWhatsAiCampaigns();
}
