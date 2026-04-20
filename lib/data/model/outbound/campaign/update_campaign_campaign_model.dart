class UpdateCampaignModel {
  bool? success;
  UpdateCampaignData? data;

  UpdateCampaignModel({this.success, this.data});

  UpdateCampaignModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? UpdateCampaignData.fromJson(json['data']) : null;
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

class UpdateCampaignData {
  String? id;
  String? name;
  String? description;
  String? category;
  bool? isRunning;
  List<dynamic>? agent;
  List<GroupId>? groupIds;
  String? clientId;
  List<dynamic>? uniqueIds;
  List<Contact>? contacts;
  String? createdAt;
  String? updatedAt;
  int? v;

  UpdateCampaignData({
    this.id,
    this.name,
    this.description,
    this.category,
    this.isRunning,
    this.agent,
    this.groupIds,
    this.clientId,
    this.uniqueIds,
    this.contacts,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  UpdateCampaignData.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    name = json['name'];
    description = json['description'];
    category = json['category'];
    isRunning = json['isRunning'];
    agent = json['agent'] != null ? List<dynamic>.from(json['agent']) : [];
    if (json['groupIds'] != null) {
      groupIds = List<GroupId>.from(json['groupIds'].map((v) => GroupId.fromJson(v)));
    }
    clientId = json['clientId'];
    uniqueIds = json['uniqueIds'] != null ? List<dynamic>.from(json['uniqueIds']) : [];
    if (json['contacts'] != null) {
      contacts = List<Contact>.from(json['contacts'].map((v) => Contact.fromJson(v)));
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
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
    if (contacts != null) {
      map['contacts'] = contacts!.map((v) => v.toJson()).toList();
    }
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
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
