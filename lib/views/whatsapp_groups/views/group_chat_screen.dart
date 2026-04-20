import 'package:aitota_business/core/app-export.dart';
import '../controller/groups_controller.dart';
import '../../../routes/app_routes.dart' as app_routes;
import 'group_info_screen.dart';
import '../../bottom_bar/controller/bottom_bar_controller.dart';

class GroupChatScreen extends GetView<GroupsController> {
  final String groupId;
  const GroupChatScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: _buildModernAppBar(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFF0F2F5),
              const Color(0xFFE8EBF0).withOpacity(0.5),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _GroupMessageInput(groupId: groupId),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      titleSpacing: 0,
      backgroundColor: const Color(0xFF075E54),
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: groupId == 'common-group'
          ? _buildCommonGroupTitle()
          : _buildGroupTitle(context),
      actions: groupId == 'common-group' ? null : [_buildPopupMenu(context)],
    );
  }

  Widget _buildCommonGroupTitle() {
    return Row(
      children: [
        Hero(
          tag: 'common-group-avatar',
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.teal.shade300,
                  Colors.teal.shade600,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.groups, color: Colors.white, size: 22),
          ),
        ),
        SizedBox(width: 12.w),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Common Group',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Community chat',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGroupTitle(BuildContext context) {
    return Obx(() {
      final fallback = controller.selectedGroup.value ??
          (controller.groups.isNotEmpty ? controller.groups.first : null);
      final group = controller.groups.firstWhere(
            (g) => g.id == groupId,
        orElse: () => fallback ?? (throw StateError('No group available')),
      );

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Get.to(
                () => GroupInfoScreen(groupId: group.id),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 300),
          );
        },
        child: Row(
          children: [
            Hero(
              tag: 'group-avatar-${group.id}',
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade300,
                      Colors.blue.shade600,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    group.name.isNotEmpty ? group.name[0].toUpperCase() : 'G',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${group.members.length} members',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      elevation: 8,
      offset: const Offset(0, 50),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'add',
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.person_add, color: Colors.teal.shade700, size: 20),
              ),
              SizedBox(width: 12.w),
              Text(
                'Add from contacts',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'add_ai',
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.smart_toy_outlined, color: Colors.purple.shade700, size: 20),
              ),
              SizedBox(width: 12.w),
              Text(
                'Add AI agent',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) async {
        if (value == 'add') {
          final result =
          await Get.toNamed(app_routes.AppRoutes.openPhonebookScreen);
          if (result != null && result is List) {
            controller.addMembersFromContacts(
              List<Map<String, dynamic>>.from(result),
            );
          }
        } else if (value == 'add_ai') {
          _showAddAiAgentDialog(context);
        }
      },
    );
  }

  Widget _buildMessageList() {
    return Obx(() {
      final bool isCommonGroup = groupId == 'common-group';
      final messages = isCommonGroup
          ? (controller.commonGroupMessages[groupId] ?? const [])
          : (controller.groupMessages[groupId] ?? const []);

      if (messages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chat_bubble_outline,
                  size: 48,
                  color: Colors.teal.shade300,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'No messages yet',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Start the conversation!',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        itemCount: messages.length,
        itemBuilder: (_, index) {
          final msg = messages[index];
          final isMine = msg.senderId == controller.aiAgent.id;
          final showAvatar = !isMine && (index == messages.length - 1 ||
              messages[index + 1].senderId != msg.senderId);

          return _MessageBubble(
            message: msg,
            isMine: isMine,
            showAvatar: showAvatar,
          );
        },
      );
    });
  }

  Future<void> _showAddAiAgentDialog(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.smart_toy, color: Colors.purple.shade600),
            ),
            const SizedBox(width: 12),
            const Text(
              'Add AI Agent',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Agent name',
                prefixIcon: const Icon(Icons.badge),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone number (optional)',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF075E54),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              final name = nameController.text.trim();
              final phone = phoneController.text.trim();
              controller.addAiAgentToSelected(name, phone);
              Get.back();
            },
            child: const Text('Add Agent'),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final dynamic message;
  final bool isMine;
  final bool showAvatar;

  const _MessageBubble({
    required this.message,
    required this.isMine,
    required this.showAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment:
        isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine && showAvatar)
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade300, Colors.blue.shade500],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.person, color: Colors.white, size: 18),
                ),
              ),
            )
          else if (!isMine)
            SizedBox(width: 40.w),
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: 0.75.sw),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: isMine
                    ? LinearGradient(
                  colors: [
                    const Color(0xFF25D366),
                    const Color(0xFF1EBE57),
                  ],
                )
                    : null,
                color: isMine ? null : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isMine ? 18.r : 4.r),
                  topRight: Radius.circular(isMine ? 4.r : 18.r),
                  bottomLeft: Radius.circular(18.r),
                  bottomRight: Radius.circular(18.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isMine ? Colors.white : Colors.black87,
                  fontSize: 15.sp,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupMessageInput extends GetView<GroupsController> {
  final String groupId;
  const _GroupMessageInput({required this.groupId});

  @override
  Widget build(BuildContext context) {
    final TextEditingController input = TextEditingController();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F2F5),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: TextField(
                    controller: input,
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 15.sp,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                      prefixIcon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: Colors.grey.shade500,
                        size: 24,
                      ),
                      suffixIcon: Icon(
                        Icons.attach_file,
                        color: Colors.grey.shade500,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF25D366), Color(0xFF1EBE57)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF25D366).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    final text = input.text.trim();
                    if (text.isNotEmpty) {
                      if (groupId == 'common-group') {
                        controller.sendCommonGroupMessage(text);
                      } else {
                        controller.sendGroupMessage(
                            groupId, controller.aiAgent.id, text);
                      }
                      input.clear();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonalChatScreen extends GetView<GroupsController> {
  final String memberId;
  const PersonalChatScreen({super.key, required this.memberId});

  @override
  Widget build(BuildContext context) {
    final TextEditingController input = TextEditingController();
    final member = controller.contacts.firstWhere(
          (m) => m.id == memberId,
      orElse: () => controller.contacts.isNotEmpty
          ? controller.contacts.first
          : (throw StateError('No contacts')),
    );

    return WillPopScope(
      onWillPop: () async {
        final fromInfo = (Get.arguments is Map) &&
            (Get.arguments as Map).containsKey('fromGroupInfo');
        if (fromInfo == true) {
          Get.offAllNamed(app_routes.AppRoutes.bottomBarScreen);
          // Set the bottom bar to Groups tab (index 2) after navigation
          Future.delayed(const Duration(milliseconds: 100), () {
            if (Get.isRegistered<BottomBarController>()) {
              Get.find<BottomBarController>().changeIndex(2);
            }
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F2F5),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF075E54),
          foregroundColor: Colors.white,
          title: Row(
            children: [
              Hero(
                tag: 'member-avatar-$memberId',
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade300, Colors.orange.shade600],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      member.displayName.isNotEmpty
                          ? member.displayName[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.displayName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.call, color: Colors.white),
              onPressed: () async {
                // Get.toNamed(app_routes.AppRoutes.myDialerPadScreen);
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFF0F2F5),
                const Color(0xFFE8EBF0).withOpacity(0.5),
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  final messages =
                      controller.personalMessages[memberId] ?? const [];

                  if (messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.chat_bubble_outline,
                              size: 48,
                              color: Colors.orange.shade300,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No messages yet',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Say hi to ${member.displayName}!',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                    itemCount: messages.length,
                    itemBuilder: (_, index) {
                      final msg = messages[index];
                      final isMine = msg.senderId == controller.aiAgent.id;
                      return _MessageBubble(
                        message: msg,
                        isMine: isMine,
                        showAvatar: !isMine,
                      );
                    },
                  );
                }),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F2F5),
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                            child: TextField(
                              controller: input,
                              maxLines: null,
                              textInputAction: TextInputAction.newline,
                              decoration: InputDecoration(
                                hintText: 'Type a message',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 15.sp,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 12.h,
                                ),
                                prefixIcon: Icon(
                                  Icons.emoji_emotions_outlined,
                                  color: Colors.grey.shade500,
                                  size: 24,
                                ),
                                suffixIcon: Icon(
                                  Icons.attach_file,
                                  color: Colors.grey.shade500,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF25D366), Color(0xFF1EBE57)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF25D366).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: () {
                              final text = input.text.trim();
                              if (text.isNotEmpty) {
                                controller.sendPersonalMessage(
                                    memberId, controller.aiAgent.id, text);
                                controller.sendPersonalMessageToCommonGroup(
                                    memberId, text);
                                input.clear();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}