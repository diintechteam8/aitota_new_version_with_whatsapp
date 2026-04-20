import 'package:aitota_business/views/auth_flow/login/controller/login_controller.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/app-export.dart';
import '../../../core/utils/widgets/app_widgets/custom_button.dart'
    show CustomButton, ButtonVariant, ButtonShape;

class EmailLoginScreen extends GetView<LoginController> {
  const EmailLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Login with Email",
        showBackButton: true,
        onTapBack: () => Get.back(),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    child: Form(
                      key: controller.emailLoginFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 40.h),
                          _buildHeader(),
                          SizedBox(height: 40.h),
                          _buildFormFields(),
                          SizedBox(height: 20.h),
                          _buildLoginButton(),
                          SizedBox(height: 24.h),
                          _buildSignupOption(),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
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
        SizedBox(height: 16.h),
        Text(
          'Email Login',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstants.colorHeading,
            fontFamily: AppFonts.poppins,
          ),
        ).animate().slideY(begin: 0.1, end: 0, duration: 500.ms),
      ],
    );
  }



  Widget _buildFormFields() {
    return Column(
      children: [
        CustomTextFormField(
          controller: controller.emailController,
          hintText: 'Email Address',
          labelText: 'Email Address',
          textInputType: TextInputType.emailAddress,
          validator: (v) => AppValidators.validateEmail(v),
          variant: TextFormFieldVariant.OutlineLightGrey,
          padding: TextFormFieldPadding.PaddingAll16,
        ).animate().fadeIn(duration: 500.ms, delay: 100.ms),
        SizedBox(height: 16.h),
        Obx(() => CustomTextFormField(
          controller: controller.passwordController,
          hintText: 'Password',
          labelText: 'Password',
          textInputType: TextInputType.visiblePassword,
          isObscureText: !controller.isPasswordVisible.value,
          // validator: AppValidators.validatePasswordComplexity,
          variant: TextFormFieldVariant.OutlineLightGrey,
          padding: TextFormFieldPadding.PaddingAll16,
          suffixIcon: IconButton(
            icon: Icon(
              controller.isPasswordVisible.value
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: ColorConstants.grey,
              size: 20.sp,
            ),
            onPressed: controller.togglePasswordVisibility,
          ),
        )).animate().fadeIn(duration: 500.ms, delay: 200.ms),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: controller.onForgotPassword,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: ColorConstants.appThemeColor,
                fontFamily: AppFonts.poppins,
              ),
            ),
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 300.ms),
      ],
    );
  }




  Widget _buildLoginButton() {
    return Obx(
      () => controller.isLoading.value
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 52.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            )
          : CustomButton(
              text: 'Login',
              loading: false,
              variant: ButtonVariant.FillActive,
              shape: ButtonShape.RoundedBorder6,
              height: 52.h,
              onTap: controller.loginWithEmail,
            ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
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
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }
}
