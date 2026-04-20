class UploadImageModel {
  bool? success;
  String? url;
  String? key;

  UploadImageModel({this.success, this.url, this.key});

  UploadImageModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    url = json['url'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['success'] = success;
    result['url'] = url;
    result['key'] = key;
    return result;
  }
}
