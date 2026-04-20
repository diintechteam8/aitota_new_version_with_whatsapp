import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/app-export.dart';
import '../controller/whatsapp_nav_controller.dart';
import 'whatsapp_bulk_landing_screen.dart';
import '../audience/audience_selection_screen.dart';
import '../inbox/whatsapp_inbox_screen.dart';
import '../templates/view/whatsapp_templates_screen.dart';
import '../../bottom_bar/controller/bottom_bar_controller.dart';

class WhatsAppMainNavigator extends GetView<WhatsAppNavController> {
  const WhatsAppMainNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      body: Obx(() {
        return IndexedStack(
          index: controller.selectedIndex.value,
          children:[
            WhatsAppBulkLandingScreen(),
            AudienceSelectionScreen(),
            WhatsAppInboxScreen(),
            WhatsAppTemplatesScreen(),
          ],
        );
      }),
      bottomNavigationBar: WhatsAppBottomNavBar(),
    );
  }
}

class WhatsAppBottomNavBar extends GetView<WhatsAppNavController> {
  const WhatsAppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.arrow_back,
                    label: "Back",
                    isSelected: false,
                    onTap: () {
                      Get.find<BottomBarController>().changeIndex(0);
                      Get.back();
                    },
                  ),
                  _buildNavItem(
                    icon: FontAwesomeIcons.whatsapp,
                    label: "WhatsApp",
                    isSelected: controller.selectedIndex.value == 0,
                    onTap: () => controller.changeIndex(0),
                  ),
                  _buildNavItem(
                    icon: Icons.people_outline,
                    label: "Users",
                    isSelected: controller.selectedIndex.value == 1,
                    onTap: () => controller.changeIndex(1),
                  ),
                  _buildNavItem(
                    icon: Icons.chat_bubble_outline,
                    label: "Chat",
                    isSelected: controller.selectedIndex.value == 2,
                    onTap: () => controller.changeIndex(2),
                  ),
                  _buildNavItem(
                    icon: Icons.description_outlined,
                    label: "Templates",
                    isSelected: controller.selectedIndex.value == 3,
                    onTap: () => controller.changeIndex(3),
                  ),
                ],
              );
            }),
          ),
        ));
  }

  Widget _buildNavItem({
    required dynamic icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isSelected
                ? ShaderMask(
                    shaderCallback: (bounds) =>
                        ColorConstants.whatsappGradient.createShader(bounds),
                    child: icon is IconData
                        ? Icon(icon, color: Colors.white, size: 26)
                        : FaIcon(icon as FaIconData,
                            color: Colors.white, size: 24),
                  )
                : icon is IconData
                    ? Icon(icon, color: Colors.grey.shade400, size: 26)
                    : FaIcon(icon as FaIconData,
                        color: Colors.grey.shade400, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? ColorConstants.whatsappGradientDark
                    : Colors.grey.shade500,
                fontFamily: AppFonts.poppins,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
