import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/inbound/grid_flow/setting/grid_flow/ai_agent/detail/controller/inbound_ai_agent_detail_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:aitota_business/core/utils/snack_bar.dart';

class InboundAiAgentDetailScreen extends GetView<InboundAiAgentDetailController> {
  const InboundAiAgentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Details",
        showBackButton: true,
        onTapBack: () => Get.back(),
        titleStyle: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.poppins,
          color: ColorConstants.white,
        ),
      ),
      body: Obx(
            () => controller.isLoading.value
            ? _buildShimmerLoading()
            : controller.errorMessage.value.isNotEmpty
            ? _buildErrorState()
            : controller.agentData.value == null
            ? _buildEmptyState()
            : Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAgentInfoCard(),
                    SizedBox(height: 16.h),
                    _buildGreetingsCard(),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 80.h, top: 8.h),
              child: _buildAvatarRow(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        children: [
          Container(
            height: 120.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            height: 80.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 40.sp),
          SizedBox(height: 8.h),
          Text(
            controller.errorMessage.value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.poppins,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: Colors.grey, size: 40.sp),
          SizedBox(height: 8.h),
          Text(
            'No Agent Available',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.poppins,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please check back later or refresh.',
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: AppFonts.poppins,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentInfoCard() {
    final agent = controller.agentData.value;
    final isInbound = agent?.callingType != null &&
        (agent!.callingType!.toLowerCase().contains('inbound') || agent.callingType!.toLowerCase() == 'both');
    final isOutbound = agent?.callingType != null &&
        (agent!.callingType!.toLowerCase().contains('outbound') || agent.callingType!.toLowerCase() == 'both');

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(20),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                            fontFamily: AppFonts.poppins,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          agent?.agentName ?? 'N/A',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.poppins,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Language',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                            fontFamily: AppFonts.poppins,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.language,
                              color: ColorConstants.appThemeColor,
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.w),
                            Flexible(
                              child: Text(
                                agent?.language ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: AppFonts.poppins,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                            fontFamily: AppFonts.poppins,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          agent?.category ?? 'N/A',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: AppFonts.poppins,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personality',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                            fontFamily: AppFonts.poppins,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          agent?.personality ?? 'N/A',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: AppFonts.poppins,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isInbound || isOutbound)
            Positioned(
              top: 0,
              right: 0,
              child: Row(
                children: [
                  if (isInbound)
                    Padding(
                      padding: EdgeInsets.only(right: isInbound && isOutbound ? 6.w : 0),
                      child: Icon(
                        Icons.call_received,
                        size: 16.sp,
                        color: Colors.green,
                      ),
                    ),
                  if (isOutbound)
                    Icon(
                      Icons.call_made,
                      size: 16.sp,
                      color: Colors.red,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGreetingsCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: ColorConstants.appThemeColor,
                    size: 15.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Greetings',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.poppins,
                      color: ColorConstants.grey,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _showEditGreetingDialog(Get.context!),
                child: Icon(
                  Icons.more_vert,
                  color: ColorConstants.grey,
                  size: 20.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Divider(color: Colors.grey[200], thickness: 1.w),
          SizedBox(height: 8.h),
          Text(
            controller.agentData.value?.firstMessage ?? 'N/A',
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: AppFonts.poppins,
              color: Colors.black87,
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarRow() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Connect with ${controller.agentData.value?.agentName ?? 'Agent'}',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.poppins,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAvatarButton(
              icon: Icons.settings_voice,
              label: 'Talk',
              onTap: () async {
                final status = await Permission.microphone.request();
                if (status.isGranted) {
                  _showMicDialog(Get.context!);
                } else {
                  customSnackBar(
                    message: "Microphone access is required to use this feature",
                    type: "E",
                  );
                }
              },
            ),
            SizedBox(width: 16.w),
            _buildAvatarButton(
              icon: Icons.chat,
              label: 'Chat',
              onTap: () {
                // Implement chat functionality here
              },
            ),
            SizedBox(width: 16.w),
            _buildAvatarButton(
              icon: Icons.call_received,
              label: 'Inbound',
              onTap: () {
                _showInboundCallDialog(Get.context!);
              },
            ),
          ],
        ),
      ],
    );
  }

  void _showInboundCallDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Make a Call',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.poppins,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16.h),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    controller.makePhoneCall();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.appThemeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  ),
                  child: Text(
                    'Call with Agent',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: AppFonts.poppins,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50.r),
          splashColor: ColorConstants.appThemeColor.withOpacity(0.3),
          child: Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey[100]!],
              ),
              border: Border.all(color: Colors.grey[200]!, width: 1.5.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: ColorConstants.appThemeColor, size: 32.sp),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: AppFonts.poppins,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  void _showMicDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 30.sp,
                color: ColorConstants.appThemeColor,
              ),
              SizedBox(height: 8.h),
              Text(
                controller.agentData.value?.firstMessage ??
                    'No greeting available.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: AppFonts.poppins,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20.h),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(50.r),
                child: Container(
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey[100]!],
                    ),
                    border: Border.all(color: Colors.grey[300]!, width: 1.5.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.mic_none_rounded,
                    size: 36.sp,
                    color: ColorConstants.appThemeColor,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Tap to Speak",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: AppFonts.poppins,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditGreetingDialog(BuildContext context) {
    controller.firstMessageController.text =
        controller.agentData.value?.firstMessage ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.textFieldFocusNode.requestFocus();
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Greeting',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.poppins,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: controller.firstMessageController,
                focusNode: controller.textFieldFocusNode,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  hintText: 'Enter greeting message',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: AppFonts.poppins,
                    color: Colors.grey[500],
                  ),
                ),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: AppFonts.poppins,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: AppFonts.poppins,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  ElevatedButton(
                    onPressed: () {
                      controller.saveGreeting();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.appThemeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: AppFonts.poppins,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}