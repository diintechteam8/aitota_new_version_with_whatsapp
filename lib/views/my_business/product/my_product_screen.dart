import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/utils/widgets/business_widgets/custom_business_widgets.dart';
import 'package:aitota_business/routes/app_routes.dart';
import 'controller/my_product_controller.dart';

class MyProductScreen extends GetView<MyProductController> {
  const MyProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      body: Obx(
            () => controller.isLoading.value
            ? const Center(
          child: CircularProgressIndicator(
            color: Colors.green,
            strokeWidth: 2,
          ),
        )
            : controller.productItems.isEmpty
            ? Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.store_outlined,
                size: 60.sp,
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                "No products found",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Tap the + button to add your first product",
                style: TextStyle(
                  color: Colors.grey.withOpacity(0.8),
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
            : RefreshIndicator(
          onRefresh: controller.fetchMyProducts,
          color: Colors.green.shade600,
          displacement: 40,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: controller.productItems.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                final item = controller.productItems[index];
                return ModernBusinessCard(
                  title: item['title'] ?? '',
                  category: item['category'] ?? '',
                  image: item['imageUrl'] ?? '',
                  sharelink: item['sharelink'] ?? '',
                  mrp: item['mrp'], // Pass MRP
                  offerPrice: item['offerPrice'], // Pass offer price
                  onViewDetails: () {
                    Get.toNamed(AppRoutes.myBusinessDetailsScreen, arguments: item);
                  },
                  onUpdate: () {
                    Get.toNamed(
                      AppRoutes.updateMyBusinessScreen,
                      arguments: item,
                    );
                  },
                  onDelete: () {
                    controller.deleteMyBusiness(item['id']);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}