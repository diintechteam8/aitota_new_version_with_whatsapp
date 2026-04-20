import 'package:aitota_business/views/outbound/grid_flow/contact/add_contact/controller/add_contact_controller.dart';
import '../../../../../core/app-export.dart';
import '../../../../../core/utils/widgets/outbound_widgets/users_widgets/custom_contact_card.dart';

class AddContactScreen extends GetView<AddContactController> {
  const AddContactScreen({super.key});

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
          backgroundColor: ColorConstants.surfaceColor,
          body: Obx(
                () => Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                      prefixIcon: const Icon(Icons.search, color: ColorConstants.appThemeColor),
                      suffixIcon: controller.searchController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey, size: 20),
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
                Expanded(
                  child: controller.isSynced.value
                      ? controller.displayedContacts.isEmpty
                      ? Center(
                    child: Text(
                      'No contacts available',
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  )
                      : NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollEndNotification &&
                          scrollNotification.metrics.extentAfter < 200 &&
                          !controller.isLoadingMore.value &&
                          controller.hasMoreContacts.value &&
                          !controller.isSearchActive.value) {
                        controller.loadMoreContacts();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      itemCount: controller.displayedContacts.length +
                          (controller.hasMoreContacts.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == controller.displayedContacts.length &&
                            controller.hasMoreContacts.value) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: const Center(
                                child: CircularProgressIndicator(
                                    color: ColorConstants.appThemeColor)),
                          );
                        }
                        final contact = controller.displayedContacts[index];
                        return CustomContactCard(
                          contact: contact,
                          theme: theme,
                        );
                      },
                    ),
                  )
                      : const Center(
                      child: CircularProgressIndicator(color: ColorConstants.appThemeColor)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}