import '../../../core/app-export.dart';
import 'controller/payment_history_controller.dart';

class PaymentHistoryScreen extends GetView<PaymentHistoryController> {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        height: 45.h,
        title: "Credits History",
        titleStyle: TextStyle(fontFamily: AppFonts.poppins, fontWeight: FontWeight.w500, fontSize: 16.sp),
        showBackButton: true,
        onTapBack: () {
          Get.back();
        },
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Tab Bar
            Container(
              color: Colors.white,
              child: Obx(() => Row(
                children: [
                  Expanded(
                    child: _buildTabButton(
                      'Payment History',
                      0,
                      controller.selectedTabIndex.value == 0,
                    ),
                  ),
                  Expanded(
                    child: _buildTabButton(
                      'Credit Usage',
                      1,
                      controller.selectedTabIndex.value == 1,
                    ),
                  ),
                ],
              )),
            ),

            // Tab Content
            Expanded(
              child: Obx(() => IndexedStack(
                index: controller.selectedTabIndex.value,
                children: [
                  _buildPaymentHistoryTab(),
                  _buildCreditUsageTab(),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }

  // Custom tab button
  Widget _buildTabButton(String text, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? ColorConstants.appThemeColor : Colors.grey[300]!,
              width: 2,
            ),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: AppFonts.poppins,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? ColorConstants.appThemeColor : Colors.grey,
          ),
        ),
      ),
    );
  }

// Payment History Tab
  Widget _buildPaymentHistoryTab() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: controller.paymentHistoryData.length,
      itemBuilder: (context, index) {
        final item = controller.paymentHistoryData[index];
        return PaymentHistoryCard(
          item: item,
          onViewInvoice: () {
            Get.snackbar(
              'Info',
              'PDF view functionality will be implemented later',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        );
      },
    );
  }

// Credit Usage Tab
  Widget _buildCreditUsageTab() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: controller.creditUsageData.length,
      itemBuilder: (context, index) {
        final item = controller.creditUsageData[index];
        return CreditUsageCard(
          item: item,
          onViewTranscript: () => controller.showTranscriptBottomSheet(
            item['transcript'],
            item['language'],
          ),
        );
      },
    );
  }


  // Helper method to build detail rows
  Widget _buildDetailRow(String label, String value, {bool isBoldValue = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: ColorConstants.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14.sp,
              fontWeight: isBoldValue ? FontWeight.w600 : FontWeight.w500,
              color: ColorConstants.blackText,
            ),
          ),
        ],
      ),
    );
  }
}