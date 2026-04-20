class EmailLoginRequest {
  String? email;
  dynamic password;
  String? clientId;

  EmailLoginRequest({this.email, this.password, this.clientId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['clientId'] = clientId;
    return data;
  }
}

class EmailLoginResponse {
  bool? success;
  String? message;
  String? token;
  String? nextStep;
  String? userId;
  User? user;
  String? userType;
  String? role;

  EmailLoginResponse({this.success, this.message, this.token, this.nextStep, this.userId, this.user, this.userType, this.role});

  EmailLoginResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    token = json['token'];
    nextStep = json['nextStep'];
    userId = json['userId'];
    userType = json['userType'];
    role = json['role'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['token'] = token;
    data['nextStep'] = nextStep;
    data['userId'] = userId;
    data['userType'] = userType;
    data['role'] = role;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? email;
  String? mobileNumber;
  bool? emailVerified;
  bool? mobileVerified;
  bool? profileCompleted;
  Map<String, dynamic>? profile;

  User({
    this.id,
    this.email,
    this.mobileNumber,
    this.emailVerified,
    this.mobileVerified,
    this.profileCompleted,
    this.profile,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    mobileNumber = json['mobileNumber'];
    emailVerified = json['emailVerified'];
    mobileVerified = json['mobileVerified'];
    profileCompleted = json['profileCompleted'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['mobileNumber'] = mobileNumber;
    data['emailVerified'] = emailVerified;
    data['mobileVerified'] = mobileVerified;
    data['profileCompleted'] = profileCompleted;
    data['profile'] = profile;
    return data;
  }
}
