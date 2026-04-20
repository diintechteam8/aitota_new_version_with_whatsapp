class GetTeamGroupsModel {
  bool? success;
  List<GetTeamGroupData>? data;
  Filter? filter;

  GetTeamGroupsModel({this.success, this.data, this.filter});

  GetTeamGroupsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <GetTeamGroupData>[];
      json['data'].forEach((v) {
        data!.add(GetTeamGroupData.fromJson(v));
      });
    }
    filter = json['filter'] != null ? Filter.fromJson(json['filter']) : null;
  }
}

class Filter {
  String? applied;

  Filter({this.applied});

  Filter.fromJson(Map<String, dynamic> json) {
    applied = json['applied'];
  }
}

class GetTeamGroupData {
  String? sId;
  String? name;
  String? category;
  String? description;
  String? ownerType;
  String? clientId;
  List<String>? assignedHumanAgents;
  String? createdAt;
  String? updatedAt;

  List<HumanAgentData>? assignedHumanAgentsData;
  int? contactsCount;
  int? assignedContactsCount;
  bool? isGroupFullyAssigned;
  int? touchedCount;
  int? untouchedCount;

  GetTeamGroupData({
    this.sId,
    this.name,
    this.category,
    this.description,
    this.ownerType,
    this.clientId,
    this.assignedHumanAgents,
    this.createdAt,
    this.updatedAt,
    this.assignedHumanAgentsData,
    this.contactsCount,
    this.assignedContactsCount,
    this.isGroupFullyAssigned,
    this.touchedCount,
    this.untouchedCount,
  });

  GetTeamGroupData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    category = json['category'];
    description = json['description'];
    ownerType = json['ownerType'];
    clientId = json['clientId'];
    assignedHumanAgents = json['assignedHumanAgents']?.cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    if (json['assignedHumanAgentsData'] != null) {
      assignedHumanAgentsData = <HumanAgentData>[];
      json['assignedHumanAgentsData'].forEach((v) {
        assignedHumanAgentsData!.add(HumanAgentData.fromJson(v));
      });
    }

    contactsCount = json['contactsCount'];
    assignedContactsCount = json['assignedContactsCount'];
    isGroupFullyAssigned = json['isGroupFullyAssigned'];
    touchedCount = json['touchedCount'];
    untouchedCount = json['untouchedCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['category'] = category;
    data['description'] = description;
    data['contactsCount'] = contactsCount;
    data['touchedCount'] = touchedCount;
    data['untouchedCount'] = untouchedCount;
    data['isGroupFullyAssigned'] = isGroupFullyAssigned;
    return data;
  }
}

class HumanAgentData {
  String? sId;
  String? humanAgentName;
  String? email;
  String? role;

  HumanAgentData({this.sId, this.humanAgentName, this.email, this.role});

  HumanAgentData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    humanAgentName = json['humanAgentName'];
    email = json['email'];
    role = json['role'];
  }
}