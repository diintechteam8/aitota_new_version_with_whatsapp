class GetProfileModel {
  bool? success;
  String? message;
  String? email;
  String? role;
  Profile? profile;
  int? statusCode;

  GetProfileModel({
    this.success,
    this.message,
    this.email,
    this.role,
    this.profile,
    this.statusCode,
  });

  factory GetProfileModel.fromJson(Map<String, dynamic> json) {
    return GetProfileModel(
      success: json['success'],
      message: json['message'],
      email: json['email'],
      role: json['role'],
      profile:
          json['profile'] != null ? Profile.fromJson(json['profile']) : null,
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'email': email,
      'role': role,
      'profile': profile?.toJson(),
      'statusCode': statusCode,
    };
  }
}

class Profile {
  String? sId;
  String? clientId;
  String? businessName;
  String? email;
  String? contactNumber;
  String? contactName;
  String? address;
  String? clientLogo;
  String? businessLogoKey;
  String? gstNo;
  String? panNo;
  String? role;
  String? city;
  String? pincode;
  bool? isProfileCompleted;
  String? createdAt;

  Profile({
    this.sId,
    this.clientId,
    this.businessName,
    this.email,
    this.contactNumber,
    this.contactName,
    this.address,
    this.clientLogo,
    this.businessLogoKey,
    this.gstNo,
    this.panNo,
    this.role,
    this.city,
    this.pincode,
    this.isProfileCompleted,
    this.createdAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      sId: json['_id'],
      clientId: json['clientId'],
      businessName: json['businessName'],
      email: json['email'],
      contactNumber: json['contactNumber'],
      contactName: json['contactName'],
      address: json['address'],
      clientLogo: json['clientLogo'],
      businessLogoKey: json['businessLogoKey'],
      gstNo: json['gstNo'],
      panNo: json['panNo'],
      role: json['role'],
      city: json['city'],
      pincode: json['pincode'],
      isProfileCompleted: json['isProfileCompleted'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'clientId': clientId,
      'businessName': businessName,
      'email': email,
      'contactNumber': contactNumber,
      'contactName': contactName,
      'address': address,
      'clientLogo': clientLogo,
      'businessLogoKey': businessLogoKey,
      'gstNo': gstNo,
      'panNo': panNo,
      'role': role,
      'city': city,
      'pincode': pincode,
      'isProfileCompleted': isProfileCompleted,
      'createdAt': createdAt,
    };
  }
}
