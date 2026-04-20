class GetDialLeadsModel {
  bool? success;
  DialLeadData? data;
  Filter? filter;

  GetDialLeadsModel({this.success, this.data, this.filter});

  factory GetDialLeadsModel.fromJson(Map<String, dynamic> json) {
    return GetDialLeadsModel(
      success: json['success'],
      data: json['data'] != null ? DialLeadData.fromJson(json['data']) : null,
      filter: json['filter'] != null ? Filter.fromJson(json['filter']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
      'filter': filter?.toJson(),
    };
  }
}

class DialLeadData {
  // New format: Map of leadStatus keys to LeadCategoryData
  Map<String, LeadCategoryData>? leadStatusMap;

  // Legacy properties for backward compatibility (deprecated)
  LeadCategoryData? veryInterested;
  LeadCategoryData? maybe;
  LeadCategoryData? enrolled;
  LeadCategoryData? junkLead;
  LeadCategoryData? notRequired;
  LeadCategoryData? enrolledOther;
  LeadCategoryData? decline;
  LeadCategoryData? notEligible;
  LeadCategoryData? wrongNumber;
  LeadCategoryData? hotFollowup;
  LeadCategoryData? coldFollowup;
  LeadCategoryData? schedule;
  LeadCategoryData? notConnected;
  LeadCategoryData? other;

  DialLeadData({
    this.leadStatusMap,
    this.veryInterested,
    this.maybe,
    this.enrolled,
    this.junkLead,
    this.notRequired,
    this.enrolledOther,
    this.decline,
    this.notEligible,
    this.wrongNumber,
    this.hotFollowup,
    this.coldFollowup,
    this.schedule,
    this.notConnected,
    this.other,
  });

  factory DialLeadData.fromJson(Map<String, dynamic> json) {
    // Check if data is in new format (Map of leadStatus keys)
    // New format has keys like: payment_pending, Document_pending, no_response, call_busy, etc.
    // Legacy format has keys like: veryInterested, maybe, enrolled, etc.
    
    bool isNewFormat = false;
    
    // Check for new format keys
    final newFormatKeys = [
      'payment_pending', 'Document_pending', 'no_response', 'call_busy', 'call_bussy',
      'not_reachable', 'switched_off', 'out_of_coverage', 'call_disconnected', 'call_later',
      'call_back_schedule', 'information_shared', 'follow_up_required', 'call_back_due',
      'whatsapp_sent', 'interested_waiting_confimation', 'admission_confirmed',
      'payment_recieved', 'course_started', 'not_interested', 'joined_another_institute',
      'dropped_the_plan', 'dnd', 'unqualified_lead', 'wrong_number', 'invalid_number',
      'postpone', 'other'
    ];
    
    // Check for legacy format keys
    final legacyFormatKeys = [
      'veryInterested', 'maybe', 'enrolled', 'junkLead', 'notRequired',
      'enrolledOther', 'decline', 'notEligible', 'wrongNumber', 'hotFollowup',
      'coldFollowup', 'schedule', 'notConnected', 'other'
    ];
    
    // Determine format by checking which keys exist
    bool hasNewFormatKey = newFormatKeys.any((key) => json.containsKey(key));
    bool hasLegacyFormatKey = legacyFormatKeys.any((key) => json.containsKey(key));
    
    if (hasNewFormatKey && !hasLegacyFormatKey) {
      isNewFormat = true;
    } else if (!hasNewFormatKey && hasLegacyFormatKey) {
      isNewFormat = false;
    } else {
      // If both exist, prefer new format
      isNewFormat = hasNewFormatKey;
    }
    
    if (isNewFormat) {
      // New format: data is a Map<String, LeadCategoryData>
      Map<String, LeadCategoryData> leadStatusMap = {};
      json.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          try {
            leadStatusMap[key] = LeadCategoryData.fromJson(value);
          } catch (e) {
            print('Error parsing leadStatus $key: $e');
          }
        }
      });
      return DialLeadData(leadStatusMap: leadStatusMap);
    } else {
      // Legacy format: individual properties
      return DialLeadData(
        veryInterested: json['veryInterested'] != null
            ? LeadCategoryData.fromJson(json['veryInterested'])
            : null,
        maybe: json['maybe'] != null
            ? LeadCategoryData.fromJson(json['maybe'])
            : null,
        enrolled: json['enrolled'] != null
            ? LeadCategoryData.fromJson(json['enrolled'])
            : null,
        junkLead: json['junkLead'] != null
            ? LeadCategoryData.fromJson(json['junkLead'])
            : null,
        notRequired: json['notRequired'] != null
            ? LeadCategoryData.fromJson(json['notRequired'])
            : null,
        enrolledOther: json['enrolledOther'] != null
            ? LeadCategoryData.fromJson(json['enrolledOther'])
            : null,
        decline: json['decline'] != null
            ? LeadCategoryData.fromJson(json['decline'])
            : null,
        notEligible: json['notEligible'] != null
            ? LeadCategoryData.fromJson(json['notEligible'])
            : null,
        wrongNumber: json['wrongNumber'] != null
            ? LeadCategoryData.fromJson(json['wrongNumber'])
            : null,
        hotFollowup: json['hotFollowup'] != null
            ? LeadCategoryData.fromJson(json['hotFollowup'])
            : null,
        coldFollowup: json['coldFollowup'] != null
            ? LeadCategoryData.fromJson(json['coldFollowup'])
            : null,
        schedule: json['schedule'] != null
            ? LeadCategoryData.fromJson(json['schedule'])
            : null,
        notConnected: json['notConnected'] != null
            ? LeadCategoryData.fromJson(json['notConnected'])
            : null,
        other: json['other'] != null
            ? LeadCategoryData.fromJson(json['other'])
            : null,
      );
    }
  }

  Map<String, dynamic> toJson() {
    if (leadStatusMap != null) {
      Map<String, dynamic> result = {};
      leadStatusMap!.forEach((key, value) {
        result[key] = value.toJson();
      });
      return result;
    }
    // Legacy format
    return {
      'veryInterested': veryInterested?.toJson(),
      'maybe': maybe?.toJson(),
      'enrolled': enrolled?.toJson(),
      'junkLead': junkLead?.toJson(),
      'notRequired': notRequired?.toJson(),
      'enrolledOther': enrolledOther?.toJson(),
      'decline': decline?.toJson(),
      'notEligible': notEligible?.toJson(),
      'wrongNumber': wrongNumber?.toJson(),
      'hotFollowup': hotFollowup?.toJson(),
      'coldFollowup': coldFollowup?.toJson(),
      'schedule': schedule?.toJson(),
      'notConnected': notConnected?.toJson(),
      'other': other?.toJson(),
    };
  }

  // Helper method to get data by leadStatus key
  LeadCategoryData? getByLeadStatus(String leadStatus) {
    return leadStatusMap?[leadStatus];
  }
}

class LeadCategoryData {
  List<LeadData>? data;
  int? count;

  LeadCategoryData({this.data, this.count});

  factory LeadCategoryData.fromJson(Map<String, dynamic> json) {
    return LeadCategoryData(
      data: json['data'] != null
          ? List<LeadData>.from(json['data'].map((v) => LeadData.fromJson(v)))
          : [],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((e) => e.toJson()).toList(),
      'count': count,
    };
  }
}

class LeadData {
  String? id;
  String? clientId;
  String? humanAgentId;
  String? category;
  String? subCategory;
  String? phoneNumber;
  String? normalizedPhoneNumber;
  String? contactName;
  String? explanation;
  String? date;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? leadStatus;
  int? duration;
  String? other;

  // 🆕 Newly added fields
  int? age;
  String? profession;
  String? gender;
  String? pincode;
  String? city;

  LeadData({
    this.id,
    this.clientId,
    this.humanAgentId,
    this.category,
    this.subCategory,
    this.phoneNumber,
    this.normalizedPhoneNumber,
    this.contactName,
    this.explanation,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.leadStatus,
    this.duration,
    this.other,
    this.age,
    this.profession,
    this.gender,
    this.pincode,
    this.city,
  });

  factory LeadData.fromJson(Map<String, dynamic> json) {
    return LeadData(
      id: json['_id'],
      clientId: json['clientId'],
      humanAgentId: json['humanAgentId'],
      category: json['category'],
      subCategory: json['subCategory'],
      phoneNumber: json['phoneNumber'],
      normalizedPhoneNumber: json['normalizedPhoneNumber'],
      contactName: json['contactName'],
      explanation: json['explanation'],
      date: json['date'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      leadStatus: json['leadStatus'],
      duration: json['duration'],
      other: json['other'],

      // 🆕 Map new fields
      age: json['age'],
      profession: json['profession'],
      gender: json['gender'],
      pincode: json['pincode'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'clientId': clientId,
      'humanAgentId': humanAgentId,
      'category': category,
      'subCategory': subCategory,
      'phoneNumber': phoneNumber,
      'normalizedPhoneNumber': normalizedPhoneNumber,
      'contactName': contactName,
      'explanation': explanation,
      'date': date,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'leadStatus': leadStatus,
      'duration': duration,
      'other': other,

      // 🆕 Include in JSON
      'age': age,
      'profession': profession,
      'gender': gender,
      'pincode': pincode,
      'city': city,
    };
  }
}



class Filter {
  String? applied;
  String? startDate;
  String? endDate;

  Filter({this.applied, this.startDate, this.endDate});

  factory Filter.fromJson(Map<String, dynamic> json) {
    return Filter(
      applied: json['applied'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'applied': applied,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}