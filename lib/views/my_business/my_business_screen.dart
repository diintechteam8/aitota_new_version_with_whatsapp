import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/my_business/product/controller/my_product_controller.dart';
import 'package:aitota_business/views/my_business/product/my_product_screen.dart';
import 'package:aitota_business/views/my_business/service/controller/my_service_controller.dart';
import 'package:aitota_business/views/my_business/service/my_services_screen.dart';
import 'package:aitota_business/routes/app_routes.dart';
import '../../core/utils/widgets/app_widgets/custom_tab_bar.dart';
import 'controller/my_business_controller.dart';

class MyBusinessScreen extends GetView<MyBusinessController> {
  const MyBusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MyBusinessController());
    Get.put(MyProductController());
    Get.put(MyServiceController());
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColorConstants.white,
        appBar: CustomAppBar(
          title: "MyBusiness",
          centerTitle: true,
        ),
        body: SafeArea(
          top: false,
          child: Container(
            decoration: const BoxDecoration(
              gradient: ColorConstants.whatsappGradient, // Apply WhatsApp gradient to SafeArea
            ),
            child: Column(
              children: [
                CustomTabBar(
                  tabs: const [
                    Tab(
                      text: 'Products',
                      icon: Icon(Icons.store, size: 18),
                    ),
                    Tab(
                      text: 'Services',
                      icon: Icon(Icons.build, size: 18),
                    ),
                  ],
                  isScrollable: false, // Match the original TabBar behavior
                  labelPadding: EdgeInsets.symmetric(horizontal: 16.w), // Match original padding
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.5),// Match original indicator color
                  labelStyle: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: AppFonts.poppins,
                  ),
                  decoration: const BoxDecoration(
                    gradient: ColorConstants.whatsappGradient, // Apply WhatsApp gradient to CustomTabBar
                  ),
                  height: 50.h, // Match original height
                  indicatorPadding: EdgeInsets.zero, // Default indicator padding
                  onTap: (index) {
                    switch (index) {
                      case 0:
                        controller.onProductsTap();
                        break;
                      case 1:
                        controller.onServicesTap();
                        break;
                    }
                  },
                ),
                Expanded(
                  child: Container(
                    color: ColorConstants.white, // Restore content background
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: const TabBarView(
                        children: [
                          MyProductScreen(),
                          MyServicesScreen(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'my_business_fab', // Added unique tag to fix Hero conflict
          onPressed: () => Get.toNamed(AppRoutes.addMyBusinessScreen),
          backgroundColor: Colors.green.shade600,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}