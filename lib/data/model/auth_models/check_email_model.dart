class CheckEmailRequest {
  String? clientId;
  String? email;

  CheckEmailRequest({this.clientId, this.email});

  CheckEmailRequest.fromJson(Map<String, dynamic> json) {
    clientId = json['clientId'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientId'] = clientId;
    data['email'] = email;
    return data;
  }
}

class CheckEmailResponse {
  bool? success;
  String? action;
  bool? clientApproved;
  String? nextStep;
  String? message;
  String? token;
  String? userType;
  String? role;
  CheckEmailUser? user;

  CheckEmailResponse({
    this.success,
    this.action,
    this.clientApproved,
    this.nextStep,
    this.message,
    this.token,
    this.userType,
    this.role,
    this.user,
  });

  CheckEmailResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    action = json['action'];
    clientApproved = json['clientApproved'];
    nextStep = json['nextStep'];
    message = json['message'];
    token = json['token'];
    userType = json['userType'];
    role = json['role'];
    user = json['user'] != null ? CheckEmailUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['action'] = action;
    data['clientApproved'] = clientApproved;
    data['nextStep'] = nextStep;
    data['message'] = message;
    data['token'] = token;
    data['userType'] = userType;
    data['role'] = role;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class CheckEmailUser {
  String? id;
  String? clientId;
  String? email;
  bool? emailVerified;
  bool? mobileVerified;
  bool? profileCompleted;
  String? mobileNumber;

  CheckEmailUser({
    this.id,
    this.clientId,
    this.email,
    this.emailVerified,
    this.mobileVerified,
    this.profileCompleted,
    this.mobileNumber,
  });

  CheckEmailUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['clientId'];
    email = json['email'];
    emailVerified = json['emailVerified'];
    mobileVerified = json['mobileVerified'];
    profileCompleted = json['profileCompleted'];
    mobileNumber = json['mobileNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['clientId'] = clientId;
    data['email'] = email;
    data['emailVerified'] = emailVerified;
    data['mobileVerified'] = mobileVerified;
    data['profileCompleted'] = profileCompleted;
    data['mobileNumber'] = mobileNumber;
    return data;
  }
}
