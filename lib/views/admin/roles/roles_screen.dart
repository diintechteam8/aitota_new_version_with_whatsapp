import '../../../core/app-export.dart';
import 'controller/roles_controller.dart';
import '../../../data/model/auth_models/get_all_profiles_model.dart';

class RolesScreen extends GetView<RolesController> {
  const RolesScreen({super.key});

  String _formatRole(String? role) {
    if (role == null) return 'Unknown';
    final lower = role.toLowerCase();
    if (lower == 'humanagent') return 'Team';
    if (lower == 'admin') return 'Admin';
    if (lower == 'client') return 'Client';
    return lower.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  Widget _fallbackLetter(GetAllProfilesModelProfile profile, bool isAdmin) {
    if (isAdmin) {
      return Icon(
        Icons.admin_panel_settings,
        color: ColorConstants.white,
        size: 24.w,
      );
    }

    final letter = (profile.name ?? profile.role ?? 'U')
        .trim()
        .substring(0, 1)
        .toUpperCase();

    return Center(
      child: Text(
        letter,
        style: TextStyle(
          color: ColorConstants.appThemeColor,
          fontWeight: FontWeight.w500,
          fontSize: 20.sp,
          fontFamily: AppFonts.poppins,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: CustomAppBar(
        title: "Manage Accounts",
        showBackButton: true,
        titleStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.poppins,
        ),
      ),
      body: SafeArea(
        top: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.profiles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline,
                      size: 48.w, color: ColorConstants.grey),
                  SizedBox(height: 16.h),
                  Text(
                    'No accounts found',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: ColorConstants.grey,
                      fontFamily: AppFonts.poppins,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  itemCount: controller.profiles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final profile = controller.profiles[index];
                    return _buildRoleCard(profile);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Obx(() {
                  final canSwitch = controller.canSwitchRole;
                  final isSwitching = controller.isSwitchingRole.value;

                  return ElevatedButton(
                    onPressed: canSwitch && !isSwitching
                        ? controller.switchRole
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canSwitch && !isSwitching
                          ? ColorConstants.appThemeColor
                          : ColorConstants.lightGrey,
                      foregroundColor: ColorConstants.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                          horizontal: 32.w, vertical: 16.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      minimumSize: Size(double.infinity, 50.h),
                    ),
                    child: isSwitching
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                      ColorConstants.white),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Switching...',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppFonts.poppins,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppFonts.poppins,
                            ),
                          ),
                  );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildRoleCard(GetAllProfilesModelProfile profile) {
    return Obx(() {
      final bool isSelected = controller.selectedProfile.value?.id == profile.id;
      final String displayRole = _formatRole(profile.role);
      final bool isAdmin = profile.role?.toLowerCase() == 'admin';
      final bool isHumanAgent = profile.role?.toLowerCase() == 'humanagent';

      String agentName = profile.name ?? 'Unknown';
      if (agentName.isNotEmpty && isHumanAgent) {
        agentName = agentName[0].toUpperCase() + agentName.substring(1).toLowerCase();
      }

      final String primaryText = isHumanAgent && profile.clientName != null
          ? profile.clientName!
          : (profile.name ?? 'Unknown');

      return InkWell(
        onTap: () => controller.selectProfile(profile),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: isAdmin
                ? LinearGradient(
                    colors: [
                      ColorConstants.premiumGradient1.withOpacity(0.15),
                      ColorConstants.premiumGradient2.withOpacity(0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isAdmin ? null : ColorConstants.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? (isAdmin
                      ? ColorConstants.premiumGradient1
                      : ColorConstants.appThemeColor)
                  : (isAdmin
                      ? ColorConstants.premiumGradient1.withOpacity(0.4)
                      : ColorConstants.grey.withOpacity(0.2)),
              width: isSelected ? 2.5 : (isAdmin ? 1.5 : 1),
            ),
            boxShadow: [
              BoxShadow(
                  color: isAdmin
                      ? ColorConstants.premiumGradient1.withOpacity(0.2)
                      : Colors.black.withOpacity(0.04),
                  blurRadius: isAdmin ? 12 : 8,
                  spreadRadius: isAdmin ? 1 : 0,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------
              //     NEW AVATAR LOGIC
              // ------------------------
              Container(
                width: 48.w,
                height: 48.w,
                clipBehavior: Clip.hardEdge,
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
                  color: isAdmin
                      ? null
                      : ColorConstants.appThemeColor.withOpacity(0.1),
                ),
                child: isAdmin
                    ? _fallbackLetter(profile, true)
                    : (profile.logoUrl != null &&
                            profile.logoUrl!.isNotEmpty)
                        ? Image.network(
                            profile.logoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _fallbackLetter(profile, false),
                          )
                        : _fallbackLetter(profile, false),
              ),

              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Primary Name
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Text(
                          primaryText,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.poppins,
                            color: ColorConstants.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (isAdmin)
                          Positioned(
                            right: -10,
                            top: -4,
                            child: Container(
                              width: 14.w,
                              height: 14.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorConstants.secondaryColor,
                                border: Border.all(
                                  color: ColorConstants.white,
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                Icons.star,
                                size: 8.w,
                                color: ColorConstants.white,
                              ),
                            ),
                          ),
                      ],
                    ),

                    // agent secondary text
                    if (isHumanAgent && profile.clientName != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        agentName,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.poppins,
                          color: ColorConstants.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // Email
                    if (profile.email != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        profile.email!,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.poppins,
                          color: ColorConstants.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Role badge + Selection
              Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      gradient: isAdmin
                          ? LinearGradient(
                              colors: [
                                ColorConstants.premiumGradient1,
                                ColorConstants.premiumGradient2,
                              ],
                            )
                          : null,
                      color: isAdmin
                          ? null
                          : ColorConstants.appThemeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isAdmin) ...[
                          Icon(Icons.verified,
                              size: 12.w, color: ColorConstants.white),
                          SizedBox(width: 4.w),
                        ],
                        Text(
                          displayRole,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.poppins,
                            color: isAdmin
                                ? ColorConstants.white
                                : ColorConstants.appThemeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isSelected && isAdmin
                          ? LinearGradient(
                              colors: [
                                ColorConstants.premiumGradient1,
                                ColorConstants.premiumGradient2,
                              ],
                            )
                          : null,
                      border: Border.all(
                        color: isSelected
                            ? (isAdmin
                                ? ColorConstants.premiumGradient1
                                : ColorConstants.appThemeColor)
                            : ColorConstants.grey.withOpacity(0.3),
                        width: 2,
                      ),
                      color: isSelected && !isAdmin
                          ? ColorConstants.appThemeColor
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? Icon(Icons.check,
                            size: 12.w, color: ColorConstants.white)
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
