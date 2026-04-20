class AddContactsInGroupModel {
  bool? success;
  AddContactsInGroupData? data;

  AddContactsInGroupModel({this.success, this.data});

  AddContactsInGroupModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? AddContactsInGroupData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AddContactsInGroupData {
  String? sId;
  String? name;
  String? category;
  String? description;
  List<AddContactsInGroupContact>? contacts;
  List<String>? agentIds;
  String? clientId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<String>? assignedHumanAgents;
  String? ownerType;

  AddContactsInGroupData({
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
    this.assignedHumanAgents,
    this.ownerType,
  });

  AddContactsInGroupData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    category = json['category'];
    description = json['description'];

    if (json['contacts'] != null) {
      contacts = List<AddContactsInGroupContact>.from(
        json['contacts'].map((v) => AddContactsInGroupContact.fromJson(v)),
      );
    }

    agentIds = json['agentIds'] != null
        ? List<String>.from(json['agentIds'])
        : null;

    clientId = json['clientId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    assignedHumanAgents = json['assignedHumanAgents'] != null
        ? List<String>.from(json['assignedHumanAgents'])
        : null;
    ownerType = json['ownerType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['category'] = category;
    data['description'] = description;

    if (contacts != null) {
      data['contacts'] = contacts!.map((v) => v.toJson()).toList();
    }
    if (agentIds != null) {
      data['agentIds'] = agentIds;
    }

    data['clientId'] = clientId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (assignedHumanAgents != null) {
      data['assignedHumanAgents'] = assignedHumanAgents;
    }
    data['ownerType'] = ownerType;

    return data;
  }
}

class AddContactsInGroupContact {
  String? sId;
  String? name;
  String? phone;
  String? email;
  String? status;
  String? createdAt;

  AddContactsInGroupContact({
    this.sId,
    this.name,
    this.phone,
    this.email,
    this.status,
    this.createdAt,
  });

  AddContactsInGroupContact.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['status'] = status;
    data['createdAt'] = createdAt;
    return data;
  }
}
