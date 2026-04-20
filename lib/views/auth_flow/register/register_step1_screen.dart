import 'package:aitota_business/views/auth_flow/register/controller/register_step1_controller.dart';
import '../../../core/app-export.dart';
import '../../../core/utils/widgets/app_widgets/custom_button.dart'
    show CustomButton, ButtonVariant, ButtonShape;

class RegisterStep1Screen extends GetView<RegisterStep1Controller> {
  const RegisterStep1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Create Account",
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
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 40.h),
                          _buildHeader(),
                          SizedBox(height: 40.h),
                          _buildFormFields(),
                          SizedBox(height: 20.h),
                          _buildErrorMessage(),
                          const Spacer(),
                          _buildRegisterButton(),
                          SizedBox(height: 24.h),
                          _buildLoginOption(),
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
          'Sign Up',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstants.colorHeading,
            fontFamily: AppFonts.poppins,
          ),
        ).animate().slideY(begin: 0.1, end: 0, duration: 500.ms),
        SizedBox(height: 8.h),
        Text(
          'Join us today and start your journey',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: ColorConstants.grey,
            fontFamily: AppFonts.poppins,
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
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
        ).animate().fadeIn(duration: 500.ms, delay: 300.ms),
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
        )).animate().fadeIn(duration: 500.ms, delay: 400.ms),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Obx(
      () {
        if (controller.errorMessage.value.isNotEmpty) {
          debugPrint("RegisterStep1 Error: ${controller.errorMessage.value}");
          return Container(
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
          ).animate().fadeIn(duration: 300.ms);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildRegisterButton() {
    return Obx(
      () => CustomButton(
        text: 'Send OTP',
        loading: controller.isLoading.value,
        variant: ButtonVariant.FillActive,
        shape: ButtonShape.RoundedBorder6,
        height: 52.h,
        onTap: controller.isLoading.value ? null : controller.registerStep1,
      ).animate().fadeIn(duration: 600.ms, delay: 500.ms),
    );
  }

  Widget _buildLoginOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(
            fontSize: 14.sp,
            color: ColorConstants.grey,
            fontFamily: AppFonts.poppins,
          ),
        ),
        GestureDetector(
          onTap: () => Get.back(),
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: ColorConstants.appThemeColor,
              fontFamily: AppFonts.poppins,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 600.ms);
  }
}
