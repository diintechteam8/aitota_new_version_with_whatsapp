class CampaignCompletedCallTableModel {
  bool? success;
  List<CompletedCall>? completedCalls;
  Campaign? campaign;
  Pagination? pagination;

  CampaignCompletedCallTableModel({
    this.success,
    this.completedCalls,
    this.campaign,
    this.pagination,
  });

  CampaignCompletedCallTableModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      completedCalls = <CompletedCall>[];
      json['data'].forEach((v) {
        completedCalls!.add(CompletedCall.fromJson(v));
      });
    }
    campaign =
    json['campaign'] != null ? Campaign.fromJson(json['campaign']) : null;
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    if (completedCalls != null) {
      map['data'] = completedCalls!.map((v) => v.toJson()).toList();
    }
    if (campaign != null) {
      map['campaign'] = campaign!.toJson();
    }
    if (pagination != null) {
      map['pagination'] = pagination!.toJson();
    }
    return map;
  }
}

class CompletedCall {
  String? documentId;
  String? number;
  String? name;
  String? leadStatus;

  CompletedCall({this.documentId, this.number, this.name, this.leadStatus});

  CompletedCall.fromJson(Map<String, dynamic> json) {
    documentId = json['documentId'];
    number = json['number'];
    name = json['name'];
    leadStatus = json['leadStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['documentId'] = documentId;
    map['number'] = number;
    map['name'] = name;
    map['leadStatus'] = leadStatus;
    return map;
  }
}

class Campaign {
  String? sId;
  String? name;
  int? uniqueIdsCount;

  Campaign({this.sId, this.name, this.uniqueIdsCount});

  Campaign.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    uniqueIdsCount = json['uniqueIdsCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['_id'] = sId;
    map['name'] = name;
    map['uniqueIdsCount'] = uniqueIdsCount;
    return map;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalItems;
  bool? hasNextPage;
  bool? hasPrevPage;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.hasNextPage,
    this.hasPrevPage,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalItems = json['totalItems'];
    hasNextPage = json['hasNextPage'];
    hasPrevPage = json['hasPrevPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['currentPage'] = currentPage;
    map['totalPages'] = totalPages;
    map['totalItems'] = totalItems;
    map['hasNextPage'] = hasNextPage;
    map['hasPrevPage'] = hasPrevPage;
    return map;
  }
}
