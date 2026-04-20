// class ApiEndpoints {
//   static const baseUrl = "https://app.aitota.com/api/v1/"; // live server
//   static const baseUrl1 = "https://test.aitota.com/api/";
//
//   static const userGoogleLogin = "client/google-login";
//   static const userRegister = 'auth/client/profile';
//   static const pendingApproval = 'client/profile';
//   static const getUserProfile = 'auth/client/profile/';
//   static const getInboundCallStaticsReport = 'client/inbound/report';
//   static const getInboundConversations = 'client/inbound/logs';
//   static const getInboundLeads = 'client/inbound/leads';
//   static const getInboundClientAgent = 'client/agents';
//   static const updateInboundAiAgent = 'client/agents/mob/';
//   static const updateInboundBusinessInfo = 'client/business-info/';
//   static const syncUserContacts = 'client/sync/contacts';
//   static const outboundCreateGroup = 'client/groups';
//   static const getOutboundGroups = 'client/groups';
//   static const deleteOutboundGroups = 'client/groups/';
//   static const updateOutboundGroups = 'client/groups/';
//   static String addContactInGroup(String groupId) =>
//       'client/groups/$groupId/contacts';
//   static String deleteContactsInGroup(String groupId, String contactId) =>
//       'client/groups/$groupId/contacts/$contactId';
//   static const getMyBusinesses = 'client/business';
//   static const addDispositionCallLogs = 'client/dials'; // pending
//   static const getDialReports = 'client/dials/report'; // pending
//   static const getDialLeads = 'client/dials/leads'; // pending
//   static const addMyBusiness = 'client/business';
//   static const updateMyBusiness = 'client/business/';
//   static const uploadUrlInMyBusiness = 'client/upload-url-mybusiness';
//   static String getHistoryCallLogs(String agentId) =>
//       'client/agents/$agentId/call-logs';
//   static const getLiveCallLogs = 'logs';
//   static const getSaleDone = 'client/dials/done';
//   static const endCall = 'calls/terminate';
//   static const getAllOutboundCampaigns = 'client/campaigns';
//   static const addOutboundCampaign = 'client/campaigns';
//   static const updateOutboundCampaign = 'client/campaigns/';
//   static const deleteOutboundCampaign = 'client/campaigns/';
//   static const getOutboundCampaignById = 'client/campaigns/';
//   static String addGroupsInCampaign(String campaignId) =>
//       'client/campaigns/$campaignId/groups';
//   static String getAllGroupsInCampaign(String campaignId) =>
//       'client/campaigns/$campaignId/groups';
//   static String deleteGroupsInCampaign(String campaignId, String groupId) =>
//       'client/campaigns/$campaignId/groups/$groupId';
//   static const getCampaignContactByGroupId = 'client/groups/';
//   static String getCampaignContacts(String campaignId) =>
//       'client/campaigns/$campaignId/contacts';
//   static String syncContactsInGroup(String campaignId) =>
//       'client/campaigns/$campaignId/sync-contacts';
//   static String startCampaign(String campaignId) =>
//       'client/campaigns/$campaignId/start-calling';
//   static String stopCampaign(String campaignId) =>
//       'client/campaigns/$campaignId/stop-calling';
//   static String getCampaignCompletedCallsTable(String campaignId) =>
//       'client/campaigns/$campaignId/leads';
//   static String getCampaignCompletedCallsLogs(String campaignId) =>
//       'client/campaigns/$campaignId/logs/';
//   static String getCampaignCallStats(String campaignId) =>
//       'client/campaigns/$campaignId/calling-status';
//   static const getIOutboundCallStaticsReport = 'client/outbound/report'; // confirm with summit
//   static const getOutboundLeads = 'client/outbound/leads';
//   static const getOutboundConversations = 'client/outbound/logs';
//   // static const getInboundBusinessInfo = 'client/business-info/';
//   // static const addInboundBusinessInfo = 'client/business-info';
//   static const deleteMyBusiness = 'client/business/';
//   static const getCampaignLiveLogs = 'logs/';
//   static String getAgentName(String agentId) =>
//       'client/agents/$agentId/name';
//   static const getAiAgentChatHistory = 'chat/agents/';
//   static const getByAiAgentIdChatHistory = 'chat/merge';
//   static const addRechargePlan = 'payments/process';
//   static const updateUserProfile = 'auth/client/profile/';
//
//
//
//   /// team endpoints
//
//   static const baseUrlTeam = "https://aitotabackend-sih2.onrender.com/api/v1/";
//   static const getTeamGroups = 'human-agent/groups';
//   static String getTeamGroupContacts(String groupId) =>
//       'human-agent/groups/$groupId/contacts';
//   static String addContactsInTeamGroup(String groupId) =>
//       'human-agent/groups/$groupId/contacts';
//   static String deleteContactsInTeamGroup(String groupId, String contactId) =>
//       'human-agent/groups/$groupId/contacts/$contactId';
//
// }

import 'app_config.dart';

/// Facade class to keep current code readable while delegating to AppConfig
/// for role-aware base URL and endpoints. This avoids duplicating logic in
/// services and repositories.
class ApiEndpoints {
  static AppConfig get _cfg => AppConfig.instance;

  // Base URLs
  static String get baseUrl => _cfg.baseUrl;
  static String get newBaseUrl => _cfg.newBaseUrl;
  // static String get baseUrl1 => _cfg.baseUrl1;

  // Auth/profile
  static String get userGoogleLogin => _cfg.endpoints.userGoogleLogin;
  static String get userRegister => _cfg.endpoints.userRegister;
  static String get pendingApproval => _cfg.endpoints.pendingApproval;
  static String get getUserProfile => _cfg.endpoints.getUserProfile;
  static String get getAllProfiles => _cfg.endpoints.getAllProfiles;
  static String get postSwitchRole => _cfg.endpoints.postSwitchRole;
  static String get emailLogin => _cfg.endpoints.emailLogin;
  static String get registerStep1 => _cfg.endpoints.registerStep1;
  static String get verifyEmailOtp => _cfg.endpoints.verifyEmailOtp;
  static String get sendMobileOtp => _cfg.endpoints.sendMobileOtp;
  static String get verifyMobileOtp => _cfg.endpoints.verifyMobileOtp;
  static String get forgotPasswordRequest => _cfg.endpoints.forgotPasswordRequest;
  static String get forgotPasswordResendOtp => _cfg.endpoints.forgotPasswordResendOtp;
  static String get verifyForgotPasswordOtp => _cfg.endpoints.verifyForgotPasswordOtp;
  static String get resetPassword => _cfg.endpoints.resetPassword;
  static String get resendEmailOtp => _cfg.endpoints.resendEmailOtp;
  static String get checkEmail => _cfg.endpoints.checkEmail;
  static String get registerStep3 => _cfg.endpoints.registerStep3;


  // ✅ Add new endpoints
  static String get getHumanAgents => _cfg.endpoints.getHumanAgents;
  static String get getAssociatedClients => _cfg.endpoints.getAssociatedClients;
  static String get getAdminClients => _cfg.endpoints.getAdminClients;
  static String getClientToken(String clientId) => _cfg.endpoints.getClientToken(clientId);

  // Inbound
  static String get getInboundCallStaticsReport =>
      _cfg.endpoints.getInboundCallStaticsReport;
  static String get getInboundConversations =>
      _cfg.endpoints.getInboundConversations;
  static String get getInboundLeads => _cfg.endpoints.getInboundLeads;
  static String get getInboundClientAgent =>
      _cfg.endpoints.getInboundClientAgent;
  static String get updateInboundAiAgent => _cfg.endpoints.updateInboundAiAgent;
  static String get updateInboundBusinessInfo =>
      _cfg.endpoints.updateInboundBusinessInfo;
  static String get syncUserContacts => _cfg.endpoints.syncUserContacts;

  // Outbound groups
  static String get outboundCreateGroup => _cfg.endpoints.outboundCreateGroup;
  static String get getOutboundGroups => _cfg.endpoints.getOutboundGroups;
  static String get deleteOutboundGroups => _cfg.endpoints.deleteOutboundGroups;
  static String get updateOutboundGroups => _cfg.endpoints.updateOutboundGroups;
  static String addContactInGroup(String groupId) =>
      _cfg.endpoints.addContactInGroup(groupId);
  static String deleteContactsInGroup(String groupId, String contactId) =>
      _cfg.endpoints.deleteContactsInGroup(groupId, contactId);

  // My business
  static String get getMyBusinesses => _cfg.endpoints.getMyBusinesses;
  static String get addDispositionCallLogs =>
      _cfg.endpoints.addDispositionCallLogs;
  static String get getDialReports => _cfg.endpoints.getDialReports;
  static String get getDialLeads => _cfg.endpoints.getDialLeads;
  static String get addMyBusiness => _cfg.endpoints.addMyBusiness;
  static String get updateMyBusiness => _cfg.endpoints.updateMyBusiness;
  static String get uploadUrlInMyBusiness =>
      _cfg.endpoints.uploadUrlInMyBusiness;
  static String getHistoryCallLogs(String agentId) =>
      _cfg.endpoints.getHistoryCallLogs(agentId);
  static String get uploadCallLogs => _cfg.endpoints.uploadCallLogs; // Add this line

  // Generic/logs/misc
  static String get getLiveCallLogs => _cfg.endpoints.getLiveCallLogs;
  static String get getCampaignLiveLogs => _cfg.endpoints.getCampaignLiveLogs;
  static String get getSaleDone => _cfg.endpoints.getSaleDone;
  static String get endCall => _cfg.endpoints.endCall;

  // Outbound campaigns
  static String get getAllOutboundCampaigns =>
      _cfg.endpoints.getAllOutboundCampaigns;
  static String get addOutboundCampaign => _cfg.endpoints.addOutboundCampaign;
  static String get updateOutboundCampaign =>
      _cfg.endpoints.updateOutboundCampaign;
  static String get deleteOutboundCampaign =>
      _cfg.endpoints.deleteOutboundCampaign;
  static String get getOutboundCampaignById =>
      _cfg.endpoints.getOutboundCampaignById;
  static String addGroupsInCampaign(String campaignId) =>
      _cfg.endpoints.addGroupsInCampaign(campaignId);
  static String getAllGroupsInCampaign(String campaignId) =>
      _cfg.endpoints.getAllGroupsInCampaign(campaignId);
  static String deleteGroupsInCampaign(String campaignId, String groupId) =>
      _cfg.endpoints.deleteGroupsInCampaign(campaignId, groupId);
  static String get getCampaignContactByGroupId =>
      _cfg.endpoints.getCampaignContactByGroupId;
  static String getCampaignContacts(String campaignId) =>
      _cfg.endpoints.getCampaignContacts(campaignId);
  static String syncContactsInGroup(String campaignId) =>
      _cfg.endpoints.syncContactsInGroup(campaignId);
  static String startCampaign(String campaignId) =>
      _cfg.endpoints.startCampaign(campaignId);
  static String stopCampaign(String campaignId) =>
      _cfg.endpoints.stopCampaign(campaignId);
  static String getCampaignCompletedCallsTable(String campaignId) =>
      _cfg.endpoints.getCampaignCompletedCallsTable(campaignId);
  static String getCampaignCompletedCallsLogs(String campaignId) =>
      _cfg.endpoints.getCampaignCompletedCallsLogs(campaignId);
  static String getCampaignCallStats(String campaignId) =>
      _cfg.endpoints.getCampaignCallStats(campaignId);

  // Outbound stats
  static String get getIOutboundCallStaticsReport =>
      _cfg.endpoints.getIOutboundCallStaticsReport;
  static String get getOutboundLeads => _cfg.endpoints.getOutboundLeads;
  static String get getOutboundConversations =>
      _cfg.endpoints.getOutboundConversations;

  // Profile / misc
  static String get deleteMyBusiness => _cfg.endpoints.deleteMyBusiness;
  static String getAgentName(String agentId) =>
      _cfg.endpoints.getAgentName(agentId);
  static String get getAiAgentChatHistory =>
      _cfg.endpoints.getAiAgentChatHistory;
  static String get getByAiAgentIdChatHistory =>
      _cfg.endpoints.getByAiAgentIdChatHistory;
  static String get addRechargePlan => _cfg.endpoints.addRechargePlan;
  static String get updateUserProfile => _cfg.endpoints.updateUserProfile;

  // Team-only helpers
  static String get getTeamGroups => _cfg.endpoints.getTeamGroups;
  static String getTeamGroupContacts(String groupId) =>
      _cfg.endpoints.getTeamGroupContacts(groupId);
  static String addContactsInTeamGroup(String groupId) =>
      _cfg.endpoints.addContactsInTeamGroup(groupId);
  static String deleteContactsInTeamGroup(String groupId, String contactId) =>
      _cfg.endpoints.deleteContactsInTeamGroup(groupId, contactId);
  static String get getAiLeadsCampaign => _cfg.endpoints.aiLeadsCampaign;
  static String get getAiLeadsCampaignContacts =>
      _cfg.endpoints.getAiLeadsCampaignContacts;
  static String getAiLeadsCampaignContactLogs(String campaignId) =>
      _cfg.endpoints.getAiLeadsCampaignContactLogs(campaignId);

  // Call Analytics
  static String getCallLogsSummary(String range, {String? start, String? end, String? direction}) =>
      _cfg.endpoints.getCallLogsSummary(range, start: start, end: end, direction: direction);
  static String getCallLogsAnalysis(String range, String type, {String? start, String? end, String? direction}) =>
      _cfg.endpoints.getCallLogsAnalysis(range, type, start: start, end: end, direction: direction);
  static String getCallLogDetail(String callLogId) =>
      _cfg.endpoints.getCallLogDetail(callLogId);
  static String get callLogsFilters => _cfg.endpoints.callLogsFilters;

  static String get whatsAiContacts => _cfg.endpoints.whatsAiContacts;
  static String get whatsAiCampaigns => _cfg.endpoints.whatsAiCampaigns;
}
