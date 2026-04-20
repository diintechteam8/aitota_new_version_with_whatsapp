import 'package:aitota_business/views/auth_flow/login/controller/login_controller.dart';
import '../../../core/app-export.dart';
import '../../../core/utils/widgets/app_widgets/custom_button.dart'
    show CustomButton, ButtonVariant, ButtonShape;
import 'package:url_launcher/url_launcher.dart';

class AuthMethodeScreen extends GetView<LoginController> {
  const AuthMethodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.homeBackgroundColor,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 60.h),
                        _buildHeader(),
                        SizedBox(height: 40.h),
                        _buildGoogleSignIn().animate().fadeIn(duration: 600.ms, delay: 400.ms),
                        SizedBox(height: 12.h),
                        _buildEmailAuthSection().animate().fadeIn(duration: 600.ms, delay: 600.ms),
                        SizedBox(height: 20.h),
                        _buildErrorMessage(),
                        SizedBox(height: 28.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            bottom: 16.h,
            left: 24.w,
            right: 24.w,
            top: 4.h,
          ),
          child: _buildFooter(),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          height: 100.h,
          width: 100.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: ColorConstants.appThemeColor.withAlpha(20),
              width: 2.5.h,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: Image.asset(
              height: 50.h,
              ImageConstant.appLogo,
              fit: BoxFit.fitHeight,
            ).paddingAll(12),
          ),
        ).animate().scale(duration: 700.ms, curve: Curves.easeOutQuad),
        SizedBox(height: 20.h),
        Text(
          'Welcome',
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.w500,
            color: ColorConstants.colorHeading,
            fontFamily: AppFonts.poppins,
            letterSpacing: 0.4,
          ),
        ).animate().slideY(begin: 0.15, end: 0, duration: 600.ms),
        SizedBox(height: 10.h),
        Text(
          'Sign in with Google to continue',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: ColorConstants.grey,
            fontFamily: AppFonts.poppins,
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
      ],
    );
  }

  Widget _buildGoogleSignIn() {
    return Obx(
          () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          color: controller.isLoading.value
              ? ColorConstants.grey.withOpacity(0.5)
              : null,
          gradient: controller.isLoading.value
              ? null
              : const LinearGradient(
            colors: [ColorConstants.appThemeColor, ColorConstants.appThemeColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: ColorConstants.appThemeColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: controller.isLoading.value
            ? const Center(
          child: CircularProgressIndicator(
            color: ColorConstants.white,
            strokeWidth: 2,
          ),
        )
            : CustomButton(
          variant: controller.isLoading.value
              ? ButtonVariant.FillUnctive
              : ButtonVariant.FillActive,
          shape: ButtonShape.RoundedBorder6,
          height: 52.h,
          text: 'Sign in with Google',
          onTap: controller.signInWithGoogle,
          prefixWidget: Image.asset(
            'assets/images/google.png',
            height: 22.h,
            width: 22.w,
          ),
        ),
      ),
    );
  }

  Widget _buildEmailAuthSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: ColorConstants.grey.withOpacity(0.2))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'OR',
                style: TextStyle(
                  color: ColorConstants.grey.withOpacity(0.6),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.poppins,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Expanded(child: Divider(color: ColorConstants.grey.withOpacity(0.2))),
          ],
        ),
        SizedBox(height: 24.h),
        CustomButton(
          text: 'Login/Signup with Email',
          variant: ButtonVariant.OutlineOnlyBorder,
          shape: ButtonShape.RoundedBorder6,
          height: 52.h,
          onTap: controller.navigateToEmailLogin,
        ),
        SizedBox(height: 16.h),
        _buildSignupOption(),
      ],
    );
  }

  Widget _buildSignupOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            fontSize: 14.sp,
            color: ColorConstants.grey,
            fontFamily: AppFonts.poppins,
          ),
        ),
        GestureDetector(
          onTap: controller.navigateToRegister,
          child: Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: ColorConstants.appThemeColor,
              fontFamily: AppFonts.poppins,
              // decoration: TextDecorat  ion.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Obx(
          () => controller.errorMessage.value.isNotEmpty
          ? Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: ColorConstants.lightPink,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: ColorConstants.errorBorder,
            width: 1,
          ),
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
      ).animate().fadeIn(duration: 400.ms)
          : const SizedBox.shrink(),
    );
  }

  Widget _buildFooter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'By continuing, you agree to our',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: ColorConstants.grey,
            fontFamily: AppFonts.poppins,
          ),
        ),
        Text.rich(
          TextSpan(
            text: 'Terms of Service',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: ColorConstants.appThemeColor,
              fontFamily: AppFonts.poppins,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final Uri url = Uri.parse('https://www.freeprivacypolicy.com/live/61d80502-cadf-40e0-bd63-3b2959fd3ecd');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  Get.snackbar('Error', 'Could not launch URL');
                }
              },
            children: [
              TextSpan(
                text: ' and ',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorConstants.grey,
                  fontFamily: AppFonts.poppins,
                ),
              ),
              TextSpan(
                text: 'Privacy Policy',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.appThemeColor,
                  fontFamily: AppFonts.poppins,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    final Uri url = Uri.parse('https://www.freeprivacypolicy.com/live/61d80502-cadf-40e0-bd63-3b2959fd3ecd');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } else {
                      Get.snackbar('Error', 'Could not launch URL');
                    }
                  },
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 500.ms);
  }
}