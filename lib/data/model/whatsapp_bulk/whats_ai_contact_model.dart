class WhatsAiContactResponseModel {
  bool? success;
  WhatsAiData? data;
  String? message;

  WhatsAiContactResponseModel({this.success, this.data, this.message});

  WhatsAiContactResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? WhatsAiData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class WhatsAiData {
  WhatsAiContact? contact;

  WhatsAiData({this.contact});

  WhatsAiData.fromJson(Map<String, dynamic> json) {
    contact = json['contact'] != null ? WhatsAiContact.fromJson(json['contact']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (contact != null) {
      data['contact'] = contact!.toJson();
    }
    return data;
  }
}

class WhatsAiContact {
  String? userId;
  String? name;
  String? phone;
  String? email;
  List<String>? tags;
  List<dynamic>? group;
  bool? optedOut;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  WhatsAiContact(
      {this.userId,
      this.name,
      this.phone,
      this.email,
      this.tags,
      this.group,
      this.optedOut,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  WhatsAiContact.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    tags = json['tags'].cast<String>();
    group = json['group'];
    optedOut = json['optedOut'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['tags'] = tags;
    data['group'] = group;
    data['optedOut'] = optedOut;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
