class CreateBusinessInfoModel {
  final bool? success;
  final BusinessInfoData? data;

  CreateBusinessInfoModel({this.success, this.data});

  factory CreateBusinessInfoModel.fromJson(Map<String, dynamic> json) {
    return CreateBusinessInfoModel(
      success: json['success'],
      data: json['data'] != null ? BusinessInfoData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class BusinessInfoData {
  final String? id;
  final String? clientId;
  final String? text;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  BusinessInfoData({
    this.id,
    this.clientId,
    this.text,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory BusinessInfoData.fromJson(Map<String, dynamic> json) {
    return BusinessInfoData(
      id: json['_id'],
      clientId: json['clientId'],
      text: json['text'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'clientId': clientId,
      'text': text,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
