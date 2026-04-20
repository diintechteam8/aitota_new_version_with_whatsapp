import '../../../core/app-export.dart';
import '../controller/groups_controller.dart';
import '../models/group_models.dart';
import '../binding/groups_binding.dart';
import 'group_chat_screen.dart';

class GroupDetailScreen extends GetView<GroupsController> {
  final String groupId;
  const GroupDetailScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    controller.initializeCommonGroup();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Light background
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54), // WhatsApp green
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: Obx(() {
          final group = controller.groups.firstWhere(
                (g) => g.id == groupId,
            orElse: () => controller.selectedGroup.value ??
                GroupModel(
                  id: groupId,
                  name: 'Unknown Group',
                  members: [],
                  adminId: '',
                ),
          );
          return Text(
            group.name,
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          );
        }),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 4,
            offset: const Offset(0, kToolbarHeight),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'add_members',
                child: Row(
                  children: [
                    const Icon(Icons.person_add, color: Color(0xFF00A884)),
                    SizedBox(width: 10.w),
                    Text(
                      'Add Members',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: AppFonts.poppins,
                        color: const Color(0xFF121B22), // Dark text for light mode
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'add_agent',
                child: Row(
                  children: [
                    const Icon(Icons.smart_toy_outlined, color: Color(0xFF00A884)),
                    SizedBox(width: 10.w),
                    Text(
                      'Add Agent',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: AppFonts.poppins,
                        color: const Color(0xFF121B22),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'rename_group',
                child: Row(
                  children: [
                    const Icon(Icons.edit, color: Color(0xFF00A884)),
                    SizedBox(width: 10.w),
                    Text(
                      'Rename Group',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: AppFonts.poppins,
                        color: const Color(0xFF121B22),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) async {
              if (value == 'add_members') {
                final result = await Get.toNamed('/openPhonebookScreen');
                if (result != null && result is List) {
                  controller.addMembersFromContacts(
                    List<Map<String, dynamic>>.from(result),
                  );
                }
              } else if (value == 'add_agent') {
                _showAddAiAgentDialog(context);
              } else if (value == 'rename_group') {
                final group = controller.groups.firstWhere(
                      (g) => g.id == groupId,
                  orElse: () => controller.selectedGroup.value ??
                      GroupModel(
                        id: groupId,
                        name: 'Unknown Group',
                        members: [],
                        adminId: '',
                      ),
                );
                _promptRename(group);
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        final group = controller.groups.firstWhere(
              (g) => g.id == groupId,
          orElse: () => controller.selectedGroup.value ??
              GroupModel(
                id: groupId,
                name: 'Unknown Group',
                members: [],
                adminId: '',
              ),
        );

        // Separate members into AI agents and regular members
        final List<MemberModel> aiAgents = group.members.where((m) => m.isAiAgent).toList();
        final List<MemberModel> regularMembers = group.members.where((m) => !m.isAiAgent).toList();

        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // White container for light mode
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _getCommonGroupNames().length,
                separatorBuilder: (_, __) => Divider(color: Colors.grey[200], height: 1.h),
                itemBuilder: (_, index) {
                  final groupName = _getCommonGroupNames()[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF00A884),
                      child: Icon(Icons.group, color: Colors.white),
                    ),
                    title: Text(
                      groupName,
                      style: TextStyle(
                        color: const Color(0xFF121B22), // Dark text
                        fontFamily: AppFonts.poppins,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Tap to open chat',
                      style: TextStyle(
                        color: const Color(0xFF6B7280), // Gray subtitle
                        fontFamily: AppFonts.poppins,
                        fontSize: 14.sp,
                      ),
                    ),
                    onTap: () {
                      // Navigate to common group chat
                      const String commonGroupId = 'common-group';
                      controller.selectGroup(group);
                      controller.onOpenGroupChat(commonGroupId);
                      Get.to(() => const GroupChatScreen(groupId: commonGroupId), binding: GroupsBinding());
                    },
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFF6B7280)),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
            // AI Agents Section
            if (aiAgents.isNotEmpty) ...[
              Text(
                'AI Agents',
                style: TextStyle(
                  color: const Color(0xFF121B22),
                  fontSize: 16.sp,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: aiAgents.length,
                  separatorBuilder: (_, __) => Divider(color: Colors.grey[200], height: 1.h),
                  itemBuilder: (_, index) {
                    final member = aiAgents[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFF075E54),
                        child: Icon(Icons.smart_toy, color: Colors.white),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              member.displayName,
                              style: TextStyle(
                                color: const Color(0xFF121B22),
                                fontFamily: AppFonts.poppins,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF25D366),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              'AI',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontFamily: AppFonts.poppins,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: member.phoneNumber != null
                          ? Text(
                        member.phoneNumber!,
                        style: TextStyle(
                          color: const Color(0xFF6B7280),
                          fontFamily: AppFonts.poppins,
                          fontSize: 14.sp,
                        ),
                      )
                          : null,
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h),
            ],
            // Regular Members Section
            Text(
              'Members',
              style: TextStyle(
                color: const Color(0xFF121B22),
                fontSize: 16.sp,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: regularMembers.length,
                separatorBuilder: (_, __) => Divider(color: Colors.grey[200], height: 1.h),
                itemBuilder: (_, index) {
                  final member = regularMembers[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE5E7EB),
                      child: Icon(Icons.person, color: Color(0xFF121B22)),
                    ),
                    title: Text(
                      member.displayName,
                      style: TextStyle(
                        color: const Color(0xFF121B22),
                        fontFamily: AppFonts.poppins,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: member.phoneNumber != null
                        ? Text(
                      member.phoneNumber!,
                      style: TextStyle(
                        color: const Color(0xFF6B7280),
                        fontFamily: AppFonts.poppins,
                        fontSize: 14.sp,
                      ),
                    )
                        : null,
                    onTap: () async {
                      await Get.to(() => PersonalChatScreen(memberId: member.id), arguments: {'fromGroupDetail': true});
                      controller.contacts.refresh();
                    },
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFF6B7280)),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _promptRename(GroupModel group) async {
    final TextEditingController nameController = TextEditingController(text: group.name);
    await showDialog(
      context: Get.context!,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white, // White for light mode
        title: Text(
          'Rename Group',
          style: TextStyle(
            color: const Color(0xFF121B22),
            fontFamily: AppFonts.poppins,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: TextField(
          controller: nameController,
          style: TextStyle(
            color: const Color(0xFF121B22),
            fontFamily: AppFonts.poppins,
            fontSize: 16.sp,
          ),
          decoration: InputDecoration(
            hintText: 'Enter new group name',
            hintStyle: TextStyle(
              color: const Color(0xFF6B7280),
              fontFamily: AppFonts.poppins,
              fontSize: 14.sp,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFF00A884)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontFamily: AppFonts.poppins,
                fontSize: 16.sp,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                controller.updateGroupName(group.id, name);
                Get.back();
              }
            },
            child: Text(
              'Save',
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddAiAgentDialog(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Add AI Agent',
          style: TextStyle(
            color: const Color(0xFF121B22),
            fontFamily: AppFonts.poppins,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: TextStyle(
                color: const Color(0xFF121B22),
                fontFamily: AppFonts.poppins,
                fontSize: 16.sp,
              ),
              decoration: InputDecoration(
                labelText: 'Agent name',
                labelStyle: TextStyle(
                  color: const Color(0xFF6B7280),
                  fontFamily: AppFonts.poppins,
                  fontSize: 14.sp,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Color(0xFF00A884)),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(
                color: const Color(0xFF121B22),
                fontFamily: AppFonts.poppins,
                fontSize: 16.sp,
              ),
              decoration: InputDecoration(
                labelText: 'Phone number (optional)',
                labelStyle: TextStyle(
                  color: const Color(0xFF6B7280),
                  fontFamily: AppFonts.poppins,
                  fontSize: 14.sp,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Color(0xFF00A884)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontFamily: AppFonts.poppins,
                fontSize: 16.sp,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: () {
              final name = nameController.text.trim();
              final phone = phoneController.text.trim();
              controller.addAiAgentToSelected(name, phone);
              Get.back();
            },
            child: Text(
              'Add',
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getCommonGroupNames() {
    return ['Together'];
  }
}