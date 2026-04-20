import 'package:get/get.dart';
import '../models/group_models.dart';

class GroupsController extends GetxController {
  final RxList<GroupModel> groups = <GroupModel>[].obs;
  final Rx<GroupModel?> selectedGroup = Rx<GroupModel?>(null);
  final RxList<MemberModel> contacts = <MemberModel>[].obs; // all known contacts
  final RxMap<String, List<MessageModel>> groupMessages = <String, List<MessageModel>>{}.obs; // groupId -> messages
  final RxMap<String, List<MessageModel>> personalMessages = <String, List<MessageModel>>{}.obs; // memberId -> messages
  final RxMap<String, List<MessageModel>> commonGroupMessages = <String, List<MessageModel>>{}.obs; // commonGroupId -> messages
  final RxMap<String, int> unreadGroupCounts = <String, int>{}.obs; // groupId -> unread
  final RxMap<String, int> unreadPersonalCounts = <String, int>{}.obs; // memberId -> unread
  final RxMap<String, DateTime> lastGroupMessageTime = <String, DateTime>{}.obs; // groupId -> last time
  final RxMap<String, DateTime> lastPersonalMessageTime = <String, DateTime>{}.obs; // memberId -> last time

  MemberModel get aiAgent => const MemberModel(
    id: 'ai-agent',
    displayName: 'AI Agent',
    isAiAgent: true,
  );

  MemberModel get admin => const MemberModel(
    id: 'admin-local',
    displayName: 'Admin',
    isAiAgent: false,
  );

  @override
  void onInit() {
    super.onInit();
    if (!contacts.any((m) => m.id == admin.id)) {
      contacts.add(admin);
      personalMessages[admin.id] = <MessageModel>[];
    }
    initializeCommonGroup();
  }

  void createGroup(String name) {
    final GroupModel group = GroupModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      members: [aiAgent],
      adminId: 'admin-local',
    );
    groups.add(group);
    groupMessages[group.id] = <MessageModel>[];
    unreadGroupCounts[group.id] = 0;
  }

  void createGroupWithContacts(String name, List<Map<String, dynamic>> selectedContacts) {
    createGroup(name);
    final GroupModel group = groups.last;
    selectedGroup.value = group;
    if (selectedContacts.isNotEmpty) {
      addMembersFromContacts(selectedContacts);
    }
  }

  void selectGroup(GroupModel group) {
    selectedGroup.value = group;
  }

  void addMemberToSelected(String phoneNumber) {
    final GroupModel? group = selectedGroup.value;
    if (group == null) return;
    final MemberModel newMember = MemberModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      displayName: phoneNumber,
      phoneNumber: phoneNumber,
    );
    final List<MemberModel> updated = List<MemberModel>.from(group.members)
      ..add(newMember);
    final GroupModel updatedGroup = group.copyWith(members: updated);

    final int index = groups.indexWhere((g) => g.id == group.id);
    if (index != -1) {
      groups[index] = updatedGroup;
      selectedGroup.value = updatedGroup;
    }

    // also add to contacts if not exists
    if (!contacts.any((m) => m.phoneNumber == phoneNumber)) {
      contacts.add(newMember);
      personalMessages[newMember.id] = <MessageModel>[];
    }
  }

  void addAiAgentToSelected(String displayName, String phoneNumber) {
    final GroupModel? group = selectedGroup.value;
    if (group == null) return;
    final MemberModel newMember = MemberModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      displayName: displayName.isNotEmpty ? displayName : 'AI Agent',
      phoneNumber: phoneNumber.isNotEmpty ? phoneNumber : null,
      isAiAgent: true,
    );
    final List<MemberModel> updated = List<MemberModel>.from(group.members)
      ..add(newMember);
    final GroupModel updatedGroup = group.copyWith(members: updated);

    final int index = groups.indexWhere((g) => g.id == group.id);
    if (index != -1) {
      groups[index] = updatedGroup;
      selectedGroup.value = updatedGroup;
    }

    if (!contacts.any((m) => (m.phoneNumber ?? '') == (phoneNumber))) {
      contacts.add(newMember);
      personalMessages[newMember.id] = <MessageModel>[];
    }
  }

  void addMembersFromContacts(List<Map<String, dynamic>> selected) {
    final GroupModel? group = selectedGroup.value;
    if (group == null) return;

    final List<MemberModel> updatedMembers = List<MemberModel>.from(group.members);
    for (final contact in selected) {
      final String phone = (contact['phone'] ?? '').toString();
      final String name = (contact['name'] ?? '').toString();
      if (phone.isEmpty) continue;
      final bool alreadyInGroup = updatedMembers.any((m) => (m.phoneNumber ?? '') == phone);
      if (alreadyInGroup) continue;
      final MemberModel member = MemberModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        displayName: name.isNotEmpty ? name : phone,
        phoneNumber: phone,
      );
      updatedMembers.add(member);

      // Always ensure a contact entry exists and is updated by phone
      final int existingIndex = contacts.indexWhere((m) => (m.phoneNumber ?? '') == phone);
      if (existingIndex == -1) {
        contacts.add(member);
      } else {
        contacts[existingIndex] = MemberModel(
          id: contacts[existingIndex].id,
          displayName: name.isNotEmpty ? name : phone,
          phoneNumber: phone,
          isAiAgent: contacts[existingIndex].isAiAgent,
        );
      }
      personalMessages.putIfAbsent(member.id, () => <MessageModel>[]);
    }

    final GroupModel updatedGroup = group.copyWith(members: updatedMembers);
    final int index = groups.indexWhere((g) => g.id == group.id);
    if (index != -1) {
      groups[index] = updatedGroup;
      selectedGroup.value = updatedGroup;
    }
  }

  void sendGroupMessage(String groupId, String senderId, String text) {
    final List<MessageModel> list = groupMessages[groupId] ?? <MessageModel>[];
    final MessageModel msg = MessageModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      senderId: senderId,
      text: text,
      timestamp: DateTime.now(),
      groupId: groupId,
    );
    list.add(msg);
    groupMessages[groupId] = List<MessageModel>.from(list);
    lastGroupMessageTime[groupId] = msg.timestamp;
    // increment unread if not currently viewing this group
    if (selectedGroup.value?.id != groupId) {
      final int current = unreadGroupCounts[groupId] ?? 0;
      unreadGroupCounts[groupId] = current + 1;
    }
  }

  void sendPersonalMessage(String memberId, String senderId, String text) {
    final List<MessageModel> list = personalMessages[memberId] ?? <MessageModel>[];
    final MessageModel msg = MessageModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      senderId: senderId,
      text: text,
      timestamp: DateTime.now(),
      recipientMemberId: memberId,
    );
    list.add(msg);
    personalMessages[memberId] = List<MessageModel>.from(list);
    lastPersonalMessageTime[memberId] = msg.timestamp;
    // increment unread if not currently viewing this member chat
    // no selected tracking for personal; will be reset on open
    final int current = unreadPersonalCounts[memberId] ?? 0;
    unreadPersonalCounts[memberId] = current + 1;
  }

  void updateGroupName(String groupId, String newName) {
    final int index = groups.indexWhere((g) => g.id == groupId);
    if (index == -1) return;
    final GroupModel current = groups[index];
    final GroupModel updated = current.copyWith(name: newName.trim());
    groups[index] = updated;
    if (selectedGroup.value?.id == groupId) {
      selectedGroup.value = updated;
    }
  }

  void onOpenGroupChat(String groupId) {
    unreadGroupCounts[groupId] = 0;
  }

  void onOpenPersonalChat(String memberId) {
    unreadPersonalCounts[memberId] = 0;
  }

  // Common Group Methods
  void initializeCommonGroup() {
    const String commonGroupId = 'common-group';
    if (!commonGroupMessages.containsKey(commonGroupId)) {
      commonGroupMessages[commonGroupId] = <MessageModel>[];
      // Add predefined conversation messages
      _addStaticMessagesToCommonGroup();
    }
  }

  void _addStaticMessagesToCommonGroup() {
    const String commonGroupId = 'common-group';
    // Predefined conversation with 6 message pairs (user and AI responses)
    final List<MessageModel> conversationMessages = [
    MessageModel(
      id: '1',
      senderId: 'user',
      text: 'Hello!',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      groupId: commonGroupId,
    ),
    MessageModel(
    id: '2',
    senderId: 'ai-agent',
    text: 'Hey there! How can I assist you today?',
    timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
    groupId: commonGroupId,
    ),
    MessageModel(
    id: '3',
    senderId: 'user',
    text: 'Just checking in, whatsup?',
    timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
    groupId: commonGroupId,
    ),
    MessageModel(
    id: '4',
    senderId: 'ai-agent',
    text: 'All good here! Ready to answer any questions or chat about anything!',
    timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
    groupId: commonGroupId,
    ),
    MessageModel(
    id: '5',
    senderId: 'user',
    text: 'Cool, tell me something interesting!',
    timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 40)),
    groupId: commonGroupId,
    ),
    MessageModel(
    id: '6',
    senderId: 'ai-agent',
    text: 'Did you know that octopuses have three hearts and can change color to blend into their surroundings?',
    timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 35)),
    groupId: commonGroupId,
    ),
    ];
    commonGroupMessages[commonGroupId] = conversationMessages;
  }

  void sendCommonGroupMessage(String text) {
    const String commonGroupId = 'common-group';
    final List<MessageModel> list = commonGroupMessages[commonGroupId] ?? <MessageModel>[];
    final MessageModel msg = MessageModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      senderId: aiAgent.id,
      text: text,
      timestamp: DateTime.now(),
      groupId: commonGroupId,
    );
    list.add(msg);
    commonGroupMessages[commonGroupId] = List<MessageModel>.from(list);

    // Send this message to all members' personal chats
    for (final member in contacts) {
      if (!member.isAiAgent) {
        sendPersonalMessage(member.id, aiAgent.id, text);
      }
    }
  }

  void sendPersonalMessageToCommonGroup(String memberId, String text) {
    const String commonGroupId = 'common-group';
    final List<MessageModel> list = commonGroupMessages[commonGroupId] ?? <MessageModel>[];
    final MessageModel msg = MessageModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      senderId: aiAgent.id, // Changed from memberId to aiAgent.id
      text: text,
      timestamp: DateTime.now(),
      groupId: commonGroupId,
    );
    list.add(msg);
    commonGroupMessages[commonGroupId] = List<MessageModel>.from(list);
  }
}