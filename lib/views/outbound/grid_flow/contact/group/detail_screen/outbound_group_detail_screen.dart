import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/group/detail_screen/controller/outbound_group_detail_controller.dart';

class OutboundGroupDetailScreen extends GetView<OutboundGroupDetailController> {
  const OutboundGroupDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        if (controller.isSearchActive.value) {
          controller.toggleSearch();
          return false;
        }
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          if (controller.isSearchActive.value) {
            controller.toggleSearch();
          }
        },
        child: Scaffold(
          backgroundColor: ColorConstants.white,
          appBar: CustomAppBar(
            title: "Add Contacts",
            showBackButton: true,
            titleStyle: TextStyle(
              fontSize: 16.sp,
              color: ColorConstants.white,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.poppins,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: ColorConstants.white),
                onPressed: () {
                  controller.fetchGroupContacts(controller.groupId.value);
                },
              ),
            ],
          ),
          body: Obx(() {
            return Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: TextFormField(
                    controller: controller.searchController,
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'Search contacts...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14.sp,
                        fontFamily: AppFonts.poppins,
                      ),
                      prefixIcon: const Icon(Icons.search,
                          color: ColorConstants.appThemeColor),
                      suffixIcon: controller.searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.grey, size: 20),
                              onPressed: () {
                                controller.searchController.clear();
                                controller.searchContacts('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: ColorConstants.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: const BorderSide(
                          color: ColorConstants.appThemeColor,
                          width: 1.2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: AppFonts.poppins,
                    ),
                    onChanged: (value) => controller.searchContacts(value),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Text(
                    'Total Contacts (${controller.filteredContacts.length})',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: controller.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: ColorConstants.appThemeColor1))
                      : controller.filteredContacts.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 40.w,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No contacts available in this group",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: AppFonts.poppins,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          ColorConstants.appThemeColor1,
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      "Refresh",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () {
                                      controller.fetchGroupContacts(
                                          controller.groupId.value);
                                    },
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.only(
                                  left: 16.w,
                                  right: 16.w,
                                  top: 8.h,
                                  bottom: 12.h),
                              itemCount: controller.filteredContacts.length,
                              itemBuilder: (context, index) {
                                // Safety: prevent out-of-bounds access
                                if (index < 0 ||
                                    index >=
                                        controller.filteredContacts.length) {
                                  return const SizedBox.shrink();
                                }

                                final rawContact =
                                    controller.filteredContacts[index];

                                // Sanitize and ensure safe contact data
                                final String contactId =
                                    rawContact['id']?.toString() ?? '';
                                if (contactId.isEmpty) {
                                  return const SizedBox
                                      .shrink(); // Skip invalid
                                }

                                final safeContact = {
                                  'id': contactId,
                                  'name': (rawContact['name']
                                              ?.toString()
                                              .trim()
                                              .isNotEmpty ==
                                          true)
                                      ? rawContact['name']
                                      : 'Unnamed Contact',
                                  'phone':
                                      rawContact['phone']?.toString().trim() ??
                                          'N/A',
                                  'email':
                                      rawContact['email']?.toString().trim() ??
                                          'N/A',
                                  'color': rawContact['color'] ?? Colors.blue,
                                };

                                return GestureDetector(
                                  onLongPress: () {
                                    controller.toggleDeleteIcon(contactId);
                                  },
                                  child: Stack(
                                    children: [
                                      CustomContactCard(
                                        contact: safeContact,
                                        theme: theme,
                                      ),
                                      Obx(() => controller
                                                  .showDeleteIcon[contactId] ==
                                              true
                                          ? Positioned(
                                              right: 8,
                                              top: 8,
                                              child: IconButton(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  controller
                                                      .deleteContact(contactId);
                                                },
                                              ),
                                            )
                                          : const SizedBox.shrink()),
                                    ],
                                  ),
                                );
                              },
                            ),
                ),
              ],
            );
          }),
          floatingActionButton: FloatingActionButton(
            heroTag: 'outbound_group_detail_fab', // Added unique tag to fix Hero conflict
            onPressed: () => ContactBottomSheet.showAddContactBottomSheet(
                context, controller),
            backgroundColor: Colors.green.shade600,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
