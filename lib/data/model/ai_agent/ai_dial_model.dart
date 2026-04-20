class AiDialModel {
  bool? success;
  Data? data;

  AiDialModel({this.success, this.data});

  AiDialModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Response? response;

  Data({this.response});

  Data.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  String? transactionId;
  String? callerid;
  String? customerNumber;
  String? status;
  String? responseCode;
  String? reason;
  String? uniqueid;
  String? uuid;
  CustomParam? customParam;

  Response(
      {this.transactionId,
        this.callerid,
        this.customerNumber,
        this.status,
        this.responseCode,
        this.reason,
        this.uniqueid,
        this.uuid,
        this.customParam});

  Response.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    callerid = json['callerid'];
    customerNumber = json['customerNumber'];
    status = json['status'];
    responseCode = json['response_code'];
    reason = json['reason'];
    uniqueid = json['uniqueid'];
    uuid = json['uuid'];
    customParam = json['custom_param'] != null
        ? new CustomParam.fromJson(json['custom_param'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_id'] = this.transactionId;
    data['callerid'] = this.callerid;
    data['customerNumber'] = this.customerNumber;
    data['status'] = this.status;
    data['response_code'] = this.responseCode;
    data['reason'] = this.reason;
    data['uniqueid'] = this.uniqueid;
    data['uuid'] = this.uuid;
    if (this.customParam != null) {
      data['custom_param'] = this.customParam!.toJson();
    }
    return data;
  }
}

class CustomParam {
  String? a;
  String? agentName;
  String? purpose;

  CustomParam({this.a, this.agentName, this.purpose});

  CustomParam.fromJson(Map<String, dynamic> json) {
    a = json['a'];
    agentName = json['agentName'];
    purpose = json['purpose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['a'] = this.a;
    data['agentName'] = this.agentName;
    data['purpose'] = this.purpose;
    return data;
  }
}