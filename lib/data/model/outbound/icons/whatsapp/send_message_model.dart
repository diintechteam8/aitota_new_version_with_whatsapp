class SendWhatsappMessageModel {
  bool? success;
  String? message;
  String? messageId;
  SendWhatsappMessageModelData? data;

  SendWhatsappMessageModel({
    this.success,
    this.message,
    this.messageId,
    this.data,
  });

  SendWhatsappMessageModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    messageId = json['messageId'];
    data = json['data'] != null
        ? SendWhatsappMessageModelData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['success'] = success;
    result['message'] = message;
    result['messageId'] = messageId;
    if (data != null) {
      result['data'] = data!.toJson();
    }
    return result;
  }
}

class SendWhatsappMessageModelData {
  String? messagingProduct;
  List<SendWhatsappMessageModelContacts>? contacts;
  List<SendWhatsappMessageModelMessages>? messages;

  SendWhatsappMessageModelData({
    this.messagingProduct,
    this.contacts,
    this.messages,
  });

  SendWhatsappMessageModelData.fromJson(Map<String, dynamic> json) {
    messagingProduct = json['messaging_product'];
    if (json['contacts'] != null) {
      contacts = (json['contacts'] as List)
          .map((v) => SendWhatsappMessageModelContacts.fromJson(v))
          .toList();
    }
    if (json['messages'] != null) {
      messages = (json['messages'] as List)
          .map((v) => SendWhatsappMessageModelMessages.fromJson(v))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['messaging_product'] = messagingProduct;
    if (contacts != null) {
      result['contacts'] = contacts!.map((v) => v.toJson()).toList();
    }
    if (messages != null) {
      result['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    return result;
  }
}

class SendWhatsappMessageModelContacts {
  String? input;
  String? waId;

  SendWhatsappMessageModelContacts({
    this.input,
    this.waId,
  });

  SendWhatsappMessageModelContacts.fromJson(Map<String, dynamic> json) {
    input = json['input'];
    waId = json['wa_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['input'] = input;
    result['wa_id'] = waId;
    return result;
  }
}

class SendWhatsappMessageModelMessages {
  String? id;

  SendWhatsappMessageModelMessages({
    this.id,
  });

  SendWhatsappMessageModelMessages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['id'] = id;
    return result;
  }
}
