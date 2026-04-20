import '../../../../../views/outbound/grid_flow/campaign/detail_screen/controller/outbound_campaign_detail_controller.dart';
import '../../../../app-export.dart';

class ContactsBottomSheet extends StatelessWidget {
  final OutboundCampaignDetailController controller;
  final BuildContext context;
  final String groupId;
  final String groupName;

  const ContactsBottomSheet({
    super.key,
    required this.controller,
    required this.context,
    required this.groupId,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchGroupContacts(groupId);
    });
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      expand: false,
      builder: (context, scrollController) {
        return Obx(() {
          return Container(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contacts in $groupName',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.poppins,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                Expanded(
                  child: controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : controller.contacts.isEmpty
                      ? Center(
                    child: Text(
                      controller.errorMessage.value.isNotEmpty
                          ? controller.errorMessage.value
                          : 'No contacts available',
                    ),
                  )
                      : ListView.builder(
                    controller: scrollController,
                    itemCount: controller.contacts.length,
                    itemBuilder: (context, index) {
                      final contact = controller.contacts[index];
                      return ListTile(
                        leading: Container(
                          width: 24.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: contact['color'].withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: contact['color'],
                            size: 16.sp,
                          ),
                        ),
                        title: Text(
                          contact['name'],
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          contact['phone'],
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? const Color(0xFFAEAEB2) : const Color(0xFF636366),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.appThemeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}