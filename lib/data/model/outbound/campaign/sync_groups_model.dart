class SyncGroupsModel {
  bool? success;
  SyncGroupsData? data;
  String? message;

  SyncGroupsModel({this.success, this.data, this.message});

  SyncGroupsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data =
    json['data'] != null ? SyncGroupsData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class SyncGroupsData {
  int? totalContacts;
  int? totalGroups;
  int? newContactsAdded;

  SyncGroupsData({this.totalContacts, this.totalGroups, this.newContactsAdded});

  SyncGroupsData.fromJson(Map<String, dynamic> json) {
    totalContacts = json['totalContacts'];
    totalGroups = json['totalGroups'];
    newContactsAdded = json['newContactsAdded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['totalContacts'] = totalContacts;
    data['totalGroups'] = totalGroups;
    data['newContactsAdded'] = newContactsAdded;
    return data;
  }
}
