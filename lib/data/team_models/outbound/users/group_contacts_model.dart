class GetTeamGroupContactsModel {
  bool? success;
  GetTeamGroupContactsData? data;

  GetTeamGroupContactsModel({this.success, this.data});

  GetTeamGroupContactsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? GetTeamGroupContactsData.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['success'] = success;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class GetTeamGroupContactsData {
  List<Contact>? contacts;
  Pagination? pagination;
  Filters? filters;
  int? touchedCount;
  int? untouchedCount;
  TouchedBreakdown? touchedBreakdown; // Newly added

  GetTeamGroupContactsData({
    this.contacts,
    this.pagination,
    this.filters,
    this.touchedCount,
    this.untouchedCount,
    this.touchedBreakdown,
  });

  GetTeamGroupContactsData.fromJson(Map<String, dynamic> json) {
    if (json['contacts'] != null) {
      contacts = (json['contacts'] as List)
          .map((v) => Contact.fromJson(v as Map<String, dynamic>))
          .toList();
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
        : null;
    filters = json['filters'] != null
        ? Filters.fromJson(json['filters'] as Map<String, dynamic>)
        : null;
    touchedCount = json['touchedCount'] as int?;
    untouchedCount = json['untouchedCount'] as int?;
    touchedBreakdown = json['touchedBreakdown'] != null
        ? TouchedBreakdown.fromJson(json['touchedBreakdown'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (contacts != null) {
      map['contacts'] = contacts!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      map['pagination'] = pagination!.toJson();
    }
    if (filters != null) {
      map['filters'] = filters!.toJson();
    }
    map['touchedCount'] = touchedCount;
    map['untouchedCount'] = untouchedCount;
    if (touchedBreakdown != null) {
      map['touchedBreakdown'] = touchedBreakdown!.toJson();
    }
    return map;
  }
}

// New class for touchedBreakdown
class TouchedBreakdown {
  int? hotLeads;
  int? warmLeads;
  int? followUp;
  int? convertedWon;

  TouchedBreakdown({
    this.hotLeads,
    this.warmLeads,
    this.followUp,
    this.convertedWon,
  });

  TouchedBreakdown.fromJson(Map<String, dynamic> json) {
    hotLeads = json['hotLeads'] as int?;
    warmLeads = json['warmLeads'] as int?;
    followUp = json['followUp'] as int?;
    convertedWon = json['convertedWon'] as int?;
  }

  Map<String, dynamic> toJson() => {
        'hotLeads': hotLeads,
        'warmLeads': warmLeads,
        'followUp': followUp,
        'convertedWon': convertedWon,
      };
}

// Rest of your existing classes remain unchanged

class Pagination {
  int? page;
  int? limit;
  int? totalPages;
  int? totalContacts;

  Pagination({this.page, this.limit, this.totalPages, this.totalContacts});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'] as int?;
    limit = json['limit'] as int?;
    totalPages = json['totalPages'] as int?;
    totalContacts = json['totalContacts'] as int?;
  }

  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
        'totalPages': totalPages,
        'totalContacts': totalContacts,
      };
}

class Filters {
  String? disposition;

  Filters({this.disposition});

  Filters.fromJson(Map<String, dynamic> json) {
    disposition = json['disposition'] as String?;
  }

  Map<String, dynamic> toJson() => {
        'disposition': disposition,
      };
}

class Contact {
  String? name;
  String? phone;
  String? email;
  String? status;
  String? createdAt;
  String? id;
  List<dynamic>? assignedToHumanAgents;
  String? dispositionStatus;
  int? dispositionCount;
  String? lastDispositionAt;
  String? lastLeadStatus;
  String? lastDispositionCategory;
  String? lastDispositionSubCategory;

  dynamic gender;
  dynamic age;
  dynamic profession;
  dynamic pinCode;
  dynamic city;

  Contact({
    this.name,
    this.phone,
    this.email,
    this.status,
    this.createdAt,
    this.id,
    this.assignedToHumanAgents,
    this.dispositionStatus,
    this.dispositionCount,
    this.lastDispositionAt,
    this.lastLeadStatus,
    this.lastDispositionCategory,
    this.lastDispositionSubCategory,
    this.gender,
    this.age,
    this.profession,
    this.pinCode,
    this.city,
  });

  Contact.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    phone = json['phone'] as String?;
    email = json['email'] as String?;
    status = json['status'] as String?;
    createdAt = json['createdAt'] as String?;
    id = json['_id'] as String?;

    assignedToHumanAgents = json['assignedToHumanAgents'] ?? [];

    dispositionStatus = json['dispositionStatus'] as String?;
    dispositionCount = json['dispositionCount'] as int?;
    lastDispositionAt = json['lastDispositionAt'] as String?;
    lastLeadStatus = json['lastLeadStatus'] as String?;
    lastDispositionCategory = json['lastDispositionCategory'] as String?;
    lastDispositionSubCategory = json['lastDispositionSubCategory'] as String?;

    gender = json['gender'];
    age = json['age'];
    profession = json['profession'];
    pinCode = json['pinCode'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'email': email,
        'status': status,
        'createdAt': createdAt,
        '_id': id,
        'assignedToHumanAgents': assignedToHumanAgents,
        'dispositionStatus': dispositionStatus,
        'dispositionCount': dispositionCount,
        'lastDispositionAt': lastDispositionAt,
        'lastLeadStatus': lastLeadStatus,
        'lastDispositionCategory': lastDispositionCategory,
        'lastDispositionSubCategory': lastDispositionSubCategory,
        'gender': gender,
        'age': age,
        'profession': profession,
        'pinCode': pinCode,
        'city': city,
      };
}