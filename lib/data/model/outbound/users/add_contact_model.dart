class AddContactModel {
  bool? success;
  AddContactData? data;

  AddContactModel({this.success, this.data});

  AddContactModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? AddContactData.fromJson(json['data']) : null;
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

class AddContactData {
  String? name;
  String? phone;
  String? email;
  String? createdAt;

  AddContactData({this.name, this.phone, this.email, this.createdAt});

  AddContactData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['name'] = name;
    map['phone'] = phone;
    map['email'] = email;
    map['createdAt'] = createdAt;
    return map;
  }
}