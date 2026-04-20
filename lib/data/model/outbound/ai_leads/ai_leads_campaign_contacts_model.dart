class AiLeadsCampaignContactsModel {
  bool? success;
  List<AiLeadsCampaignContactsData>? data;
  AiLeadsCampaignContactsCampaignInfo? campaignInfo;
  AiLeadsCampaignContactsPagination? pagination;
  AiLeadsCampaignContactsFilter? filter;

  AiLeadsCampaignContactsModel({
    this.success,
    this.data,
    this.campaignInfo,
    this.pagination,
    this.filter,
  });

  AiLeadsCampaignContactsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <AiLeadsCampaignContactsData>[];
      json['data'].forEach((v) {
        data!.add(AiLeadsCampaignContactsData.fromJson(v));
      });
    }
    campaignInfo = json['campaignInfo'] != null
        ? AiLeadsCampaignContactsCampaignInfo.fromJson(json['campaignInfo'])
        : null;
    pagination = json['pagination'] != null
        ? AiLeadsCampaignContactsPagination.fromJson(json['pagination'])
        : null;
    filter = json['filter'] != null
        ? AiLeadsCampaignContactsFilter.fromJson(json['filter'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (campaignInfo != null) {
      data['campaignInfo'] = campaignInfo!.toJson();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (filter != null) {
      data['filter'] = filter!.toJson();
    }
    return data;
  }
}

class AiLeadsCampaignContactsData {
  String? documentId;
  String? number;
  String? name;
  String? leadStatus;
  String? contactId;
  String? time;
  String? status;
  int? duration;
  String? sId;
  List<AiLeadsCampaignContactsAssignedToHumanAgents>? assignedToHumanAgents;
  String? campaignHistoryId;
  String? campaignId;
  String? runId;
  int? instanceNumber;
  String? assignedAt;
  String? assignedBy;
  String? campaignName;
  String? campaignDescription;

  AiLeadsCampaignContactsData({
    this.documentId,
    this.number,
    this.name,
    this.leadStatus,
    this.contactId,
    this.time,
    this.status,
    this.duration,
    this.sId,
    this.assignedToHumanAgents,
    this.campaignHistoryId,
    this.campaignId,
    this.runId,
    this.instanceNumber,
    this.assignedAt,
    this.assignedBy,
    this.campaignName,
    this.campaignDescription,
  });

  AiLeadsCampaignContactsData.fromJson(Map<String, dynamic> json) {
    documentId = json['documentId'];
    number = json['number'];
    name = json['name'];
    leadStatus = json['leadStatus'];
    contactId = json['contactId'];
    time = json['time'];
    status = json['status'];
    duration = json['duration'];
    sId = json['_id'];
    if (json['assignedToHumanAgents'] != null) {
      assignedToHumanAgents = <AiLeadsCampaignContactsAssignedToHumanAgents>[];
      json['assignedToHumanAgents'].forEach((v) {
        assignedToHumanAgents!
            .add(AiLeadsCampaignContactsAssignedToHumanAgents.fromJson(v));
      });
    }
    campaignHistoryId = json['campaignHistoryId'];
    campaignId = json['campaignId'];
    runId = json['runId'];
    instanceNumber = json['instanceNumber'];
    assignedAt = json['assignedAt'];
    assignedBy = json['assignedBy'];
    campaignName = json['campaignName'];
    campaignDescription = json['campaignDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['documentId'] = documentId;
    data['number'] = number;
    data['name'] = name;
    data['leadStatus'] = leadStatus;
    data['contactId'] = contactId;
    data['time'] = time;
    data['status'] = status;
    data['duration'] = duration;
    data['_id'] = sId;
    if (assignedToHumanAgents != null) {
      data['assignedToHumanAgents'] =
          assignedToHumanAgents!.map((v) => v.toJson()).toList();
    }
    data['campaignHistoryId'] = campaignHistoryId;
    data['campaignId'] = campaignId;
    data['runId'] = runId;
    data['instanceNumber'] = instanceNumber;
    data['assignedAt'] = assignedAt;
    data['assignedBy'] = assignedBy;
    data['campaignName'] = campaignName;
    data['campaignDescription'] = campaignDescription;
    return data;
  }
}

class AiLeadsCampaignContactsAssignedToHumanAgents {
  String? humanAgentId;
  String? assignedAt;
  String? assignedBy;
  String? sId;

  AiLeadsCampaignContactsAssignedToHumanAgents({
    this.humanAgentId,
    this.assignedAt,
    this.assignedBy,
    this.sId,
  });

  AiLeadsCampaignContactsAssignedToHumanAgents.fromJson(
      Map<String, dynamic> json) {
    humanAgentId = json['humanAgentId'];
    assignedAt = json['assignedAt'];
    assignedBy = json['assignedBy'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['humanAgentId'] = humanAgentId;
    data['assignedAt'] = assignedAt;
    data['assignedBy'] = assignedBy;
    data['_id'] = sId;
    return data;
  }
}

class AiLeadsCampaignContactsCampaignInfo {
  String? campaignId;
  String? campaignName;
  String? campaignDescription;

  AiLeadsCampaignContactsCampaignInfo({
    this.campaignId,
    this.campaignName,
    this.campaignDescription,
  });

  AiLeadsCampaignContactsCampaignInfo.fromJson(Map<String, dynamic> json) {
    campaignId = json['campaignId'];
    campaignName = json['campaignName'];
    campaignDescription = json['campaignDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['campaignId'] = campaignId;
    data['campaignName'] = campaignName;
    data['campaignDescription'] = campaignDescription;
    return data;
  }
}

class AiLeadsCampaignContactsPagination {
  int? currentPage;
  int? totalPages;
  int? totalItems;
  int? itemsPerPage;
  bool? hasNextPage;
  bool? hasPrevPage;
  dynamic nextPage;
  dynamic prevPage;

  AiLeadsCampaignContactsPagination({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.itemsPerPage,
    this.hasNextPage,
    this.hasPrevPage,
    this.nextPage,
    this.prevPage,
  });

  AiLeadsCampaignContactsPagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalItems = json['totalItems'];
    itemsPerPage = json['itemsPerPage'];
    hasNextPage = json['hasNextPage'];
    hasPrevPage = json['hasPrevPage'];
    nextPage = json['nextPage'];
    prevPage = json['prevPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['totalItems'] = totalItems;
    data['itemsPerPage'] = itemsPerPage;
    data['hasNextPage'] = hasNextPage;
    data['hasPrevPage'] = hasPrevPage;
    data['nextPage'] = nextPage;
    data['prevPage'] = prevPage;
    return data;
  }
}

class AiLeadsCampaignContactsFilter {
  String? applied;

  AiLeadsCampaignContactsFilter({this.applied});

  AiLeadsCampaignContactsFilter.fromJson(Map<String, dynamic> json) {
    applied = json['applied'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['applied'] = applied;
    return data;
  }
}
