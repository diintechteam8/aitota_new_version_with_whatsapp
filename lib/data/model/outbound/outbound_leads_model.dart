class OutboundLeadsModel {
  bool? success;
  OutboundData? data;
  Filter? filter;

  OutboundLeadsModel({this.success, this.data, this.filter});

  OutboundLeadsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? OutboundData.fromJson(json['data']) : null;
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

class OutboundData {
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

  OutboundData({
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

  OutboundData.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> map = {};
    if (veryInterested != null) map['veryInterested'] = veryInterested!.toJson();
    if (maybe != null) map['maybe'] = maybe!.toJson();
    if (enrolled != null) map['enrolled'] = enrolled!.toJson();
    if (junkLead != null) map['junkLead'] = junkLead!.toJson();
    if (notRequired != null) map['notRequired'] = notRequired!.toJson();
    if (enrolledOther != null) map['enrolledOther'] = enrolledOther!.toJson();
    if (decline != null) map['decline'] = decline!.toJson();
    if (notEligible != null) map['notEligible'] = notEligible!.toJson();
    if (wrongNumber != null) map['wrongNumber'] = wrongNumber!.toJson();
    if (hotFollowup != null) map['hotFollowup'] = hotFollowup!.toJson();
    if (coldFollowup != null) map['coldFollowup'] = coldFollowup!.toJson();
    if (schedule != null) map['schedule'] = schedule!.toJson();
    if (notConnected != null) map['notConnected'] = notConnected!.toJson();
    return map;
  }
}

class LeadCategory {
  List<LeadItem>? data;
  int? count;

  LeadCategory({this.data, this.count});

  LeadCategory.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <LeadItem>[];
      json['data'].forEach((v) {
        data!.add(LeadItem.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (data != null) map['data'] = data!.map((v) => v.toJson()).toList();
    map['count'] = count;
    return map;
  }
}

class LeadItem {
  LeadMetadata? metadata;
  String? id;
  String? clientId;
  String? agentId;
  String? mobile;
  String? time;
  String? transcript;
  int? duration;
  String? leadStatus;
  String? disposition;
  String? subDisposition;
  String? dispositionId;
  String? subDispositionId;
  String? streamSid;
  String? callSid;
  String? createdAt;
  String? updatedAt;
  int? version;

  LeadItem({
    this.metadata,
    this.id,
    this.clientId,
    this.agentId,
    this.mobile,
    this.time,
    this.transcript,
    this.duration,
    this.leadStatus,
    this.disposition,
    this.subDisposition,
    this.dispositionId,
    this.subDispositionId,
    this.streamSid,
    this.callSid,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  LeadItem.fromJson(Map<String, dynamic> json) {
    metadata = json['metadata'] != null ? LeadMetadata.fromJson(json['metadata']) : null;
    id = json['_id'];
    clientId = json['clientId'];
    agentId = json['agentId'];
    mobile = json['mobile'];
    time = json['time'];
    transcript = json['transcript'];
    duration = json['duration'];
    leadStatus = json['leadStatus'];
    disposition = json['disposition'];
    subDisposition = json['subDisposition'];
    dispositionId = json['dispositionId'];
    subDispositionId = json['subDispositionId'];
    streamSid = json['streamSid'];
    callSid = json['callSid'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    version = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (metadata != null) map['metadata'] = metadata!.toJson();
    map['_id'] = id;
    map['clientId'] = clientId;
    map['agentId'] = agentId;
    map['mobile'] = mobile;
    map['time'] = time;
    map['transcript'] = transcript;
    map['duration'] = duration;
    map['leadStatus'] = leadStatus;
    map['disposition'] = disposition;
    map['subDisposition'] = subDisposition;
    map['dispositionId'] = dispositionId;
    map['subDispositionId'] = subDispositionId;
    map['streamSid'] = streamSid;
    map['callSid'] = callSid;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = version;
    return map;
  }
}

class LeadMetadata {
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
  bool? whatsappRequested;
  bool? whatsappMessageSent;
  bool? whatsappSent;
  bool? googleMeetRequested;
  GoogleMeetDetails? googleMeetDetails;
  bool? googleMeetEmailSent;
  String? callEndTime;
  Sanpbx? sanpbx;

  LeadMetadata({
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
    this.whatsappRequested,
    this.whatsappMessageSent,
    this.whatsappSent,
    this.googleMeetRequested,
    this.googleMeetDetails,
    this.googleMeetEmailSent,
    this.callEndTime,
    this.sanpbx,
  });

  LeadMetadata.fromJson(Map<String, dynamic> json) {
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
    whatsappRequested = json['whatsappRequested'];
    whatsappMessageSent = json['whatsappMessageSent'];
    whatsappSent = json['whatsappSent'];
    googleMeetRequested = json['googleMeetRequested'];
    googleMeetDetails = json['googleMeetDetails'] != null ? GoogleMeetDetails.fromJson(json['googleMeetDetails']) : null;
    googleMeetEmailSent = json['googleMeetEmailSent'];
    callEndTime = json['callEndTime'];
    sanpbx = json['sanpbx'] != null ? Sanpbx.fromJson(json['sanpbx']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userTranscriptCount'] = userTranscriptCount;
    map['aiResponseCount'] = aiResponseCount;
    map['languages'] = languages;
    map['callDirection'] = callDirection;
    map['isActive'] = isActive;
    map['lastUpdated'] = lastUpdated;
    if (customParams != null) map['customParams'] = customParams!.toJson();
    map['callerId'] = callerId;
    map['sttProvider'] = sttProvider;
    map['ttsProvider'] = ttsProvider;
    map['llmProvider'] = llmProvider;
    map['totalUpdates'] = totalUpdates;
    map['whatsappRequested'] = whatsappRequested;
    map['whatsappMessageSent'] = whatsappMessageSent;
    map['whatsappSent'] = whatsappSent;
    map['googleMeetRequested'] = googleMeetRequested;
    if (googleMeetDetails != null) map['googleMeetDetails'] = googleMeetDetails!.toJson();
    map['googleMeetEmailSent'] = googleMeetEmailSent;
    map['callEndTime'] = callEndTime;
    if (sanpbx != null) map['sanpbx'] = sanpbx!.toJson();
    return map;
  }
}

class Sanpbx {
  String? event;
  String? channelId;
  String? callId;
  String? streamId;
  String? callerId;
  String? callDirection;
  Map<String, dynamic>? extraParams;
  String? cid;
  String? did;
  String? timestamp;
  MediaFormat? mediaFormat;
  String? from;
  String? to;

  Sanpbx({
    this.event,
    this.channelId,
    this.callId,
    this.streamId,
    this.callerId,
    this.callDirection,
    this.extraParams,
    this.cid,
    this.did,
    this.timestamp,
    this.mediaFormat,
    this.from,
    this.to,
  });

  Sanpbx.fromJson(Map<String, dynamic> json) {
    event = json['event'];
    channelId = json['channelId'];
    callId = json['callId'];
    streamId = json['streamId'];
    callerId = json['callerId'];
    callDirection = json['callDirection'];
    extraParams = json['extraParams'];
    cid = json['cid'];
    did = json['did'];
    timestamp = json['timestamp'];
    mediaFormat = json['mediaFormat'] != null ? MediaFormat.fromJson(json['mediaFormat']) : null;
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['event'] = event;
    map['channelId'] = channelId;
    map['callId'] = callId;
    map['streamId'] = streamId;
    map['callerId'] = callerId;
    map['callDirection'] = callDirection;
    map['extraParams'] = extraParams;
    map['cid'] = cid;
    map['did'] = did;
    map['timestamp'] = timestamp;
    if (mediaFormat != null) map['mediaFormat'] = mediaFormat!.toJson();
    map['from'] = from;
    map['to'] = to;
    return map;
  }
}

class MediaFormat {
  String? encoding;
  int? sampleRate;
  int? channels;

  MediaFormat({this.encoding, this.sampleRate, this.channels});

  MediaFormat.fromJson(Map<String, dynamic> json) {
    encoding = json['encoding'];
    sampleRate = json['sampleRate'];
    channels = json['channels'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['encoding'] = encoding;
    map['sampleRate'] = sampleRate;
    map['channels'] = channels;
    return map;
  }
}

class CustomParams {
  String? uniqueid;
  String? name;
  String? agentId;
  String? agentName;
  String? contactName;
  String? campaignId;
  String? region;
  String? priority;
  String? humanAgentId;
  String? runId;

  CustomParams({
    this.uniqueid,
    this.name,
    this.agentId,
    this.agentName,
    this.contactName,
    this.campaignId,
    this.region,
    this.priority,
    this.humanAgentId,
    this.runId,
  });

  CustomParams.fromJson(Map<String, dynamic> json) {
    uniqueid = json['uniqueid'];
    name = json['name'];
    agentId = json['agentId'];
    agentName = json['agentName'];
    contactName = json['contact_name'] ?? json['contactName'];
    campaignId = json['campaign_id'];
    region = json['region'];
    priority = json['priority'];
    humanAgentId = json['HumanagentID'];
    runId = json['runId'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uniqueid'] = uniqueid;
    map['name'] = name;
    map['agentId'] = agentId;
    map['agentName'] = agentName;
    map['contact_name'] = contactName;
    map['campaign_id'] = campaignId;
    map['region'] = region;
    map['priority'] = priority;
    map['HumanagentID'] = humanAgentId;
    map['runId'] = runId;
    return map;
  }
}

class GoogleMeetDetails {
  String? status;
  String? link;
  String? meetingId;
  String? createdAt;
  String? expiresAt;

  GoogleMeetDetails({this.status, this.link, this.meetingId, this.createdAt, this.expiresAt});

  GoogleMeetDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    link = json['link'];
    meetingId = json['meetingId'];
    createdAt = json['createdAt'];
    expiresAt = json['expiresAt'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['link'] = link;
    map['meetingId'] = meetingId;
    map['createdAt'] = createdAt;
    map['expiresAt'] = expiresAt;
    return map;
  }
}

class Filter {
  String? applied;

  Filter({this.applied});

  Filter.fromJson(Map<String, dynamic> json) {
    applied = json['applied'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['applied'] = applied;
    return map;
  }
}
