class GetAllAgentsModel {
  bool? success;
  List<AgentData>? data;

  GetAllAgentsModel({this.success, this.data});

  GetAllAgentsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = List<AgentData>.from(
        json['data'].map((v) => AgentData.fromJson(v)),
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    if (data != null) 'data': data!.map((v) => v.toJson()).toList(),
  };
}

class AgentData {
  AudioMetadata? audioMetadata;
  String? id;
  String? clientId;
  String? createdBy;
  String? createdByType;
  bool? isActive;
  String? agentName;
  String? description;
  String? category;
  String? personality;
  String? language;
  String? firstMessage;
  String? sttSelection;
  String? ttsSelection;
  String? llmSelection;
  String? voiceSelection;
  List<StartingMessage>? startingMessages;
  String? accountSid;
  String? serviceProvider;
  String? callingNumber;
  String? callingType;
  String? callerId;
  String? xApiKey;
  String? createdAt;
  String? updatedAt;
  int? v;

  AgentData({
    this.audioMetadata,
    this.id,
    this.clientId,
    this.createdBy,
    this.createdByType,
    this.isActive,
    this.agentName,
    this.description,
    this.category,
    this.personality,
    this.language,
    this.firstMessage,
    this.sttSelection,
    this.ttsSelection,
    this.llmSelection,
    this.voiceSelection,
    this.startingMessages,
    this.accountSid,
    this.serviceProvider,
    this.callingNumber,
    this.callingType,
    this.callerId,
    this.xApiKey,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  AgentData.fromJson(Map<String, dynamic> json) {
    audioMetadata = json['audioMetadata'] != null
        ? AudioMetadata.fromJson(json['audioMetadata'])
        : null;
    id = json['_id'];
    clientId = json['clientId'];
    createdBy = json['createdBy'];
    createdByType = json['createdByType'];
    isActive = json['isActive'];
    agentName = json['agentName'];
    description = json['description'];
    category = json['category'];
    personality = json['personality'];
    language = json['language'];
    firstMessage = json['firstMessage'];
    sttSelection = json['sttSelection'];
    ttsSelection = json['ttsSelection'];
    llmSelection = json['llmSelection'];
    voiceSelection = json['voiceSelection'];
    if (json['startingMessages'] != null) {
      startingMessages = List<StartingMessage>.from(
        json['startingMessages'].map((v) => StartingMessage.fromJson(v)),
      );
    }
    accountSid = json['accountSid'];
    serviceProvider = json['serviceProvider'];
    callingNumber = json['callingNumber'];
    callingType = json['callingType'];
    callerId = json['callerId'];
    xApiKey = json['X_API_KEY']; // note: API key is uppercase
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() => {
    if (audioMetadata != null) 'audioMetadata': audioMetadata!.toJson(),
    '_id': id,
    'clientId': clientId,
    'createdBy': createdBy,
    'createdByType': createdByType,
    'isActive': isActive,
    'agentName': agentName,
    'description': description,
    'category': category,
    'personality': personality,
    'language': language,
    'firstMessage': firstMessage,
    'sttSelection': sttSelection,
    'ttsSelection': ttsSelection,
    'llmSelection': llmSelection,
    'voiceSelection': voiceSelection,
    if (startingMessages != null)
      'startingMessages': startingMessages!.map((v) => v.toJson()).toList(),
    'accountSid': accountSid,
    'serviceProvider': serviceProvider,
    'callingNumber': callingNumber,
    'callingType': callingType,
    'callerId': callerId,
    'X_API_KEY': xApiKey,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    '__v': v,
  };
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

  Map<String, dynamic> toJson() => {
    'format': format,
    'sampleRate': sampleRate,
    'channels': channels,
    'language': language,
    'provider': provider,
    'size': size,
  };
}

class StartingMessage {
  String? text;
  String? audioBase64;
  String? id;

  StartingMessage({this.text, this.audioBase64, this.id});

  StartingMessage.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    audioBase64 = json['audioBase64'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'audioBase64': audioBase64,
    '_id': id,
  };
}
