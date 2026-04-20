import 'package:aitota_business/routes/app_routes.dart';
import '../../../core/app-export.dart';
import '../binding/groups_binding.dart';
import '../controller/groups_controller.dart';
import '../models/group_models.dart';
import 'group_chat_screen.dart';
import 'group_detail_screen.dart';
import 'create_group_select_members_screen.dart';
import '../../more_flow/more_screen/controller/more_controller.dart';
import '../../voice_screens/voice_screen/Aiscreen.dart';
import '../../bottom_bar/controller/bottom_bar_controller.dart';

class GroupsLandingScreen extends StatelessWidget {
  const GroupsLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<GroupsController>()) {
      Get.put<GroupsController>(GroupsController(), permanent: true);
    }
    final int initialTab = (Get.arguments is Map &&
            (Get.arguments as Map).containsKey('initialTab'))
        ? (Get.arguments as Map)['initialTab'] as int
        : 0;
    return DefaultTabController(
      length: 2,
      initialIndex: initialTab,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F2F5), // Light background
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent, // transparent so gradient shows
          foregroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorConstants.whatsappGradientDark,
                  ColorConstants.whatsappGradientLight,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Obx(() {
            // Get user name from MoreController
            String userName = 'Aitota Business'; // Default fallback
            try {
              if (Get.isRegistered<MoreController>()) {
                final moreController = Get.find<MoreController>();
                userName = moreController.userName.value.isNotEmpty
                    ? moreController.userName.value
                    : 'Aitota Business';
              }
            } catch (e) {
              // Keep default if controller not found
            }

            return Padding(
              padding:  EdgeInsets.only(left: 16.w),
              child: Text(
                userName,
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                ),
              ),
            );
          }),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    ColorConstants.whatsappGradientDark,
                    ColorConstants.whatsappGradientLight,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xCCFFFFFF),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  fontFamily: AppFonts.poppins,
                ),
                tabs: const [
                  Tab(text: 'Groups'),
                  Tab(text: 'Team'),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Get.offAllNamed(AppRoutes.bottomBarScreen);
                // Set the bottom bar to Groups tab (index 2) after navigation
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (Get.isRegistered<BottomBarController>()) {
                    Get.find<BottomBarController>().changeIndex(2);
                  }
                });
              },
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              elevation: 8,
              offset: const Offset(0, kToolbarHeight),
              itemBuilder: (context) => [
                _buildPopupMenuItem(
                  icon: Icons.group_add,
                  label: 'New Group',
                  color: ColorConstants.whatsappGradientDark,
                ),
                _buildPopupMenuItem(
                  icon: Icons.help_outline,
                  label: 'Help',
                  color: ColorConstants.whatsappGradientDark,
                ),
                _buildPopupMenuItem(
                  icon: Icons.contacts,
                  label: 'Contacts',
                  color: ColorConstants.whatsappGradientDark,
                ),
              ],
              onSelected: (value) {
                if (value == 'new_group') {
                  Get.to(() => const CreateGroupSelectMembersScreen());
                } else if (value == 'help') {
                  Get.snackbar(
                    'Help',
                    'This is a WhatsApp-style demo',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: ColorConstants.whatsappGradientDark,
                    colorText: Colors.white,
                    margin: EdgeInsets.all(12.r),
                    borderRadius: 12.r,
                  );
                } else if (value == 'contacts') {
                  _showContactsBottomSheet(context);
                }
              },
            ),
          ],
        ),

        body: SafeArea(
          top: false,
          child: TabBarView(
            children: [
              _buildGroupsTab(context),
              _buildChatsTab(context),
            ],
          ),
        ),
        // Remove the floatingActionButton section entirely
      ),
    );
  }

  Widget _buildChatsTab(BuildContext context) {
    final GroupsController controller = Get.find<GroupsController>();
    return Obx(() {
      final all = controller.contacts;
      final filtered = all
          .where(
              (m) => (controller.personalMessages[m.id] ?? const []).isNotEmpty)
          .toList();
      const String commonGroupId = 'common-group';
      final bool hasCommonMessages =
          (controller.commonGroupMessages[commonGroupId] ?? const [])
              .isNotEmpty;

      if (filtered.isEmpty && !hasCommonMessages) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble_outline,
                  size: 40.sp, color: Colors.grey[400]),
              SizedBox(height: 16.h),
              Text(
                'No chats yet',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.poppins,
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        color: const Color(0xFFF0F2F5), // Light background
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: ListView(
          children: [
            // Admin Card
            if (hasCommonMessages) ...[
              _buildAdminCard(controller),
              SizedBox(height: 8.h),
            ],
            // AI Agent Card - Updated to open AI screen
            if (hasCommonMessages) ...[
              _buildAiAgentCard(controller),
              SizedBox(height: 8.h),
            ],
            // Other contacts
            ...filtered.map((member) {
              final int unread =
                  controller.unreadPersonalCounts[member.id] ?? 0;
              final DateTime? last =
                  controller.lastPersonalMessageTime[member.id];
              final String timeStr = last != null ? _formatTime(last) : '';
              final personalMsgs =
                  controller.personalMessages[member.id] ?? const [];
              final String lastText =
                  personalMsgs.isNotEmpty ? personalMsgs.last.text : '';
              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
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
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16.r),
                    onTap: () {
                      controller.onOpenPersonalChat(member.id);
                      Get.to(() => PersonalChatScreen(memberId: member.id),
                          binding: GroupsBinding());
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12.r),
                      child: Row(
                        children: [
                          Container(
                            width: 46.w,
                            height: 46.w,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF075E54), Color(0xFF128C7E)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF075E54).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.person,
                                color: Colors.white, size: 20),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.displayName,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppFonts.poppins,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  lastText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13.sp,
                                    fontFamily: AppFonts.poppins,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                timeStr,
                                style: TextStyle(
                                  color: unread > 0
                                      ? const Color(0xFF075E54)
                                      : Colors.grey[500],
                                  fontSize: 11.sp,
                                  fontWeight: unread > 0
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontFamily: AppFonts.poppins,
                                ),
                              ),
                              if (unread > 0) ...[
                                SizedBox(height: 6.h),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF075E54),
                                        Color(0xFF128C7E)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF075E54)
                                            .withOpacity(0.4),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    unread.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AppFonts.poppins,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  Widget _buildAdminCard(GroupsController controller) {
    const String commonGroupId = 'common-group';
    final admin = controller.admin;
    final commonMsgs =
        controller.commonGroupMessages[commonGroupId] ?? const [];
    final int unread = controller.unreadPersonalCounts[admin.id] ?? 0;
    final DateTime? last =
        commonMsgs.isNotEmpty ? commonMsgs.last.timestamp : null;
    final String timeStr = last != null ? _formatTime(last) : '';
    final String lastText = commonMsgs.isNotEmpty ? commonMsgs.last.text : '';

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            Get.toNamed(AppRoutes.teamChatsListScreen);
          },
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Row(
              children: [
                Container(
                  width: 46.w,
                  height: 46.w,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF075E54), Color(0xFF128C7E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF075E54).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.admin_panel_settings,
                      color: Colors.white, size: 20),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        admin.displayName,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.poppins,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        lastText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13.sp,
                          fontFamily: AppFonts.poppins,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      timeStr,
                      style: TextStyle(
                        color: unread > 0
                            ? const Color(0xFF075E54)
                            : Colors.grey[500],
                        fontSize: 11.sp,
                        fontWeight:
                            unread > 0 ? FontWeight.w600 : FontWeight.w400,
                        fontFamily: AppFonts.poppins,
                      ),
                    ),
                    if (unread > 0) ...[
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF075E54), Color(0xFF128C7E)],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF075E54).withOpacity(0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          unread.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.poppins,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAiAgentCard(GroupsController controller) {
    const String commonGroupId = 'common-group';
    final aiAgent = controller.aiAgent;
    final messages = controller.commonGroupMessages[commonGroupId] ?? const [];
    final int unread = controller.unreadPersonalCounts[aiAgent.id] ?? 0;
    final DateTime? last = messages.isNotEmpty ? messages.last.timestamp : null;
    final String timeStr = last != null ? _formatTime(last) : '';
    final String lastText = messages.isNotEmpty ? messages.last.text : '';

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            // Open AI screen instead of personal chat
            Get.to(() => const VoiceScreen(isFromBottomNav: false));
          },
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Row(
              children: [
                Container(
                  width: 46.w,
                  height: 46.w,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF075E54), Color(0xFF128C7E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF075E54).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.smart_toy,
                      color: Colors.white, size: 20),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        aiAgent.displayName,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.poppins,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        lastText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13.sp,
                          fontFamily: AppFonts.poppins,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      timeStr,
                      style: TextStyle(
                        color: unread > 0
                            ? const Color(0xFF075E54)
                            : Colors.grey[500],
                        fontSize: 11.sp,
                        fontWeight:
                            unread > 0 ? FontWeight.w600 : FontWeight.w400,
                        fontFamily: AppFonts.poppins,
                      ),
                    ),
                    if (unread > 0) ...[
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF075E54), Color(0xFF128C7E)],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF075E54).withOpacity(0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          unread.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.poppins,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupsTab(BuildContext context) {
    final GroupsController controller = Get.find<GroupsController>();
    return Obx(() {
      if (controller.groups.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.group_add,
                    size: 24.w, color: const Color(0xFF075E54)),
              ),
              SizedBox(height: 12.h),
              Text(
                'No groups available',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.poppins,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Create your first group to get started',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10.sp,
                  fontFamily: AppFonts.poppins,
                ),
              ),
              SizedBox(height: 20.h),
              // Add Create Group button
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF075E54), Color(0xFF128C7E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF075E54).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25.r),
                    onTap: () => Get.to(() => const CreateGroupSelectMembersScreen()),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.group_add,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Create Group',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppFonts.poppins,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return Container(
        color: const Color(0xFFF0F2F5), // Light background
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: ListView.builder(
          itemCount: controller.groups.length,
          itemBuilder: (context, index) {
            final GroupModel group = controller.groups[index];
            final int unread = controller.unreadGroupCounts[group.id] ?? 0;
            final DateTime? last = controller.lastGroupMessageTime[group.id];
            final String timeStr = last != null ? _formatTime(last) : '';
            return Container(
              margin: EdgeInsets.only(bottom: 8.h),
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
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16.r),
                  onTap: () {
                    controller.selectGroup(group);
                    Get.to(() => GroupDetailScreen(groupId: group.id),
                        binding: GroupsBinding());
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: Row(
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF075E54), Color(0xFF128C7E)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF075E54).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.group,
                              color: Colors.white, size: 24),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                group.name,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppFonts.poppins,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.people_outline,
                                    size: 14.sp,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '${group.members.length} members',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 11.sp,
                                      fontFamily: AppFonts.poppins,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              timeStr,
                              style: TextStyle(
                                color: unread > 0
                                    ? const Color(0xFF075E54)
                                    : Colors.grey[500],
                                fontSize: 11.sp,
                                fontWeight: unread > 0
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                fontFamily: AppFonts.poppins,
                              ),
                            ),
                            if (unread > 0) ...[
                              SizedBox(height: 6.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF075E54),
                                      Color(0xFF128C7E)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF075E54)
                                          .withOpacity(0.4),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  unread.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFonts.poppins,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  void _showContactsBottomSheet(BuildContext context) {
    final GroupsController controller = Get.find<GroupsController>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white, // Light background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  const Icon(Icons.contacts, color: Color(0xFF075E54)),
                  SizedBox(width: 12.w),
                  Text(
                    'Select Contact',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.poppins,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.grey),
            Expanded(
              child: Obx(() {
                final items = controller.contacts;
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    final m = items[index];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          Get.to(() => PersonalChatScreen(memberId: m.id),
                              binding: GroupsBinding());
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 12.h),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24.r,
                                backgroundColor:
                                    const Color(0xFF075E54).withOpacity(0.1),
                                child: const Icon(Icons.person,
                                    color: Color(0xFF075E54)),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      m.displayName,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppFonts.poppins,
                                      ),
                                    ),
                                    if (m.phoneNumber != null &&
                                        m.phoneNumber!.isNotEmpty) ...[
                                      SizedBox(height: 2.h),
                                      Text(
                                        m.phoneNumber!,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13.sp,
                                          fontFamily: AppFonts.poppins,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right,
                                  color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final ampm = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }
  PopupMenuItem<String> _buildPopupMenuItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return PopupMenuItem(
      value: label.toLowerCase().replaceAll(' ', '_'),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 15.sp,
              fontFamily: AppFonts.poppins,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

}
