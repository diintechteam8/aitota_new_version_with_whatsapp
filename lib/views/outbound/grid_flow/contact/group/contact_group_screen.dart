import 'package:aitota_business/routes/app_routes.dart';
import '../../../../../core/app-export.dart';
import '../../../../../core/utils/widgets/common_widgets/shimmer_loading.dart';
import '../../../../../core/utils/widgets/outbound_widgets/users_widgets/custom_dialog_box.dart';
import '../../../../../core/utils/widgets/outbound_widgets/users_widgets/custom_group_card.dart';
import 'controller/contact_group_controller.dart';

class ContactGroupScreen extends GetView<ContactGroupController> {
  const ContactGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: RefreshIndicator(
        onRefresh: controller.fetchAllGroups,
        color: ColorConstants.appThemeColor,
        child: Obx(
          () => controller.isLoading.value && controller.groups.isEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: 8,
                  itemBuilder: (context, index) =>
                      const BaseShimmer(child: GroupCardShimmer()),
                )
              : controller.groups.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: controller.groups.length,
                      itemBuilder: (context, index) {
                        final group = controller.groups[index];
                        return CustomGroupCard(
                          group: group,
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.outboundGroupDetailScreen,
                              arguments: group,
                            );
                          },
                          onEdit: () =>
                              EditGroupDialog.show(context, controller, group),
                          onDelete: () => DeleteGroupDialog.show(
                            context,
                            controller,
                            group['_id'],
                            group['name'],
                          ),
                        );
                      },
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'contact_group_fab', // Added unique tag to fix Hero conflict
        onPressed: () => AddGroupDialog.show(context, controller),
        backgroundColor: ColorConstants.appThemeColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// 🔹 Modernized empty state widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: ColorConstants.appThemeColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.groups_rounded,
              size: 40.w,
              color: ColorConstants.appThemeColor.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            "No Groups Available",
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: ColorConstants.textColor ?? Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            "Tap the + button below to create your first group.",
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstants.appThemeColor,
              shape: const StadiumBorder(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            ),
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: Text(
              "Refresh",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.poppins,
              ),
            ),
            onPressed: controller.fetchAllGroups,
          ),
        ],
      ),
    );
  }
}
