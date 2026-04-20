class GetOutboundCampaignDetailModel {
  bool? success;
  OutboundCampaignDetailData? data;

  GetOutboundCampaignDetailModel({this.success, this.data});

  GetOutboundCampaignDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? OutboundCampaignDetailData.fromJson(json['data'])
        : null;
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

class OutboundCampaignDetailData {
  String? id;
  String? name;
  String? description;
  String? category; // ✅ replaced status with category
  List<GroupIds>? groupIds;
  String? clientId;
  DateTime? startDate;
  DateTime? endDate;
  List<Contact>? contacts;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? currentStatus;
  bool? isRunning;
  List<Detail>? details;

  OutboundCampaignDetailData({
    this.id,
    this.name,
    this.description,
    this.category,
    this.groupIds,
    this.clientId,
    this.startDate,
    this.endDate,
    this.contacts,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.currentStatus,
    this.isRunning,
    this.details,
  });

  OutboundCampaignDetailData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    description = json['description'];
    category = json['category']; // ✅ now mapped correctly

    if (json['groupIds'] != null) {
      groupIds = List<GroupIds>.from(
        json['groupIds'].map((v) => GroupIds.fromJson(v)),
      );
    }

    clientId = json['clientId'];
    startDate =
    json['startDate'] != null ? DateTime.parse(json['startDate']) : null;
    endDate = json['endDate'] != null ? DateTime.parse(json['endDate']) : null;

    if (json['contacts'] != null) {
      contacts = List<Contact>.from(
        json['contacts'].map((v) => Contact.fromJson(v)),
      );
    }

    if (json['details'] != null) {
      details = List<Detail>.from(
        json['details'].map((v) => Detail.fromJson(v)),
      );
    }

    createdAt =
    json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    updatedAt =
    json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
    v = json['__v'];
    currentStatus = json['currentStatus'];
    isRunning = json['isRunning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['_id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['category'] = category; // ✅ category added

    if (groupIds != null) {
      map['groupIds'] = groupIds!.map((v) => v.toJson()).toList();
    }

    map['clientId'] = clientId;
    map['startDate'] = startDate?.toIso8601String();
    map['endDate'] = endDate?.toIso8601String();

    if (contacts != null) {
      map['contacts'] = contacts!.map((v) => v.toJson()).toList();
    }

    if (details != null) {
      map['details'] = details!.map((v) => v.toJson()).toList();
    }

    map['createdAt'] = createdAt?.toIso8601String();
    map['updatedAt'] = updatedAt?.toIso8601String();
    map['__v'] = v;
    map['currentStatus'] = currentStatus;
    map['isRunning'] = isRunning;
    map['id'] = id;
    return map;
  }
}

class GroupIds {
  String? id;
  String? name;
  String? description;
  List<Contact>? contacts;

  GroupIds({this.id, this.name, this.description, this.contacts});

  GroupIds.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    description = json['description'];
    if (json['contacts'] != null) {
      contacts = List<Contact>.from(
        json['contacts'].map((v) => Contact.fromJson(v)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['_id'] = id;
    map['name'] = name;
    map['description'] = description;
    if (contacts != null) {
      map['contacts'] = contacts!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Contact {
  String? id;
  String? name;
  String? phone;
  String? email;
  DateTime? createdAt;
  DateTime? addedAt;

  Contact({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.createdAt,
    this.addedAt,
  });

  Contact.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    createdAt =
    json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    addedAt =
    json['addedAt'] != null ? DateTime.parse(json['addedAt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['_id'] = id;
    map['name'] = name;
    map['phone'] = phone;
    map['email'] = email;
    map['createdAt'] = createdAt?.toIso8601String();
    map['addedAt'] = addedAt?.toIso8601String();
    return map;
  }
}

class Detail {
  String? uniqueId;
  String? contactId;
  DateTime? time;
  String? status;
  DateTime? lastStatusUpdate;
  String? id;
  int? callDuration;

  Detail({
    this.uniqueId,
    this.contactId,
    this.time,
    this.status,
    this.lastStatusUpdate,
    this.id,
    this.callDuration,
  });

  Detail.fromJson(Map<String, dynamic> json) {
    uniqueId = json['uniqueId'];
    contactId = json['contactId'];
    time = json['time'] != null ? DateTime.parse(json['time']) : null;
    status = json['status'];
    lastStatusUpdate = json['lastStatusUpdate'] != null
        ? DateTime.parse(json['lastStatusUpdate'])
        : null;
    id = json['_id'] ?? json['id'];
    callDuration = json['callDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['uniqueId'] = uniqueId;
    map['contactId'] = contactId;
    map['time'] = time?.toIso8601String();
    map['status'] = status;
    map['lastStatusUpdate'] = lastStatusUpdate?.toIso8601String();
    map['_id'] = id;
    map['callDuration'] = callDuration;
    return map;
  }
}
