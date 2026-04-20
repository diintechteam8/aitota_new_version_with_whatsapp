import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/app-export.dart';
import '../../../core/utils/widgets/app_widgets/custom_button.dart'
    show CustomButton, ButtonVariant, ButtonShape;
import 'controller/pending_approval_controller.dart';

class ApprovalPendingScreen extends GetView<ApprovalPendingController> {
  const ApprovalPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: CustomAppBar(
        title: "Registration Submitted",
        showBackButton: true,
        onTapBack: controller.onBackToHome,
        titleStyle: TextStyle(
          fontSize: 16.sp,
          fontFamily: AppFonts.poppins,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: SafeArea(
        top: false,
        child: Obx(() {
          if (controller.isLoading.value &&
              controller.pendingApproval.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.pendingApproval.value == null) {
            return Center(
              child: Text(
                'Checking approval status...',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ColorConstants.grey,
                  fontFamily: AppFonts.poppins,
                ),
              ),
            );
          }

          final pendingData = controller.pendingApproval.value!;
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(pendingData.data?.businessLogoUrl),
                  SizedBox(height: 24.h),
                  _buildMessage(pendingData.data?.name),
                  SizedBox(height: 16.h),
                  _buildSupportButton(),
                  SizedBox(height: 32.h),
                  _buildReachOutButton(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader(String? businessLogoUrl) {
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
            child: businessLogoUrl != null && businessLogoUrl.isNotEmpty
                ? Image.network(
                    businessLogoUrl,
                    height: 50.h,
                    fit: BoxFit.fitHeight,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      ImageConstant.appLogo,
                      height: 50.h,
                      fit: BoxFit.fitHeight,
                    ),
                  ).paddingAll(12)
                : Image.asset(
                    ImageConstant.appLogo,
                    height: 50.h,
                    fit: BoxFit.fitHeight,
                  ).paddingAll(12),
          ),
        ).animate().scale(duration: 700.ms, curve: Curves.easeOutQuad),
        SizedBox(height: 12.h),
        Icon(
          Icons.hourglass_empty,
          size: 48.sp,
          color: ColorConstants.appThemeColor,
        ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
      ],
    );
  }

  Widget _buildMessage(String? userName) {
    return Obx(() => Text(
          userName != null
              ? controller.isLoading.value
                  ? 'Hello $userName, checking approval status...'
                  : 'Hello $userName, your registration is under review. We’ll notify you once approved.'
              : controller.isLoading.value
                  ? 'Checking approval status...'
                  : 'Your registration is under review. We’ll notify you once approved.',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: ColorConstants.colorHeading,
            fontFamily: AppFonts.poppins,
            letterSpacing: 0.4,
          ),
          textAlign: TextAlign.center,
        )).animate().fadeIn(duration: 600.ms, delay: 300.ms);
  }

  Widget _buildSupportButton() {
    return CustomButton(
      variant: ButtonVariant.OutlineOnlyBorder,
      shape: ButtonShape.RoundedBorder6,
      height: 40.h,
      width: 200.w,
      text: 'Contact Support',
      onTap: () async {
        try {
          final Uri emailUri = Uri(
            scheme: 'mailto',
            path: 'aitototeam@gmail.com',
            queryParameters: {
              'subject': 'Support Request',
              'body': 'Please describe your issue or question:'
            },
          );
          if (await canLaunchUrl(emailUri)) {
            await launchUrl(emailUri, mode: LaunchMode.externalApplication);
            return;
          }

          final Uri gmailWebUri = Uri.parse(
            'https://mail.google.com/mail/?view=cm&fs=1&to=aitototeam@gmail.com&su=Support+Request&body=',
          );
          if (await canLaunchUrl(gmailWebUri)) {
            await launchUrl(gmailWebUri, mode: LaunchMode.externalApplication);
          }
        } catch (e) {
          rethrow;
        }
      },
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }

  Widget _buildReachOutButton() {
    return CustomButton(
      variant: ButtonVariant.FillActive,
      shape: ButtonShape.RoundedBorder6,
      height: 55.h,
      text: 'Reach out for help',
      prefixWidget: Padding(
        padding: EdgeInsets.only(left: 40.w),
        child: SvgPicture.asset(
          ImageConstant.whatsappIcon,
          height: 24.h,
          width: 24.w,
        ),
      ),
      onTap: () async {
        try {
          final Uri whatsappUri = Uri.parse(
            'whatsapp://send?phone=918147540362&text=Hello, I need help with my registration approval status.',
          );
          if (await canLaunchUrl(whatsappUri)) {
            await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
            return;
          }

          final Uri waWebUri = Uri.parse(
            'https://wa.me/918147540362?text=Hello, I need help with my registration approval status.',
          );
          if (await canLaunchUrl(waWebUri)) {
            await launchUrl(waWebUri, mode: LaunchMode.externalApplication);
          }
        } catch (e) {
          rethrow;
        }
      },
    ).animate().fadeIn(duration: 600.ms, delay: 500.ms);
  }
}
