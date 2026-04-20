import 'package:aitota_business/routes/app_routes.dart';
import '../../../../../core/app-export.dart';
import '../../../../../core/utils/widgets/outbound_widgets/users_widgets/custom_group_card.dart';
import 'controller/direct_group_controller.dart';

class DirectGroupScreen extends GetView<DirectGroupController> {
  const DirectGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: RefreshIndicator(
        onRefresh: controller.fetchAllGroups,
        color: ColorConstants.appThemeColor,
      child: Obx(() {
  /// SHOW CENTER LOADING ONLY ON FIRST LOAD
  if (controller.isInitialLoading.value &&
      controller.groups.isEmpty) {
    return const Center(
      child: CircularProgressIndicator(
        color: ColorConstants.appThemeColor,
      ),
    );
  }

  /// DURING REFRESH → DO NOT SHOW CENTER LOADER
  if (controller.isLoading.value &&
      !controller.isInitialLoading.value &&
      controller.groups.isEmpty) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        SizedBox(height: 300), // So pull-to-refresh works
      ],
    );
  }

  /// EMPTY UI WHEN LOADING FINISHED
  if (!controller.isLoading.value && controller.groups.isEmpty) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.group,
            size: 40.w,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 16),
          Text(
            "No groups available",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14.sp,
              fontFamily: AppFonts.poppins,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              shape: const StadiumBorder(),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text(
              "Refresh",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: controller.fetchAllGroups,
          ),
        ],
      ),
    );
  }

  /// LIST OF GROUPS
  return ListView.builder(
    padding: const EdgeInsets.all(12),
    itemCount: controller.groups.length,
    itemBuilder: (context, index) {
      final group = controller.groups[index];
      return CustomGroupCard(
        group: group,
        onTap: () {
          Get.toNamed(
            AppRoutes.myAssignGroupDetailScreen,
            arguments: group,
          );
        },
        onEdit: () {},
        onDelete: () {},
        showEditActions: false,
      );
    },
  );
}),

      ),
    );
  }
}
