class OutboundAllGroupModel {
  bool? success;
  List<OutboundGroupData>? data;

  OutboundAllGroupModel({this.success, this.data});

  OutboundAllGroupModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <OutboundGroupData>[];
      json['data'].forEach((v) {
        data!.add(OutboundGroupData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = {};
    jsonData['success'] = success;
    if (data != null) {
      jsonData['data'] = data!.map((v) => v.toJson()).toList();
    }
    return jsonData;
  }
}

class OutboundGroupData {
  String? sId;
  String? name;
  String? category;
  String? description;
  String? clientId;
  String? createdAt;
  String? updatedAt;
  int? contactsCount;

  OutboundGroupData({
    this.sId,
    this.name,
    this.category,
    this.description,
    this.clientId,
    this.createdAt,
    this.updatedAt,
    this.contactsCount,
  });

  OutboundGroupData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    category = json['category'];
    description = json['description'];
    clientId = json['clientId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    contactsCount = json['contactsCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = {};
    jsonData['_id'] = sId;
    jsonData['name'] = name;
    jsonData['category'] = category;
    jsonData['description'] = description;
    jsonData['clientId'] = clientId;
    jsonData['createdAt'] = createdAt;
    jsonData['updatedAt'] = updatedAt;
    jsonData['contactsCount'] = contactsCount;
    return jsonData;
  }
}
