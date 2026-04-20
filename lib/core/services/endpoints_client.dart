import 'api_endpoints_contract.dart';

class ApiEndpointsClient implements ApiEndpointsContract {
  @override
  String get baseUrl => "https://app.aitota.com/api/v1/";
  @override
  String get newBaseUrl => "https://app.aitota.com/api/v1/";
  @override
  String get baseUrl1 => "http://test.aitota.com/api/";

  // Auth/profile
  @override
  String get userGoogleLogin => "client/google-login";
  // Keep stubs to satisfy contract usage (not used on client role)
  String get getAllProfiles => 'client/auth/profiles';
  String get postSwitchRole => 'client/auth/switch';
  @override
  String get emailLogin => 'user-auth/login/email-password';
  @override
  String get registerStep1 => 'user-auth/register/step1';
  @override
  String get verifyEmailOtp => 'user-auth/register/step1/verify-email-otp';
  @override
  String get sendMobileOtp => 'user-auth/register/step2/send-mobile-otp';
  @override
  String get verifyMobileOtp => 'user-auth/register/step2/verify-mobile-otp';
  @override
  String get forgotPasswordRequest => 'user-auth/forgot-password/request';

  @override
  String get forgotPasswordResendOtp => 'user-auth/forgot-password/resend-otp';
  @override
  String get verifyForgotPasswordOtp => 'user-auth/forgot-password/verify-otp';
  @override
  String get resetPassword => 'user-auth/forgot-password/reset';
  @override
  String get resendEmailOtp => 'user-auth/register/step1/resend-email-otp';
  @override
  String get checkEmail => 'user-auth/check-email';

  @override
  String get registerStep3 => 'user-auth/register/step3/complete-profile';

  @override
  String get userRegister => 'auth/client/profile';
  @override
  String get pendingApproval => 'client/profile';
  @override
  String get getUserProfile =>
      'https://aitotabackend-sih2.onrender.com/api/v1/auth/client/profile/';

  // ✅ Add new endpoints for client role
  @override
  String get getHumanAgents => 'client/human-agents';
  @override
  String get getAssociatedClients =>
      'client/associations'; // Not used for client role

  // Inbound
  @override
  String get getInboundCallStaticsReport => 'client/inbound/report';
  @override
  String get getInboundConversations => 'client/inbound/logs';
  @override
  String get getInboundLeads => 'client/inbound/leads';
  @override
  String get getInboundClientAgent => 'client/agents';
  @override
  String get updateInboundAiAgent => 'client/agents/mob/';
  @override
  String get updateInboundBusinessInfo => 'client/business-info/';
  @override
  String get syncUserContacts => 'client/sync/contacts';

  // Outbound groups
  @override
  String get outboundCreateGroup => 'client/groups';
  @override
  String get getOutboundGroups => 'client/groups';
  @override
  String get deleteOutboundGroups => 'client/groups/';
  @override
  String get updateOutboundGroups => 'client/groups/';
  @override
  String addContactInGroup(String groupId) => 'client/groups/$groupId/contacts';
  @override
  String deleteContactsInGroup(String groupId, String contactId) =>
      'client/groups/$groupId/contacts/$contactId';

  // My business
  @override
  String get getMyBusinesses => 'client/business';
  @override
  String get addDispositionCallLogs =>
      'https://aitotabackend-sih2.onrender.com/api/v1/client/dials';
  @override
  String get getDialReports => 'client/dials/report';
  @override
  String get getDialLeads =>
      'https://aitotabackend-sih2.onrender.com/api/v1/client/dials/leads';
  @override
  String get addMyBusiness => 'client/business';
  @override
  String get updateMyBusiness => 'client/business/';
  @override
  String get uploadUrlInMyBusiness => 'client/upload-url-mybusiness';
  @override
  String getHistoryCallLogs(String agentId) =>
      'client/agents/$agentId/call-logs';
  @override
  String get uploadCallLogs => 'mobile/call-logs/upload';

  // Generic/logs/misc
  @override
  String get getLiveCallLogs => 'logs';
  @override
  String get getCampaignLiveLogs => 'logs/';
  @override
  String get getSaleDone => 'client/dials/done';
  @override
  String get endCall => 'calls/terminate';

  // Outbound campaigns
  @override
  String get getAllOutboundCampaigns => 'client/campaigns';
  @override
  String get addOutboundCampaign => 'client/campaigns';
  @override
  String get updateOutboundCampaign => 'client/campaigns/';
  @override
  String get deleteOutboundCampaign => 'client/campaigns/';
  @override
  String get getOutboundCampaignById => 'client/campaigns/';
  @override
  String addGroupsInCampaign(String campaignId) =>
      'client/campaigns/$campaignId/groups';
  @override
  String getAllGroupsInCampaign(String campaignId) =>
      'client/campaigns/$campaignId/groups';
  @override
  String deleteGroupsInCampaign(String campaignId, String groupId) =>
      'client/campaigns/$campaignId/groups/$groupId';
  @override
  String get getCampaignContactByGroupId => 'client/groups/';
  @override
  String getCampaignContacts(String campaignId) =>
      'client/campaigns/$campaignId/contacts';
  @override
  String syncContactsInGroup(String campaignId) =>
      'client/campaigns/$campaignId/sync-contacts';
  @override
  String startCampaign(String campaignId) =>
      'client/campaigns/$campaignId/start-calling';
  @override
  String stopCampaign(String campaignId) =>
      'client/campaigns/$campaignId/stop-calling';
  @override
  String getCampaignCompletedCallsTable(String campaignId) =>
      'client/campaigns/$campaignId/leads';
  @override
  String getCampaignCompletedCallsLogs(String campaignId) =>
      'client/campaigns/$campaignId/logs/';
  @override
  String getCampaignCallStats(String campaignId) =>
      'client/campaigns/$campaignId/calling-status';

  // Outbound stats
  @override
  String get getIOutboundCallStaticsReport => 'client/outbound/report';
  @override
  String get getOutboundLeads => 'client/outbound/leads';
  @override
  String get getOutboundConversations => 'client/outbound/logs';

  // Profile / misc
  @override
  String get deleteMyBusiness => 'client/business/';
  @override
  String getAgentName(String agentId) => 'client/agents/$agentId/name';
  @override
  String get getAiAgentChatHistory => 'chat/agents/';
  @override
  String get getByAiAgentIdChatHistory => 'chat/merge';
  @override
  String get addRechargePlan => 'payments/process';
  @override
  String get updateUserProfile => 'auth/client/profile/';

  // Team-only
  @override
  String get getTeamGroups =>
      'https://aitotabackend-sih2.onrender.com/api/v1/client/groups';
  @override
  String getTeamGroupContacts(String groupId) =>
      'https://app.aitota.com/api/v1/client/groups/$groupId';
  @override
  String addContactsInTeamGroup(String groupId) =>
      'human-agent/groups/$groupId/contacts';
  @override
  String deleteContactsInTeamGroup(String groupId, String contactId) =>
      'human-agent/groups/$groupId/contacts/$contactId';

  @override
  String get aiLeadsCampaign => throw UnimplementedError();

  @override
  String get getAiLeadsCampaignContacts => throw UnimplementedError();

  @override
  String getAiLeadsCampaignContactLogs(String campaignId) {
    // TODO: implement getAiLeadsCampaignContactLogs
    throw UnimplementedError();
  }

  // ✅ Add new endpoints for admin operations
  @override
  String get getAdminClients => 'admin/getclients';
  @override
  String getClientToken(String clientId) => 'admin/get-client-token/$clientId';

  // Call Analytics
  @override
  String getCallLogsSummary(String range,
      {String? start, String? end, String? direction}) {
    final queryParams = <String>[];
    queryParams.add('range=$range');
    if (start != null) queryParams.add('start=$start');
    if (end != null) queryParams.add('end=$end');
    if (direction != null) queryParams.add('direction=$direction');
    return 'mobile/call-logs/summary?${queryParams.join('&')}';
  }

  @override
  String getCallLogsAnalysis(String range, String type,
      {String? start, String? end, String? direction}) {
    final queryParams = <String>[];
    queryParams.add('range=$range');
    queryParams.add('type=$type');
    if (start != null) queryParams.add('start=$start');
    if (end != null) queryParams.add('end=$end');
    if (direction != null) queryParams.add('direction=$direction');
    return 'mobile/call-logs/analysis?${queryParams.join('&')}';
  }

  @override
  String getCallLogDetail(String callLogId) => 'mobile/call-logs/id/$callLogId';

  @override
  String get callLogsFilters => 'mobile/call-logs/filters';

  @override
  String get whatsAiContacts => "${newBaseUrl}whatsai/contacts";
}
