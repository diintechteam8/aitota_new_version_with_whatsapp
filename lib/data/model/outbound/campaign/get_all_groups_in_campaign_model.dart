class GetAllGroupsCampaignModel {
  bool? success;
  String? campaignName;
  int? totalGroups;
  List<GroupCampaignData>? data;
  String? campaignId;

  GetAllGroupsCampaignModel({
    this.success,
    this.campaignName,
    this.totalGroups,
    this.data,
    this.campaignId,
  });

  GetAllGroupsCampaignModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    campaignName = json['campaignName'];
    totalGroups = json['totalGroups'];
    if (json['data'] != null) {
      data = <GroupCampaignData>[];
      json['data'].forEach((v) {
        data!.add(GroupCampaignData.fromJson(v));
      });
    }
    campaignId = json['campaignId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['success'] = success;
    result['campaignName'] = campaignName;
    result['totalGroups'] = totalGroups;
    if (data != null) {
      result['data'] = data!.map((v) => v.toJson()).toList();
    }
    result['campaignId'] = campaignId;
    return result;
  }
}

class GroupCampaignData {
  String? sId;
  String? name;
  String? category;
  String? description;
  List<Contacts>? contacts;
  List<dynamic>? agentIds; // ✅ replaced List<Null>
  String? clientId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  GroupCampaignData({
    this.sId,
    this.name,
    this.category,
    this.description,
    this.contacts,
    this.agentIds,
    this.clientId,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  GroupCampaignData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    category = json['category'];
    description = json['description'];
    if (json['contacts'] != null) {
      contacts = <Contacts>[];
      json['contacts'].forEach((v) {
        contacts!.add(Contacts.fromJson(v));
      });
    }
    agentIds = json['agentIds'] != null ? List<dynamic>.from(json['agentIds']) : [];
    clientId = json['clientId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['_id'] = sId;
    result['name'] = name;
    result['category'] = category;
    result['description'] = description;
    if (contacts != null) {
      result['contacts'] = contacts!.map((v) => v.toJson()).toList();
    }
    if (agentIds != null) {
      result['agentIds'] = agentIds;
    }
    result['clientId'] = clientId;
    result['createdAt'] = createdAt;
    result['updatedAt'] = updatedAt;
    result['__v'] = iV;
    return result;
  }
}

class Contacts {
  String? name;
  String? phone;
  String? email;
  String? createdAt;
  String? sId;

  Contacts({
    this.name,
    this.phone,
    this.email,
    this.createdAt,
    this.sId,
  });

  Contacts.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    createdAt = json['createdAt'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['name'] = name;
    result['phone'] = phone;
    result['email'] = email;
    result['createdAt'] = createdAt;
    result['_id'] = sId;
    return result;
  }
}
