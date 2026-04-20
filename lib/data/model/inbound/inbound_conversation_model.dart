import 'package:intl/intl.dart';

class InboundConversationModel {
  bool? success;
  ClientName? clientName;
  List<InboundConversationData>? data;
  Pagination? pagination;

  InboundConversationModel({this.success, this.clientName, this.data, this.pagination});

  InboundConversationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    clientName = json['clientName'] != null ? ClientName.fromJson(json['clientName']) : null;
    if (json['data'] != null) {
      data = <InboundConversationData>[];
      json['data'].forEach((v) {
        data!.add(InboundConversationData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['success'] = success;
    if (clientName != null) result['clientName'] = clientName!.toJson();
    if (data != null) result['data'] = data!.map((v) => v.toJson()).toList();
    if (pagination != null) result['pagination'] = pagination!.toJson();
    return result;
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

  Map<String, dynamic> toJson() => {'_id': id, 'name': name};
}

class InboundConversationData {
  String? sId;
  String? clientId;
  AgentId? agentId;
  String? agentName;
  String? campaignId;
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
  int? iV;

  InboundConversationData(
      {this.sId,
        this.clientId,
        this.agentId,
        this.agentName,
        this.campaignId,
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
        this.iV});

  InboundConversationData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    clientId = json['clientId'];
    agentId = json['agentId'] != null ? AgentId.fromJson(json['agentId']) : null;
    agentName = json['agentName'];
    campaignId = json['campaignId'];
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
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['_id'] = sId;
    result['clientId'] = clientId;
    if (agentId != null) result['agentId'] = agentId!.toJson();
    result['agentName'] = agentName;
    result['campaignId'] = campaignId;
    result['mobile'] = mobile;
    result['time'] = time;
    result['transcript'] = transcript;
    result['duration'] = duration;
    result['leadStatus'] = leadStatus;
    result['streamSid'] = streamSid;
    result['callSid'] = callSid;
    if (metadata != null) result['metadata'] = metadata!.toJson();
    result['createdAt'] = createdAt;
    result['updatedAt'] = updatedAt;
    result['__v'] = iV;
    return result;
  }

  String get formattedTime {
    if (time == null || time!.isEmpty) return 'N/A';
    try {
      DateTime dateTime = DateTime.parse(time!).toLocal();
      return DateFormat('dd MMM yyyy, HH:mm').format(dateTime); // Updated format
    } catch (e) {
      print('Error parsing time: $time, Error: $e');
      return 'Invalid date';
    }
  }
}

class AgentId {
  String? sId;
  String? agentName;

  AgentId({this.sId, this.agentName});

  AgentId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    agentName = json['agentName'];
  }

  Map<String, dynamic> toJson() => {'_id': sId, 'agentName': agentName};
}

class Metadata {
  int? userTranscriptCount;
  int? aiResponseCount;
  List<String>? languages;
  String? callDirection;
  bool? isActive;
  String? lastUpdated;
  String? callerId; // keep String
  String? sttProvider;
  String? ttsProvider;
  String? llmProvider;
  int? totalUpdates;
  bool? whatsappSent;
  bool? googleMeetRequested;
  GoogleMeetDetails? googleMeetDetails;
  bool? googleMeetEmailSent;
  String? callEndTime;
  CustomParams? customParams;
  String? leadCategory;

  Metadata(
      {this.userTranscriptCount,
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
        this.whatsappSent,
        this.googleMeetRequested,
        this.googleMeetDetails,
        this.googleMeetEmailSent,
        this.callEndTime,
        this.customParams,
        this.leadCategory});

  Metadata.fromJson(Map<String, dynamic> json) {
    userTranscriptCount = json['userTranscriptCount'];
    aiResponseCount = json['aiResponseCount'];
    languages = json['languages'] != null ? List<String>.from(json['languages']) : [];
    callDirection = json['callDirection'];
    isActive = json['isActive'];
    lastUpdated = json['lastUpdated'];
    callerId = json['callerId']?.toString();
    sttProvider = json['sttProvider'];
    ttsProvider = json['ttsProvider'];
    llmProvider = json['llmProvider'];
    totalUpdates = json['totalUpdates'];
    whatsappSent = json['whatsappSent'];
    googleMeetRequested = json['googleMeetRequested'];
    googleMeetDetails = json['googleMeetDetails'] != null
        ? GoogleMeetDetails.fromJson(json['googleMeetDetails'])
        : null;
    googleMeetEmailSent = json['googleMeetEmailSent'];
    callEndTime = json['callEndTime'];
    customParams = json['customParams'] != null ? CustomParams.fromJson(json['customParams']) : null;
    leadCategory = json['leadCategory'];
  }

  Map<String, dynamic> toJson() {
    return {
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
      'whatsappSent': whatsappSent,
      'googleMeetRequested': googleMeetRequested,
      if (googleMeetDetails != null) 'googleMeetDetails': googleMeetDetails!.toJson(),
      'googleMeetEmailSent': googleMeetEmailSent,
      'callEndTime': callEndTime,
      if (customParams != null) 'customParams': customParams!.toJson(),
      'leadCategory': leadCategory,
    };
  }
}

class GoogleMeetDetails {
  String? status;
  GoogleMeetDetails({this.status});

  GoogleMeetDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  Map<String, dynamic> toJson() => {'status': status};
}

class CustomParams {
  String? uniqueid;
  String? name;

  CustomParams({this.uniqueid, this.name});

  CustomParams.fromJson(Map<String, dynamic> json) {
    uniqueid = json['uniqueid'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() => {'uniqueid': uniqueid, 'name': name};
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

  Pagination(
      {this.currentPage,
        this.totalPages,
        this.totalItems,
        this.itemsPerPage,
        this.hasNextPage,
        this.hasPrevPage,
        this.nextPage,
        this.prevPage});

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
