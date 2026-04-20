import 'google_profiles_response.dart';

class ClientTokenModel {
  final bool? success;
  final String? token;
  final String? message;
  final String? profileId;
  final String? userType;
  final String? id;
  final String? email;
  final String? name;
  final String? clientUserId;
  final bool? isApproved;
  final bool? isprofileCompleted;
  final GoogleProfileTokens? tokens;

  ClientTokenModel({
    this.success,
    this.token,
    this.message,
    this.profileId,
    this.userType,
    this.id,
    this.email,
    this.name,
    this.clientUserId,
    this.isApproved,
    this.isprofileCompleted,
    this.tokens,
  });

  factory ClientTokenModel.fromJson(Map<String, dynamic> json) {
    return ClientTokenModel(
      success: json['success'] ?? true,
      token: json['token'] as String?,
      message: json['message'] as String?,
      profileId: json['profileId'] as String?,
      userType: json['userType'] as String?,
      id: json['id'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      clientUserId: json['clientUserId'] as String?,
      isApproved: json['isApproved'] as bool?,
      isprofileCompleted: json['isprofileCompleted'] as bool?,
      tokens: json['tokens'] != null
          ? GoogleProfileTokens.fromJson(json['tokens'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'token': token,
      'message': message,
      'profileId': profileId,
      'userType': userType,
      'id': id,
      'email': email,
      'name': name,
      'clientUserId': clientUserId,
      'isApproved': isApproved,
      'isprofileCompleted': isprofileCompleted,
      'tokens': tokens?.toJson(),
    };
  }
}
