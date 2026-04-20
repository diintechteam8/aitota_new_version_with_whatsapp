class GetWhatsappMessageModel {
  String? sId;
  String? waId;
  String? direction;
  String? type;
  String? text;
  String? messageId;
  String? status;
  String? timestamp;
  String? createdAt;
  String? updatedAt;
  int? v;

  GetWhatsappMessageModel({
    this.sId,
    this.waId,
    this.direction,
    this.type,
    this.text,
    this.messageId,
    this.status,
    this.timestamp,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  GetWhatsappMessageModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    waId = json['waID'];
    direction = json['direction'];
    type = json['type'];
    text = json['text'];
    messageId = json['messageId'];
    status = json['status'];
    timestamp = json['timestamp'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['_id'] = sId;
    result['waID'] = waId;
    result['direction'] = direction;
    result['type'] = type;
    result['text'] = text;
    result['messageId'] = messageId;
    result['status'] = status;
    result['timestamp'] = timestamp;
    result['createdAt'] = createdAt;
    result['updatedAt'] = updatedAt;
    result['__v'] = v;
    return result;
  }
}
