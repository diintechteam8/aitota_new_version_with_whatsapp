class AdminClientsModel {
  final bool? success;
  final int? count;
  final List<ClientData>? data;

  AdminClientsModel({
    this.success,
    this.count,
    this.data,
  });

  factory AdminClientsModel.fromJson(Map<String, dynamic> json) {
    return AdminClientsModel(
      success: json['success'],
      count: json['count'],
      data: json['data'] != null
          ? List<ClientData>.from(
              json['data'].map((v) => ClientData.fromJson(v)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      if (data != null) 'data': data!.map((v) => v.toJson()).toList(),
    };
  }
}

class ClientData {
  final String? id;
  final String? name;
  final String? email;
  final String? clientType;
  final bool? isGoogleUser;
  final String? googleId;
  final String? googlePicture;
  final bool? emailVerified;
  final bool? isProfileCompleted;
  final bool? isApproved;
  final String? createdAt;
  final String? userId;
  final String? businessName;
  final String? businessLogoKey;
  final String? businessLogoUrl;
  final String? gstNo;
  final String? panNo;
  final String? mobileNo;
  final String? address;
  final String? city;
  final String? pincode;
  final String? websiteUrl;

  ClientData({
    this.id,
    this.name,
    this.email,
    this.clientType,
    this.isGoogleUser,
    this.googleId,
    this.googlePicture,
    this.emailVerified,
    this.isProfileCompleted,
    this.isApproved,
    this.createdAt,
    this.userId,
    this.businessName,
    this.businessLogoKey,
    this.businessLogoUrl,
    this.gstNo,
    this.panNo,
    this.mobileNo,
    this.address,
    this.city,
    this.pincode,
    this.websiteUrl,
  });

  factory ClientData.fromJson(Map<String, dynamic> json) {
    return ClientData(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      clientType: json['clientType'],
      isGoogleUser: json['isGoogleUser'],
      googleId: json['googleId'],
      googlePicture: json['googlePicture'],
      emailVerified: json['emailVerified'],
      isProfileCompleted: json['isprofileCompleted'],
      isApproved: json['isApproved'],
      createdAt: json['createdAt'],
      userId: json['userId'],
      businessName: json['businessName'],
      businessLogoKey: json['businessLogoKey'],
      businessLogoUrl: json['businessLogoUrl'],
      gstNo: json['gstNo'],
      panNo: json['panNo'],
      mobileNo: json['mobileNo'],
      address: json['address'],
      city: json['city'],
      pincode: json['pincode'],
      websiteUrl: json['websiteUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'clientType': clientType,
      'isGoogleUser': isGoogleUser,
      'googleId': googleId,
      'googlePicture': googlePicture,
      'emailVerified': emailVerified,
      'isprofileCompleted': isProfileCompleted,
      'isApproved': isApproved,
      'createdAt': createdAt,
      'userId': userId,
      'businessName': businessName,
      'businessLogoKey': businessLogoKey,
      'businessLogoUrl': businessLogoUrl,
      'gstNo': gstNo,
      'panNo': panNo,
      'mobileNo': mobileNo,
      'address': address,
      'city': city,
      'pincode': pincode,
      'websiteUrl': websiteUrl,
    };
  }
}
