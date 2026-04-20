class RegisterStep3Request {
  String? clientId;
  String? email;
  String? businessName;
  String? businessType;
  String? contactNumber;
  String? contactName;
  String? pincode;
  String? city;
  String? state;
  String? website;
  String? pancard;
  String? gst;
  String? annualTurnover;

  RegisterStep3Request({
    this.clientId,
    this.email,
    this.businessName,
    this.businessType,
    this.contactNumber,
    this.contactName,
    this.pincode,
    this.city,
    this.state,
    this.website,
    this.pancard,
    this.gst,
    this.annualTurnover,
  });

  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'email': email,
      'businessName': businessName,
      'businessType': businessType,
      'contactNumber': contactNumber,
      'contactName': contactName,
      'pincode': pincode,
      'city': city,
      'state': state,
      'website': website,
      'pancard': pancard,
      'gst': gst,
      'annualTurnover': annualTurnover,
    };
  }
}

class RegisterStep3Response {
  bool? success;
  String? message;
  String? token;
  bool? pendingAdminApproval;
  String? nextStep;
  RegisterStep3User? user;

  RegisterStep3Response({
    this.success,
    this.message,
    this.token,
    this.pendingAdminApproval,
    this.nextStep,
    this.user,
  });

  factory RegisterStep3Response.fromJson(Map<String, dynamic> json) {
    return RegisterStep3Response(
      success: json['success'],
      message: json['message'],
      token: json['token'],
      pendingAdminApproval: json['pendingAdminApproval'],
      nextStep: json['nextStep'],
      user: json['user'] != null ? RegisterStep3User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'token': token,
      'pendingAdminApproval': pendingAdminApproval,
      'nextStep': nextStep,
      'user': user?.toJson(),
    };
  }
}

class RegisterStep3User {
  String? id;
  String? clientId;
  String? email;
  String? mobileNumber;
  bool? emailVerified;
  bool? mobileVerified;
  bool? profileCompleted;
  bool? isProfileCompleted;
  String? businessName;
  String? businessType;
  String? contactNumber;
  String? contactName;
  String? pincode;
  String? city;
  String? state;
  String? website;
  String? pancard;
  String? gst;
  String? annualTurnover;

  RegisterStep3User({
    this.id,
    this.clientId,
    this.email,
    this.mobileNumber,
    this.emailVerified,
    this.mobileVerified,
    this.profileCompleted,
    this.isProfileCompleted,
    this.businessName,
    this.businessType,
    this.contactNumber,
    this.contactName,
    this.pincode,
    this.city,
    this.state,
    this.website,
    this.pancard,
    this.gst,
    this.annualTurnover,
  });

  factory RegisterStep3User.fromJson(Map<String, dynamic> json) {
    return RegisterStep3User(
      id: json['id'],
      clientId: json['clientId'],
      email: json['email'],
      mobileNumber: json['mobileNumber'],
      emailVerified: json['emailVerified'],
      mobileVerified: json['mobileVerified'],
      profileCompleted: json['profileCompleted'],
      isProfileCompleted: json['isProfileCompleted'],
      businessName: json['businessName'],
      businessType: json['businessType'],
      contactNumber: json['contactNumber'],
      contactName: json['contactName'],
      pincode: json['pincode'],
      city: json['city'],
      state: json['state'],
      website: json['website'],
      pancard: json['pancard'],
      gst: json['gst'],
      annualTurnover: json['annualTurnover'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'email': email,
      'mobileNumber': mobileNumber,
      'emailVerified': emailVerified,
      'mobileVerified': mobileVerified,
      'profileCompleted': profileCompleted,
      'isProfileCompleted': isProfileCompleted,
      'businessName': businessName,
      'businessType': businessType,
      'contactNumber': contactNumber,
      'contactName': contactName,
      'pincode': pincode,
      'city': city,
      'state': state,
      'website': website,
      'pancard': pancard,
      'gst': gst,
      'annualTurnover': annualTurnover,
    };
  }
}
