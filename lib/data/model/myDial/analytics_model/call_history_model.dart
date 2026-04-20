enum CallType { incoming, outgoing, missed, rejected }

class CallHistoryItem {
  final String id; // Add this field
  final String name;
  final String phoneNumber;
  final String date;
  final String time;
  final String duration;
  final CallType callType;

  CallHistoryItem({
    required this.id, // Add this parameter
    required this.name,
    required this.phoneNumber,
    required this.date,
    required this.time,
    required this.duration,
    required this.callType,
  });
}
