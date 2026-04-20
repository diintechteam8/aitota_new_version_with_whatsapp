class RegisterStep1Request {
  String? email;
  dynamic password;
  String? clientId;

  RegisterStep1Request({this.email, this.password, this.clientId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['clientId'] = clientId;
    return data;
  }
}

class RegisterStep1Response {
  bool? success;
  String? message;
  String? token;
  String? nextStep;
  String? userId;
  bool? emailVerified;
  String? emailOtpExpiresAt;
  User? user;

  RegisterStep1Response({
    this.success,
    this.message,
    this.token,
    this.nextStep,
    this.userId,
    this.emailVerified,
    this.emailOtpExpiresAt,
    this.user,
  });

  RegisterStep1Response.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    token = json['token'];
    nextStep = json['nextStep'];
    userId = json['userId'];
    emailVerified = json['emailVerified'];
    emailOtpExpiresAt = json['emailOtpExpiresAt'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['token'] = token;
    data['nextStep'] = nextStep;
    data['userId'] = userId;
    data['emailVerified'] = emailVerified;
    data['emailOtpExpiresAt'] = emailOtpExpiresAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? email;
  bool? emailVerified;
  bool? mobileVerified;
  bool? profileCompleted;
  String? mobileNumber;

  User({
    this.id,
    this.email,
    this.emailVerified,
    this.mobileVerified,
    this.profileCompleted,
    this.mobileNumber,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    emailVerified = json['emailVerified'];
    mobileVerified = json['mobileVerified'];
    profileCompleted = json['profileCompleted'];
    mobileNumber = json['mobileNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['emailVerified'] = emailVerified;
    data['mobileVerified'] = mobileVerified;
    data['profileCompleted'] = profileCompleted;
    data['mobileNumber'] = mobileNumber;
    return data;
  }
}
