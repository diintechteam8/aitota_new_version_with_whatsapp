class UpdateOutboundGroupModel {
  bool? success;
  GroupData? data;

  UpdateOutboundGroupModel({this.success, this.data});

  UpdateOutboundGroupModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? GroupData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class GroupData {
  String? sId;
  String? name;
  String? category;
  String? description;
  List<Contact>? contacts;
  List<String>? agentIds;
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
      contacts = List<Contact>.from(
        json['contacts'].map((v) => Contact.fromJson(v)),
      );
    }
    if (json['agentIds'] != null) {
      agentIds = List<String>.from(json['agentIds']);
    }
    clientId = json['clientId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'name': name,
      'category': category,
      'description': description,
      'contacts': contacts?.map((v) => v.toJson()).toList(),
      'agentIds': agentIds,
      'clientId': clientId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
    };
  }
}

class Contact {
  String? name;
  String? phone;
  String? email;
  String? createdAt;
  String? sId;

  Contact({
    this.name,
    this.phone,
    this.email,
    this.createdAt,
    this.sId,
  });

  Contact.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    createdAt = json['createdAt'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'createdAt': createdAt,
      '_id': sId,
    };
  }
}
