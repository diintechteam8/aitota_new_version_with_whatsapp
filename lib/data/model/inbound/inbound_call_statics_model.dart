class InboundCallStaticsReportModel {
  final bool success;
  final Data? data;
  final Filter? filter;

  InboundCallStaticsReportModel({
    required this.success,
    this.data,
    this.filter,
  });

  factory InboundCallStaticsReportModel.fromJson(Map<String, dynamic> json) {
    return InboundCallStaticsReportModel(
      success: json['success'] ?? false,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      filter: json['filter'] != null ? Filter.fromJson(json['filter']) : null,
    );
  }
}

class Data {
  final int totalCalls;
  final int totalConnected;
  final int totalNotConnected;
  final int totalConversationTime;
  final double avgCallDuration;

  Data({
    required this.totalCalls,
    required this.totalConnected,
    required this.totalNotConnected,
    required this.totalConversationTime,
    required this.avgCallDuration,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      totalCalls: json['totalCalls'] ?? 0,
      totalConnected: json['totalConnected'] ?? 0,
      totalNotConnected: json['totalNotConnected'] ?? 0,
      totalConversationTime: json['totalConversationTime'] ?? 0,
      avgCallDuration: (json['avgCallDuration'] ?? 0.0).toDouble(),
    );
  }
}

class Filter {
  final String applied;
  final String startDate;
  final String endDate;

  Filter({
    required this.applied,
    required this.startDate,
    required this.endDate,
  });

  factory Filter.fromJson(Map<String, dynamic> json) {
    return Filter(
      applied: json['applied'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
    );
  }
}