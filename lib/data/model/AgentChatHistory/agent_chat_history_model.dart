class AgentChatHistoryModel {
  bool? success;
  AgentChatData? data; // renamed

  AgentChatHistoryModel({this.success, this.data});

  AgentChatHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? AgentChatData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

// renamed from Data
class AgentChatData {
  String? clientId;
  List<String>? agentIds;
  List<AgentDetail>? agents;

  AgentChatData({this.clientId, this.agentIds, this.agents});

  AgentChatData.fromJson(Map<String, dynamic> json) {
    clientId = json['clientId'];
    agentIds = json['agentIds']?.cast<String>();
    if (json['agents'] != null) {
      agents = <AgentDetail>[];
      json['agents'].forEach((v) {
        agents!.add(AgentDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientId'] = clientId;
    data['agentIds'] = agentIds;
    if (agents != null) {
      data['agents'] = agents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// renamed from Agents
class AgentDetail {
  String? agentId;
  String? lastActivityAt;
  List<String>? sessions;
  AgentInfo? agent;

  AgentDetail({this.agentId, this.lastActivityAt, this.sessions, this.agent});

  AgentDetail.fromJson(Map<String, dynamic> json) {
    agentId = json['agentId'];
    lastActivityAt = json['lastActivityAt'];
    sessions = json['sessions']?.cast<String>();
    agent = json['agent'] != null ? AgentInfo.fromJson(json['agent']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['agentId'] = agentId;
    data['lastActivityAt'] = lastActivityAt;
    data['sessions'] = sessions;
    if (agent != null) {
      data['agent'] = agent!.toJson();
    }
    return data;
  }
}

// renamed from Agent
class AgentInfo {
  String? sId;
  List<String>? email;

  AgentInfo({this.sId, this.email});

  AgentInfo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'] != null ? List<String>.from(json['email']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (email != null) {
      data['email'] = email;
    }
    return data;
  }
}
