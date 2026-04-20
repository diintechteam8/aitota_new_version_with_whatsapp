import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app-export.dart';
import '../controller/groups_controller.dart';
import '../models/group_models.dart';
import 'group_chat_screen.dart';
import 'create_group_select_members_screen.dart';
import '../../../routes/app_routes.dart' as app_routes;

class GroupInfoScreen extends GetView<GroupsController> {
  final String groupId;
  const GroupInfoScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Light background
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54), // WhatsApp green
        foregroundColor: Colors.white,
        titleSpacing: 0, // Reduces spacing between back button and title
        title: const Text(
          'Group info',
          style: TextStyle(fontFamily: AppFonts.poppins),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: Colors.white, // Light popup background
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'add_members',
                child: Row(
                  children: [
                    const Icon(Icons.person_add, color: Color(0xFF075E54), size: 20),
                    SizedBox(width: 10.w),
                    const Text(
                      'Add members',
                      style: TextStyle(color: Colors.black87, fontFamily: AppFonts.poppins),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'add_ai',
                child: Row(
                  children: [
                    const Icon(Icons.smart_toy_outlined, color: Color(0xFF075E54), size: 20),
                    SizedBox(width: 10.w),
                    Text(
                      'Add AI Agent',
                      style: TextStyle(color: Colors.black87, fontFamily: AppFonts.poppins),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) async {
              final group = _resolveGroup();
              if (value == 'add_members') {
                await _openSelectMembersAndAdd(group);
              } else if (value == 'add_ai') {
                await _showAddAiAgentDialog(group);
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        final group = _resolveGroup();
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28.w,
                  backgroundColor: const Color(0xFF075E54), // WhatsApp green
                  child: const Icon(Icons.group, color: Colors.white),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(group.name, style: TextStyle(color: Colors.black87, fontSize: 18.sp, fontFamily: AppFonts.poppins, fontWeight: FontWeight.w600)),
                      SizedBox(height: 4.h),
                      Text('${group.members.length} participants', style: TextStyle(color: Colors.grey[600], fontSize: 12.sp, fontFamily: AppFonts.poppins)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFF075E54)),
                  onPressed: () => _promptRename(group),
                )
              ],
            ),
            SizedBox(height: 16.h),
            Divider(color: Colors.grey[300], height: 1.h),
            SizedBox(height: 8.h),
            Text('Participants', style: TextStyle(color: Colors.black87, fontSize: 14.sp, fontFamily: AppFonts.poppins, fontWeight: FontWeight.w600)),
            SizedBox(height: 8.h),
            ...group.members.map((m) => ListTile(
              leading: CircleAvatar(
                backgroundColor: m.isAiAgent ? const Color(0xFF075E54) : Colors.grey[200],
                child: Icon(m.isAiAgent ? Icons.smart_toy : Icons.person, color: m.isAiAgent ? Colors.white : Colors.grey[600]),
              ),
              title: Row(
                children: [
                  Expanded(child: Text(m.displayName, style: TextStyle(color: Colors.black87, fontFamily: AppFonts.poppins))),
                  if (m.isAiAgent)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(color: const Color(0xFF075E54).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: Text('AI', style: TextStyle(color: const Color(0xFF075E54), fontSize: 11.sp, fontFamily: AppFonts.poppins, fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
              subtitle: m.phoneNumber != null ? Text(m.phoneNumber!, style: TextStyle(color: Colors.grey[600], fontFamily: AppFonts.poppins)) : null,
              onTap: !m.isAiAgent ? () async {
                await Get.to(() => PersonalChatScreen(memberId: m.id), arguments: {'fromGroupInfo': true});
                controller.contacts.refresh();
              } : null,
              trailing: !m.isAiAgent ? const Icon(Icons.chevron_right, color: Colors.grey) : null,
            )),
            SizedBox(height: 12.h),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF075E54), // WhatsApp green
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              ),
              onPressed: () async {
                final group = _resolveGroup();
                await _openSelectMembersAndAdd(group);
              },
              icon: const Icon(Icons.person_add),
              label: Text('Add participants', style: TextStyle(fontFamily: AppFonts.poppins)),
            ),
            SizedBox(height: 8.h),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF075E54), // WhatsApp green
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              ),
              onPressed: () async {
                final group = _resolveGroup();
                await _showAddAiAgentDialog(group);
              },
              icon: const Icon(Icons.smart_toy),
              label: Text('Add AI Agent', style: TextStyle(fontFamily: AppFonts.poppins)),
            )
          ],
        );
      }),
    );
  }

  GroupModel _resolveGroup() {
    final g = controller.groups.firstWhere(
          (g) => g.id == groupId,
      orElse: () => controller.selectedGroup.value ?? (controller.groups.isNotEmpty ? controller.groups.first : GroupModel(id: groupId, name: '', members: [], adminId: '')),
    );
    return g;
  }

  Future<void> _openSelectMembersAndAdd(GroupModel group) async {
    final existingPhones = group.members
        .map((m) => (m.phoneNumber ?? '').trim())
        .where((p) => p.isNotEmpty)
        .toList();

    final result = await Get.to(
          () => const CreateGroupSelectMembersScreen(),
      arguments: {
        'mode': 'add',
        'excludePhones': existingPhones,
      },
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 250),
    );

    if (result != null && result is List) {
      controller.selectGroup(group);
      controller.addMembersFromContacts(List<Map<String, dynamic>>.from(result));
    }
  }

  Future<void> _showAddAiAgentDialog(GroupModel group) async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    await showDialog(
      context: Get.context!,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white, // Light background
        title: const Text('Add AI Agent', style: TextStyle(color: Colors.black87)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.black87),
              decoration: const InputDecoration(
                labelText: 'Agent name',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF075E54))),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.black87),
              decoration: const InputDecoration(
                labelText: 'Phone number (optional)',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF075E54))),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF075E54), foregroundColor: Colors.white),
            onPressed: () {
              controller.selectGroup(group);
              controller.addAiAgentToSelected(nameController.text.trim(), phoneController.text.trim());
              Get.back();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _promptRename(GroupModel group) async {
    final TextEditingController nameController = TextEditingController(text: group.name);
    await showDialog(
      context: Get.context!,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white, // Light background
        title: const Text('Rename group', style: TextStyle(color: Colors.black87)),
        content: TextField(
          controller: nameController,
          style: const TextStyle(color: Colors.black87),
          decoration: const InputDecoration(
            hintText: 'Enter new group name',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF075E54))),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF075E54), foregroundColor: Colors.white),
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                controller.updateGroupName(group.id, name);
                Get.back();
              }
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }
}