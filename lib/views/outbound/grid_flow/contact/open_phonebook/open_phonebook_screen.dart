// lib/views/outbound/grid_flow/contact/open_phonebook/open_phonebook_screen.dart
import '../../../../../core/app-export.dart';
import 'controller/open_phonebook_controller.dart';

class OpenPhonebookScreen extends GetView<OpenPhoneBookController> {
  OpenPhonebookScreen({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Phonebook",
        height: 45.h,
        titleStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, fontFamily: AppFonts.poppins,color: ColorConstants.white),
        showBackButton: true,
        onTapBack: () {
          Get.back();
        },
        actions: [
          Obx(() => controller.selectedContactIds.isNotEmpty
              ? TextButton(
            onPressed: controller.importSelectedContacts,
            child:  Text(
              'Import',
              style: TextStyle(color: ColorConstants.appThemeColor, fontSize: 16.sp,fontFamily: AppFonts.poppins,fontWeight: FontWeight.w500)
            ),
          )
              : const SizedBox.shrink()),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => controller.filterContacts(value),
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.contacts.isEmpty && !controller.isLoadingMore.value) {
                return const Center(child: Text('No contacts found'));
              }
              return NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollEndNotification &&
                      _scrollController.position.extentAfter < 200 &&
                      controller.hasMoreContacts.value &&
                      !controller.isLoadingMore.value) {
                    controller.loadMoreContacts();
                  }
                  return false;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.contacts.length + (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.contacts.length && controller.isLoadingMore.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final contact = controller.contacts[index];
                    return ListTile(
                      leading: Obx(() => Checkbox(
                        value: controller.isSelected(contact.id),
                        onChanged: (value) => controller.toggleSelectionById(contact.id, value!),
                      )),
                      title: Text(contact.displayName),
                      subtitle: Text(contact.phones.isNotEmpty ? contact.phones.first.number : 'No Phone'),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}