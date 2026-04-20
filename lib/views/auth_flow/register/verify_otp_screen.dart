import 'package:aitota_business/views/auth_flow/register/controller/otp_controller.dart';
import '../../../core/app-export.dart';
import '../../../core/utils/widgets/app_widgets/custom_button.dart'
    show CustomButton, ButtonVariant, ButtonShape;

class VerifyOtpScreen extends GetView<OtpController> {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Verify Email",
        showBackButton: true,
        onTapBack: () => Get.back(),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40.h),
                    _buildHeader(),
                    SizedBox(height: 48.h),
                    _buildOtpInput(),
                    SizedBox(height: 24.h),
                    _buildResendOption(),
                    SizedBox(height: 32.h),
                    _buildErrorMessage(),
                    SizedBox(height: 40.h),
                    _buildVerifyButton(),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
    Container(
          height: 80.h,
          width: 80.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: ColorConstants.appThemeColor.withAlpha(20),
              width: 2.h,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Image.asset(
              ImageConstant.appLogo,
              fit: BoxFit.fitHeight,
            ).paddingAll(10),
          ),
        ).animate().scale(duration: 600.ms, curve: Curves.easeOutQuad),
       
        SizedBox(height: 24.h),
        Text(
          'Email Verification',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstants.colorHeading,
            fontFamily: AppFonts.poppins,
          ),
        ).animate().slideY(begin: 0.1, end: 0, duration: 500.ms),
        SizedBox(height: 12.h),
        Obx(() => RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: ColorConstants.grey,
              fontFamily: AppFonts.poppins,
              height: 1.5,
            ),
            children: [
              const TextSpan(text: 'Please enter the 6-digit code sent to\n'),
              TextSpan(
                text: controller.userEmail.value,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.colorHeading,
                ),
              ),
            ],
          ),
        )).animate().fadeIn(duration: 500.ms, delay: 200.ms),
      ],
    );
  }


Widget _buildOtpInput() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: List.generate(6, (index) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: controller.otpFocusNodes[index].hasFocus
                    ? ColorConstants.appThemeColor
                    : Colors.grey.shade300,
                width: 1.5,
              ),
              boxShadow: [
                if (controller.otpFocusNodes[index].hasFocus)
                  BoxShadow(
                    color: ColorConstants.appThemeColor.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
              ],
            ),
            child: Center(
              child: TextFormField(
                controller: controller.otpControllers[index],
                focusNode: controller.otpFocusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                maxLength: 1,
                decoration: const InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    if (index < 5) {
                      controller.otpFocusNodes[index + 1].requestFocus();
                    } else {
                      controller.otpFocusNodes[index].unfocus();
                    }
                  } else {
                    if (index > 0) {
                      controller.otpFocusNodes[index - 1].requestFocus();
                    }
                  }
                },
              ),
            ),
          ),
        ),
      );
    }),
  ).animate().fadeIn(duration: 500.ms, delay: 300.ms);
}

// Widget _buildOtpInput() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: List.generate(
//       6,
//       (index) => Expanded(
//         child: Container(
//           margin: EdgeInsets.symmetric(horizontal: 6.w),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14.r),
//             border: Border.all(
//               color: controller.otpControllers[index].text.isNotEmpty
//                   ? ColorConstants.appThemeColor
//                   : Colors.grey.shade300,
//               width: 1.5,
//             ),
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.04),
//                 blurRadius: 8,
//                 offset: Offset(0, 2),
//               ),
//             ],
//           ),
//           child: TextFormField(
//             controller: controller.otpControllers[index],
//             focusNode: controller.otpFocusNodes[index],
//             keyboardType: TextInputType.number,
//             textAlign: TextAlign.center,
//             maxLength: 1,
//             style: TextStyle(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.w600,
//             ),
//             decoration: InputDecoration(
//               counterText: "",
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.symmetric(vertical: 14.h),
//             ),
//             inputFormatters: [
//               FilteringTextInputFormatter.digitsOnly,
//             ],
//             onChanged: (value) {
//               if (value.isNotEmpty) {
//                 if (index < 5) {
//                   controller.otpFocusNodes[index + 1].requestFocus();
//                 } else {
//                   controller.otpFocusNodes[index].unfocus();
//                 }
//               } else {
//                 if (index > 0) {
//                   controller.otpFocusNodes[index - 1].requestFocus();
//                 }
//               }
//             },
//           ),
//         ),
//       ),
//     ),
//   ).animate().fadeIn(duration: 500.ms, delay: 300.ms);
// }


  // Widget _buildOtpInput() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: List.generate(
  //       6,
  //       (index) => SizedBox(
  //         width: 44.w,
  //         child: CustomTextFormField(
  //           controller: controller.otpControllers[index],
  //           focusNode: controller.otpFocusNodes[index],
  //           textInputType: TextInputType.number,
  //           maxLength: 1,
  //           variant: TextFormFieldVariant.OutlineLightGrey,
  //           padding: TextFormFieldPadding.PaddingAll12,
  //           inputFormatters: [
  //             FilteringTextInputFormatter.digitsOnly,
  //           ],
  //           onChanged: (value) {
  //             if (value.isNotEmpty) {
  //               if (index < 5) {
  //                 controller.otpFocusNodes[index + 1].requestFocus();
  //               } else {
  //                 controller.otpFocusNodes[index].unfocus();
  //               }
  //             } else if (value.isEmpty) {
  //               if (index > 0) {
  //                 controller.otpFocusNodes[index - 1].requestFocus();
  //               }
  //             }
  //           },
  //         ),
  //       ),
  //     ),
  //   ).animate().fadeIn(duration: 500.ms, delay: 300.ms);
  // }


  Widget _buildResendOption() {
    return Obx(() => Column(
      children: [
        Text(
          controller.resendTimer.value > 0
              ? 'Resend code in ${controller.resendTimer.value}s'
              : "Didn't receive the code?",
          style: TextStyle(
            fontSize: 14.sp,
            color: ColorConstants.grey,
            fontFamily: AppFonts.poppins,
          ),
        ),
        if (controller.resendTimer.value == 0)
          GestureDetector(
            onTap: () {
              controller.resendEmailOtp();
            },
            child: Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                'Resend Code',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.appThemeColor,
                  fontFamily: AppFonts.poppins,
                ),
              ),
            ),
          ),
      ],
    )).animate().fadeIn(duration: 500.ms, delay: 400.ms);
  }

  Widget _buildErrorMessage() {
    return Obx(
      () => controller.errorMessage.value.isNotEmpty
          ? Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: ColorConstants.lightPink,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: ColorConstants.errorBorder, width: 1),
              ),
              child: Text(
                controller.errorMessage.value,
                style: TextStyle(
                  color: ColorConstants.error,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.poppins,
                ),
                textAlign: TextAlign.center,
              ),
            ).animate().fadeIn(duration: 300.ms)
          : const SizedBox.shrink(),
    );
  }

  Widget _buildVerifyButton() {
    return Obx(
      () => CustomButton(
        text: 'Verify',
        loading: controller.isLoading.value,
        variant: ButtonVariant.FillActive,
        shape: ButtonShape.RoundedBorder6,
        height: 52.h,
        onTap: controller.isLoading.value ? null : controller.verifyEmailOtp,
      ).animate().fadeIn(duration: 600.ms, delay: 500.ms),
    );
  }
}
