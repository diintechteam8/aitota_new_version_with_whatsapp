class StopCampaignModel {
  bool? success;
  String? message;
  CampaignStopData? data;

  StopCampaignModel({this.success, this.message, this.data});

  StopCampaignModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] as bool?;
    message = json['message'] as String?;
    data = json['data'] != null
        ? CampaignStopData.fromJson(json['data'])
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

class CampaignStopData {
  String? campaignId;
  String? status;

  CampaignStopData({this.campaignId, this.status});

  CampaignStopData.fromJson(Map<String, dynamic> json) {
    campaignId = json['campaignId'] as String?;
    status = json['status'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['campaignId'] = campaignId;
    map['status'] = status;
    return map;
  }
}
