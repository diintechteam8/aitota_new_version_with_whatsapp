import 'package:aitota_business/views/auth_flow/register/controller/otp_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/app-export.dart';
import '../../../core/utils/widgets/app_widgets/custom_button.dart'
    show CustomButton, ButtonVariant, ButtonShape;

class MobileVerifyScreen extends GetView<OtpController> {
  const MobileVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Phone Verification",
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
                child: Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 5.h),
                        _buildHeader(),
                        SizedBox(height: 4.h),
                        controller.isMobileOtpSent.value
                            ? _buildOtpInputSection()
                            : _buildPhoneInputSection(),
                        SizedBox(height: 32.h),
                        _buildErrorMessage(),
                        SizedBox(height: 40.h),
                        _buildActionButton(),
                        SizedBox(height: 40.h),
                      ],
                    )),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    bool sent = controller.isMobileOtpSent.value;
    return Column(
      children: [
        Container(
          height: 80.h,
          width: 80.w,
          decoration: BoxDecoration(
            color: ColorConstants.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: ColorConstants.appThemeColor.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: ColorConstants.appThemeColor.withOpacity(0.05),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: Image.asset(
              ImageConstant.appLogo,
              fit: BoxFit.contain,
            ).paddingAll(16),
          ),
        )
            .animate(key: ValueKey('icon_$sent'))
            .scale(duration: 600.ms, curve: Curves.easeOutBack)
            .shimmer(delay: 800.ms, duration: 1500.ms),
        SizedBox(height: 24.h),
        Text(
          sent ? 'Verify OTP' : 'Phone Verification',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: ColorConstants.colorHeading,
            fontFamily: AppFonts.poppins,
            letterSpacing: -0.5,
          ),
        ).animate(key: ValueKey('title_$sent')).fadeIn().moveY(begin: 10, end: 0),
        SizedBox(height: 12.h),
        Text(
          sent
              ? 'We\'ve sent a verification code to\n+91 ${controller.mobileNumberController.text}'
              : 'Choose your preferred method to receive\nthe verification code',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: ColorConstants.grey,
            fontFamily: AppFonts.poppins,
            height: 1.5,
          ),
        )
            .animate(key: ValueKey('subtitle_$sent'))
            .fadeIn(delay: 200.ms)
            .moveY(begin: 10, end: 0),
      ],
    );
  }

  Widget _buildPhoneInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Mobile Number",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstants.colorHeading.withOpacity(0.7),
            fontFamily: AppFonts.poppins,
          ),
        ).paddingOnly(left: 4.w, bottom: 8.h),
        CustomTextFormField(
          controller: controller.mobileNumberController,
          hintText: '9876543210',
          textInputType: TextInputType.phone,
          variant: TextFormFieldVariant.OutlineLightGrey,
          padding: TextFormFieldPadding.PaddingAll16,
          prefixIcon: Container(
            margin: EdgeInsets.only(right: 8.w),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: ColorConstants.outlineStroke.withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '🇮🇳',
                  style: TextStyle(fontSize: 18.sp),
                ),
                SizedBox(width: 8.w),
                Text(
                  '+91',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.colorHeading,
                    fontFamily: AppFonts.poppins,
                  ),
                ),
              ],
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
        ).animate().fadeIn(duration: 500.ms),
        SizedBox(height: 32.h),
        Text(
          "Receive via",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstants.colorHeading.withOpacity(0.7),
            fontFamily: AppFonts.poppins,
          ),
        ).paddingOnly(left: 4.w, bottom: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildSelectionCard(
                title: "WhatsApp",
                icon: FontAwesomeIcons.whatsapp,
                method: "whatsapp",
                activeColor: const Color(0xFF25D366),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildSelectionCard(
                title: "SMS",
                icon: Icons.message_rounded,
                method: "sms",
                activeColor: ColorConstants.appThemeColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectionCard({
    required String title,
    required dynamic icon,
    required String method,
    required Color activeColor,
  }) {
    return Obx(() {
      bool isSelected = controller.selectedMethod.value == method;
      return GestureDetector(
        onTap: () => controller.setOtpMethod(method),
        child: AnimatedContainer(
          duration: 300.ms,
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withOpacity(0.05) : ColorConstants.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? activeColor : ColorConstants.outlineStroke.withOpacity(0.5),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeColor.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ]
                : [],
          ),
          child: Column(
            children: [
              icon is FaIconData
                  ? FaIcon(
                      icon,
                      size: 28.sp,
                      color: isSelected ? activeColor : ColorConstants.grey,
                    )
                  : Icon(
                      icon,
                      size: 28.sp,
                      color: isSelected ? activeColor : ColorConstants.grey,
                    ),
              SizedBox(height: 8.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? activeColor : ColorConstants.grey,
                  fontFamily: AppFonts.poppins,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

Widget _buildOtpInputSection() {
  return Column(
    children: [
      Row(
        children: List.generate(
          6,
          (index) => Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: CustomTextFormField(
                controller: controller.mobileOtpControllers[index],
                focusNode: controller.mobileOtpFocusNodes[index],
                textInputType: TextInputType.number,
                maxLength: 1,
                variant: TextFormFieldVariant.OutlineLightGrey,
                padding: TextFormFieldPadding.PaddingAll12,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    if (index < 5) {
                      controller.mobileOtpFocusNodes[index + 1].requestFocus();
                    } else {
                      controller.mobileOtpFocusNodes[index].unfocus();
                    }
                  } else {
                    if (index > 0) {
                      controller.mobileOtpFocusNodes[index - 1].requestFocus();
                    }
                  }
                },
              ),
            ),
          ),
        ),
      ).animate().fadeIn(duration: 500.ms),

      SizedBox(height: 24.h),

      _buildResendOption(),
    ],
  );
}

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
                  controller.startResendTimer();
                  controller.sendMobileOtp();
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    'Resend via ${controller.selectedMethod.value == 'whatsapp' ? 'WhatsApp' : 'SMS'}',
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
        )).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildErrorMessage() {
    return Obx(
      () => controller.errorMessage.value.isNotEmpty
          ? Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: ColorConstants.lightPink,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: ColorConstants.errorBorder.withOpacity(0.3), width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: ColorConstants.error, size: 20.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      controller.errorMessage.value,
                      style: TextStyle(
                        color: ColorConstants.error,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppFonts.poppins,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().shake(duration: 500.ms)
          : const SizedBox.shrink(),
    );
  }

  Widget _buildActionButton() {
    bool sent = controller.isMobileOtpSent.value;
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: ColorConstants.appThemeColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: CustomButton(
          text: sent ? 'Verify & Continue' : 'Send Verification Code',
          loading: controller.isLoading.value,
          variant: ButtonVariant.FillActive,
          shape: ButtonShape.RoundedBorder6,
          height: 54.h,
          onTap: controller.isLoading.value
              ? null
              : (sent ? controller.verifyMobileOtp : controller.sendMobileOtp),
        ),
      ).animate().fadeIn(duration: 800.ms),
    );
  }
}
