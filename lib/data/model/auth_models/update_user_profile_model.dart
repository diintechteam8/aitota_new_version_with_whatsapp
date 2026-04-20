class UpdateUserProfileModel {
  bool? success;
  String? message;
  UpdateUserProfileProfile? profile;
  int? statusCode;

  UpdateUserProfileModel({
    this.success,
    this.message,
    this.profile,
    this.statusCode,
  });

  UpdateUserProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    profile = json['profile'] != null
        ? UpdateUserProfileProfile.fromJson(json['profile'])
        : null;
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    data['statusCode'] = statusCode;
    return data;
  }
}

class UpdateUserProfileProfile {
  String? sId;
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
  String? createdAt;
  String? updatedAt;
  int? iV;

  UpdateUserProfileProfile({
    this.sId,
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
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  UpdateUserProfileProfile.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
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
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
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
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
