import 'package:aitota_business/core/app-export.dart';
import 'controller/profile_select_controller.dart';
import '../../../data/model/auth_models/google_profiles_response.dart';

class ProfileSelectScreen extends GetView<ProfileSelectController> {
  const ProfileSelectScreen({super.key});

  String _capitalizeFirst(String? text) {
    if (text == null || text.isEmpty || text == 'N/A') return text ?? 'Unknown';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // ... appBar content ...
        backgroundColor: ColorConstants.appThemeColor,
        title: Obx(() {
          final profile =
              controller.profiles.isNotEmpty ? controller.profiles[0] : null;
          return RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Accounts',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.poppins,
                    color: Colors.white,
                  ),
                ),
                if (profile != null && profile.email != null) ...[
                  TextSpan(
                    text: ' (${profile.email})',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppFonts.poppins,
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.w),
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0,
        elevation: 0,
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
                  Icon(
                    Icons.person_outline,
                    size: 64.w,
                    color: ColorConstants.grey,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No Profiles Found',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.poppins,
                      color: ColorConstants.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'There are no profiles available to select.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: AppFonts.poppins,
                      color: ColorConstants.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Sort profiles: admin > client > humanAgent
          final sortedProfiles = controller.profiles.toList()
            ..sort((a, b) {
              const priority = {
                'admin': 1,
                'client': 2,
                'humanagent': 3,
              };
              return (priority[a.userType?.toLowerCase() ?? ''] ?? 4)
                  .compareTo(priority[b.userType?.toLowerCase() ?? ''] ?? 4);
            });

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                  itemCount: sortedProfiles.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final SelectableProfile item = sortedProfiles[index];
                    return _buildProfileCard(item, context);
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                child: Obx(() {
                  final canContinue = controller.selected.value != null;
                  final isLoading = controller.isLoading.value;

                  return ElevatedButton(
                    onPressed: canContinue && !isLoading
                        ? controller.confirmSelection
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canContinue && !isLoading
                          ? ColorConstants.appThemeColor
                          : ColorConstants.lightGrey,
                      foregroundColor: ColorConstants.white,
                      elevation: 0,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(double.infinity, 50.h),
                    ),
                    child: isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    ColorConstants.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Continuing...',
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

  // -------------------------------------------------------------
  // UPDATED AVATAR WITH logoUrl SUPPORT
  // -------------------------------------------------------------
  Widget _buildProfileCard(SelectableProfile item, BuildContext context) {
    return Obx(() {
      final bool isSelected = controller.selected.value?.id == item.id;
      final bool isAdmin = item.userType?.toLowerCase() == 'admin';
      final bool isHumanAgent = item.userType?.toLowerCase() == 'humanagent';

      final rawDisplayName = item.name ??
          item.clientName ??
          (isHumanAgent
              ? (item.role ?? 'Team Member')
              : (item.userType ?? 'Unknown'));
      final displayName = _capitalizeFirst(rawDisplayName);

      final Color cardBg = isAdmin
          ? ColorConstants.adminCardColor
          : (isSelected
              ? ColorConstants.appThemeColor.withOpacity(0.1)
              : ColorConstants.white);

      final Color borderColor = isAdmin
          ? ColorConstants.adminAccent
          : (isSelected
              ? ColorConstants.appThemeColor
              : ColorConstants.grey.withOpacity(0.3));

      return InkWell(
        onTap: () {
          controller.selectProfile(item);
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              //---------------------------------------------------------
              // AVATAR with logoUrl support
              //---------------------------------------------------------
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  color: ColorConstants.grey.withOpacity(0.2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.r),
                  child: (item.logoUrl != null &&
                          item.logoUrl!.trim().isNotEmpty)
                      ? Image.network(
                          item.logoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Center(
                            child: Text(
                              displayName[0],
                              style: TextStyle(
                                color: ColorConstants.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 20.sp,
                                fontFamily: AppFonts.poppins,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            displayName[0],
                            style: TextStyle(
                              color: ColorConstants.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20.sp,
                              fontFamily: AppFonts.poppins,
                            ),
                          ),
                        ),
                ),
              ),

              SizedBox(width: 16.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24.h,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Text(
                            displayName,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppFonts.poppins,
                              color: ColorConstants.black,
                            ),
                          ),
                          if (isAdmin)
                            Positioned(
                              right: -12.w,
                              top: -8.h,
                              child: Icon(
                                Icons.star,
                                color: ColorConstants.adminAccent,
                                size: 18.w,
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6.h),

                    if (isHumanAgent) ...[
                      _buildInfoRow('Role(Team Member): ', item.role ?? 'N/A'),
                      SizedBox(height: 2.h),
                      _buildInfoRow('Client: ', item.clientName ?? 'N/A'),
                    ] else
                      _buildInfoRow('Role: ', item.userType ?? 'N/A'),
                  ],
                ),
              ),

              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: ColorConstants.appThemeColor,
                  size: 24.w,
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: AppFonts.poppins,
              color: ColorConstants.grey,
            ),
          ),
          TextSpan(
            text: _capitalizeFirst(value),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.poppins,
              color: ColorConstants.black,
            ),
          ),
        ],
      ),
    );
  }
}
