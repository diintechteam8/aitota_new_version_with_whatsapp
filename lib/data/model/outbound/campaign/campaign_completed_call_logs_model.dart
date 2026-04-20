class CampaignCompletedCallLogsModel {
  final bool? success;
  final String? transcript;
  final String? documentId;

  CampaignCompletedCallLogsModel({
    this.success,
    this.transcript,
    this.documentId,
  });

  factory CampaignCompletedCallLogsModel.fromJson(Map<String, dynamic> json) {
    return CampaignCompletedCallLogsModel(
      success: json['success'] as bool?,
      transcript: json['transcript'] as String?,
      documentId: json['documentId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'transcript': transcript,
      'documentId': documentId,
    };
  }
}
