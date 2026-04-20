class WhatsAiContactsListModel {
  bool? success;
  WhatsAiListData? data;
  String? message;

  WhatsAiContactsListModel({this.success, this.data, this.message});

  WhatsAiContactsListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? WhatsAiListData.fromJson(json['data']) : null;
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

class WhatsAiListData {
  List<WhatsAiContact>? contacts;
  Pagination? pagination;

  WhatsAiListData({this.contacts, this.pagination});

  WhatsAiListData.fromJson(Map<String, dynamic> json) {
    if (json['contacts'] != null) {
      contacts = <WhatsAiContact>[];
      json['contacts'].forEach((v) {
        contacts!.add(WhatsAiContact.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (contacts != null) {
      data['contacts'] = contacts!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class WhatsAiContact {
  String? sId;
  String? userId;
  String? name;
  String? phone;
  String? email;
  List<String>? tags;
  List<dynamic>? group;
  bool? optedOut;
  String? createdAt;
  String? updatedAt;
  int? iV;

  WhatsAiContact(
      {this.sId,
      this.userId,
      this.name,
      this.phone,
      this.email,
      this.tags,
      this.group,
      this.optedOut,
      this.createdAt,
      this.updatedAt,
      this.iV});

  WhatsAiContact.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    tags = json['tags']?.cast<String>();
    group = json['group'];
    optedOut = json['optedOut'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userId'] = userId;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['tags'] = tags;
    data['group'] = group;
    data['optedOut'] = optedOut;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Pagination {
  int? page;
  int? limit;
  int? total;

  Pagination({this.page, this.limit, this.total});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['limit'] = limit;
    data['total'] = total;
    return data;
  }
}
