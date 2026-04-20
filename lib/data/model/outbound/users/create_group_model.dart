class OutboundCreateGroupModel {
  bool? success;
  OutboundGroupData? data;

  OutboundCreateGroupModel({this.success, this.data});

  OutboundCreateGroupModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? OutboundGroupData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class OutboundGroupData {
  String? name;
  String? category;
  String? description;
  List<String>? contacts;
  List<String>? agentIds;
  String? clientId;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  OutboundGroupData({
    this.name,
    this.category,
    this.description,
    this.contacts,
    this.agentIds,
    this.clientId,
    this.sId,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  OutboundGroupData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    category = json['category'];
    description = json['description'];
    contacts = json['contacts'] != null
        ? List<String>.from(json['contacts'])
        : null;
    agentIds = json['agentIds'] != null
        ? List<String>.from(json['agentIds'])
        : null;
    clientId = json['clientId'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = this.name;
    data['category'] = this.category;
    data['description'] = this.description;
    if (this.contacts != null) {
      data['contacts'] = this.contacts;
    }
    if (this.agentIds != null) {
      data['agentIds'] = this.agentIds;
    }
    data['clientId'] = this.clientId;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
