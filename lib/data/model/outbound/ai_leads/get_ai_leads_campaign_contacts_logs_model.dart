class GetAiLeadsCampaignContactsLogsModel {
  bool? success;
  String? transcript;
  String? documentId;

  GetAiLeadsCampaignContactsLogsModel(
      {this.success, this.transcript, this.documentId});

  GetAiLeadsCampaignContactsLogsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    transcript = json['transcript'];
    documentId = json['documentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = this.success;
    data['transcript'] = this.transcript;
    data['documentId'] = this.documentId;
    return data;
  }
}