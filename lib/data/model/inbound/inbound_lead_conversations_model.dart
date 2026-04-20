class InboundLeadConversationsModel {
  bool? success;
  InboundLeadData? data;
  FilterModel? filter;

  InboundLeadConversationsModel({this.success, this.data, this.filter});

  InboundLeadConversationsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? InboundLeadData.fromJson(json['data']) : null;
    filter = json['filter'] != null ? FilterModel.fromJson(json['filter']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
      'filter': filter?.toJson(),
    };
  }
}

class InboundLeadData {
  LeadCategory? veryInterested;
  LeadCategory? maybe;
  LeadCategory? enrolled;
  LeadCategory? junkLead;
  LeadCategory? notRequired;
  LeadCategory? enrolledOther;
  LeadCategory? decline;
  LeadCategory? notEligible;
  LeadCategory? wrongNumber;
  LeadCategory? hotFollowup;
  LeadCategory? coldFollowup;
  LeadCategory? schedule;
  LeadCategory? notConnected;

  InboundLeadData({
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

  InboundLeadData.fromJson(Map<String, dynamic> json) {
    veryInterested = json['veryInterested'] != null ? LeadCategory.fromJson(json['veryInterested']) : null;
    maybe = json['maybe'] != null ? LeadCategory.fromJson(json['maybe']) : null;
    enrolled = json['enrolled'] != null ? LeadCategory.fromJson(json['enrolled']) : null;
    junkLead = json['junkLead'] != null ? LeadCategory.fromJson(json['junkLead']) : null;
    notRequired = json['notRequired'] != null ? LeadCategory.fromJson(json['notRequired']) : null;
    enrolledOther = json['enrolledOther'] != null ? LeadCategory.fromJson(json['enrolledOther']) : null;
    decline = json['decline'] != null ? LeadCategory.fromJson(json['decline']) : null;
    notEligible = json['notEligible'] != null ? LeadCategory.fromJson(json['notEligible']) : null;
    wrongNumber = json['wrongNumber'] != null ? LeadCategory.fromJson(json['wrongNumber']) : null;
    hotFollowup = json['hotFollowup'] != null ? LeadCategory.fromJson(json['hotFollowup']) : null;
    coldFollowup = json['coldFollowup'] != null ? LeadCategory.fromJson(json['coldFollowup']) : null;
    schedule = json['schedule'] != null ? LeadCategory.fromJson(json['schedule']) : null;
    notConnected = json['notConnected'] != null ? LeadCategory.fromJson(json['notConnected']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'veryInterested': veryInterested?.toJson(),
      'maybe': maybe?.toJson(),
      'enrolled': enrolled?.toJson(),
      'junkLead': junkLead?.toJson(),
      'notRequired': notRequired?.toJson(),
      'enrolledOther': enrolledOther?.toJson(),
      'decline': decline?.toJson(),
      'notEligible': notEligible?.toJson(),
      'wrongNumber': wrongNumber?.toJson(),
      'hotFollowup': hotFollowup?.toJson(),
      'coldFollowup': coldFollowup?.toJson(),
      'schedule': schedule?.toJson(),
      'notConnected': notConnected?.toJson(),
    };
  }
}

class LeadCategory {
  List<LeadItem>? data;
  int? count;

  LeadCategory({this.data, this.count});

  LeadCategory.fromJson(Map<String, dynamic> json) {
    data = (json['data'] as List?)?.map((e) => LeadItem.fromJson(e)).toList();
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((e) => e.toJson()).toList(),
      'count': count,
    };
  }
}

class LeadItem {
  String? id;
  String? clientId;
  String? agentId;
  String? mobile;
  String? time;
  String? transcript;
  int? duration;
  String? leadStatus;
  String? streamSid;
  String? callSid;
  String? disposition;
  String? subDisposition;
  String? dispositionId;
  String? subDispositionId;
  Metadata? metadata;
  String? createdAt;
  String? updatedAt;
  int? v;

  LeadItem({
    this.id,
    this.clientId,
    this.agentId,
    this.mobile,
    this.time,
    this.transcript,
    this.duration,
    this.leadStatus,
    this.streamSid,
    this.callSid,
    this.disposition,
    this.subDisposition,
    this.dispositionId,
    this.subDispositionId,
    this.metadata,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  LeadItem.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    clientId = json['clientId'];
    agentId = json['agentId'];
    mobile = json['mobile'];
    time = json['time'];
    transcript = json['transcript'];
    duration = json['duration'];
    leadStatus = json['leadStatus'];
    streamSid = json['streamSid'];
    callSid = json['callSid'];
    disposition = json['disposition'];
    subDisposition = json['subDisposition'];
    dispositionId = json['dispositionId'];
    subDispositionId = json['subDispositionId'];
    metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'clientId': clientId,
      'agentId': agentId,
      'mobile': mobile,
      'time': time,
      'transcript': transcript,
      'duration': duration,
      'leadStatus': leadStatus,
      'streamSid': streamSid,
      'callSid': callSid,
      'disposition': disposition,
      'subDisposition': subDisposition,
      'dispositionId': dispositionId,
      'subDispositionId': subDispositionId,
      'metadata': metadata?.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class Metadata {
  bool? whatsappRequested;
  bool? whatsappMessageSent;
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

  Metadata({
    this.whatsappRequested,
    this.whatsappMessageSent,
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
  });

  Metadata.fromJson(Map<String, dynamic> json) {
    whatsappRequested = json['whatsappRequested'];
    whatsappMessageSent = json['whatsappMessageSent'];
    userTranscriptCount = json['userTranscriptCount'];
    aiResponseCount = json['aiResponseCount'];
    languages = (json['languages'] as List?)?.map((e) => e.toString()).toList();
    callDirection = json['callDirection'];
    isActive = json['isActive'];
    lastUpdated = json['lastUpdated'];
    callerId = json['callerId'];
    sttProvider = json['sttProvider'];
    ttsProvider = json['ttsProvider'];
    llmProvider = json['llmProvider'];
    totalUpdates = json['totalUpdates'];
    callEndTime = json['callEndTime'];
  }

  Map<String, dynamic> toJson() {
    return {
      'whatsappRequested': whatsappRequested,
      'whatsappMessageSent': whatsappMessageSent,
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
  }
}

class FilterModel {
  String? applied;
  String? startDate;
  String? endDate;

  FilterModel({this.applied, this.startDate, this.endDate});

  FilterModel.fromJson(Map<String, dynamic> json) {
    applied = json['applied'];
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    return {
      'applied': applied,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}




// class InboundLeadConversationsModel {
//   bool? success;
//   InboundLeadData? data;
//   FilterModel? filter;
//
//   InboundLeadConversationsModel({this.success, this.data, this.filter});
//
//   InboundLeadConversationsModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     data = json['data'] != null ? InboundLeadData.fromJson(json['data']) : null;
//     filter = json['filter'] != null ? FilterModel.fromJson(json['filter']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'data': data?.toJson(),
//       'filter': filter?.toJson(),
//     };
//   }
// }
//
// class InboundLeadData {
//   LeadCategory? veryInterested;
//   LeadCategory? maybe;
//   LeadCategory? enrolled;
//   LeadCategory? junkLead;
//   LeadCategory? notRequired;
//   LeadCategory? enrolledOther;
//   LeadCategory? decline;
//   LeadCategory? notEligible;
//   LeadCategory? wrongNumber;
//   LeadCategory? hotFollowup;
//   LeadCategory? coldFollowup;
//   LeadCategory? schedule;
//   LeadCategory? notConnected;
//
//   InboundLeadData({
//     this.veryInterested,
//     this.maybe,
//     this.enrolled,
//     this.junkLead,
//     this.notRequired,
//     this.enrolledOther,
//     this.decline,
//     this.notEligible,
//     this.wrongNumber,
//     this.hotFollowup,
//     this.coldFollowup,
//     this.schedule,
//     this.notConnected,
//   });
//
//   InboundLeadData.fromJson(Map<String, dynamic> json) {
//     veryInterested = json['veryInterested'] != null ? LeadCategory.fromJson(json['veryInterested']) : null;
//     maybe = json['maybe'] != null ? LeadCategory.fromJson(json['maybe']) : null;
//     enrolled = json['enrolled'] != null ? LeadCategory.fromJson(json['enrolled']) : null;
//     junkLead = json['junkLead'] != null ? LeadCategory.fromJson(json['junkLead']) : null;
//     notRequired = json['notRequired'] != null ? LeadCategory.fromJson(json['notRequired']) : null;
//     enrolledOther = json['enrolledOther'] != null ? LeadCategory.fromJson(json['enrolledOther']) : null;
//     decline = json['decline'] != null ? LeadCategory.fromJson(json['decline']) : null;
//     notEligible = json['notEligible'] != null ? LeadCategory.fromJson(json['notEligible']) : null;
//     wrongNumber = json['wrongNumber'] != null ? LeadCategory.fromJson(json['wrongNumber']) : null;
//     hotFollowup = json['hotFollowup'] != null ? LeadCategory.fromJson(json['hotFollowup']) : null;
//     coldFollowup = json['coldFollowup'] != null ? LeadCategory.fromJson(json['coldFollowup']) : null;
//     schedule = json['schedule'] != null ? LeadCategory.fromJson(json['schedule']) : null;
//     notConnected = json['notConnected'] != null ? LeadCategory.fromJson(json['notConnected']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'veryInterested': veryInterested?.toJson(),
//       'maybe': maybe?.toJson(),
//       'enrolled': enrolled?.toJson(),
//       'junkLead': junkLead?.toJson(),
//       'notRequired': notRequired?.toJson(),
//       'enrolledOther': enrolledOther?.toJson(),
//       'decline': decline?.toJson(),
//       'notEligible': notEligible?.toJson(),
//       'wrongNumber': wrongNumber?.toJson(),
//       'hotFollowup': hotFollowup?.toJson(),
//       'coldFollowup': coldFollowup?.toJson(),
//       'schedule': schedule?.toJson(),
//       'notConnected': notConnected?.toJson(),
//     };
//   }
// }
//
// class LeadCategory {
//   List<LeadItem>? data;
//   int? count;
//
//   LeadCategory({this.data, this.count});
//
//   LeadCategory.fromJson(Map<String, dynamic> json) {
//     data = (json['data'] as List?)?.map((e) => LeadItem.fromJson(e)).toList();
//     count = json['count'];
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'data': data?.map((e) => e.toJson()).toList(),
//       'count': count,
//     };
//   }
// }
//
// class LeadItem {
//   String? id;
//   String? clientId;
//   String? mobile;
//   String? time;
//   String? transcript;
//   int? duration;
//   String? leadStatus;
//   Metadata? metadata;
//   String? createdAt;
//   String? updatedAt;
//   int? v;
//
//   LeadItem({
//     this.id,
//     this.clientId,
//     this.mobile,
//     this.time,
//     this.transcript,
//     this.duration,
//     this.leadStatus,
//     this.metadata,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//   });
//
//   LeadItem.fromJson(Map<String, dynamic> json) {
//     id = json['_id'];
//     clientId = json['clientId'];
//     mobile = json['mobile'];
//     time = json['time'];
//     transcript = json['transcript'];
//     duration = json['duration'];
//     leadStatus = json['leadStatus'];
//     metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     v = json['__v'];
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'clientId': clientId,
//       'mobile': mobile,
//       'time': time,
//       'transcript': transcript,
//       'duration': duration,
//       'leadStatus': leadStatus,
//       'metadata': metadata?.toJson(),
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//       '__v': v,
//     };
//   }
// }
//
// class Metadata {
//   int? userTranscriptCount;
//   int? aiResponseCount;
//   List<String>? languages;
//   String? callEndTime;
//   String? leadCategory;
//
//   Metadata({
//     this.userTranscriptCount,
//     this.aiResponseCount,
//     this.languages,
//     this.callEndTime,
//     this.leadCategory,
//   });
//
//   Metadata.fromJson(Map<String, dynamic> json) {
//     userTranscriptCount = json['userTranscriptCount'];
//     aiResponseCount = json['aiResponseCount'];
//     languages = (json['languages'] as List?)?.map((e) => e.toString()).toList();
//     callEndTime = json['callEndTime'];
//     leadCategory = json['leadCategory'];
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'userTranscriptCount': userTranscriptCount,
//       'aiResponseCount': aiResponseCount,
//       'languages': languages,
//       'callEndTime': callEndTime,
//       'leadCategory': leadCategory,
//     };
//   }
// }
//
// class FilterModel {
//   String? applied;
//   String? startDate;
//   String? endDate;
//
//   FilterModel({this.applied, this.startDate, this.endDate});
//
//   FilterModel.fromJson(Map<String, dynamic> json) {
//     applied = json['applied'];
//     startDate = json['startDate'];
//     endDate = json['endDate'];
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'applied': applied,
//       'startDate': startDate,
//       'endDate': endDate,
//     };
//   }
// }
