class CampaignCallStatsModel {
  bool? success;
  CampaignData? data;

  CampaignCallStatsModel({this.success, this.data});

  CampaignCallStatsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? CampaignData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class CampaignData {
  String? campaignId;
  bool? isRunning;
  int? totalContacts;
  CampaignProgress? progress;

  CampaignData({this.campaignId, this.isRunning, this.totalContacts, this.progress});

  CampaignData.fromJson(Map<String, dynamic> json) {
    campaignId = json['campaignId'];
    isRunning = json['isRunning'];
    totalContacts = json['totalContacts'];
    progress = json['progress'] != null ? CampaignProgress.fromJson(json['progress']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['campaignId'] = campaignId;
    map['isRunning'] = isRunning;
    map['totalContacts'] = totalContacts;
    if (progress != null) {
      map['progress'] = progress!.toJson();
    }
    return map;
  }
}

class CampaignProgress {
  String? campaignId;
  int? totalContacts;
  int? currentIndex;
  int? completedCalls;
  int? successfulCalls;
  int? failedCalls;
  String? startTime;
  bool? isRunning;
  String? lastCallTime;
  String? endTime;

  CampaignProgress({
    this.campaignId,
    this.totalContacts,
    this.currentIndex,
    this.completedCalls,
    this.successfulCalls,
    this.failedCalls,
    this.startTime,
    this.isRunning,
    this.lastCallTime,
    this.endTime,
  });

  CampaignProgress.fromJson(Map<String, dynamic> json) {
    campaignId = json['campaignId'];
    totalContacts = json['totalContacts'];
    currentIndex = json['currentIndex'];
    completedCalls = json['completedCalls'];
    successfulCalls = json['successfulCalls'];
    failedCalls = json['failedCalls'];
    startTime = json['startTime'];
    isRunning = json['isRunning'];
    lastCallTime = json['lastCallTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['campaignId'] = campaignId;
    map['totalContacts'] = totalContacts;
    map['currentIndex'] = currentIndex;
    map['completedCalls'] = completedCalls;
    map['successfulCalls'] = successfulCalls;
    map['failedCalls'] = failedCalls;
    map['startTime'] = startTime;
    map['isRunning'] = isRunning;
    map['lastCallTime'] = lastCallTime;
    map['endTime'] = endTime;
    return map;
  }
}
