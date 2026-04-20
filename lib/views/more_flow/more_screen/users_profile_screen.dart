import '../../../core/app-export.dart';
import 'package:shimmer/shimmer.dart';
import '../../../routes/app_routes.dart';
import 'controller/more_controller.dart';

class UsersProfileScreen extends GetView<MoreController> {
  const UsersProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: const CustomAppBar(
        title: "Profile",
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () async {
            controller.refreshSettings();
            await Future.delayed(const Duration(milliseconds: 500));
          },
          displacement: 60,
          color: ColorConstants.appThemeColor,
          backgroundColor: ColorConstants.white,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildUserProfileSection(controller, context),
                _buildCardSection(
                  context: context,
                  title: 'Credits',
                  children: [_buildCreditsSection(controller, context)],
                ),
                SizedBox(height: 8.h),
                _buildRoleBasedSections(),
                _buildCardSection(
                  context: context,
                  title: 'Account',
                  children: [
                    _buildSettingsItem(
                      context: context,
                      icon: Icons.person_outline,
                      iconColor: ColorConstants.appThemeColor,
                      iconBackground:
                          ColorConstants.appThemeColor.withAlpha(20),
                      title: 'Profile Info',
                      subtitle: 'Edit your account details',
                      onTap: controller.onProfileInfoTap,
                    ),
                    _buildSettingsItem(
                      context: context,
                      icon: Icons.help_outline,
                      iconColor: ColorConstants.appThemeColor,
                      iconBackground:
                          ColorConstants.appThemeColor.withAlpha(20),
                      title: 'Help & Support',
                      subtitle: 'Find answers to your questions',
                      onTap: controller.onHelpSupportTap,
                    ),
                    _buildSettingsItem(
                      context: context,
                      icon: Icons.admin_panel_settings_outlined,
                      iconColor: ColorConstants.appThemeColor,
                      iconBackground:
                          ColorConstants.appThemeColor.withAlpha(20),
                      title: 'Accounts',
                      subtitle: 'Switch between accounts',
                      onTap: () => Get.toNamed(AppRoutes.rolesScreen),
                      isLast: true,
                    ),
                  ],
                ),
                _buildCardSection(
                  context: context,
                  title: '',
                  children: [
                    _buildSettingsItem(
                      context: context,
                      icon: Icons.logout,
                      iconColor: ColorConstants.appThemeColor,
                      iconBackground:
                          ColorConstants.appThemeColor.withAlpha(20),
                      title: 'Logout',
                      subtitle: 'Are you sure you want to logout?',
                      onTap: controller.onLogoutTap,
                      isLast: true,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Role-based sections
  Widget _buildRoleBasedSections() {
    return Obx(() {
      final List<Widget> sections = [];
      // Show Human Agents for clients
      if (controller.userRole.value == 'client') {
        sections.add(_buildHumanAgentsSection());
      }
      // Show Associated Clients for human agents/executives
      if (controller.userRole.value == 'executive' ||
          controller.userRole.value == 'humanAgent') {
        sections.add(_buildAssociatedClientsSection());
      }
      // Show Admin's Clients if admin token is present (any role)
      if (controller.hasAdminToken.value) {
        sections.add(_buildAdminClientsSection());
      }
      if (sections.isEmpty) return const SizedBox.shrink();
      return Column(children: sections);
    });
  }

  Widget _buildHumanAgentsSection() {
    return Obx(() {
      // Agar loading ya count 0 → kuch mat dikhao
      if (controller.isHumanAgentsLoading.value ||
          controller.humanAgents.isEmpty) {
        return const SizedBox.shrink();
      }

      return _buildCardSection(
        context: Get.context!,
        title: '',
        children: [
          _buildSettingsItem(
            context: Get.context!,
            icon: Icons.people,
            iconColor: ColorConstants.appThemeColor,
            iconBackground: ColorConstants.appThemeColor.withAlpha(20),
            title: 'Team',
            subtitle: '${controller.humanAgents.length} members available',
            onTap: controller.onHumanAgentsTap,
            isLast: true,
          ),
        ],
      );
    });
  }

  Widget _buildAssociatedClientsSection() {
    return Obx(() {
      // Agar loading ya count 0 → hide kar do
      if (controller.isAssociatedClientsLoading.value ||
          controller.associatedClients.isEmpty) {
        return const SizedBox.shrink();
      }

      return _buildCardSection(
        context: Get.context!,
        title: 'Associated Clients',
        children: [
          _buildSettingsItem(
            context: Get.context!,
            icon: Icons.business,
            iconColor: ColorConstants.appThemeColor,
            iconBackground: ColorConstants.appThemeColor.withAlpha(20),
            title: 'Associated Clients',
            subtitle:
                '${controller.associatedClients.length} clients available',
            onTap: controller.onAssociatedClientsTap,
            isLast: true,
          ),
        ],
      );
    });
  }

  Widget _buildAdminClientsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorConstants.premiumGradient1.withOpacity(0.1),
            ColorConstants.premiumGradient2.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSettingsItem(
            context: Get.context!,
            icon: Icons.admin_panel_settings,
            iconColor: ColorConstants.premiumGradient1,
            iconBackground: ColorConstants.premiumGradient1.withAlpha(30),
            title: "Clients",
            subtitle: 'View and login to your clients',
            onTap: () => Get.toNamed(AppRoutes.adminClientsScreen),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16.w),
      child: Shimmer.fromColors(
        baseColor: ColorConstants.lightGrey,
        highlightColor: ColorConstants.lightGrey.withAlpha(60),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConstants.white,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16.h,
                    width: 120.w,
                    color: ColorConstants.white,
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    height: 14.h,
                    width: 80.w,
                    color: ColorConstants.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
//  Replace the whole _buildUserProfileSection (and keep the 3 helpers)
// ─────────────────────────────────────────────────────────────────────────────
  Widget _buildUserProfileSection(
    MoreController controller,
    BuildContext context,
  ) {
    return Obx(() {
      // ── Shimmer while loading ───────────────────────────────────────
      if (controller.isProfileLoading.value ||
          (controller.userName.value.isEmpty &&
              controller.businessName.value.isEmpty)) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          color: ColorConstants.white,
          child: Row(
            children: [
              Shimmer.fromColors(
                baseColor: ColorConstants.lightGrey,
                highlightColor: ColorConstants.lightGrey.withAlpha(60),
                child: Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorConstants.white,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: ColorConstants.lightGrey,
                      highlightColor: ColorConstants.lightGrey.withAlpha(60),
                      child: Container(
                          height: 14.h, width: 80.w, color: Colors.white),
                    ),
                    SizedBox(height: 4.h),
                    Shimmer.fromColors(
                      baseColor: ColorConstants.lightGrey,
                      highlightColor: ColorConstants.lightGrey.withAlpha(60),
                      child: Container(
                          height: 18.h, width: 150.w, color: Colors.white),
                    ),
                    SizedBox(height: 4.h),
                    Shimmer.fromColors(
                      baseColor: ColorConstants.lightGrey,
                      highlightColor: ColorConstants.lightGrey.withAlpha(60),
                      child: Container(
                          height: 14.h, width: 200.w, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      // ── Main profile content ───────────────────────────────────────
      final bool isAdmin = controller.userRole.value.toLowerCase() == 'admin' ||
          controller.hasAdminToken.value;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: ColorConstants.white,
          gradient: isAdmin
              ? LinearGradient(
                  colors: [
                    ColorConstants.premiumGradient1.withOpacity(0.08),
                    ColorConstants.premiumGradient2.withOpacity(0.04),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── AVATAR / LOGO (WITHOUT BADGE) ───────────────────────────────────────
            Obx(() {
              final bool isAdmin =
                  controller.userRole.value.toLowerCase() == 'admin' ||
                      controller.hasAdminToken.value;

              if (controller.userRole.value == 'client' &&
                  controller.clientLogo.value.isNotEmpty) {
                return Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isAdmin
                        ? Border.all(
                            color: ColorConstants.premiumGradient1,
                            width: 2.5,
                          )
                        : null,
                    boxShadow: isAdmin
                        ? [
                            BoxShadow(
                              color: ColorConstants.premiumGradient1
                                  .withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: ClipOval(
                    child: Image.network(
                      controller.clientLogo.value,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _fallbackIcon(true, isAdmin),
                      loadingBuilder: (c, child, progress) =>
                          progress == null ? child : _shimmerAvatar(),
                    ),
                  ),
                );
              }
              return _fallbackIcon(
                  controller.userRole.value == 'client', isAdmin);
            }),
            // ───────────────────────────────────────────────────────

            SizedBox(width: 16.w),

            // ── TEXT AREA (business name, name+role, email) ───────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---- BUSINESS NAME (alone) -------------------------
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          controller.businessName.value,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.poppins,
                            color: isAdmin
                                ? ColorConstants.premiumGradient1
                                : ColorConstants.appThemeColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // ---- USER NAME + STAR ICON (if admin) + ROLE BADGE (same row) -------------
                  LayoutBuilder(
                    builder: (ctx, constraints) {
                      return ConstrainedBox(
                        constraints:
                            BoxConstraints(maxWidth: constraints.maxWidth),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // User name with star icon
                            Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      controller.userName.value,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppFonts.poppins,
                                        color: ColorConstants.grey,
                                      ),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                  if (isAdmin) ...[
                                    SizedBox(width: 4.w),
                                    Icon(
                                      Icons.star,
                                      size: 14.sp,
                                      color: ColorConstants.secondaryColor,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(width: 8.w),
                            // Role badge – always on the right
                            _roleBadge(controller),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 4.h),

                  // ---- EMAIL -----------------------------------------
                  Text(
                    controller.userEmail.value,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: AppFonts.poppins,
                      color: ColorConstants.lightTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

// ── Helper: fallback icon (client / person) WITHOUT BADGE ─────────────────────
  Widget _fallbackIcon(bool isClient, bool isAdmin) {
    return Container(
      width: 60.w,
      height: 60.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isAdmin
            ? LinearGradient(
                colors: [
                  ColorConstants.premiumGradient1,
                  ColorConstants.premiumGradient2,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isAdmin ? null : ColorConstants.grey.withAlpha(38),
        border: isAdmin
            ? Border.all(
                color: ColorConstants.premiumGradient1,
                width: 2,
              )
            : null,
        boxShadow: isAdmin
            ? [
                BoxShadow(
                  color: ColorConstants.premiumGradient1.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Icon(
        isAdmin
            ? Icons.admin_panel_settings
            : (isClient ? Icons.business : Icons.person),
        size: 30.w,
        color: isAdmin ? ColorConstants.white : ColorConstants.grey,
      ),
    );
  }

// ── Helper: shimmer avatar ─────────────────────────────────────
  Widget _shimmerAvatar() {
    return Shimmer.fromColors(
      baseColor: ColorConstants.lightGrey,
      highlightColor: ColorConstants.lightGrey.withAlpha(60),
      child: Container(width: 60.w, height: 60.h, color: Colors.white),
    );
  }

// ── Helper: role badge (Admin for client, otherwise role name) ─────
  Widget _roleBadge(MoreController controller) {
    final bool isAdmin = controller.userRole.value.toLowerCase() == 'admin' ||
        controller.hasAdminToken.value;
    final String label = controller.userRole.value == 'client'
        ? 'Admin'
        : (controller.userRole.value.capitalizeFirst ?? '');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: isAdmin
            ? LinearGradient(
                colors: [
                  ColorConstants.premiumGradient1,
                  ColorConstants.premiumGradient2,
                ],
              )
            : null,
        border: Border.all(
          color:
              isAdmin ? ColorConstants.premiumGradient1 : ColorConstants.grey,
        ),
        color: isAdmin ? null : ColorConstants.appThemeColor.withOpacity(0.08),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isAdmin) ...[
            Icon(
              Icons.verified,
              size: 12.w,
              color: ColorConstants.white,
            ),
            SizedBox(width: 4.w),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.poppins,
              color: isAdmin ? ColorConstants.white : ColorConstants.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditsSection(MoreController controller, BuildContext context) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              ColorConstants.appThemeColor,
              ColorConstants.appThemeColor1,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: ColorConstants.appThemeColor1.withAlpha(60),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: controller.isCreditsLoading.value
            ? Shimmer.fromColors(
                baseColor: ColorConstants.lightGrey,
                highlightColor: ColorConstants.lightGrey.withAlpha(60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 120.w, height: 20.h, color: Colors.white),
                    SizedBox(height: 12.h),
                    Container(
                      width: double.infinity,
                      height: 20.h,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      height: 20.h,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Credits',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.white,
                          fontFamily: AppFonts.poppins,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.payment,
                          size: 24.w,
                          color: ColorConstants.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Available Balance',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: ColorConstants.white.withOpacity(0.7),
                                fontFamily: AppFonts.poppins,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${controller.totalCredits.value}',
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w500,
                                color: ColorConstants.white,
                                fontFamily: AppFonts.poppins,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.paymentHistoryScreen);
                        },
                        child: Icon(
                          Icons.visibility_outlined,
                          size: 20.w,
                          color: ColorConstants.white,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.addRechargeScreen, arguments: {
                            'totalCredits': controller.totalCredits.value,
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: ColorConstants.white,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Add Credits',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: ColorConstants.white,
                                fontFamily: AppFonts.poppins,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            const Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: ColorConstants.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      );
    });
  }

  Widget _buildCardSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.poppins,
                  color: ColorConstants.black,
                ),
              ),
            ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: ColorConstants.lightGrey.withAlpha(50),
                    width: 0.5,
                  ),
                ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconBackground,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20.w,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.poppins,
                      color: ColorConstants.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
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
            Icon(
              Icons.chevron_right,
              color: ColorConstants.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
