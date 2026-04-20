import '../../../core/app-export.dart';
import '../../../routes/app_routes.dart';
import '../../outbound/grid_flow/contact/open_phonebook/controller/open_phonebook_controller.dart';
import '../controller/groups_controller.dart';
import '../../bottom_bar/controller/bottom_bar_controller.dart';

class CreateGroupSelectMembersScreen extends StatefulWidget {
  const CreateGroupSelectMembersScreen({super.key});

  @override
  State<CreateGroupSelectMembersScreen> createState() => _CreateGroupSelectMembersScreenState();
}

class _CreateGroupSelectMembersScreenState extends State<CreateGroupSelectMembersScreen> {
  late OpenPhoneBookController phonebookController;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    phonebookController = Get.isRegistered<OpenPhoneBookController>()
        ? Get.find<OpenPhoneBookController>()
        : Get.put(OpenPhoneBookController());
  }

  @override
  void dispose() {
    searchController.dispose();
    // Optional: Clean up controller if not used elsewhere
    if (!Get.isRegistered<OpenPhoneBookController>()) {
      Get.delete<OpenPhoneBookController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF075E54),
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Members',
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Obx(() => Text(
              phonebookController.selectedContactIds.isEmpty
                  ? ''
                  : '${phonebookController.selectedContactIds.length} selected',
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            )),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Search bar
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) => phonebookController.filterContacts(value),
                      decoration: InputDecoration(
                        hintText: 'Search contacts...',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontFamily: AppFonts.poppins,
                        ),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF075E54)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.r),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.r),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.r),
                          borderSide: const BorderSide(color: Color(0xFF075E54)),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                    ),
                  ),
                  // Contacts list
                  Obx(() {
                    if (phonebookController.isLoading.value) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - 200.h,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                    final contacts = phonebookController.contacts;
                    if (contacts.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - 200.h,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.contacts_outlined, size: 64.sp, color: Colors.grey[400]),
                              SizedBox(height: 16.h),
                              Text(
                                'No contacts found',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16.sp,
                                  fontFamily: AppFonts.poppins,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Container(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 200.h,
                      ),
                      color: const Color(0xFFF0F2F5),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: contacts.length + (phonebookController.hasMoreContacts.value ? 1 : 0),
                        itemBuilder: (_, index) {
                          if (index == contacts.length && phonebookController.hasMoreContacts.value) {
                            phonebookController.loadMoreContacts();
                            return const Center(child: CircularProgressIndicator());
                          }
                          final contact = contacts[index];
                          final name = contact.displayName.isEmpty ? 'Unknown' : contact.displayName;
                          final phone = contact.phones.isNotEmpty ? contact.phones.first.number : '';
                          return Obx(() {
                            final isSelected = phonebookController.selectedContactIds.contains(contact.id);
                            return Container(
                              margin: EdgeInsets.only(bottom: 8.h),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF075E54).withOpacity(0.1) : Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF075E54) : Colors.transparent,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16.r),
                                  onTap: () => phonebookController.toggleSelectionById(contact.id, !isSelected),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.r),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50.w,
                                          height: 50.w,
                                          decoration: BoxDecoration(
                                            gradient: isSelected
                                                ? const LinearGradient(
                                              colors: [Color(0xFF075E54), Color(0xFF128C7E)],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )
                                                : null,
                                            color: isSelected ? null : Colors.grey[200],
                                            shape: BoxShape.circle,
                                            boxShadow: isSelected
                                                ? [
                                              BoxShadow(
                                                color: const Color(0xFF075E54).withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                                : null,
                                          ),
                                          child: Icon(
                                            Icons.person,
                                            color: isSelected ? Colors.white : Colors.grey[600],
                                            size: 26.sp,
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                name,
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: AppFonts.poppins,
                                                ),
                                              ),
                                              if (phone.isNotEmpty) ...[
                                                SizedBox(height: 2.h),
                                                Text(
                                                  phone,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12.sp,
                                                    fontFamily: AppFonts.poppins,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 24.w,
                                          height: 24.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelected ? const Color(0xFF075E54) : Colors.transparent,
                                            border: Border.all(
                                              color: isSelected ? const Color(0xFF075E54) : Colors.grey[400]!,
                                              width: 2,
                                            ),
                                          ),
                                          child: isSelected
                                              ? Icon(Icons.check, color: Colors.white, size: 16.sp)
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    );
                  }),
                  SizedBox(height: 80.h), // Space for the fixed button
                ],
              ),
            ),
            // Fixed "Next" button at bottom-right
            Positioned(
              bottom: 16.h + MediaQuery.of(context).viewInsets.bottom,
              right: 16.w,
              child: Obx(() {
                final hasSelected = phonebookController.selectedContactIds.isNotEmpty;
                return AnimatedScale(
                  scale: hasSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF075E54),
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    ),
                    onPressed: hasSelected
                        ? () {
                      // Get selected contacts and navigate to group name screen
                      final selected = <Map<String, dynamic>>[];
                      final all = phonebookController.allContacts;
                      for (final contact in all) {
                        if (phonebookController.selectedContactIds.contains(contact.id)) {
                          selected.add({
                            'name': contact.displayName.isEmpty ? 'Unknown' : contact.displayName,
                            'phone': contact.phones.isNotEmpty ? contact.phones.first.number : '',
                            'email': contact.emails.isNotEmpty ? contact.emails.first.address : '',
                          });
                        }
                      }
                      // Navigate to group name screen instead of going back
                      Get.to(() => const CreateGroupNameScreen(), arguments: {'selectedContacts': selected});
                    }
                        : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                            fontFamily: AppFonts.poppins,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false, // Prevent Scaffold resizing
    );
  }
}

class CreateGroupNameScreen extends StatefulWidget {
  const CreateGroupNameScreen({super.key});

  @override
  State<CreateGroupNameScreen> createState() => _CreateGroupNameScreenState();
}

class _CreateGroupNameScreenState extends State<CreateGroupNameScreen> {
  final TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> selectedContacts =
    (Get.arguments is Map && (Get.arguments as Map).containsKey('selectedContacts'))
        ? List<Map<String, dynamic>>.from((Get.arguments as Map)['selectedContacts'])
        : <Map<String, dynamic>>[];

    return Scaffold(
      resizeToAvoidBottomInset: false, // Allow resizing when keyboard appears
      backgroundColor: const Color(0xFFF0F2F5), // Light background
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        backgroundColor: const Color(0xFF075E54), // WhatsApp green
        foregroundColor: Colors.white,
        title: Text(
          'New Group',
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Group icon section
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF075E54), Color(0xFF128C7E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF075E54).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(Icons.group, color: Colors.white, size: 30.sp),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFF075E54),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFF0F2F5), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(Icons.camera_alt, color: Colors.white, size: 14.sp),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              // Group name input
              Text(
                'Group Name',
                style: TextStyle(
                  color: const Color(0xFF075E54),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.poppins,
                ),
              ),
              SizedBox(height: 8.h),
              Form(
                key: _formKey,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: nameController,
                    autofocus: true,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16.sp,
                      fontFamily: AppFonts.poppins,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter group name',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14.sp,
                        fontFamily: AppFonts.poppins,
                      ),
                      prefixIcon: const Icon(Icons.edit, color: Color(0xFF075E54)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 12.sp,
                        fontFamily: AppFonts.poppins,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Group name is required';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // Members section
              Text(
                'Members (${selectedContacts.length})',
                style: TextStyle(
                  color: const Color(0xFF075E54),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.poppins,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(8.r),
                  itemCount: selectedContacts.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: Colors.grey[300],
                  ),
                  itemBuilder: (_, index) {
                    final contact = selectedContacts[index];
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                      leading: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF075E54), Color(0xFF128C7E)],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.person, color: Colors.white, size: 22.sp),
                      ),
                      title: Text(
                        contact['name'] ?? '',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.poppins,
                        ),
                      ),
                      subtitle: contact['phone'] != null && contact['phone'].isNotEmpty
                          ? Text(
                        contact['phone'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12.sp,
                          fontFamily: AppFonts.poppins,
                        ),
                      )
                          : null,
                    );
                  },
                ),
              ),
              SizedBox(height: 100.h), // Extra padding for keyboard
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "create_group_name_fab", // Unique hero tag
        backgroundColor: const Color(0xFF075E54), // WhatsApp green
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.check_circle, size: 18),
        label: Text(
          'Create',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            fontFamily: AppFonts.poppins,
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final name = nameController.text.trim();
            final controller = Get.find<GroupsController>();
            controller.createGroupWithContacts(name, selectedContacts);
            Get.offAllNamed(AppRoutes.bottomBarScreen);
            // Set the bottom bar to Groups tab (index 2) after navigation
            Future.delayed(const Duration(milliseconds: 100), () {
              if (Get.isRegistered<BottomBarController>()) {
                Get.find<BottomBarController>().changeIndex(2);
              }
            });
          }
        },

      ),
    );
  }
}