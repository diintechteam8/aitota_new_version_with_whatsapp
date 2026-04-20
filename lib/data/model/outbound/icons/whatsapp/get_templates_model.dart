class GetTemplateModel {
  bool? success;
  String? message;
  List<GetTemplateModelTemplates>? templates;

  GetTemplateModel({
    this.success,
    this.message,
    this.templates,
  });

  GetTemplateModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['templates'] != null) {
      templates = (json['templates'] as List)
          .map((v) => GetTemplateModelTemplates.fromJson(v))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['success'] = success;
    result['message'] = message;
    if (templates != null) {
      result['templates'] = templates!.map((v) => v.toJson()).toList();
    }
    return result;
  }
}

class GetTemplateModelTemplates {
  String? sId;
  String? language;
  String? name;
  int? v;
  String? category;
  List<GetTemplateModelComponents>? components;
  String? createdAt;
  GetTemplateModelMetaRaw? metaRaw;
  String? metaTemplateId;
  String? status;
  String? updatedAt;

  GetTemplateModelTemplates({
    this.sId,
    this.language,
    this.name,
    this.v,
    this.category,
    this.components,
    this.createdAt,
    this.metaRaw,
    this.metaTemplateId,
    this.status,
    this.updatedAt,
  });

  GetTemplateModelTemplates.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    language = json['language'];
    name = json['name'];
    v = json['__v'];
    category = json['category'];
    if (json['components'] != null) {
      components = (json['components'] as List)
          .map((v) => GetTemplateModelComponents.fromJson(v))
          .toList();
    }
    createdAt = json['createdAt'];
    metaRaw = json['metaRaw'] != null
        ? GetTemplateModelMetaRaw.fromJson(json['metaRaw'])
        : null;
    metaTemplateId = json['metaTemplateId'];
    status = json['status'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['_id'] = sId;
    result['language'] = language;
    result['name'] = name;
    result['__v'] = v;
    result['category'] = category;
    if (components != null) {
      result['components'] = components!.map((v) => v.toJson()).toList();
    }
    result['createdAt'] = createdAt;
    if (metaRaw != null) {
      result['metaRaw'] = metaRaw!.toJson();
    }
    result['metaTemplateId'] = metaTemplateId;
    result['status'] = status;
    result['updatedAt'] = updatedAt;
    return result;
  }
}

class GetTemplateModelComponents {
  String? type;
  String? format;
  String? text;
  List<GetTemplateModelButtons>? buttons;
  GetTemplateModelExample? example;

  GetTemplateModelComponents({
    this.type,
    this.format,
    this.text,
    this.buttons,
    this.example,
  });

  GetTemplateModelComponents.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    format = json['format'];
    text = json['text'];
    if (json['buttons'] != null) {
      buttons = (json['buttons'] as List)
          .map((v) => GetTemplateModelButtons.fromJson(v))
          .toList();
    }
    example = json['example'] != null
        ? GetTemplateModelExample.fromJson(json['example'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['type'] = type;
    result['format'] = format;
    result['text'] = text;
    if (buttons != null) {
      result['buttons'] = buttons!.map((v) => v.toJson()).toList();
    }
    if (example != null) {
      result['example'] = example!.toJson();
    }
    return result;
  }
}

class GetTemplateModelButtons {
  String? type;
  String? text;
  String? url;
  String? phoneNumber;

  GetTemplateModelButtons({
    this.type,
    this.text,
    this.url,
    this.phoneNumber,
  });

  GetTemplateModelButtons.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    text = json['text'];
    url = json['url'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['type'] = type;
    result['text'] = text;
    result['url'] = url;
    result['phone_number'] = phoneNumber;
    return result;
  }
}

class GetTemplateModelExample {
  List<String>? headerHandle;

  GetTemplateModelExample({this.headerHandle});

  GetTemplateModelExample.fromJson(Map<String, dynamic> json) {
    headerHandle = json['header_handle'] != null
        ? List<String>.from(json['header_handle'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['header_handle'] = headerHandle;
    return result;
  }
}

class GetTemplateModelMetaRaw {
  String? name;
  String? parameterFormat;
  List<GetTemplateModelComponents>? components;
  String? language;
  String? status;
  String? category;
  String? id;
  String? subCategory;

  GetTemplateModelMetaRaw({
    this.name,
    this.parameterFormat,
    this.components,
    this.language,
    this.status,
    this.category,
    this.id,
    this.subCategory,
  });

  GetTemplateModelMetaRaw.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    parameterFormat = json['parameter_format'];
    if (json['components'] != null) {
      components = (json['components'] as List)
          .map((v) => GetTemplateModelComponents.fromJson(v))
          .toList();
    }
    language = json['language'];
    status = json['status'];
    category = json['category'];
    id = json['id'];
    subCategory = json['sub_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['name'] = name;
    result['parameter_format'] = parameterFormat;
    if (components != null) {
      result['components'] = components!.map((v) => v.toJson()).toList();
    }
    result['language'] = language;
    result['status'] = status;
    result['category'] = category;
    result['id'] = id;
    result['sub_category'] = subCategory;
    return result;
  }
}