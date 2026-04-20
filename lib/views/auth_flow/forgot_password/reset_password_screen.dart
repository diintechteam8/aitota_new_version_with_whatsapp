import '../../../core/app-export.dart';
import '../../../core/utils/widgets/app_widgets/custom_button.dart'
    show CustomButton, ButtonVariant, ButtonShape;
import 'controller/reset_password_controller.dart';

class ResetPasswordScreen extends GetView<ResetPasswordController> {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Reset Password",
        showBackButton: true,
        onTapBack: () => Get.back(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                _buildHeader(),
                SizedBox(height: 48.h),
                _buildPasswordFields(),
                SizedBox(height: 40.h),
                _buildResetButton(),
              ],
            ),
          ),
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
          'Reset Password',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstants.colorHeading,
            fontFamily: AppFonts.poppins,
          ),
        ).animate().slideY(begin: 0.1, end: 0, duration: 500.ms),
        SizedBox(height: 12.h),
        Text(
          'Create a new password that is secure\nand easy to remember.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: ColorConstants.grey,
            fontFamily: AppFonts.poppins,
            height: 1.5,
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
      ],
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      children: [
        Obx(
          () => CustomTextFormField(
            controller: controller.newPasswordController,
            hintText: 'New Password',
            labelText: 'New Password',
            textInputType: TextInputType.visiblePassword,
            isObscureText: !controller.isPasswordVisible.value,
            suffixIcon: IconButton(
              icon: Icon(
                controller.isPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: ColorConstants.grey,
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
            variant: TextFormFieldVariant.OutlineLightGrey,
            padding: TextFormFieldPadding.PaddingAll16,
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 300.ms),
        SizedBox(height: 20.h),
        Obx(
          () => CustomTextFormField(
            controller: controller.confirmPasswordController,
            hintText: 'Confirm Password',
            labelText: 'Confirm Password',
            textInputType: TextInputType.visiblePassword,
            isObscureText: !controller.isConfirmPasswordVisible.value,
            suffixIcon: IconButton(
              icon: Icon(
                controller.isConfirmPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: ColorConstants.grey,
              ),
              onPressed: controller.toggleConfirmPasswordVisibility,
            ),
            variant: TextFormFieldVariant.OutlineLightGrey,
            padding: TextFormFieldPadding.PaddingAll16,
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 400.ms),
      ],
    );
  }

  Widget _buildResetButton() {
    return Obx(
      () => CustomButton(
        text: 'Reset Password',
        loading: controller.isLoading.value,
        variant: ButtonVariant.FillActive,
        shape: ButtonShape.RoundedBorder6,
        height: 52.h,
        onTap: controller.isLoading.value ? null : () => controller.resetPassword(),
      ).animate().fadeIn(duration: 600.ms, delay: 500.ms),
    );
  }
}
