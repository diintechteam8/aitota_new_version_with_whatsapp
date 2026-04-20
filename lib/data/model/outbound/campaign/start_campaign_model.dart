class StartCampaignModel {
  bool? success;
  String? message;
  StartCampaignData? data;

  StartCampaignModel({this.success, this.message, this.data});

  StartCampaignModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? StartCampaignData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class StartCampaignData {
  String? campaignId;
  int? totalContacts;
  String? status;

  StartCampaignData({this.campaignId, this.totalContacts, this.status});

  StartCampaignData.fromJson(Map<String, dynamic> json) {
    campaignId = json['campaignId'];
    totalContacts = json['totalContacts'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['campaignId'] = campaignId;
    map['totalContacts'] = totalContacts;
    map['status'] = status;
    return map;
  }
}
