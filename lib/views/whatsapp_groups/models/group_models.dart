// Models only; keep framework imports minimal.

class MemberModel {
  final String id;
  final String displayName;
  final String? phoneNumber;
  final bool isAiAgent;

  const MemberModel({
    required this.id,
    required this.displayName,
    this.phoneNumber,
    this.isAiAgent = false,
  });
}

class GroupModel {
  final String id;
  final String name;
  final List<MemberModel> members;
  final String adminId;

  const GroupModel({
    required this.id,
    required this.name,
    required this.members,
    required this.adminId,
  });

  GroupModel copyWith({String? id, String? name, List<MemberModel>? members}) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      members: members ?? this.members,
      adminId: adminId,
    );
  }
}

class MessageModel {
  final String id;
  final String senderId;
  final String? groupId;
  final String? recipientMemberId; // for personal chats
  final String text;
  final DateTime timestamp;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.groupId,
    this.recipientMemberId,
  });
}


