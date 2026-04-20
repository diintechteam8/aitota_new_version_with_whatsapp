class GoogleLoginModel {
  bool? success;
  String? message;
  String? token;
  String? userType;
  bool? isprofileCompleted;
  bool? isApproved;
  String? id;
  String? email;
  String? name;
  String? profileId; // ✅ Newly added

  GoogleLoginModel({
    this.success,
    this.message,
    this.token,
    this.userType,
    this.isprofileCompleted,
    this.isApproved,
    this.id,
    this.email,
    this.name,
    this.profileId,
  });

  factory GoogleLoginModel.fromJson(Map<String, dynamic> json) {
    return GoogleLoginModel(
      success: json['success'],
      message: json['message'],
      token: json['token'],
      userType: json['userType'],
      isprofileCompleted: json['isprofileCompleted'],
      isApproved: json['isApproved'],
      id: json['id'],
      email: json['email'],
      name: json['name'],
      profileId: json['profileId'], // ✅ Parse new field
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    data['token'] = token;
    data['userType'] = userType;
    data['isprofileCompleted'] = isprofileCompleted;
    data['isApproved'] = isApproved;
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['profileId'] = profileId; // ✅ Include in toJson
    return data;
  }
}
