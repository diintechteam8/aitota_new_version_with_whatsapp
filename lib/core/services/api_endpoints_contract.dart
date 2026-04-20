/// Abstraction for role-scoped endpoints collections.
abstract class ApiEndpointsContract {
  // Base URLs for different backend hosts
  String get baseUrl; 
  String get newBaseUrl;
  // primary REST API host
  // String get baseUrl1; // secondary host, if any (kept for legacy endpoints)

  // Auth/profile
  String get userGoogleLogin;
  String get userRegister;
  String get pendingApproval;
  String get getUserProfile; // ends with '/'
  // Role management
  String get getAllProfiles; // GET
  String get postSwitchRole; // POST
  String get emailLogin; // POST - email/password login
  String get registerStep1; // POST - registration initial step
  String get verifyEmailOtp; // POST
  String get sendMobileOtp; // POST
  String get verifyMobileOtp; // POST
  String get forgotPasswordRequest; // POST
  String get forgotPasswordResendOtp; // POST
  String get verifyForgotPasswordOtp; // POST
  String get resetPassword; // POST
  String get resendEmailOtp; // POST
  String get checkEmail; // POST
  String get registerStep3; // POST


  // ✅ Add new endpoints for human agents and associated clients
  String get getHumanAgents; // GET - for clients to see their human agents
  String get getAssociatedClients; // GET - for human agents to see their clients

  // Inbound
  String get getInboundCallStaticsReport;
  String get getInboundConversations;
  String get getInboundLeads;
  String get getInboundClientAgent;
  String get updateInboundAiAgent; // ends with '/'
  String get updateInboundBusinessInfo; // ends with '/'
  String get syncUserContacts;

  // Outbound groups
  String get outboundCreateGroup;
  String get getOutboundGroups;
  String get deleteOutboundGroups; // ends with '/'
  String get updateOutboundGroups; // ends with '/'
  String addContactInGroup(String groupId);
  String deleteContactsInGroup(String groupId, String contactId);

  // My business
  String get getMyBusinesses;
  String get addDispositionCallLogs;
  String get getDialReports;
  String get getDialLeads;
  String get addMyBusiness;
  String get updateMyBusiness; // ends with '/'
  String get uploadUrlInMyBusiness;
  String getHistoryCallLogs(String agentId);
  String get uploadCallLogs; // Add this line

  // Generic/logs/misc
  String get getLiveCallLogs;
  String get getCampaignLiveLogs; // ends with '/'
  String get getSaleDone;
  String get endCall;

  // Outbound campaigns
  String get getAllOutboundCampaigns;
  String get addOutboundCampaign;
  String get updateOutboundCampaign; // ends with '/'
  String get deleteOutboundCampaign; // ends with '/'
  String get getOutboundCampaignById; // ends with '/'
  String addGroupsInCampaign(String campaignId);
  String getAllGroupsInCampaign(String campaignId);
  String deleteGroupsInCampaign(String campaignId, String groupId);
  String get getCampaignContactByGroupId; // ends with '/'
  String getCampaignContacts(String campaignId);
  String syncContactsInGroup(String campaignId);
  String startCampaign(String campaignId);
  String stopCampaign(String campaignId);
  String getCampaignCompletedCallsTable(String campaignId);
  String getCampaignCompletedCallsLogs(String campaignId);
  String getCampaignCallStats(String campaignId);

  // Outbound stats
  String get getIOutboundCallStaticsReport;
  String get getOutboundLeads;
  String get getOutboundConversations;

  // Profile / misc
  String get deleteMyBusiness; // ends with '/'
  String getAgentName(String agentId);
  String get getAiAgentChatHistory; // ends with '/'
  String get getByAiAgentIdChatHistory;
  String get addRechargePlan;
  String get updateUserProfile; // ends with '/'

  // Team-only helpers for executive role
  String get getTeamGroups;
  String getTeamGroupContacts(String groupId);
  String addContactsInTeamGroup(String groupId);
  String deleteContactsInTeamGroup(String groupId, String contactId);
  String get aiLeadsCampaign;
  String get getAiLeadsCampaignContacts;
  String getAiLeadsCampaignContactLogs(String campaignId);

  // ✅ Add new endpoints for admin operations
  String get getAdminClients; // GET - for admin to see all clients
  String getClientToken(String clientId); // GET - for admin to get client token

  // Call Analytics
  String getCallLogsSummary(String range, {String? start, String? end, String? direction});
  String getCallLogsAnalysis(String range, String type, {String? start, String? end, String? direction});
  String getCallLogDetail(String callLogId);
  String get callLogsFilters;

  String get whatsAiContacts;
}
