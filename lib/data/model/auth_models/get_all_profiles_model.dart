class GetAllProfilesModel {
  bool? success;
  List<GetAllProfilesModelProfile>? profiles;

  GetAllProfilesModel({this.success, this.profiles});

  GetAllProfilesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['profiles'] != null) {
      profiles = <GetAllProfilesModelProfile>[];
      json['profiles'].forEach((v) {
        profiles!.add(GetAllProfilesModelProfile.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (profiles != null) {
      data['profiles'] = profiles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetAllProfilesModelProfile {
  String? role;
  String? id;
  String? clientUserId;
  String? name;
  String? email;
  bool? isApproved;
  bool? isProfileCompleted;
  String? clientId;
  String? clientName;
  String? logoUrl; // NEW FIELD

  GetAllProfilesModelProfile({
    this.role,
    this.id,
    this.clientUserId,
    this.name,
    this.email,
    this.isApproved,
    this.isProfileCompleted,
    this.clientId,
    this.clientName,
    this.logoUrl,
  });

  GetAllProfilesModelProfile.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    id = json['id'];
    clientUserId = json['clientUserId'];
    name = json['name'];
    email = json['email'];
    isApproved = json['isApproved'];

    // Handle both cases from API
    isProfileCompleted = json['isProfileCompleted'] ??
        json['isprofileCompleted'];

    clientId = json['clientId'];
    clientName = json['clientName'];
    logoUrl = json['logoUrl']; // NEW
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role'] = role;
    data['id'] = id;
    data['clientUserId'] = clientUserId;
    data['name'] = name;
    data['email'] = email;
    data['isApproved'] = isApproved;
    data['isProfileCompleted'] = isProfileCompleted;
    data['clientId'] = clientId;
    data['clientName'] = clientName;
    data['logoUrl'] = logoUrl; // NEW
    return data;
  }
}
