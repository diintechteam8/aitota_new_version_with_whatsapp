class EndCallModel {
  bool? success;
  String? message;
  EndCallData? data;

  EndCallModel({this.success, this.message, this.data});

  EndCallModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] as bool?;
    message = json['message'] as String?;
    data = json['data'] != null
        ? EndCallData.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = {};
    jsonData['success'] = success;
    jsonData['message'] = message;
    if (data != null) {
      jsonData['data'] = data!.toJson();
    }
    return jsonData;
  }
}

class EndCallData {
  String? streamSid;
  String? reason;
  String? method;
  String? timestamp;

  EndCallData({this.streamSid, this.reason, this.method, this.timestamp});

  EndCallData.fromJson(Map<String, dynamic> json) {
    streamSid = json['streamSid'] as String?;
    reason = json['reason'] as String?;
    method = json['method'] as String?;
    timestamp = json['timestamp'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = {};
    jsonData['streamSid'] = streamSid;
    jsonData['reason'] = reason;
    jsonData['method'] = method;
    jsonData['timestamp'] = timestamp;
    return jsonData;
  }
}
