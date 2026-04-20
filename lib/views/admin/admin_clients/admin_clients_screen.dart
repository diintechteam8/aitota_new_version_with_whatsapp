import '../../../core/app-export.dart';
import '../../../data/model/auth_models/admin_clients_model.dart';
import 'controller/admin_clients_controller.dart';

class AdminClientsScreen extends GetView<AdminClientsController> {
  const AdminClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: "Select Client",
        showBackButton: true,
        onTapBack: () => Get.back(),
        titleStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500, // Max w500
          fontFamily: AppFonts.poppins,
        ),
      ),

      // ── BODY ─────────────────────────────────────────────────────
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // ── TABS (Prime | InHouse) - TOP ─────────────────────
            Container(
              color: ColorConstants.white,
              child: TabBar(
                controller: controller.tabController,
                tabs: const [
                  Tab(text: "Prime"),
                  Tab(text: "InHouse"),
                ],
                labelColor: ColorConstants.appThemeColor,
                unselectedLabelColor: ColorConstants.grey,
                indicatorColor: ColorConstants.appThemeColor,
                labelStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500, // Max w500
                  fontFamily: AppFonts.poppins,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                indicatorPadding: EdgeInsets.zero,
              ),
            ),

            // ── SEARCH + SORT ROW (Compact) ─────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
              child: Row(
                children: [
                  // Search Field
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      onChanged: controller.updateSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Search clients...',
                        hintStyle: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: AppFonts.poppins,
                          color: ColorConstants.grey,
                        ),
                        prefixIcon: Icon(Icons.search,
                            color: ColorConstants.grey, size: 18.w),
                        suffixIcon: controller.searchQuery.value.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear,
                                    color: ColorConstants.grey, size: 16.w),
                                onPressed: controller.clearSearch,
                              )
                            : null,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 10.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(
                              color: ColorConstants.grey.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(
                              color: ColorConstants.grey.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(
                              color: ColorConstants.appThemeColor, width: 1.5),
                        ),
                        filled: true,
                        fillColor: ColorConstants.white,
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // Sort Button
                  Obx(() => GestureDetector(
                        onTap: controller.toggleSortOrder,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: ColorConstants.appThemeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                                color: ColorConstants.appThemeColor, width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                controller.isAscending.value
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                size: 16.w,
                                color: ColorConstants.appThemeColor,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                controller.isAscending.value ? "A-Z" : "Z-A",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500, // Max w500
                                  color: ColorConstants.appThemeColor,
                                  fontFamily: AppFonts.poppins,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),

            // ── CLIENT LIST (Compact Cards) ─────────────────────
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.isNotEmpty) {
                  return _buildErrorWidget();
                }

                if (controller.filteredClients.isEmpty) {
                  return _buildEmptyWidget(
                    icon: controller.searchQuery.value.isNotEmpty
                        ? Icons.search_off
                        : Icons.business_outlined,
                    title: controller.searchQuery.value.isNotEmpty
                        ? 'No Matching Clients'
                        : 'No Clients Found',
                    subtitle: controller.searchQuery.value.isNotEmpty
                        ? 'Try adjusting your search.'
                        : 'No clients available.',
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.loadAdminClients,
                  child: ListView.separated(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    itemCount: controller.filteredClients.length,
                    separatorBuilder: (_, __) => SizedBox(height: 8.h),
                    itemBuilder: (context, index) => _buildCompactClientCard(
                        controller.filteredClients[index]),
                  ),
                );
              }),
            ),

            // ── LOGIN BUTTON (Bottom) ─────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: Obx(() {
                final canLogin = controller.selectedClient.value != null;
                final isSwitching = controller.isLoading.value;

                return ElevatedButton(
                  onPressed:
                      canLogin && !isSwitching ? controller.switchToClient : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canLogin && !isSwitching
                        ? ColorConstants.appThemeColor
                        : ColorConstants.lightGrey,
                    foregroundColor: ColorConstants.white,
                    elevation: 0,
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    minimumSize: Size(double.infinity, 48.h),
                  ),
                  child: isSwitching
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                    ColorConstants.white),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              'Logging in...',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500, // Max w500
                                fontFamily: AppFonts.poppins,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500, // Max w500
                            fontFamily: AppFonts.poppins,
                          ),
                        ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ── COMPACT CLIENT CARD (Email Preserved) ─────────────────
  Widget _buildCompactClientCard(ClientData client) {
    return Obx(() {
      final isSelected = controller.selectedClient.value?.id == client.id;

      String? location;
      if (client.city?.isNotEmpty == true &&
          client.pincode?.isNotEmpty == true) {
        location = '${client.city}, ${client.pincode}';
      } else if (client.city?.isNotEmpty == true) {
        location = client.city;
      } else if (client.pincode?.isNotEmpty == true) {
        location = client.pincode;
      }

      return InkWell(
        onTap: () => controller.selectClient(client),
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: isSelected
                ? ColorConstants.appThemeColor.withOpacity(0.12)
                : ColorConstants.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isSelected
                  ? ColorConstants.appThemeColor
                  : ColorConstants.grey.withOpacity(0.3),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              // Avatar (40x40)
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? ColorConstants.appThemeColor
                        : Colors.transparent,
                    width: isSelected ? 1.5 : 0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: (client.businessLogoUrl?.isNotEmpty ?? false)
                      ? Image.network(
                          client.businessLogoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.business,
                            color: ColorConstants.grey,
                            size: 18.w,
                          ),
                        )
                      : Icon(Icons.business,
                          color: ColorConstants.grey, size: 18.w),
                ),
              ),
              SizedBox(width: 12.w),

              // Info Column (Email Always Shown)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Business Name
                    Text(
                      client.businessName ?? client.name ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500, // Max w500
                        fontFamily: AppFonts.poppins,
                        color: ColorConstants.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Owner Name (if different)
                    if (client.name != null &&
                        client.name != client.businessName) ...[
                      SizedBox(height: 2.h),
                      Text(
                        client.name!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorConstants.grey,
                          fontFamily: AppFonts.poppins,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // Email (Always shown, even if owner name exists)
                    if (client.email?.isNotEmpty == true) ...[
                      SizedBox(height: 2.h),
                      Text(
                        client.email!,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorConstants.grey,
                          fontFamily: AppFonts.poppins,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // Location (only if exists)
                    if (location != null)
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 10.w, color: ColorConstants.grey),
                            SizedBox(width: 3.w),
                            Text(
                              location,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w400,
                                color: ColorConstants.grey,
                                fontFamily: AppFonts.poppins,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Selection Check
              if (isSelected)
                Icon(Icons.check_circle,
                    color: ColorConstants.appThemeColor, size: 20.w),
            ],
          ),
        ),
      );
    });
  }

  // ── ERROR WIDGET ─────────────────────────────────────
  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.w, color: ColorConstants.grey),
            SizedBox(height: 12.h),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: ColorConstants.grey,
                fontFamily: AppFonts.poppins,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: controller.loadAdminClients,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.appThemeColor,
                foregroundColor: ColorConstants.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              ),
              child: Text(
                'Retry',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500, // Max w500
                  fontFamily: AppFonts.poppins,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── EMPTY WIDGET ─────────────────────────────────────
  Widget _buildEmptyWidget({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56.w, color: ColorConstants.grey),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500, // Max w500
                fontFamily: AppFonts.poppins,
                color: ColorConstants.black,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                fontFamily: AppFonts.poppins,
                color: ColorConstants.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
