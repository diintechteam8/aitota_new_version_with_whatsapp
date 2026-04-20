import '../../../core/app-export.dart';
import '../login/controller/login_controller.dart';
import '../../../core/utils/widgets/app_widgets/custom_button.dart'
    show CustomButton, ButtonVariant, ButtonShape;

class ForgotPasswordEmailScreen extends GetView<LoginController> {
  const ForgotPasswordEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Forgot Password",
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
                _buildEmailField(),
                SizedBox(height: 40.h),
                _buildContinueButton(),
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
          'Forgot Password',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstants.colorHeading,
            fontFamily: AppFonts.poppins,
          ),
        ).animate().slideY(begin: 0.1, end: 0, duration: 500.ms),
        SizedBox(height: 12.h),
        Text(
          'Enter your email address to receive a\npassword reset code.',
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

  Widget _buildEmailField() {
    return CustomTextFormField(
      controller: controller.emailController,
      hintText: 'Email Address',
      labelText: 'Email Address',
      textInputType: TextInputType.emailAddress,
      validator: (v) => AppValidators.validateEmail(v),
      variant: TextFormFieldVariant.OutlineLightGrey,
      padding: TextFormFieldPadding.PaddingAll16,
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms);
  }

  Widget _buildContinueButton() {
    return Obx(
      () => CustomButton(
        text: 'Continue',
        loading: controller.isLoading.value,
        variant: ButtonVariant.FillActive,
        shape: ButtonShape.RoundedBorder6,
        height: 52.h,
        onTap: controller.isLoading.value
            ? null
            : () => controller.forgotPasswordRequest(),
      ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
    );
  }
}
