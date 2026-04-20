class OutboundConversationsModel {
  bool? success;
  ClientName? clientName;
  List<ConversationData>? data;
  Pagination? pagination;

  OutboundConversationsModel({this.success, this.clientName, this.data, this.pagination});

  OutboundConversationsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    clientName = json['clientName'] != null ? ClientName.fromJson(json['clientName']) : null;
    if (json['data'] != null) {
      data = <ConversationData>[];
      json['data'].forEach((v) {
        data!.add(ConversationData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    if (clientName != null) data['clientName'] = clientName!.toJson();
    if (this.data != null) data['data'] = this.data!.map((v) => v.toJson()).toList();
    if (pagination != null) data['pagination'] = pagination!.toJson();
    return data;
  }
}

class ClientName {
  String? id;
  String? name;

  ClientName({this.id, this.name});

  ClientName.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
  };
}

class ConversationData {
  String? id;
  String? clientId;
  Agent? agent;
  String? mobile;
  String? time;
  String? transcript;
  int? duration;
  String? leadStatus;
  String? streamSid;
  String? callSid;
  Metadata? metadata;
  String? createdAt;
  String? updatedAt;
  int? version;
  String? agentName;

  ConversationData({
    this.id,
    this.clientId,
    this.agent,
    this.mobile,
    this.time,
    this.transcript,
    this.duration,
    this.leadStatus,
    this.streamSid,
    this.callSid,
    this.metadata,
    this.createdAt,
    this.updatedAt,
    this.version,
    this.agentName,
  });

  ConversationData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    clientId = json['clientId'];
    agent = json['agentId'] != null ? Agent.fromJson(json['agentId']) : null;
    mobile = json['mobile'];
    time = json['time'];
    transcript = json['transcript'];
    duration = json['duration'];
    leadStatus = json['leadStatus'];
    streamSid = json['streamSid'];
    callSid = json['callSid'];
    metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    version = json['__v'];
    agentName = json['agentName'];
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'clientId': clientId,
    'agentId': agent?.toJson(),
    'mobile': mobile,
    'time': time,
    'transcript': transcript,
    'duration': duration,
    'leadStatus': leadStatus,
    'streamSid': streamSid,
    'callSid': callSid,
    'metadata': metadata?.toJson(),
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    '__v': version,
    'agentName': agentName,
  };
}

class Agent {
  String? id;
  String? agentName;

  Agent({this.id, this.agentName});

  Agent.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    agentName = json['agentName'];
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'agentName': agentName,
  };
}

class Metadata {
  int? userTranscriptCount;
  int? aiResponseCount;
  List<String>? languages;
  String? callDirection;
  bool? isActive;
  String? lastUpdated;
  CustomParams? customParams;
  String? callerId;
  String? sttProvider;
  String? ttsProvider;
  String? llmProvider;
  int? totalUpdates;
  bool? whatsappSent;
  bool? googleMeetRequested;
  GoogleMeetDetails? googleMeetDetails;
  bool? googleMeetEmailSent;
  String? callEndTime;

  Metadata({
    this.userTranscriptCount,
    this.aiResponseCount,
    this.languages,
    this.callDirection,
    this.isActive,
    this.lastUpdated,
    this.customParams,
    this.callerId,
    this.sttProvider,
    this.ttsProvider,
    this.llmProvider,
    this.totalUpdates,
    this.whatsappSent,
    this.googleMeetRequested,
    this.googleMeetDetails,
    this.googleMeetEmailSent,
    this.callEndTime,
  });

  Metadata.fromJson(Map<String, dynamic> json) {
    userTranscriptCount = json['userTranscriptCount'];
    aiResponseCount = json['aiResponseCount'];
    languages = json['languages']?.cast<String>();
    callDirection = json['callDirection'];
    isActive = json['isActive'];
    lastUpdated = json['lastUpdated'];
    customParams = json['customParams'] != null ? CustomParams.fromJson(json['customParams']) : null;
    callerId = json['callerId'];
    sttProvider = json['sttProvider'];
    ttsProvider = json['ttsProvider'];
    llmProvider = json['llmProvider'];
    totalUpdates = json['totalUpdates'];
    whatsappSent = json['whatsappSent'];
    googleMeetRequested = json['googleMeetRequested'];
    googleMeetDetails = json['googleMeetDetails'] != null ? GoogleMeetDetails.fromJson(json['googleMeetDetails']) : null;
    googleMeetEmailSent = json['googleMeetEmailSent'];
    callEndTime = json['callEndTime'];
  }

  Map<String, dynamic> toJson() => {
    'userTranscriptCount': userTranscriptCount,
    'aiResponseCount': aiResponseCount,
    'languages': languages,
    'callDirection': callDirection,
    'isActive': isActive,
    'lastUpdated': lastUpdated,
    'customParams': customParams?.toJson(),
    'callerId': callerId,
    'sttProvider': sttProvider,
    'ttsProvider': ttsProvider,
    'llmProvider': llmProvider,
    'totalUpdates': totalUpdates,
    'whatsappSent': whatsappSent,
    'googleMeetRequested': googleMeetRequested,
    'googleMeetDetails': googleMeetDetails?.toJson(),
    'googleMeetEmailSent': googleMeetEmailSent,
    'callEndTime': callEndTime,
  };
}

class CustomParams {
  String? uniqueId;

  CustomParams({this.uniqueId});

  CustomParams.fromJson(Map<String, dynamic> json) {
    uniqueId = json['uniqueid'];
  }

  Map<String, dynamic> toJson() => {
    'uniqueid': uniqueId,
  };
}

class GoogleMeetDetails {
  String? status;

  GoogleMeetDetails({this.status});

  GoogleMeetDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  Map<String, dynamic> toJson() => {
    'status': status,
  };
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalItems;
  int? itemsPerPage;
  bool? hasNextPage;
  bool? hasPrevPage;
  int? nextPage;
  int? prevPage;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.itemsPerPage,
    this.hasNextPage,
    this.hasPrevPage,
    this.nextPage,
    this.prevPage,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalItems = json['totalItems'];
    itemsPerPage = json['itemsPerPage'];
    hasNextPage = json['hasNextPage'];
    hasPrevPage = json['hasPrevPage'];
    nextPage = json['nextPage'];
    prevPage = json['prevPage'];
  }

  Map<String, dynamic> toJson() => {
    'currentPage': currentPage,
    'totalPages': totalPages,
    'totalItems': totalItems,
    'itemsPerPage': itemsPerPage,
    'hasNextPage': hasNextPage,
    'hasPrevPage': hasPrevPage,
    'nextPage': nextPage,
    'prevPage': prevPage,
  };
}
