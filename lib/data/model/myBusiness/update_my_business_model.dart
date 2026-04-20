class UpdateMyBusinessModel {
  bool? success;
  UpdatedBusinessData? data;

  UpdateMyBusinessModel({this.success, this.data});

  UpdateMyBusinessModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? UpdatedBusinessData.fromJson(json['data']) : null;
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

class UpdatedBusinessData {
  BusinessImage? image;
  Documents? documents;
  String? sId;
  String? clientId;
  String? title;
  String? category;
  String? type;
  String? videoLink;
  String? link;
  String? shareLink;
  String? description;
  int? mrp;
  int? offerPrice;
  String? hash;
  String? createdAt;
  String? updatedAt;
  int? iV;

  UpdatedBusinessData({
    this.image,
    this.documents,
    this.sId,
    this.clientId,
    this.title,
    this.category,
    this.type,
    this.videoLink,
    this.link,
    this.shareLink,
    this.description,
    this.mrp,
    this.offerPrice,
    this.hash,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  UpdatedBusinessData.fromJson(Map<String, dynamic> json) {
    image = json['image'] != null ? BusinessImage.fromJson(json['image']) : null;
    documents = json['documents'] != null ? Documents.fromJson(json['documents']) : null;
    sId = json['_id'];
    clientId = json['clientId'];
    title = json['title'];
    category = json['category'];
    type = json['type'];
    videoLink = json['videoLink'];
    link = json['link'];
    shareLink = json['Sharelink']; // keeping API's original key case
    description = json['description'];
    mrp = json['mrp'];
    offerPrice = json['offerPrice'];
    hash = json['hash'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    if (image != null) {
      result['image'] = image!.toJson();
    }
    if (documents != null) {
      result['documents'] = documents!.toJson();
    }
    result['_id'] = sId;
    result['clientId'] = clientId;
    result['title'] = title;
    result['category'] = category;
    result['type'] = type;
    result['videoLink'] = videoLink;
    result['link'] = link;
    result['Sharelink'] = shareLink;
    result['description'] = description;
    result['mrp'] = mrp;
    result['offerPrice'] = offerPrice;
    result['hash'] = hash;
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
