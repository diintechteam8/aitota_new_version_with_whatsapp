class AddGroupInCampaignModel {
  bool? success;
  AddGroupCampaignData? data;

  AddGroupInCampaignModel({this.success, this.data});

  AddGroupInCampaignModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? AddGroupCampaignData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['success'] = success;
    if (data != null) {
      result['data'] = data!.toJson();
    }
    return result;
  }
}

class AddGroupCampaignData {
  String? sId;
  String? name;
  String? description;
  List<GroupIds>? groupIds;
  String? clientId;
  String? startDate;
  String? endDate;
  String? status;
  List<dynamic>? contacts;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? currentStatus;
  String? id;

  AddGroupCampaignData({
    this.sId,
    this.name,
    this.description,
    this.groupIds,
    this.clientId,
    this.startDate,
    this.endDate,
    this.status,
    this.contacts,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.currentStatus,
    this.id,
  });

  AddGroupCampaignData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    if (json['groupIds'] != null) {
      groupIds = <GroupIds>[];
      json['groupIds'].forEach((v) {
        groupIds!.add(GroupIds.fromJson(v));
      });
    }
    clientId = json['clientId'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    status = json['status'];
    contacts = json['contacts'] != null ? List<dynamic>.from(json['contacts']) : [];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    currentStatus = json['currentStatus'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['_id'] = sId;
    result['name'] = name;
    result['description'] = description;
    if (groupIds != null) {
      result['groupIds'] = groupIds!.map((v) => v.toJson()).toList();
    }
    result['clientId'] = clientId;
    result['startDate'] = startDate;
    result['endDate'] = endDate;
    result['status'] = status;
    if (contacts != null) {
      result['contacts'] = contacts;
    }
    result['createdAt'] = createdAt;
    result['updatedAt'] = updatedAt;
    result['__v'] = iV;
    result['currentStatus'] = currentStatus;
    result['id'] = id;
    return result;
  }
}

class GroupIds {
  String? sId;
  String? name;
  String? description;

  GroupIds({this.sId, this.name, this.description});

  GroupIds.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['_id'] = sId;
    result['name'] = name;
    result['description'] = description;
    return result;
  }
}
