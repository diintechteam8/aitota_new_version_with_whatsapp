import 'package:aitota_business/routes/app_routes.dart';

import '../../../core/app-export.dart';
import '../../../core/utils/widgets/app_widgets/custom_button.dart'
    show CustomButton, ButtonVariant, ButtonShape;
import 'controller/register_controller.dart';

class CompleteProfileScreen extends GetView<RegisterController> {
  const CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: CustomAppBar(
        title: "Register",
        showBackButton: true,
        onTapBack: () => Get.offAllNamed(AppRoutes.loginScreen),
        titleStyle: TextStyle(
          fontSize: 16.sp,
          fontFamily: AppFonts.poppins,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(),
                  SizedBox(height: 16.h),
                  _buildFormFields(),
                  _buildErrorMessage(),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: _buildBottomNavigationBar(),
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
              ImageConstant.appLogo,
              height: 50.h,
              fit: BoxFit.fitHeight,
            ).paddingAll(12),
          ),
        ).animate().scale(duration: 700.ms, curve: Curves.easeOutQuad),
        SizedBox(height: 12.h),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Create Your Account',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: ColorConstants.colorHeading,
              fontFamily: AppFonts.poppins,
              letterSpacing: 0.4,
            ),
          ).animate().slideY(begin: 0.15, end: 0, duration: 600.ms),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        // Business Name - REQUIRED
        CustomTextFormField(
          controller: controller.businessNameController,
          hintText: 'Business Name',
          labelText: 'Business Name',
          textInputType: TextInputType.text,
          validator: (v) =>
              AppValidators.validateRequired(v, fieldName: 'Business Name'),
          margin: EdgeInsets.only(bottom: 16.h),
          variant: TextFormFieldVariant.OutlineLightGrey,
          padding: TextFormFieldPadding.PaddingAll16,
        ).animate().fadeIn(duration: 600.ms, delay: 300.ms),

        // Business Type - REQUIRED
        CustomTextFormField(
          controller: controller.businessTypeController,
          hintText: 'Business Type',
          labelText: 'Business Type',
          textInputType: TextInputType.none,
          validator: (v) =>
              AppValidators.validateRequired(v, fieldName: 'Business Type'),
          margin: EdgeInsets.only(bottom: 16.h),
          variant: TextFormFieldVariant.OutlineLightGrey,
          padding: TextFormFieldPadding.PaddingAll16,
          readOnly: true,
          onTap: () => controller.showBusinessTypeBottomSheet(),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Icon(Icons.arrow_drop_down,
                color: ColorConstants.grey, size: 24.sp),
          ),
          suffixIconConstraints:
              BoxConstraints(maxHeight: 24.h, maxWidth: 40.w),
        ).animate().fadeIn(duration: 600.ms, delay: 350.ms),

        // Contact Name - REQUIRED
        CustomTextFormField(
          controller: controller.contactNameController,
          hintText: 'Name',
          labelText: 'Name',
          textInputType: TextInputType.text,
          validator: (v) =>
              AppValidators.validateRequired(v, fieldName: 'Contact Name'),
          margin: EdgeInsets.only(bottom: 16.h),
          variant: TextFormFieldVariant.OutlineLightGrey,
          padding: TextFormFieldPadding.PaddingAll16,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z\s]'))
          ],
        ).animate().fadeIn(duration: 600.ms, delay: 400.ms),

        // Email Address - PRE-FILLED
        CustomTextFormField(
          controller: controller.emailController,
          hintText: 'Email Address',
          labelText: 'Email Address',
          textInputType: TextInputType.emailAddress,
          validator: AppValidators.validateEmail,
          margin: EdgeInsets.only(bottom: 16.h),
          variant: TextFormFieldVariant.OutlineLightGrey,
          padding: TextFormFieldPadding.PaddingAll16,
          readOnly: true,
        ).animate().fadeIn(duration: 600.ms, delay: 425.ms),

        // Contact Number - PRE-FILLED & VERIFIED
        CustomTextFormField(
          controller: controller.contactNumberController,
          hintText: 'Contact Number',
          labelText: 'Contact Number',
          textInputType: TextInputType.phone,
          validator: AppValidators.validateIndianPhone,
          margin: EdgeInsets.only(bottom: 16.h),
          variant: TextFormFieldVariant.OutlineLightGrey,
          padding: TextFormFieldPadding.PaddingAll16,
          readOnly: true,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
        ).animate().fadeIn(duration: 600.ms, delay: 450.ms),

        // Pin Code - REQUIRED + 6 digits
        CustomTextFormField(
          controller: controller.pinCodeController,
          hintText: 'Pin Code',
          labelText: 'Pin Code',
          textInputType: TextInputType.number,
          validator: AppValidators.validatePinCode,
          margin: EdgeInsets.only(bottom: 16.h),
          variant: TextFormFieldVariant.OutlineLightGrey,
          padding: TextFormFieldPadding.PaddingAll16,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
        ).animate().fadeIn(duration: 600.ms, delay: 500.ms),

        // State - REQUIRED
        CustomTextFormField(
          controller: controller.stateController,
          hintText: 'State',
          labelText: 'State',
          textInputType: TextInputType.none,
          validator: (v) =>
              AppValidators.validateRequired(v, fieldName: 'State'),
          margin: EdgeInsets.only(bottom: 16.h),
          variant: TextFormFieldVariant.OutlineLightGrey,
          padding: TextFormFieldPadding.PaddingAll16,
          readOnly: true,
          onTap: () => controller.showStateBottomSheet(),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Icon(Icons.arrow_drop_down,
                color: ColorConstants.grey, size: 24.sp),
          ),
          suffixIconConstraints:
              BoxConstraints(maxHeight: 24.h, maxWidth: 40.w),
        ).animate().fadeIn(duration: 600.ms, delay: 550.ms),

        // City - REQUIRED
        CustomTextFormField(
          controller: controller.cityController,
          hintText: 'City',
          labelText: 'City',
          textInputType: TextInputType.text,
          validator: (v) =>
              AppValidators.validateRequired(v, fieldName: 'City'),
          margin: EdgeInsets.only(bottom: 16.h),
          variant: TextFormFieldVariant.OutlineLightGrey,
          padding: TextFormFieldPadding.PaddingAll16,
        ).animate().fadeIn(duration: 600.ms, delay: 600.ms),

        // Website - OPTIONAL, but valid if entered
        CustomTextFormField(
          controller: controller.websiteController,
          hintText: 'Website',
          labelText: 'Website',
          textInputType: TextInputType.url,
          validator: AppValidators.validateWebsiteOptional,
          margin: EdgeInsets.only(bottom: 16.h),
          variant: TextFormFieldVariant.OutlineLightGrey,
          padding: TextFormFieldPadding.PaddingAll16,
        ).animate().fadeIn(duration: 600.ms, delay: 650.ms),

        // PAN Card - OPTIONAL, but valid if entered
        CustomTextFormField(
          controller: controller.panCardController,
          hintText: 'PAN Card',
          labelText: 'PAN Card',
          textInputType: TextInputType.text,
          validator: AppValidators.validatePanOptional,
          margin: EdgeInsets.only(bottom: 16.h),
          variant: TextFormFieldVariant.OutlineLightGrey,
          padding: TextFormFieldPadding.PaddingAll16,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
            LengthLimitingTextInputFormatter(10),
          ],
        ).animate().fadeIn(duration: 600.ms, delay: 700.ms),

        // GST Number - OPTIONAL, valid if entered
        CustomTextFormField(
          controller: controller.gstController,
          hintText: 'GST Number (Optional)',
          labelText: 'GST Number (Optional)',
          textInputType: TextInputType.text,
          // validator: AppValidators.validateGstOptional,
          margin: EdgeInsets.only(bottom: 16.h),
          variant: TextFormFieldVariant.OutlineLightGrey,
          padding: TextFormFieldPadding.PaddingAll16,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
            LengthLimitingTextInputFormatter(15),
          ],
        ).animate().fadeIn(duration: 600.ms, delay: 750.ms),

        // Annual Turnover - REQUIRED
        CustomTextFormField(
          controller: controller.annualTurnoverController,
          hintText: 'Annual Turnover',
          labelText: 'Annual Turnover',
          textInputType: TextInputType.none,
          validator: (v) =>
              AppValidators.validateRequired(v, fieldName: 'Annual Turnover'),
          margin: EdgeInsets.only(bottom: 24.h),
          variant: TextFormFieldVariant.OutlineLightGrey,
          padding: TextFormFieldPadding.PaddingAll16,
          readOnly: true,
          onTap: () => controller.showAnnualTurnoverBottomSheet(),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Icon(Icons.arrow_drop_down,
                color: ColorConstants.grey, size: 24.sp),
          ),
          suffixIconConstraints:
              BoxConstraints(maxHeight: 24.h, maxWidth: 40.w),
        ).animate().fadeIn(duration: 600.ms, delay: 800.ms),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Obx(
      () => controller.errorMessage.value.isNotEmpty
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: ColorConstants.lightPink,
                borderRadius: BorderRadius.circular(6.r),
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
            ).animate().fadeIn(duration: 400.ms)
          : const SizedBox.shrink(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 52.h,
          decoration: BoxDecoration(
            gradient: controller.isLoading.value
                ? null
                : const LinearGradient(
                    colors: [
                      ColorConstants.appThemeColor,
                      ColorConstants.appThemeColor
                    ],
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
          child: CustomButton(
            variant: controller.isLoading.value
                ? ButtonVariant.FillUnctive
                : ButtonVariant.FillActive,
            shape: ButtonShape.RoundedBorder6,
            height: 55.h,
            text: controller.isLoading.value ? '' : 'Register',
            onTap: controller.isLoading.value ? null : controller.onSubmit,
            loading: controller.isLoading.value,
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 700.ms),
      ),
    );
  }
}
