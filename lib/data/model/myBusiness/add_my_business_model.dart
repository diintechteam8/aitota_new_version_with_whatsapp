class AddMyBusinessModel {
  bool? success;
  BusinessData? data;

  AddMyBusinessModel({this.success, this.data});

  AddMyBusinessModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? BusinessData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['success'] = success;
    if (data != null) {
      result['data'] = data!.toJson();
    }
    return result;
  }
}

class BusinessData {
  String? clientId;
  String? title;
  String? category;
  String? type;
  BusinessImage? image;
  Documents? documents;
  String? videoLink;
  String? link;
  String? shareLink;
  String? description;
  int? mrp;
  int? offerPrice;
  String? hash;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  BusinessData({
    this.clientId,
    this.title,
    this.category,
    this.type,
    this.image,
    this.documents,
    this.videoLink,
    this.link,
    this.shareLink,
    this.description,
    this.mrp,
    this.offerPrice,
    this.hash,
    this.sId,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  BusinessData.fromJson(Map<String, dynamic> json) {
    clientId = json['clientId'];
    title = json['title'];
    category = json['category'];
    type = json['type'];
    image = json['image'] != null ? BusinessImage.fromJson(json['image']) : null;
    documents = json['documents'] != null ? Documents.fromJson(json['documents']) : null;
    videoLink = json['videoLink'];
    link = json['link'];
    shareLink = json['Sharelink'];
    description = json['description'];
    mrp = json['mrp'];
    offerPrice = json['offerPrice'];
    hash = json['hash'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['clientId'] = clientId;
    result['title'] = title;
    result['category'] = category;
    result['type'] = type;
    if (image != null) {
      result['image'] = image!.toJson();
    }
    if (documents != null) {
      result['documents'] = documents!.toJson();
    }
    result['videoLink'] = videoLink;
    result['link'] = link;
    result['Sharelink'] = shareLink;
    result['description'] = description;
    result['mrp'] = mrp;
    result['offerPrice'] = offerPrice;
    result['hash'] = hash;
    result['_id'] = sId;
    result['createdAt'] = createdAt;
    result['updatedAt'] = updatedAt;
    result['__v'] = iV;
    return result;
  }
}

class BusinessImage {
  String? url;
  String? key;

  BusinessImage({this.url, this.key});

  BusinessImage.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['url'] = url;
    result['key'] = key;
    return result;
  }
}

class Documents {
  String? url;
  String? key;

  Documents({this.url, this.key});

  Documents.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['url'] = url;
    result['key'] = key;
    return result;
  }
}
