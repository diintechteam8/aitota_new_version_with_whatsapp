import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/app-export.dart';
import '../../routes/app_routes.dart';
import '../dashboard/dashboard_screen.dart';
import '../myDial/my_dial_screen.dart';
import '../my_business/my_business_screen.dart';
import '../more_flow/more_screen/users_profile_screen.dart';
import '../whatsapp_bulk/view/whatsapp_bulk_landing_screen.dart';
import '../whatsapp_groups/views/groups_landing_screen.dart';
import 'controller/bottom_bar_controller.dart';

class BottomBarScreen extends GetView<BottomBarController> {
  const BottomBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      body: Obx(() {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (controller.numberClick.value == 0) {
              controller.lastTime.value = DateTime.now();
              controller.numberClick.value++;
              showExitPrompt(context);
            } else if (controller.numberClick.value == 1 &&
                DateTime.now().difference(controller.lastTime.value) <=
                    const Duration(seconds: 3)) {
              exit(0);
            } else {
              controller.numberClick.value = 0;
              controller.lastTime.value = DateTime.now();
              controller.numberClick.value++;
              showExitPrompt(context);
            }
          },
          child: IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              DashboardScreen(),
              MyBusinessScreen(),
              GroupsLandingScreen(), // Changed from VoiceScreen to GroupsLandingScreen
              MyDialScreen(),
              WhatsAppBulkLandingScreen(),
            ],
          ),
        );
      }),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Obx(() {
          return CustomBottomNavBar(
            selectedIndex: controller.currentIndex.value,
            onTap: (index) {
              if (index == 4) {
                Get.toNamed(AppRoutes.whatsappMainNavigator);
              } else {
                controller.changeIndex(index);
              }
            },
            onCenterTap: () => controller.changeIndex(2),
          );
        }),
      ),
    );
  }

  void showExitPrompt(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Press Back Button Again to Exit',
          style: TextStyle(fontFamily: AppFonts.poppins),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final Function(int)? onTap;
  final VoidCallback? onCenterTap;
  final int selectedIndex;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    this.onTap,
    this.onCenterTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80, // Fixed height
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// Background Bar
          Container(
            height: 80, // Fixed height
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// LEFT SIDE (Dashboard + MyBusiness)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _BottomIcon(
                        icon: Icons.dashboard,
                        label: "Dashboard",
                        selected: selectedIndex == 0,
                        onTap: () => onTap?.call(0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 14.w),
                        child: _BottomIcon(
                          icon: Icons.business,
                          label: "MyBusiness",
                          selected: selectedIndex == 1,
                          onTap: () => onTap?.call(1),
                        ),
                      ),
                    ],
                  ),
                ),

                /// RIGHT SIDE (MyDials + Profile)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 14.w),
                        child: _BottomIcon(
                          icon: Icons.call,
                          label: "MyDials",
                          selected: selectedIndex == 3,
                          onTap: () => onTap?.call(3),
                        ),
                      ),
                      _BottomIcon(
                        icon: FontAwesomeIcons.whatsapp,
                        label: "WhatsApp",
                        selected: selectedIndex == 4,
                        onTap: () => onTap?.call(4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// Center Floating Button (True Centered)
          Positioned(
            top: -28,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: selectedIndex == 2
                          ? ColorConstants.whatsappGradientDark
                              .withOpacity(0.25)
                          : ColorConstants.appThemeColor.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: onCenterTap,
                    child: Center(
                      child: selectedIndex == 2
                          ? ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  ColorConstants.whatsappGradientDark,
                                  ColorConstants.whatsappGradientLight,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: const Icon(
                                Icons.support_agent_outlined,
                                size: 32,
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              Icons.support_agent_outlined,
                              size: 32,
                              color: ColorConstants.grey,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomIcon extends StatelessWidget {
  final dynamic icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BottomIcon({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              selected
                  ? ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          ColorConstants.whatsappGradientDark,
                          ColorConstants.whatsappGradientLight,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: icon is FaIconData
                          ? FaIcon(
                              icon,
                              color: Colors.white,
                              size: 24,
                            )
                          : Icon(
                              icon,
                              color: Colors.white,
                              size: 24,
                            ),
                    )
                  : icon is FaIconData
                      ? FaIcon(
                          icon,
                          color: ColorConstants.grey,
                          size: 24,
                        )
                      : Icon(
                          icon,
                          color: ColorConstants.grey,
                          size: 24,
                        ),
              const SizedBox(height: 4),
              selected
                  ? ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          ColorConstants.whatsappGradientDark,
                          ColorConstants.whatsappGradientLight,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: ColorConstants.grey,
                      ),
                    ),
            ],
          ),
        ));
  }
}
