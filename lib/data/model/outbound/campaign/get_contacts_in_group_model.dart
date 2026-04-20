class GetContactsInGroupModel {
  bool? success;
  GroupData? data;

  GetContactsInGroupModel({this.success, this.data});

  GetContactsInGroupModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? GroupData.fromJson(json['data']) : null;
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

class GroupData {
  String? sId;
  String? name;
  String? category;
  String? description;
  List<GroupContact>? contacts;
  List<dynamic>? agentIds; // ✅ fixed (no List<Null>)
  String? clientId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  GroupData({
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

  GroupData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    category = json['category'];
    description = json['description'];
    if (json['contacts'] != null) {
      contacts = <GroupContact>[];
      json['contacts'].forEach((v) {
        contacts!.add(GroupContact.fromJson(v));
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

class GroupContact {
  String? name;
  String? phone;
  String? email;
  String? createdAt;
  String? sId;

  GroupContact({this.name, this.phone, this.email, this.createdAt, this.sId});

  GroupContact.fromJson(Map<String, dynamic> json) {
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
