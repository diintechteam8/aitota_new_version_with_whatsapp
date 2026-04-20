class LiveCallLogsModel {
  List<Logs>? logs;
  Pagination? pagination;
  Stats? stats;
  Filters? filters;

  LiveCallLogsModel({this.logs, this.pagination, this.stats, this.filters});

  LiveCallLogsModel.fromJson(Map<String, dynamic> json) {
    if (json['logs'] != null) {
      logs = (json['logs'] as List)
          .map((v) => Logs.fromJson(v as Map<String, dynamic>))
          .toList();
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    stats = json['stats'] != null ? Stats.fromJson(json['stats']) : null;
    filters =
    json['filters'] != null ? Filters.fromJson(json['filters']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (logs != null) {
      data['logs'] = logs!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (stats != null) {
      data['stats'] = stats!.toJson();
    }
    if (filters != null) {
      data['filters'] = filters!.toJson();
    }
    return data;
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
  String? streamSid; // NEW
  String? callSid;   // NEW
  Metadata? metadata;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Logs({
    this.sId,
    this.clientId,
    this.agentId,
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
    this.iV,
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
    streamSid = json['streamSid'];
    callSid = json['callSid'];
    metadata = json['metadata'] != null
        ? Metadata.fromJson(json['metadata'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['clientId'] = clientId;
    data['agentId'] = agentId;
    data['mobile'] = mobile;
    data['time'] = time;
    data['transcript'] = transcript;
    data['duration'] = duration;
    data['leadStatus'] = leadStatus;
    data['streamSid'] = streamSid;
    data['callSid'] = callSid;
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
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
        : null;
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
    final Map<String, dynamic> data = {};
    data['userTranscriptCount'] = userTranscriptCount;
    data['aiResponseCount'] = aiResponseCount;
    data['languages'] = languages;
    data['callDirection'] = callDirection;
    data['isActive'] = isActive;
    data['lastUpdated'] = lastUpdated;
    data['callerId'] = callerId;
    data['sttProvider'] = sttProvider;
    data['ttsProvider'] = ttsProvider;
    data['llmProvider'] = llmProvider;
    data['totalUpdates'] = totalUpdates;
    data['callEndTime'] = callEndTime;
    if (customParams != null) {
      data['customParams'] = customParams!.toJson();
    }
    return data;
  }
}

class CustomParams {
  String? agentId;
  String? agentName;
  String? contactName;
  String? uniqueid;
  String? a;
  String? purpose;
  String? c; // NEW

  CustomParams({
    this.agentId,
    this.agentName,
    this.contactName,
    this.uniqueid,
    this.a,
    this.purpose,
    this.c,
  });

  CustomParams.fromJson(Map<String, dynamic> json) {
    agentId = json['agentId'];
    agentName = json['agentName'];
    contactName = json['contactName'];
    uniqueid = json['uniqueid'];
    a = json['a'];
    purpose = json['purpose'];
    c = json['c'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['agentId'] = agentId;
    data['agentName'] = agentName;
    data['contactName'] = contactName;
    data['uniqueid'] = uniqueid;
    data['a'] = a;
    data['purpose'] = purpose;
    data['c'] = c;
    return data;
  }
}

class Pagination {
  int? total;
  int? page;
  int? limit;
  int? pages;

  Pagination({this.total, this.page, this.limit, this.pages});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    pages = json['pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['total'] = total;
    data['page'] = page;
    data['limit'] = limit;
    data['pages'] = pages;
    return data;
  }
}

class Stats {
  int? total;
  int? active;
  int? clients;
  String? timestamp;

  Stats({this.total, this.active, this.clients, this.timestamp});

  Stats.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    active = json['active'];
    clients = json['clients'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['total'] = total;
    data['active'] = active;
    data['clients'] = clients;
    data['timestamp'] = timestamp;
    return data;
  }
}

class Filters {
  List<String>? availableClients;

  Filters({this.availableClients});

  Filters.fromJson(Map<String, dynamic> json) {
    availableClients = json['availableClients'] != null
        ? List<String>.from(json['availableClients'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['availableClients'] = availableClients;
    return data;
  }
}
