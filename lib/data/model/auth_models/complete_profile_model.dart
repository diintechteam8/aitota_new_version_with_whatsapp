class CompleteProfileModel {
  bool? success;
  String? message;
  UserProfile? profile;
  int? statusCode;

  CompleteProfileModel({this.success, this.message, this.profile, this.statusCode});

  CompleteProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    profile = json['profile'] != null ? UserProfile.fromJson(json['profile']) : null;
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    data['statusCode'] = statusCode;
    return data;
  }
}

class UserProfile {
  String? clientId;
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
  bool? isProfileCompleted;
  String? id;
  String? createdAt;
  String? updatedAt;
  int? v;

  UserProfile({
    this.clientId,
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
    this.isProfileCompleted,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  UserProfile.fromJson(Map<String, dynamic> json) {
    clientId = json['clientId'];
    businessName = json['businessName'];
    businessType = json['businessType'];
    contactNumber = json['contactNumber'];
    contactName = json['contactName'];
    pincode = json['pincode'];
    city = json['city'];
    state = json['state'];
    website = json['website'];
    pancard = json['pancard'];
    gst = json['gst'];
    annualTurnover = json['annualTurnover'];
    isProfileCompleted = json['isProfileCompleted'];
    id = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['clientId'] = clientId;
    data['businessName'] = businessName;
    data['businessType'] = businessType;
    data['contactNumber'] = contactNumber;
    data['contactName'] = contactName;
    data['pincode'] = pincode;
    data['city'] = city;
    data['state'] = state;
    data['website'] = website;
    data['pancard'] = pancard;
    data['gst'] = gst;
    data['annualTurnover'] = annualTurnover;
    data['isProfileCompleted'] = isProfileCompleted;
    data['_id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    return data;
  }
}
