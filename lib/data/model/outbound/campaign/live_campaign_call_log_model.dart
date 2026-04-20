class GetLiveCampaignCallLogsModel {
  List<GetLiveCampaignCallLog>? logs;
  Pagination? pagination;
  Stats? stats;
  Filters? filters;

  GetLiveCampaignCallLogsModel({
    this.logs,
    this.pagination,
    this.stats,
    this.filters,
  });

  GetLiveCampaignCallLogsModel.fromJson(Map<String, dynamic> json) {
    logs = (json['logs'] as List?)
        ?.map((v) => GetLiveCampaignCallLog.fromJson(v))
        .toList();

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;

    stats = json['stats'] != null ? Stats.fromJson(json['stats']) : null;

    filters = json['filters'] != null ? Filters.fromJson(json['filters']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (logs != null) data['logs'] = logs!.map((v) => v.toJson()).toList();
    if (pagination != null) data['pagination'] = pagination!.toJson();
    if (stats != null) data['stats'] = stats!.toJson();
    if (filters != null) data['filters'] = filters!.toJson();
    return data;
  }
}

class GetLiveCampaignCallLog {
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
  LogMetadata? metadata;
  String? createdAt;
  String? updatedAt;
  int? v;

  GetLiveCampaignCallLog({
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
    this.metadata,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  GetLiveCampaignCallLog.fromJson(Map<String, dynamic> json) {
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
    metadata =
    json['metadata'] != null ? LogMetadata.fromJson(json['metadata']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['clientId'] = clientId;
    data['agentId'] = agentId;
    data['mobile'] = mobile;
    data['time'] = time;
    data['transcript'] = transcript;
    data['duration'] = duration;
    data['leadStatus'] = leadStatus;
    data['streamSid'] = streamSid;
    data['callSid'] = callSid;
    if (metadata != null) data['metadata'] = metadata!.toJson();
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    return data;
  }
}

class LogMetadata {
  int? userTranscriptCount;
  int? aiResponseCount;
  List<String>? languages;
  String? callDirection;
  bool? isActive;
  String? lastUpdated;
  LogCustomParams? customParams;
  String? callerId;
  String? sttProvider;
  String? ttsProvider;
  String? llmProvider;
  int? totalUpdates;

  LogMetadata({
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
  });

  LogMetadata.fromJson(Map<String, dynamic> json) {
    userTranscriptCount = json['userTranscriptCount'];
    aiResponseCount = json['aiResponseCount'];
    languages = (json['languages'] as List?)?.map((e) => e.toString()).toList();
    callDirection = json['callDirection'];
    isActive = json['isActive'];
    lastUpdated = json['lastUpdated'];
    customParams = json['customParams'] != null
        ? LogCustomParams.fromJson(json['customParams'])
        : null;
    callerId = json['callerId'];
    sttProvider = json['sttProvider'];
    ttsProvider = json['ttsProvider'];
    llmProvider = json['llmProvider'];
    totalUpdates = json['totalUpdates'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userTranscriptCount'] = userTranscriptCount;
    data['aiResponseCount'] = aiResponseCount;
    data['languages'] = languages;
    data['callDirection'] = callDirection;
    data['isActive'] = isActive;
    data['lastUpdated'] = lastUpdated;
    if (customParams != null) data['customParams'] = customParams!.toJson();
    data['callerId'] = callerId;
    data['sttProvider'] = sttProvider;
    data['ttsProvider'] = ttsProvider;
    data['llmProvider'] = llmProvider;
    data['totalUpdates'] = totalUpdates;
    return data;
  }
}

class LogCustomParams {
  String? uniqueid;
  String? name;

  LogCustomParams({this.uniqueid, this.name});

  LogCustomParams.fromJson(Map<String, dynamic> json) {
    uniqueid = json['uniqueid'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uniqueid'] = uniqueid;
    data['name'] = name;
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
    final data = <String, dynamic>{};
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
    final data = <String, dynamic>{};
    data['total'] = total;
    data['active'] = active;
    data['clients'] = clients;
    data['timestamp'] = timestamp;
    return data;
  }
}

class Filters {
  String? uniqueid;
  List<String>? availableClients;

  Filters({this.uniqueid, this.availableClients});

  Filters.fromJson(Map<String, dynamic> json) {
    uniqueid = json['uniqueid'];
    availableClients =
        (json['availableClients'] as List?)?.map((e) => e.toString()).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uniqueid'] = uniqueid;
    data['availableClients'] = availableClients;
    return data;
  }
}
