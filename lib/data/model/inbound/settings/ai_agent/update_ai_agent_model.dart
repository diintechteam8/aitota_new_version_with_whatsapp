class UpdateInboundAiAgentModel {
  AudioMetadata? audioMetadata;
  String? id;
  String? clientId;
  String? agentName;
  String? description;
  String? category;
  String? personality;
  String? language;
  String? firstMessage;
  String? systemPrompt;
  String? sttSelection;
  String? ttsSelection;
  String? llmSelection;
  String? voiceSelection;
  List<StartingMessage>? startingMessages;
  String? accountSid;
  String? serviceProvider;
  String? createdAt;
  String? updatedAt;
  int? v;

  UpdateInboundAiAgentModel({
    this.audioMetadata,
    this.id,
    this.clientId,
    this.agentName,
    this.description,
    this.category,
    this.personality,
    this.language,
    this.firstMessage,
    this.systemPrompt,
    this.sttSelection,
    this.ttsSelection,
    this.llmSelection,
    this.voiceSelection,
    this.startingMessages,
    this.accountSid,
    this.serviceProvider,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  UpdateInboundAiAgentModel.fromJson(Map<String, dynamic> json) {
    audioMetadata = json['audioMetadata'] != null
        ? AudioMetadata.fromJson(json['audioMetadata'])
        : null;
    id = json['_id'];
    clientId = json['clientId'];
    agentName = json['agentName'];
    description = json['description'];
    category = json['category'];
    personality = json['personality'];
    language = json['language'];
    firstMessage = json['firstMessage'];
    systemPrompt = json['systemPrompt'];
    sttSelection = json['sttSelection'];
    ttsSelection = json['ttsSelection'];
    llmSelection = json['llmSelection'];
    voiceSelection = json['voiceSelection'];
    startingMessages = (json['startingMessages'] as List?)
        ?.map((e) => StartingMessage.fromJson(e))
        .toList();
    accountSid = json['accountSid'];
    serviceProvider = json['serviceProvider'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    return {
      'audioMetadata': audioMetadata?.toJson(),
      '_id': id,
      'clientId': clientId,
      'agentName': agentName,
      'description': description,
      'category': category,
      'personality': personality,
      'language': language,
      'firstMessage': firstMessage,
      'systemPrompt': systemPrompt,
      'sttSelection': sttSelection,
      'ttsSelection': ttsSelection,
      'llmSelection': llmSelection,
      'voiceSelection': voiceSelection,
      'startingMessages':
      startingMessages?.map((e) => e.toJson()).toList(),
      'accountSid': accountSid,
      'serviceProvider': serviceProvider,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class AudioMetadata {
  String? format;
  int? sampleRate;
  int? channels;
  String? language;
  String? provider;
  int? size;

  AudioMetadata({
    this.format,
    this.sampleRate,
    this.channels,
    this.language,
    this.provider,
    this.size,
  });

  AudioMetadata.fromJson(Map<String, dynamic> json) {
    format = json['format'];
    sampleRate = json['sampleRate'];
    channels = json['channels'];
    language = json['language'];
    provider = json['provider'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    return {
      'format': format,
      'sampleRate': sampleRate,
      'channels': channels,
      'language': language,
      'provider': provider,
      'size': size,
    };
  }
}

class StartingMessage {
  String? text;
  String? id;

  StartingMessage({this.text, this.id});

  StartingMessage.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      '_id': id,
    };
  }
}
