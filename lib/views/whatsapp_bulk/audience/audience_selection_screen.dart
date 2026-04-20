import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/app-export.dart';
import 'controller/audience_selection_controller.dart';
import '../../outbound/grid_flow/contact/group/controller/contact_group_controller.dart';
import '../../outbound/grid_flow/contact/add_contact/controller/add_contact_controller.dart';
import '../../../../core/utils/widgets/common_widgets/shimmer_loading.dart';
import '../../../../core/utils/widgets/outbound_widgets/users_widgets/custom_dialog_box.dart';

class AudienceSelectionScreen extends GetView<AudienceSelectionController> {
  AudienceSelectionScreen({super.key});

  final ContactGroupController groupController =
      Get.put(ContactGroupController());
  final AddContactController contactController =
      Get.put(AddContactController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110.h),
        child: Container(
          decoration: const BoxDecoration(
            gradient: ColorConstants.whatsappGradient,
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildAppBarHeader(context),
                _buildModernTabBar(),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          _buildContactGroupsView(context),
          _buildContactsView(context),
          _buildImportAndHistoryView(),
        ],
      ),
      // floatingActionButton: Obx(() {
      //   final index = controller.currentTabIndex.value;
      //   return FloatingActionButton(
      //     heroTag: 'audience_selection_fab',
      //     elevation: 4,
      //     onPressed: () {
      //       if (index == 0) {
      //         AddGroupDialog.show(context, groupController);
      //       } else if (index == 1) {
      //         _showAddContactDialog(context);
      //       } else {
      //         controller.importNewAudience();
      //       }
      //     },
      //     backgroundColor: ColorConstants.whatsappGradientDark,
      //     child: Icon(
      //       index == 2 ? Icons.upload_file : Icons.person_add_alt_1_rounded,
      //       color: Colors.white,
      //     ),
      //   );
      // }),
    );
  }

  Widget _buildAppBarHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // IconButton(
          //   icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          //   onPressed: () => Get.back(),
          // ),
          Expanded(
            child: Container(
              height: 30.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search audience...",
                  hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.6), fontSize: 14.sp),
                  prefixIcon:
                      const Icon(Icons.search_rounded, color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                ),
                onChanged: (value) {
                  final index = controller.currentTabIndex.value;
                  if (index == 0) {
                    groupController.searchGroups(value);
                  } else if (index == 1) {
                    contactController.searchContacts(value);
                  } else if (index == 2) {
                    controller.searchHistory(value);
                  }
                  // Uploads search can be added to controller if needed
                },
              ),
            ),
          ),
          SizedBox(width: 8.w),
          // IconButton(
          //   icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
          //   onPressed: () {},
          // ),
        ],
      ),
    );
  }

  Widget _buildModernTabBar() {
    return Container(
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: controller.tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: ColorConstants.whatsappGradientDark,
        unselectedLabelColor: Colors.white,
        labelStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent, // ✅ REMOVE LINE (Flutter 3.7+)
        tabs: const [
          Tab(text: "Groups"),
          Tab(text: "Contacts"),
          Tab(text: "Uploads"),
        ],
      ),
    );
  }

  Widget _buildContactGroupsView(BuildContext context) {
    return RefreshIndicator(
      onRefresh: groupController.fetchAllGroups,
      color: ColorConstants.whatsappGradientDark,
      child: Obx(
        () => groupController.isLoading.value && groupController.groups.isEmpty
            ? ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: 8,
                itemBuilder: (context, index) =>
                    const BaseShimmer(child: GroupCardShimmer()),
              )
            : groupController.displayedGroups.isEmpty
                ? _buildEmptyState("No Groups Available",
                    "Tap the + button to create a new group.")
                : ListView.builder(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                    itemCount: groupController.displayedGroups.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildActionTile(
                          icon: Icons.group_add_rounded,
                          title: "New Group",
                          onTap: () =>
                              AddGroupDialog.show(context, groupController),
                        );
                      }
                      final group = groupController.displayedGroups[index - 1];
                      return _buildModernGroupCard(context, group);
                    },
                  ),
      ),
    );
  }

  Widget _buildModernGroupCard(
      BuildContext context, Map<String, dynamic> group) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.back(result: group),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ColorConstants.whatsappGradientDark,
                            ColorConstants.whatsappGradientDark
                                .withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.groups_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group['name'] ?? 'Unnamed Group',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            group['description'] ?? 'No description',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          EditGroupDialog.show(context, groupController, group);
                        } else if (value == 'delete') {
                          DeleteGroupDialog.show(
                            context,
                            groupController,
                            group['_id'],
                            group['name'],
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_rounded,
                                  size: 18, color: Colors.blue),
                              SizedBox(width: 8.w),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_rounded,
                                  size: 18, color: Colors.red),
                              SizedBox(width: 8.w),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: ColorConstants.whatsappGradientDark.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 14,
                        color: ColorConstants.whatsappGradientDark,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        _formatDate(group['createdAt']),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: ColorConstants.whatsappGradientDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(dynamic date) {
    try {
      if (date is String) {
        final parsedDate = DateTime.parse(date);
        return '${parsedDate.day} ${_getMonth(parsedDate.month)} ${parsedDate.year}';
      } else if (date is DateTime) {
        return '${date.day} ${_getMonth(date.month)} ${date.year}';
      }
      return 'Unknown';
    } catch (e) {
      return 'Unknown';
    }
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  Widget _buildContactsView(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: contactController.refreshContacts,
            color: ColorConstants.whatsappGradientDark,
            child: Obx(() {
              if (contactController.isSyncing.value &&
                  contactController.contacts.isEmpty) {
                return _buildContactShimmer();
              }

              final contacts = contactController.displayedContacts;

              return ListView.builder(
                controller: contactController.scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount:
                    contacts.length + 4, // +3 for Action Tiles, +1 for loading
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildActionTile(
                      icon: Icons.person_add_rounded,
                      title: "New Contact",
                      onTap: () => _showAddContactDialog(context),
                    );
                  }
                  if (index == 1) {
                    return _buildActionTile(
                      icon: Icons.sync_rounded,
                      title: "Sync Device Contacts",
                      subtitle: "Import your phone's address book",
                      onTap: contactController.fetchPhoneContacts,
                      trailing: contactController.isSyncing.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : null,
                    );
                  }
                  if (index == 2) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                      child: Text(
                        "Contacts on WhatsApp",
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600),
                      ),
                    );
                  }

                  if (index == contacts.length + 3) {
                    return Obx(() => contactController.isLoadingMore.value
                        ? const Center(
                            child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ))
                        : const SizedBox.shrink());
                  }

                  final contact = contacts[index - 3];
                  return _buildContactTile(context, contact);
                },
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: ColorConstants.whatsappGradientDark,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
      title: Text(title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
      subtitle: subtitle != null
          ? Text(subtitle,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey))
          : null,
      trailing: trailing,
    );
  }

  Widget _buildContactTile(BuildContext context, Map<String, dynamic> contact) {
    final initials = _getInitials(contact['name'] ?? 'Unknown');
    final isSynced = contact['isSynced'] ?? false;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.back(result: contact),
          onLongPress: () => _showDeleteContactConfirmation(context, contact),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: Row(
              children: [
                // Avatar with gradient background
                Hero(
                  tag: 'contact_${contact['phone']}',
                  child: Container(
                    width: 52.w,
                    height: 52.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorConstants.whatsappGradientDark,
                          ColorConstants.whatsappGradientDark.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      image: contact['photo'] != null
                          ? DecorationImage(
                              image: MemoryImage(contact['photo']),
                              fit: BoxFit.cover)
                          : null,
                    ),
                    child: contact['photo'] == null
                        ? Center(
                            child: Text(
                              initials,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
                SizedBox(width: 14.w),

                // Contact info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              contact['name'] ?? 'Unknown',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isSynced)
                            Padding(
                              padding: EdgeInsets.only(left: 6.w),
                              child: Icon(
                                Icons.check_circle_rounded,
                                size: 18,
                                color: Colors.green.shade600,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Icon(Icons.phone_rounded,
                              size: 14, color: Colors.grey.shade500),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              contact['phone'] ?? '',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if ((contact['email'] ?? '').isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(Icons.email_rounded,
                                size: 14, color: Colors.grey.shade500),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                contact['email'] ?? '',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.grey.shade600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 12.w),

                // Action button
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'select') {
                      Get.back(result: contact);
                    } else if (value == 'edit') {
                      _showEditContactDialog(context, contact);
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: 'select',
                      child: Row(
                        children: [
                          Icon(Icons.check_rounded,
                              size: 18, color: Colors.green),
                          SizedBox(width: 8.w),
                          Text('Select'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_rounded,
                              size: 18, color: Colors.blue),
                          SizedBox(width: 8.w),
                          Text('Edit'),
                        ],
                      ),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  offset: const Offset(-50, 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Widget _buildContactShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 10,
      itemBuilder: (context, index) => BaseShimmer(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle)),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 150.w, height: 16.h, color: Colors.white),
                  SizedBox(height: 6.h),
                  Container(width: 100.w, height: 12.h, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_search_rounded,
                size: 64, color: Colors.grey.shade400),
          ),
          SizedBox(height: 16.h),
          Text(title,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800)),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600)),
          ),
        ],
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2)))),
            SizedBox(height: 20.h),
            Text("Create New Contact",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 20.h),
            _buildTextField(
                nameController, "Name", Icons.person_outline_rounded),
            SizedBox(height: 12.h),
            _buildTextField(
              phoneController,
              "Phone",
              Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            SizedBox(height: 12.h),
            _buildTextField(
                emailController, "Email (Optional)", Icons.email_outlined,
                keyboardType: TextInputType.emailAddress),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () {
                  if (nameController.text.isEmpty) {
                    Get.snackbar("Error", "Name is required",
                        backgroundColor: Colors.red, colorText: Colors.white);
                    return;
                  }
                  if (phoneController.text.length != 10) {
                    Get.snackbar(
                        "Error", "Phone number must be exactly 10 digits",
                        backgroundColor: Colors.red, colorText: Colors.white);
                    return;
                  }
                  controller.createContact(nameController.text,
                      phoneController.text, emailController.text);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.whatsappGradientDark,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Save Contact",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }


  void _showEditContactDialog(
    BuildContext context, Map<String, dynamic> contact) {

  final nameController = TextEditingController(text: contact['name']);
  final emailController = TextEditingController(text: contact['email']);
  final optedOut = RxBool(contact['optedOut'] ?? false);
  final List<String> tags = List<String>.from(contact['tags'] ?? []);

  final bottomInset = MediaQuery.of(context).viewPadding.bottom;

  Get.bottomSheet(
    SafeArea(
      top: false, // only bottom safe area
      child: Container(
        padding: EdgeInsets.fromLTRB(
          20.w,
          20.h,
          20.w,
          bottomInset + 12.h, // 👈 perfect spacing
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView( // 👈 keyboard safe
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              Text(
                "Edit Contact",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 10.h),

              _buildTextField(
                nameController,
                "Name",
                Icons.person_outline_rounded,
              ),

              SizedBox(height: 12.h),

              _buildTextField(
                emailController,
                "Email",
                Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 12.h),

              Obx(() => CheckboxListTile(
                    title: const Text("Opted Out"),
                    value: optedOut.value,
                    onChanged: (val) => optedOut.value = val ?? false,
                    activeColor: ColorConstants.whatsappGradientDark,
                    contentPadding: EdgeInsets.zero,
                  )),

              SizedBox(height: 16.h),

              // Update Button
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isEmpty) {
                    Get.snackbar(
                      "Error",
                      "Name is required",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  contactController.updateContact(
                    contact,
                    nameController.text,
                    emailController.text,
                    tags,
                    optedOut.value,
                  );

                  Get.back(); // ✅ close sheet
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.whatsappGradientDark,
                  minimumSize: Size(double.infinity, 45.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Update Contact",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    isScrollControlled: true,
  );
}
  void _showDeleteContactConfirmation(
      BuildContext context, Map<String, dynamic> contact) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
            SizedBox(height: 28.h),
            Container(
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade600, Colors.red.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Icon(
                Icons.delete_rounded,
                size: 48,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "Delete Contact",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              "${contact['name'] ?? 'This contact'} will be permanently removed.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            SizedBox(height: 32.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await contactController.deleteContact(contact);
                      await Future.delayed(const Duration(milliseconds: 300));
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    child: Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatters,
      int? maxLength}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        counterText: "",
        prefixIcon: Icon(icon, color: ColorConstants.whatsappGradientDark),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
                color: ColorConstants.whatsappGradientDark, width: 2)),
      ),
    );
  }

  Widget _buildImportAndHistoryView() {
    return RefreshIndicator(
      onRefresh: controller.refreshAudienceHistory,
      color: ColorConstants.whatsappGradientDark,
      child: Column(
        children: [
          _buildImportButton(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              children: [
                const Icon(Icons.history_rounded, size: 20, color: Colors.grey),
                SizedBox(width: 8.w),
                Text(
                  "Recent Uploads",
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800),
                ),
              ],
            ),
          ),
          Expanded(child: _buildHistoryList()),
        ],
      ),
    );
  }

  Widget _buildImportButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
                color: ColorConstants.whatsappGradientDark.withOpacity(0.1),
                shape: BoxShape.circle),
            child: const Icon(Icons.cloud_upload_rounded,
                color: ColorConstants.whatsappGradientDark, size: 32),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Import CSV / Excel",
                    style: TextStyle(
                        fontSize: 17.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 4.h),
                Text("Select a file from your storage",
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
                SizedBox(height: 16.h),
                Obx(() => SizedBox(
                      width: 140.w,
                      child: ElevatedButton(
                        onPressed: controller.isPicking.value
                            ? null
                            : controller.importNewAudience,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.whatsappGradientDark,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text("Pick File",
                            style: TextStyle(color: Colors.white)),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return Obx(() {
      if (controller.isLoadingHistory.value) {
        return ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: 5,
          itemBuilder: (context, index) => BaseShimmer(
            child: Card(
              margin: EdgeInsets.only(bottom: 12.h),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Row(
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 120.w, height: 14.h, color: Colors.white),
                          SizedBox(height: 8.h),
                          Container(
                              width: 100.w, height: 12.h, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      if (controller.audienceHistory.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.cloud_off_rounded,
                    size: 64, color: Colors.grey.shade400),
              ),
              SizedBox(height: 16.h),
              Text("No Uploads Yet",
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800)),
              SizedBox(height: 8.h),
              Text("Import your first CSV or Excel file",
                  style:
                      TextStyle(fontSize: 14.sp, color: Colors.grey.shade600)),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: controller.audienceHistory.length,
        itemBuilder: (context, index) {
          final audience = controller.audienceHistory[index];
          return Card(
            margin: EdgeInsets.only(bottom: 12.h),
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade100)),
            child: ListTile(
              contentPadding: EdgeInsets.all(12.w),
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: Icon(
                    audience["name"].contains("xlsx")
                        ? Icons.table_chart_rounded
                        : Icons.description_rounded,
                    color: Colors.blue),
              ),
              title: Text(audience["name"],
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
              subtitle: Text(
                  "${audience["count"]} Contacts • ${audience["date"]}",
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded,
                  size: 16, color: Colors.grey),
              onTap: () => controller.selectAudience(audience),
            ),
          );
        },
      );
    });
  }
}
