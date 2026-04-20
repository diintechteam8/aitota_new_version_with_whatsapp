class PendingApprovalModel {
  bool? success;
  Data? data;

  PendingApprovalModel({this.success, this.data});

  PendingApprovalModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? name;
  String? email;
  bool? isGoogleUser;
  String? googleId;
  String? googlePicture;
  bool? emailVerified;
  bool? isprofileCompleted;
  bool? isApproved;
  String? createdAt;
  String? userId;
  int? iV;
  String? businessLogoUrl;

  Data(
      {this.sId,
        this.name,
        this.email,
        this.isGoogleUser,
        this.googleId,
        this.googlePicture,
        this.emailVerified,
        this.isprofileCompleted,
        this.isApproved,
        this.createdAt,
        this.userId,
        this.iV,
        this.businessLogoUrl});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    isGoogleUser = json['isGoogleUser'];
    googleId = json['googleId'];
    googlePicture = json['googlePicture'];
    emailVerified = json['emailVerified'];
    isprofileCompleted = json['isprofileCompleted'];
    isApproved = json['isApproved'];
    createdAt = json['createdAt'];
    userId = json['userId'];
    iV = json['__v'];
    businessLogoUrl = json['businessLogoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['isGoogleUser'] = isGoogleUser;
    data['googleId'] = googleId;
    data['googlePicture'] = googlePicture;
    data['emailVerified'] = emailVerified;
    data['isprofileCompleted'] = isprofileCompleted;
    data['isApproved'] = isApproved;
    data['createdAt'] = createdAt;
    data['userId'] = userId;
    data['__v'] = iV;
    data['businessLogoUrl'] = businessLogoUrl;
    return data;
  }
}