class AddCampaignCampaignModel {
  bool? success;
  CampaignData? data;

  AddCampaignCampaignModel({this.success, this.data});

  AddCampaignCampaignModel.fromJson(Map<String, dynamic> json) {
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
  String? id;
  String? name;
  String? description;
  String? category;
  bool? isRunning;
  List<String>? agent;
  List<GroupId>? groupIds;
  String? clientId;
  List<String>? uniqueIds;
  String? startDate;
  String? endDate;
  String? status;
  List<Contact>? contacts;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? currentStatus;

  CampaignData({
    this.id,
    this.name,
    this.description,
    this.category,
    this.isRunning,
    this.agent,
    this.groupIds,
    this.clientId,
    this.uniqueIds,
    this.startDate,
    this.endDate,
    this.status,
    this.contacts,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.currentStatus,
  });

  CampaignData.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    name = json['name'];
    description = json['description'];
    category = json['category'];
    isRunning = json['isRunning'];
    agent = json['agent'] != null ? List<String>.from(json['agent']) : [];
    if (json['groupIds'] != null) {
      groupIds = List<GroupId>.from(
        json['groupIds'].map((v) => GroupId.fromJson(v)),
      );
    }
    clientId = json['clientId'];
    uniqueIds =
    json['uniqueIds'] != null ? List<String>.from(json['uniqueIds']) : [];
    startDate = json['startDate'];
    endDate = json['endDate'];
    status = json['status'];
    if (json['contacts'] != null) {
      contacts = List<Contact>.from(
        json['contacts'].map((v) => Contact.fromJson(v)),
      );
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
    currentStatus = json['currentStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['_id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['category'] = category;
    map['isRunning'] = isRunning;
    map['agent'] = agent;
    if (groupIds != null) {
      map['groupIds'] = groupIds!.map((v) => v.toJson()).toList();
    }
    map['clientId'] = clientId;
    map['uniqueIds'] = uniqueIds;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['status'] = status;
    if (contacts != null) {
      map['contacts'] = contacts!.map((v) => v.toJson()).toList();
    }
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    map['currentStatus'] = currentStatus;
    return map;
  }
}

class GroupId {
  String? id;
  String? name;
  String? description;

  GroupId({this.id, this.name, this.description});

  GroupId.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['_id'] = id;
    map['name'] = name;
    map['description'] = description;
    return map;
  }
}

class Contact {
  String? id;
  String? name;
  String? phone;
  String? email;
  String? addedAt;

  Contact({this.id, this.name, this.phone, this.email, this.addedAt});

  Contact.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    addedAt = json['addedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['_id'] = id;
    map['name'] = name;
    map['phone'] = phone;
    map['email'] = email;
    map['addedAt'] = addedAt;
    return map;
  }
}
