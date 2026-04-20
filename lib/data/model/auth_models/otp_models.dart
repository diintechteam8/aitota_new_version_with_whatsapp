class VerifyEmailOtpRequest {
  String? email;
  String? otp;
  String? clientId;

  VerifyEmailOtpRequest({this.email, this.otp, this.clientId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['otp'] = otp;
    data['clientId'] = clientId;
    return data;
  }
}

class SendMobileOtpRequest {
  String? email;
  String? mobileNumber;
  String? clientId;
  String? otpMethode;

  SendMobileOtpRequest(
      {this.email, this.mobileNumber, this.clientId, this.otpMethode});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['mobileNumber'] = mobileNumber;
    data['clientId'] = clientId;
    data['otpMethode'] = otpMethode;
    return data;
  }
}

class VerifyMobileOtpRequest {
  String? email;
  String? otp;
  String? clientId;

  VerifyMobileOtpRequest({this.email, this.otp, this.clientId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['otp'] = otp;
    data['clientId'] = clientId;
    return data;
  }
}

class OtpResponse {
  bool? success;
  String? message;
  String? nextStep;

  OtpResponse({this.success, this.message, this.nextStep});

  OtpResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    nextStep = json['nextStep'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['nextStep'] = nextStep;
    return data;
  }
}

class ResendEmailOtpRequest {
  String? email;
  String? clientId;

  ResendEmailOtpRequest({this.email, this.clientId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['clientId'] = clientId;
    return data;
  }
}
