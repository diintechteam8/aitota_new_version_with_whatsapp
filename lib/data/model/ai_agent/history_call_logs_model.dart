class HistoryCallLogsModel {
  bool? success;
  Data? data;
  Filter? filter;

  HistoryCallLogsModel({this.success, this.data, this.filter});

  HistoryCallLogsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    filter = json['filter'] != null ? Filter.fromJson(json['filter']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    if (data != null) map['data'] = data!.toJson();
    if (filter != null) map['filter'] = filter!.toJson();
    return map;
  }
}

class Data {
  Agent? agent;
  List<Logs>? logs;
  Statistics? statistics;
  Pagination? pagination;

  Data({this.agent, this.logs, this.statistics, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    agent = json['agent'] != null ? Agent.fromJson(json['agent']) : null;
    if (json['logs'] != null && json['logs'] is List) {
      logs = (json['logs'] as List).map((v) => Logs.fromJson(v)).toList();
    }
    statistics = json['statistics'] != null
        ? Statistics.fromJson(json['statistics'])
        : null;
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (agent != null) map['agent'] = agent!.toJson();
    if (logs != null) map['logs'] = logs!.map((v) => v.toJson()).toList();
    if (statistics != null) map['statistics'] = statistics!.toJson();
    if (pagination != null) map['pagination'] = pagination!.toJson();
    return map;
  }
}

class Agent {
  String? sId;
  String? agentName;
  String? category;
  String? personality;

  Agent({this.sId, this.agentName, this.category, this.personality});

  Agent.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    agentName = json['agentName'];
    category = json['category'];
    personality = json['personality'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'agentName': agentName,
      'category': category,
      'personality': personality,
    };
  }
}

class Logs {
  String? sId;
  String? clientId;
  String? agentId;
  String? mobile;
  String? time;
  String? transcript;
  int? duration;
  String? leadStatus;
  Metadata? metadata;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? audioUrl;
  String? campaignId;

  Logs({
    this.sId,
    this.clientId,
    this.agentId,
    this.mobile,
    this.time,
    this.transcript,
    this.duration,
    this.leadStatus,
    this.metadata,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.audioUrl,
    this.campaignId,
  });

  Logs.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    clientId = json['clientId'];
    agentId = json['agentId'];
    mobile = json['mobile'];
    time = json['time'];
    transcript = json['transcript'];
    duration = json['duration'];
    leadStatus = json['leadStatus'];
    metadata =
    json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    audioUrl = json['audioUrl'];
    campaignId = json['campaignId'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      '_id': sId,
      'clientId': clientId,
      'agentId': agentId,
      'mobile': mobile,
      'time': time,
      'transcript': transcript,
      'duration': duration,
      'leadStatus': leadStatus,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
      'audioUrl': audioUrl,
      'campaignId': campaignId,
    };
    if (metadata != null) map['metadata'] = metadata!.toJson();
    return map;
  }
}

class Metadata {
  int? userTranscriptCount;
  int? aiResponseCount;
  List<String>? languages;
  String? callDirection;
  bool? isActive;
  String? lastUpdated;
  String? callerId;
  String? sttProvider;
  String? ttsProvider;
  String? llmProvider;
  int? totalUpdates;
  String? callEndTime;
  CustomParams? customParams;

  Metadata({
    this.userTranscriptCount,
    this.aiResponseCount,
    this.languages,
    this.callDirection,
    this.isActive,
    this.lastUpdated,
    this.callerId,
    this.sttProvider,
    this.ttsProvider,
    this.llmProvider,
    this.totalUpdates,
    this.callEndTime,
    this.customParams,
  });

  Metadata.fromJson(Map<String, dynamic> json) {
    userTranscriptCount = json['userTranscriptCount'];
    aiResponseCount = json['aiResponseCount'];
    languages = json['languages'] != null
        ? List<String>.from(json['languages'])
        : [];
    callDirection = json['callDirection'];
    isActive = json['isActive'];
    lastUpdated = json['lastUpdated'];
    callerId = json['callerId'];
    sttProvider = json['sttProvider'];
    ttsProvider = json['ttsProvider'];
    llmProvider = json['llmProvider'];
    totalUpdates = json['totalUpdates'];
    callEndTime = json['callEndTime'];
    customParams = json['customParams'] != null
        ? CustomParams.fromJson(json['customParams'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'userTranscriptCount': userTranscriptCount,
      'aiResponseCount': aiResponseCount,
      'languages': languages,
      'callDirection': callDirection,
      'isActive': isActive,
      'lastUpdated': lastUpdated,
      'callerId': callerId,
      'sttProvider': sttProvider,
      'ttsProvider': ttsProvider,
      'llmProvider': llmProvider,
      'totalUpdates': totalUpdates,
      'callEndTime': callEndTime,
    };
    if (customParams != null) map['customParams'] = customParams!.toJson();
    return map;
  }
}

class CustomParams {
  String? agentId;
  String? agentName;
  String? contactName;

  CustomParams({this.agentId, this.agentName, this.contactName});

  CustomParams.fromJson(Map<String, dynamic> json) {
    agentId = json['agentId'];
    agentName = json['agentName'];
    contactName = json['contactName'];
  }

  Map<String, dynamic> toJson() {
    return {
      'agentId': agentId,
      'agentName': agentName,
      'contactName': contactName,
    };
  }
}

class Statistics {
  int? totalCalls;
  int? totalConnected;
  int? totalNotConnected;
  int? totalConversationTime;
  double? avgCallDuration;
  LeadStatusBreakdown? leadStatusBreakdown;

  Statistics({
    this.totalCalls,
    this.totalConnected,
    this.totalNotConnected,
    this.totalConversationTime,
    this.avgCallDuration,
    this.leadStatusBreakdown,
  });

  Statistics.fromJson(Map<String, dynamic> json) {
    totalCalls = json['totalCalls'];
    totalConnected = json['totalConnected'];
    totalNotConnected = json['totalNotConnected'];
    totalConversationTime = json['totalConversationTime'];
    avgCallDuration = (json['avgCallDuration'] is int)
        ? (json['avgCallDuration'] as int).toDouble()
        : json['avgCallDuration'];
    leadStatusBreakdown = json['leadStatusBreakdown'] != null
        ? LeadStatusBreakdown.fromJson(json['leadStatusBreakdown'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'totalCalls': totalCalls,
      'totalConnected': totalConnected,
      'totalNotConnected': totalNotConnected,
      'totalConversationTime': totalConversationTime,
      'avgCallDuration': avgCallDuration,
    };
    if (leadStatusBreakdown != null) {
      map['leadStatusBreakdown'] = leadStatusBreakdown!.toJson();
    }
    return map;
  }
}

class LeadStatusBreakdown {
  int? veryInterested;
  int? maybe;
  int? enrolled;
  int? junkLead;
  int? notRequired;
  int? enrolledOther;
  int? decline;
  int? notEligible;
  int? wrongNumber;
  int? hotFollowup;
  int? coldFollowup;
  int? schedule;
  int? notConnected;

  LeadStatusBreakdown({
    this.veryInterested,
    this.maybe,
    this.enrolled,
    this.junkLead,
    this.notRequired,
    this.enrolledOther,
    this.decline,
    this.notEligible,
    this.wrongNumber,
    this.hotFollowup,
    this.coldFollowup,
    this.schedule,
    this.notConnected,
  });

  LeadStatusBreakdown.fromJson(Map<String, dynamic> json) {
    veryInterested = json['veryInterested'];
    maybe = json['maybe'];
    enrolled = json['enrolled'];
    junkLead = json['junkLead'];
    notRequired = json['notRequired'];
    enrolledOther = json['enrolledOther'];
    decline = json['decline'];
    notEligible = json['notEligible'];
    wrongNumber = json['wrongNumber'];
    hotFollowup = json['hotFollowup'];
    coldFollowup = json['coldFollowup'];
    schedule = json['schedule'];
    notConnected = json['notConnected'];
  }

  Map<String, dynamic> toJson() {
    return {
      'veryInterested': veryInterested,
      'maybe': maybe,
      'enrolled': enrolled,
      'junkLead': junkLead,
      'notRequired': notRequired,
      'enrolledOther': enrolledOther,
      'decline': decline,
      'notEligible': notEligible,
      'wrongNumber': wrongNumber,
      'hotFollowup': hotFollowup,
      'coldFollowup': coldFollowup,
      'schedule': schedule,
      'notConnected': notConnected,
    };
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalLogs;
  bool? hasNextPage;
  bool? hasPrevPage;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.totalLogs,
    this.hasNextPage,
    this.hasPrevPage,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalLogs = json['totalLogs'];
    hasNextPage = json['hasNextPage'];
    hasPrevPage = json['hasPrevPage'];
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalLogs': totalLogs,
      'hasNextPage': hasNextPage,
      'hasPrevPage': hasPrevPage,
    };
  }
}

class Filter {
  String? applied;

  Filter({this.applied});

  Filter.fromJson(Map<String, dynamic> json) {
    applied = json['applied'];
  }

  Map<String, dynamic> toJson() {
    return {
      'applied': applied,
    };
  }
}
