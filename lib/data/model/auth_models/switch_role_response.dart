class SwitchRoleResponse {
  final bool? success;
  final String? token;
  final String? userType;
  final String? id;
  final String? email;
  final String? name;
  final bool? isApproved;
  final bool? isprofileCompleted;
  final String? clientId;
  final String? clientUserId;
  final String? clientName;
  final String? humanAgentProfileId;
  final String? clientProfileId;
  final String? profileId;

  SwitchRoleResponse({
    this.success,
    this.token,
    this.userType,
    this.id,
    this.email,
    this.name,
    this.isApproved,
    this.isprofileCompleted,
    this.clientId,
    this.clientUserId,
    this.clientName,
    this.humanAgentProfileId,
    this.clientProfileId,
    this.profileId,
  });

  factory SwitchRoleResponse.fromJson(Map<String, dynamic> json) {
    return SwitchRoleResponse(
      success: json['success'] as bool?,
      token: json['token'] as String?,
      userType: json['userType'] as String?,
      id: json['id'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      isApproved: json['isApproved'] as bool?,
      isprofileCompleted: json['isprofileCompleted'] as bool?,
      clientId: json['clientId'] as String?,
      clientUserId: json['clientUserId'] as String?,
      clientName: json['clientName'] as String?,
      humanAgentProfileId: json['humanAgentProfileId'] as String?,
      clientProfileId: json['clientProfileId'] as String?,
      profileId: json['profileId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'token': token,
        'userType': userType,
        'id': id,
        'email': email,
        'name': name,
        'isApproved': isApproved,
        'isprofileCompleted': isprofileCompleted,
        'clientId': clientId,
        'clientUserId': clientUserId,
        'clientName': clientName,
        'humanAgentProfileId': humanAgentProfileId,
        'clientProfileId': clientProfileId,
        'profileId': profileId,
      };
}

class RoleProfileItem {
  final String? role;
  final String? id;
  final String? clientId;
  final String? clientUserId;
  final String? clientName;
  final String? email;
  final bool? isApproved;
  final bool? isprofileCompleted;

  RoleProfileItem({
    this.role,
    this.id,
    this.clientId,
    this.clientUserId,
    this.clientName,
    this.email,
    this.isApproved,
    this.isprofileCompleted,
  });

  factory RoleProfileItem.fromJson(Map<String, dynamic> json) => RoleProfileItem(
        role: json['role'] as String?,
        id: json['id'] as String?,
        clientId: json['clientId'] as String?,
        clientUserId: json['clientUserId'] as String?,
        clientName: json['clientName'] as String?,
        email: json['email'] as String?,
        isApproved: json['isApproved'] as bool?,
        isprofileCompleted: json['isprofileCompleted'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'role': role,
        'id': id,
        'clientId': clientId,
        'clientUserId': clientUserId,
        'clientName': clientName,
        'email': email,
        'isApproved': isApproved,
        'isprofileCompleted': isprofileCompleted,
      };
}

class RoleProfilesResponse {
  final bool? success;
  final List<RoleProfileItem>? profiles;

  RoleProfilesResponse({this.success, this.profiles});

  factory RoleProfilesResponse.fromJson(Map<String, dynamic> json) {
    final list = json['profiles'] as List<dynamic>?;
    return RoleProfilesResponse(
      success: json['success'] as bool?,
      profiles: list == null
          ? null
          : list.map((e) => RoleProfileItem.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'profiles': profiles?.map((e) => e.toJson()).toList(),
      };
}


