class CallLog {
  final String? id; // Add this field
  final String contactName;
  final String phoneNumber;
  final bool isIncoming;
  final DateTime dateTime;
  final Duration duration;

  CallLog({
    this.id, // Add this parameter
    required this.contactName,
    required this.phoneNumber,
    required this.isIncoming,
    required this.dateTime,
    required this.duration,
  });
}