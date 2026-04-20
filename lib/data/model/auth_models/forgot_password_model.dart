class ForgotPasswordRequest {
  String? email;
  String? clientId;

  ForgotPasswordRequest({this.email, this.clientId});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'clientId': clientId,
    };
  }
}

class ForgotPasswordResponse {
  bool? success;
  String? message;
  String? resetOtpExpiresAt;

  ForgotPasswordResponse({this.success, this.message, this.resetOtpExpiresAt});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      success: json['success'],
      message: json['message'],
      resetOtpExpiresAt: json['resetOtpExpiresAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'resetOtpExpiresAt': resetOtpExpiresAt,
    };
  }
}

class VerifyForgotPasswordOtpRequest {
  String? email;
  String? clientId;
  String? otp;

  VerifyForgotPasswordOtpRequest({this.email, this.clientId, this.otp});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'clientId': clientId,
      'otp': otp,
    };
  }
}

class VerifyForgotPasswordOtpResponse {
  bool? success;
  String? message;
  String? resetToken;

  VerifyForgotPasswordOtpResponse({this.success, this.message, this.resetToken});

  factory VerifyForgotPasswordOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyForgotPasswordOtpResponse(
      success: json['success'],
      message: json['message'],
      resetToken: json['resetToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'resetToken': resetToken,
    };
  }
}

class ResetPasswordRequest {
  String? email;
  String? clientId;
  String? resetToken;
  String? newPassword;

  ResetPasswordRequest({this.email, this.clientId, this.resetToken, this.newPassword});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'clientId': clientId,
      'resetToken': resetToken,
      'newPassword': newPassword,
    };
  }
}
