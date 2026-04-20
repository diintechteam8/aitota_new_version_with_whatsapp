class GetByAgentIdChatHistoryModel {
  bool? success;
  AgentChatDetail? data; // renamed

  GetByAgentIdChatHistoryModel({this.success, this.data});

  GetByAgentIdChatHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? AgentChatDetail.fromJson(json['data']) : null;
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
class AgentChatDetail {
  String? clientId;
  String? agentId;
  List<String>? sessions;
  String? startedAt;
  String? endedAt;
  String? lastActivityAt;
  int? messageCount;
  List<ChatMessage>? messages;

  AgentChatDetail({
    this.clientId,
    this.agentId,
    this.sessions,
    this.startedAt,
    this.endedAt,
    this.lastActivityAt,
    this.messageCount,
    this.messages,
  });

  AgentChatDetail.fromJson(Map<String, dynamic> json) {
    clientId = json['clientId'];
    agentId = json['agentId'];
    sessions = json['sessions']?.cast<String>();
    startedAt = json['startedAt'];
    endedAt = json['endedAt'];
    lastActivityAt = json['lastActivityAt'];
    messageCount = json['messageCount'];
    if (json['messages'] != null) {
      messages = <ChatMessage>[];
      json['messages'].forEach((v) {
        messages!.add(ChatMessage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientId'] = clientId;
    data['agentId'] = agentId;
    data['sessions'] = sessions;
    data['startedAt'] = startedAt;
    data['endedAt'] = endedAt;
    data['lastActivityAt'] = lastActivityAt;
    data['messageCount'] = messageCount;
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// renamed from Messages
class ChatMessage {
  String? role;
  String? type;
  String? text;
  String? createdAt;
  ChatSource? source; // renamed from sSource

  ChatMessage({this.role, this.type, this.text, this.createdAt, this.source});

  ChatMessage.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    type = json['type'];
    text = json['text'];
    createdAt = json['createdAt'];
    source =
    json['_source'] != null ? ChatSource.fromJson(json['_source']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role'] = role;
    data['type'] = type;
    data['text'] = text;
    data['createdAt'] = createdAt;
    if (source != null) {
      data['_source'] = source!.toJson();
    }
    return data;
  }
}

// renamed from Source
class ChatSource {
  String? sessionId;
  String? chatId;

  ChatSource({this.sessionId, this.chatId});

  ChatSource.fromJson(Map<String, dynamic> json) {
    sessionId = json['sessionId'];
    chatId = json['chatId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sessionId'] = sessionId;
    data['chatId'] = chatId;
    return data;
  }
}
