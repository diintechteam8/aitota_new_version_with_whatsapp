class AILeadsCampaignModel {
  bool? success;
  List<AILeadsCampaignData>? data;
  AILeadsCampaignFilter? filter;

  AILeadsCampaignModel({this.success, this.data, this.filter});

  AILeadsCampaignModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <AILeadsCampaignData>[];
      json['data'].forEach((v) {
        data!.add(AILeadsCampaignData.fromJson(v));
      });
    }
    filter = json['filter'] != null
        ? AILeadsCampaignFilter.fromJson(json['filter'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (filter != null) {
      data['filter'] = filter!.toJson();
    }
    return data;
  }
}

class AILeadsCampaignData {
  String? campaignId;
  String? campaignName;
  String? description;
  int? totalAssignedContacts;
  int? connectedContacts;
  int? notConnectedContacts;
  int? connectionRate;
  String? lastAssignedAt;
  int? totalRuns;
  String? campaignCreatedAt;

  AILeadsCampaignData({
    this.campaignId,
    this.campaignName,
    this.description,
    this.totalAssignedContacts,
    this.connectedContacts,
    this.notConnectedContacts,
    this.connectionRate,
    this.lastAssignedAt,
    this.totalRuns,
    this.campaignCreatedAt,
  });

  AILeadsCampaignData.fromJson(Map<String, dynamic> json) {
    campaignId = json['campaignId'];
    campaignName = json['campaignName'];
    description = json['description'];
    totalAssignedContacts = json['totalAssignedContacts'];
    connectedContacts = json['connectedContacts'];
    notConnectedContacts = json['notConnectedContacts'];
    connectionRate = json['connectionRate'];
    lastAssignedAt = json['lastAssignedAt'];
    totalRuns = json['totalRuns'];
    campaignCreatedAt = json['campaignCreatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['campaignId'] = campaignId;
    data['campaignName'] = campaignName;
    data['description'] = description;
    data['totalAssignedContacts'] = totalAssignedContacts;
    data['connectedContacts'] = connectedContacts;
    data['notConnectedContacts'] = notConnectedContacts;
    data['connectionRate'] = connectionRate;
    data['lastAssignedAt'] = lastAssignedAt;
    data['totalRuns'] = totalRuns;
    data['campaignCreatedAt'] = campaignCreatedAt;
    return data;
  }
}

class AILeadsCampaignFilter {
  String? applied;

  AILeadsCampaignFilter({this.applied});

  AILeadsCampaignFilter.fromJson(Map<String, dynamic> json) {
    applied = json['applied'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['applied'] = applied;
    return data;
  }
}
