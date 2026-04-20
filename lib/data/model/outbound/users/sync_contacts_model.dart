class SyncContactsModel {
  bool? status;
  String? message;
  Results? results;

  SyncContactsModel({this.status, this.message, this.results});

  SyncContactsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    results = json['results'] != null ? Results.fromJson(json['results']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    if (results != null) {
      data['results'] = results!.toJson();
    }
    return data;
  }
}

class Results {
  List<Success>? success;
  List<dynamic>? duplicates; // Replace dynamic with actual model if available
  List<dynamic>? errors;     // Replace dynamic with actual model if available

  Results({this.success, this.duplicates, this.errors});

  Results.fromJson(Map<String, dynamic> json) {
    if (json['success'] != null) {
      success = List<Success>.from(json['success'].map((v) => Success.fromJson(v)));
    }
    if (json['duplicates'] != null) {
      duplicates = List<dynamic>.from(json['duplicates']);
    }
    if (json['errors'] != null) {
      errors = List<dynamic>.from(json['errors']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (success != null) {
      data['success'] = success!.map((v) => v.toJson()).toList();
    }
    if (duplicates != null) {
      data['duplicates'] = duplicates;
    }
    if (errors != null) {
      data['errors'] = errors;
    }
    return data;
  }
}

class Success {
  int? index;
  ContactData? data;

  Success({this.index, this.data});

  Success.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    data = json['data'] != null ? ContactData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['index'] = index;
    if (data != null) {
      dataMap['data'] = data!.toJson();
    }
    return dataMap;
  }
}

class ContactData {
  String? name;
  String? phone;
  String? email;
  String? clientId;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ContactData({
    this.name,
    this.phone,
    this.email,
    this.clientId,
    this.sId,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  ContactData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    clientId = json['clientId'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['clientId'] = clientId;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
