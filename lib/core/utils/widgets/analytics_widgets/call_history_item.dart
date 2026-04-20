import '../../../../data/model/myDial/analytics_model/call_history_model.dart';
import '../../../app-export.dart';
import 'dart:math';

class CallHistoryListItem extends StatelessWidget {
  final CallHistoryItem callItem;

  const CallHistoryListItem({super.key, required this.callItem});

  @override
  Widget build(BuildContext context) {
    final String firstLetter = (callItem.name.isNotEmpty
            ? callItem.name[0].toUpperCase()
            : (callItem.phoneNumber.isNotEmpty ? callItem.phoneNumber[0] : '?'))
        .toUpperCase();

    final Color avatarColor = _getColorFromName(callItem.name);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // 🔹 Circle Avatar with First Letter
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: avatarColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              firstLetter,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // 🔹 Name & Number
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  callItem.name.isNotEmpty ? callItem.name : 'Unknown',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  callItem.phoneNumber,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // 🔹 Date & Time
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  callItem.date,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  callItem.time,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // 🔹 Call Type Icon
          Icon(
            _getCallIcon(callItem.callType),
            color: _getCallColor(callItem.callType),
            size: 22,
          ),
        ],
      ),
    );
  }

  /// 🔹 Icon for each call type
  IconData _getCallIcon(CallType type) {
    switch (type) {
      case CallType.incoming:
        return Icons.call_received;
      case CallType.outgoing:
        return Icons.call_made;
      case CallType.missed:
        return Icons.call_missed;
      case CallType.rejected:
        return Icons.call_end;
      default:
        return Icons.call;
    }
  }

  /// 🔹 Color for each call type
  Color _getCallColor(CallType type) {
    switch (type) {
      case CallType.incoming:
        return Colors.green;
      case CallType.outgoing:
        return Colors.blue;
      case CallType.missed:
        return Colors.red;
      case CallType.rejected:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  /// 🔹 Generate a color from the name (deterministic random)
  Color _getColorFromName(String name) {
    if (name.isEmpty) return Colors.grey.shade400;
    final int hash = name.codeUnits.fold(0, (a, b) => a + b);
    final Random random = Random(hash);
    return Color.fromARGB(
      255,
      100 + random.nextInt(156),
      100 + random.nextInt(156),
      100 + random.nextInt(156),
    );
  }
}
