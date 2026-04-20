class MyBusinessModel {
  bool? success;
  List<Data>? data;

  MyBusinessModel({this.success, this.data});

  MyBusinessModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = List<Data>.from(json['data'].map((v) => Data.fromJson(v)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['success'] = success;
    if (data != null) {
      result['data'] = data!.map((v) => v.toJson()).toList();
    }
    return result;
  }
}

class Data {
  ImageData? image;
  ImageData? documents;
  String? sId;
  String? clientId;
  String? title;
  String? category;
  String? type;
  String? videoLink;
  String? link;
  String? sharelink;
  String? description;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? mrp;
  int? offerPrice;

  Data({
    this.image,
    this.documents,
    this.sId,
    this.clientId,
    this.title,
    this.category,
    this.type,
    this.videoLink,
    this.link,
    this.sharelink,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.mrp,
    this.offerPrice,
  });

  Data.fromJson(Map<String, dynamic> json) {
    image = json['image'] != null ? ImageData.fromJson(json['image']) : null;
    documents = json['documents'] != null ? ImageData.fromJson(json['documents']) : null;
    sId = json['_id'];
    clientId = json['clientId'];
    title = json['title'];
    category = json['category'];
    type = json['type'];
    videoLink = json['videoLink'];
    link = json['link'];
    sharelink = json['sharelink'] ?? json['Sharelink']; // case-insensitive fallback
    description = json['description'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    mrp = json['mrp'];
    offerPrice = json['offerPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    if (image != null) result['image'] = image!.toJson();
    if (documents != null) result['documents'] = documents!.toJson();
    result['_id'] = sId;
    result['clientId'] = clientId;
    result['title'] = title;
    result['category'] = category;
    result['type'] = type;
    result['videoLink'] = videoLink;
    result['link'] = link;
    result['sharelink'] = sharelink;
    result['description'] = description;
    result['createdAt'] = createdAt;
    result['updatedAt'] = updatedAt;
    result['__v'] = iV;
    result['mrp'] = mrp;
    result['offerPrice'] = offerPrice;
    return result;
  }
}

class ImageData {
  String? url;
  String? key;

  ImageData({this.url, this.key});

  ImageData.fromJson(Map<String, dynamic> json) {
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
