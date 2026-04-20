import 'package:aitota_business/core/app-export.dart';
import '../controller/groups_controller.dart';
import '../models/group_models.dart';
import 'group_chat_screen.dart';

class TeamChatsListScreen extends GetView<GroupsController> {
  const TeamChatsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Light background
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54), // WhatsApp green
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: Text(
          'Team Chats',
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Obx(() {
        final members = controller.contacts;
        // Build pairwise conversations where messages exist between two members
        final pairs = <_PairItem>[];

        // A simple heuristic using personalMessages keyed by memberId (messages from AI/admin to members)
        for (final from in members) {
          final msgs = controller.personalMessages[from.id] ?? const [];
          if (msgs.isEmpty) continue;
          // Assume messages are directed to 'from' (recipientMemberId == from.id)
          // We list pairs as (sender -> from)
          for (final msg in msgs) {
            final String senderId = msg.senderId;
            final MemberModel? sender = members.firstWhereOrNull((m) => m.id == senderId) ??
                (senderId == controller.aiAgent.id ? controller.aiAgent : (senderId == controller.admin.id ? controller.admin : null));
            if (sender == null) continue;
            final key = '${sender.id}->${from.id}';
            if (pairs.any((p) => p.key == key)) continue;
            pairs.add(_PairItem(
              key: key,
              from: sender,
              to: from,
              lastTime: msg.timestamp,
            ));
          }
        }

        pairs.sort((a, b) => (b.lastTime?.millisecondsSinceEpoch ?? 0) - (a.lastTime?.millisecondsSinceEpoch ?? 0));

        if (pairs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.forum_outlined, size: 40.sp, color: Colors.grey[400]),
                SizedBox(height: 12.h),
                Text(
                  'No team chats yet',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.sp,
                    fontFamily: AppFonts.poppins,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(12.w),
          separatorBuilder: (_, __) => SizedBox(height: 8.h),
          itemCount: pairs.length,
          itemBuilder: (_, index) {
            final p = pairs[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white, // Light card background
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF075E54).withOpacity(0.1),
                  child: const Icon(Icons.group, color: Color(0xFF075E54)),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        p.from.displayName,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15.sp,
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Icon(Icons.arrow_forward, color: const Color(0xFF075E54), size: 18.sp),
                    ),
                    Expanded(
                      child: Text(
                        p.to.displayName,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15.sp,
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                subtitle: p.lastTime != null
                    ? Text(
                        _formatTime(p.lastTime!),
                        style: TextStyle(color: Colors.grey[500], fontSize: 12.sp, fontFamily: AppFonts.poppins),
                      )
                    : null,
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () async {
                  // Open the detailed chat between p.from and p.to
                  // We reuse PersonalChatScreen focusing on the recipient (to)
                  await Get.to(() => PersonalChatScreen(memberId: p.to.id));
                  controller.contacts.refresh();
                },
              ),
            );
          },
        );
      }),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final ampm = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }
}

class _PairItem {
  final String key;
  final MemberModel from;
  final MemberModel to;
  final DateTime? lastTime;
  _PairItem({required this.key, required this.from, required this.to, required this.lastTime});
}

