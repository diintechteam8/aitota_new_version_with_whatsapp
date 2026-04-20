class WhatsAiCampaignListModel {
  bool? success;
  WhatsAiCampaignData? data;
  String? message;

  WhatsAiCampaignListModel({this.success, this.data, this.message});

  WhatsAiCampaignListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? WhatsAiCampaignData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class WhatsAiCampaignData {
  List<WhatsAiCampaign>? campaigns;

  WhatsAiCampaignData({this.campaigns});

  WhatsAiCampaignData.fromJson(Map<String, dynamic> json) {
    if (json['campaigns'] != null) {
      campaigns = <WhatsAiCampaign>[];
      json['campaigns'].forEach((v) {
        campaigns!.add(WhatsAiCampaign.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (campaigns != null) {
      data['campaigns'] = campaigns!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WhatsAiCampaign {
  String? sId;
  String? userId;
  String? name;
  String? targetGroup;
  String? template;
  String? status;
  String? scheduledAt;
  int? totalContacts;
  int? sent;
  int? delivered;
  int? read;
  int? failed;
  String? lastError;
  String? createdAt;
  String? updatedAt;
  int? iV;

  WhatsAiCampaign(
      {this.sId,
      this.userId,
      this.name,
      this.targetGroup,
      this.template,
      this.status,
      this.scheduledAt,
      this.totalContacts,
      this.sent,
      this.delivered,
      this.read,
      this.failed,
      this.lastError,
      this.createdAt,
      this.updatedAt,
      this.iV});

  WhatsAiCampaign.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    name = json['name'];
    targetGroup = json['targetGroup'];
    template = json['template'];
    status = json['status'];
    scheduledAt = json['scheduledAt'];
    totalContacts = json['totalContacts'];
    sent = json['sent'];
    delivered = json['delivered'];
    read = json['read'];
    failed = json['failed'];
    lastError = json['lastError'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userId'] = userId;
    data['name'] = name;
    data['targetGroup'] = targetGroup;
    data['template'] = template;
    data['status'] = status;
    data['scheduledAt'] = scheduledAt;
    data['totalContacts'] = totalContacts;
    data['sent'] = sent;
    data['delivered'] = delivered;
    data['read'] = read;
    data['failed'] = failed;
    data['lastError'] = lastError;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
