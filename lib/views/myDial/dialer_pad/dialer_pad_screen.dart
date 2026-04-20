import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/myDial/dialer_pad/controller/dialer_pad_controller.dart';

class DialerPadScreen extends GetView<DialerPadController> {
  const DialerPadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Dialer",
        showBackButton: true,
        onTapBack: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Obx(
                    () => TextField(
                  controller: controller.numberController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    suffixIcon: controller.phoneNumber.value.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: controller.clearNumber,
                    )
                        : null,
                  ),
                  style: TextStyle(fontSize: 24.sp, letterSpacing: 2),
                  textAlign: TextAlign.center,
                  // readOnly: true, // Ensures input only via dial buttons
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDialButton(context, '1', ''),
                        _buildDialButton(context, '2', 'ABC'),
                        _buildDialButton(context, '3', 'DEF'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDialButton(context, '4', 'GHI'),
                        _buildDialButton(context, '5', 'JKL'),
                        _buildDialButton(context, '6', 'MNO'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDialButton(context, '7', 'PQRS'),
                        _buildDialButton(context, '8', 'TUV'),
                        _buildDialButton(context, '9', 'WXYZ'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDialButton(context, '*', ''),
                        _buildDialButton(context, '0', '+'),
                        _buildDialButton(context, '#', ''),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.backspace, size: 30.sp),
                    onPressed: controller.removeDigit,
                  ),
                  Obx(
                    () => FloatingActionButton(
                      heroTag: 'dialer_pad_fab', // Added unique tag to fix Hero conflict
                      onPressed: controller.phoneNumber.value.isEmpty
                          ? null
                          : () => controller.makePhoneCall(),
                      backgroundColor: controller.phoneNumber.value.isEmpty
                          ? Colors.white
                          : Colors.green,
                      child: const Icon(
                        Icons.call,
                        color: ColorConstants.appThemeColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialButton(BuildContext context, String digit, String letters) {
    return GestureDetector(
      onTap: () => controller.addDigit(digit),
      child: Container(
        width: 80.w,
        height: 80.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              digit,
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (letters.isNotEmpty)
              Text(
                letters,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}