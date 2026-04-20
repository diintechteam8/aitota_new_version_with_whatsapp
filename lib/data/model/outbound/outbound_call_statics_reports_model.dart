class OutboundCallStaticsReportModel {
  bool? success;
  OutboundCallData? data;
  Filter? filter;

  OutboundCallStaticsReportModel({this.success, this.data, this.filter});

  OutboundCallStaticsReportModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? OutboundCallData.fromJson(json['data']) : null;
    filter = json['filter'] != null ? Filter.fromJson(json['filter']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.filter != null) {
      data['filter'] = this.filter!.toJson();
    }
    return data;
  }
}

class OutboundCallData {
  String? clientId;
  int? totalCalls;
  int? totalConnected;
  int? totalNotConnected;
  int? totalConversationTime;
  double? avgCallDuration;

  OutboundCallData({
    this.clientId,
    this.totalCalls,
    this.totalConnected,
    this.totalNotConnected,
    this.totalConversationTime,
    this.avgCallDuration,
  });

  OutboundCallData.fromJson(Map<String, dynamic> json) {
    clientId = json['clientId'];
    totalCalls = json['totalCalls'];
    totalConnected = json['totalConnected'];
    totalNotConnected = json['totalNotConnected'];
    totalConversationTime = json['totalConversationTime'];
    avgCallDuration = (json['avgCallDuration'] != null)
        ? double.tryParse(json['avgCallDuration'].toString())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['clientId'] = clientId;
    data['totalCalls'] = totalCalls;
    data['totalConnected'] = totalConnected;
    data['totalNotConnected'] = totalNotConnected;
    data['totalConversationTime'] = totalConversationTime;
    data['avgCallDuration'] = avgCallDuration;
    return data;
  }
}

class Filter {
  String? applied;

  Filter({this.applied});

  Filter.fromJson(Map<String, dynamic> json) {
    applied = json['applied'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['applied'] = applied;
    return data;
  }
}
