class GetContactsInGroupsCampaignModel {
  bool? success;
  List<GroupContactData>? data;

  GetContactsInGroupsCampaignModel({this.success, this.data});

  GetContactsInGroupsCampaignModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <GroupContactData>[];
      json['data'].forEach((v) {
        data!.add(GroupContactData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['success'] = success;
    if (data != null) {
      result['data'] = data!.map((v) => v.toJson()).toList();
    }
    return result;
  }
}

class GroupContactData {
  String? sId;
  String? name;
  String? phone;
  String? email;
  String? addedAt;
  String? id;

  GroupContactData({
    this.sId,
    this.name,
    this.phone,
    this.email,
    this.addedAt,
    this.id,
  });

  GroupContactData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    addedAt = json['addedAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['_id'] = sId;
    result['name'] = name;
    result['phone'] = phone;
    result['email'] = email;
    result['addedAt'] = addedAt;
    result['id'] = id;
    return result;
  }
}
