import 'package:aitota_business/views/outbound/grid_flow/campaign/controller/outbound_campaign_controller.dart';
import '../../../../core/app-export.dart';
import '../../../../core/utils/widgets/common_widgets/shimmer_loading.dart';
import '../../../../routes/app_routes.dart';

class OutboundCampaignScreen extends GetView<OutboundCampaignController> {
  const OutboundCampaignScreen({super.key});

  // -----------------------------------------------------------------
  //  Filter dialog
  // -----------------------------------------------------------------
  void showCategoryFilterDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Filter by Category",
      titleStyle: TextStyle(
        fontFamily: AppFonts.poppins,
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 300.h,
        child: Obx(
          () => ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            children: [
              _buildFilterOption(
                label: "All Categories",
                value: '',
                isSelected: controller.selectedCategory.value.isEmpty,
              ),
              Divider(height: 1, color: Colors.grey.shade300),
              ...controller.uniqueCategories.map(
                (cat) => _buildFilterOption(
                  label: cat,
                  value: cat,
                  isSelected: controller.selectedCategory.value == cat,
                ),
              ),
            ],
          ),
        ),
      ),
      radius: 12,
      contentPadding: EdgeInsets.symmetric(vertical: 8.h),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Close',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontFamily: AppFonts.poppins,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterOption({
    required String label,
    required String value,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        controller.selectedCategory.value = value;
        Get.back();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        color: isSelected ? Colors.green.shade50 : Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  fontSize: 14.sp,
                  color: isSelected ? Colors.green.shade700 : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------------------
  //  Search + Filter Row (now in BODY, not AppBar)
  // -----------------------------------------------------------------
  Widget _buildSearchAndFilterRow() {
    return Container(
      color: Theme.of(Get.context!).appBarTheme.backgroundColor ?? Colors.white,
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 8.h),
      child: Row(
        children: [
          // Search Field
          Expanded(
            child: Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: TextField(
                onChanged: (v) => controller.searchQuery.value = v,
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: 'Search campaigns...',
                  hintStyle: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 14.sp,
                    color: Colors.grey.shade500,
                  ),
                  prefixIcon:
                      Icon(Icons.search, color: Colors.grey.shade600, size: 20),
                  suffixIcon: controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear,
                              color: Colors.grey.shade600, size: 20),
                          onPressed: () => controller.searchQuery.value = '',
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),

          // Filter Button
          Material(
            color: controller.selectedCategory.value.isNotEmpty
                ? Colors.green.shade600
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () => showCategoryFilterDialog(Get.context!),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 45.h,
                width: 45.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.selectedCategory.value.isNotEmpty
                        ? Colors.green.shade600
                        : Colors.grey.shade300,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.filter_list,
                      color: controller.selectedCategory.value.isNotEmpty
                          ? Colors.white
                          : Colors.green.shade600,
                      size: 22,
                    ),
                    if (controller.selectedCategory.value.isNotEmpty)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------------
  //  Active Filter Chip
  // -----------------------------------------------------------------
  Widget _buildActiveFilterChip() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.shade200, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.selectedCategory.value,
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontFamily: AppFonts.poppins,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 6.w),
                GestureDetector(
                  onTap: () => controller.selectedCategory.value = '',
                  child:
                      Icon(Icons.close, size: 16, color: Colors.green.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------------
  //  Empty State
  // -----------------------------------------------------------------
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
              Icons.campaign_rounded,
              size: 40.w,
              color: ColorConstants.appThemeColor.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "No Campaigns Found",
            style: TextStyle(
              color: ColorConstants.textColor ?? Colors.black87,
              fontSize: 14.sp,
              fontFamily: AppFonts.poppins,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Tap the + button to add your first campaign",
            style: TextStyle(
              color: Colors.grey.withOpacity(0.8),
              fontSize: 12.sp,
              fontFamily: AppFonts.poppins,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------------
  //  BUILD – NO AppBar
  // -----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,

      // No AppBar → perfect for TabBarView
      body: SafeArea(
        top: true,
        child: Obx(
          () => Column(
            children: [
              // 1. Search + Filter Row (acts like AppBar)
              _buildSearchAndFilterRow(),

              // 2. Active Filter Chip (optional)
              if (controller.selectedCategory.value.isNotEmpty) _buildActiveFilterChip(),

              // 3. Campaign List or Shimmer
              Expanded(
                child: controller.isLoading.value
                    ? ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                        itemCount: 5,
                        itemBuilder: (context, index) =>
                             BaseShimmer(child: CampaignCardShimmer()),
                      )
                    : controller.filteredCampaignItems.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: controller.fetchAllOutboundCampaigns,
                            color: Colors.green.shade600,
                            displacement: 40,
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                              itemCount: controller.filteredCampaignItems.length,
                              separatorBuilder: (_, __) => SizedBox(height: 8.h),
                              itemBuilder: (context, index) {
                                final item = controller.filteredCampaignItems[index];
                                return CustomOutboundCampaignCardWidget(
                                  id: item['id'] ?? '',
                                  name: item['name'] ?? '',
                                  description: item['description'] ?? '',
                                  category: item['category'],
                                  onViewDetails: () => Get.toNamed(
                                    AppRoutes.outboundCampaignDetailsScreen,
                                    arguments: item,
                                  ),
                                  onUpdate: () => Get.toNamed(
                                    AppRoutes.updateOutboundCampaignScreen,
                                    arguments: item,
                                  ),
                                  onDelete: () {
                                    Get.defaultDialog(
                                      title: "Confirm Delete",
                                      middleText:
                                          "Are you sure you want to delete ${item['name']}?",
                                      textConfirm: "Delete",
                                      confirmTextColor: Colors.white,
                                      buttonColor: Colors.red.shade600,
                                      onConfirm: () {
                                        controller.deleteOutboundCampaign(item['id']);
                                        Get.back();
                                      },
                                      textCancel: "Cancel",
                                    );
                                  },
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        heroTag: 'outbound_campaign_fab', // Added unique tag to fix Hero conflict
        onPressed: () => Get.toNamed(AppRoutes.addOutboundCampaignScreen),
        backgroundColor: Colors.green.shade600,
        child: const Icon(Icons.add, color: Colors.white, size: 24),
      ),
    );
  }
}
