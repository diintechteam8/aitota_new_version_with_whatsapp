import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/setting/grid_flow/ai_agent/detail_screen/controller/outbound_ai_agnt_detail_controller.dart';
import 'package:aitota_business/views/voice_screens/voice_screen/controller.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../../core/utils/snack_bar.dart';
import '../../../../../../../routes/app_routes.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class OutboundAiAgentDetailScreen extends GetView<OutboundAiAgentDetailController> {
  const OutboundAiAgentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Details",
        showBackButton: true,
        onTapBack: () => Get.back(),
        titleStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.poppins,
          color: ColorConstants.white
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: ColorConstants.white),
            onPressed: () => Get.toNamed(AppRoutes.callHistoryScreen, arguments: controller.agentData.value),
            tooltip: 'Call History',
          ),
        ],
      ),
      body: Obx(
            () => RefreshIndicator(
          onRefresh: controller.refreshAgentData,
          color: ColorConstants.appThemeColor,
          child: controller.isLoading.value
              ? _buildShimmerLoading()
              : controller.errorMessage.value.isNotEmpty
              ? _buildErrorState()
              : Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAgentInfoCard(),
                      SizedBox(height: 16.h),
                      _buildGreetingsCard(),
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
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: controller.refreshAgentData,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstants.appThemeColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Retry',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: AppFonts.poppins,
                color: Colors.white,
              ),
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
                final status = await Permission.camera.request();
                if (!status.isGranted) {
                  customSnackBar(
                    message: "Camera access is required to scan the agent QR",
                    type: "E",
                  );
                  return;
                }
                final vc = _ensureVoiceController();
                vc.isChatMode.value = false;
                vc.onAgentConnected = () => _showTalkBottomSheet(vc);
                _showScannerDialogForAgent(Get.context!, (agentId) {
                  vc.connectToWebSocket(agentId);
                });
              },
            ),
            SizedBox(width: 16.w),
            _buildAvatarButton(
              icon: Icons.chat,
              label: 'Chat',
              onTap: () async {
                final status = await Permission.camera.request();
                if (!status.isGranted) {
                  customSnackBar(
                    message: "Camera access is required to scan the agent QR",
                    type: "E",
                  );
                  return;
                }
                final vc = _ensureVoiceController();
                vc.isChatMode.value = true;
                vc.onAgentConnected = () => _showChatBottomSheet(vc);
                _showScannerDialogForAgent(Get.context!, (agentId) {
                  vc.connectToWebSocket(agentId);
                });
              },
            ),
            SizedBox(width: 16.w),
            _buildAvatarButton(
              icon: Icons.call_made,
              label: 'Outbound',
              onTap: () {
                _showCallOptionsDialog(Get.context!);
              },
            ),
          ],
        ),
      ],
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

  void _showCallOptionsDialog(BuildContext context) {
    controller.phoneNumberController.clear();
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
              TextField(
                controller: controller.phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  hintText: 'Enter phone number',
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
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final phoneNumber = controller.phoneNumberController.text.trim();
                      if (phoneNumber.isEmpty) {
                        customSnackBar(message: "Please enter a phone number", type: "E");
                        return;
                      }
                      Get.back(); // Close the dialog
                      await controller.initiateClickToBotCall(phoneNumber);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.appThemeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    ),
                    child: Text(
                      'Call',
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

  VoiceController _ensureVoiceController() {
    if (Get.isRegistered<VoiceController>()) {
      final vc = Get.find<VoiceController>();
      // Ensure speech is initialized
      vc.initializeSpeech();
      return vc;
    }
    final vc = Get.put(VoiceController(initialChatMode: false, isRagChatAvailable: true));
    vc.initializeSpeech();
    return vc;
  }

  void _showScannerDialogForAgent(BuildContext context, void Function(String agentId) onScanned) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: Get.width * 0.9,
            height: Get.height * 0.75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 10,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.indigo.shade600,
                        Colors.purple.shade700,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: const Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Scan Agent QR Code',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: AppFonts.poppins,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Point camera at agent QR code to connect',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                                fontFamily: AppFonts.poppins,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 20),
                          onPressed: () => Navigator.of(ctx).pop(),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.indigo.shade200,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(17),
                      child: MobileScanner(
                        onDetect: (capture) {
                          final List<Barcode> barcodes = capture.barcodes;
                          for (final barcode in barcodes) {
                            final String? code = barcode.rawValue;
                            if (code != null && code.isNotEmpty) {
                              Navigator.of(ctx).pop();
                              final agentId = _extractAgentIdFromCode(code);
                              onScanned(agentId);
                              return;
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.indigo.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Position QR code within the frame',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.indigo.shade600,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.poppins,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _extractAgentIdFromCode(String code) {
    String agentId = code;

    if (code.startsWith('{') && code.endsWith('}')) {
      try {
        final Map<String, dynamic> jsonData = jsonDecode(code);
        agentId = jsonData['agentId'] ?? code;
      } catch (_) {
        agentId = code;
      }
    }

    if (code.contains('aitota.com/agent/')) {
      try {
        final uri = Uri.parse(code);
        final pathSegments = uri.pathSegments;
        if (pathSegments.length >= 2 && pathSegments[0] == 'agent') {
          agentId = pathSegments[1];
        }
      } catch (_) {
        agentId = code;
      }
    }

    return agentId;
  }

  void _showTalkBottomSheet(VoiceController vc) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return Container(
          height: Get.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 30,
                spreadRadius: 5,
                offset: Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                      ),
                      child: const Icon(
                        Icons.support_agent,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(() => Text(
                        vc.currentAgentName.value.isNotEmpty
                            ? vc.currentAgentName.value
                            : 'Connecting...',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: AppFonts.poppins,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 20),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.5),
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 20,
                                title: Text(
                                  'End Agent Session',
                                  style: TextStyle(
                                    fontFamily: AppFonts.poppins,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.indigo.shade800,
                                  ),
                                ),
                                content: Text(
                                  'Are you sure you want to end the agent session?',
                                  style: TextStyle(
                                    fontFamily: AppFonts.poppins,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontFamily: AppFonts.poppins,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.red.shade500,
                                          Colors.red.shade600,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        vc.stopAgentSession();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'End Session',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: AppFonts.poppins,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
              // Messages
              Expanded(
                child: Obx(() {
                  final messages = vc.agentMessages;
                  final List<Widget> chatBubbles = [];

                  // Add agent messages (no static greeting)
                  for (final message in messages) {
                    final isUser = message['sender'] == 'user';
                    String messageText = message['message'] ?? '';
                    if (!isUser && messageText.contains('**')) {
                      messageText = messageText.replaceAll(RegExp(r'^\*\*[^*]+\*\*:\s*'), '');
                    }
                    chatBubbles.add(
                      MessageBubble(
                        message: messageText,
                        isUser: isUser,
                        theme: Theme.of(context),
                      ),
                    );
                  }

                  // Show thinking animation
                  if (vc.isAgentProcessing.value) {
                    chatBubbles.add(
                      Container(
                        margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.indigo.shade200),
                        ),
                        child: Row(
                          children: [
                            SpinKitSpinningLines(
                              color: Colors.indigo.shade600,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Agent is thinking...',
                              style: TextStyle(
                                color: Colors.indigo.shade700,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppFonts.poppins,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView(
                    controller: vc.scrollController,
                    padding: const EdgeInsets.all(16),
                    children: chatBubbles,
                  );
                }),
              ),
              // Microphone Input
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Obx(() {
                  final isListening = vc.isAgentListening.value;
                  final isProcessing = vc.isAgentProcessing.value;

                  return Center(
                    child: Transform.translate(
                      offset: const Offset(0, -15),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        width: isListening ? 120 : 80,
                        height: isListening ? 120 : 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isListening
                                ? [
                              Colors.indigo.shade400,
                              Colors.purple.shade600,
                              Colors.indigo.shade700,
                            ]
                                : [
                              Colors.indigo.shade500,
                              Colors.purple.shade600,
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: isListening
                                  ? Colors.indigo.withOpacity(0.4)
                                  : Colors.indigo.withOpacity(0.3),
                              blurRadius: isListening ? 30 : 20,
                              spreadRadius: isListening ? 6 : 4,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(isListening ? 60 : 40),
                            onTap: isProcessing
                                ? null
                                : () async {
                              final status = await Permission.microphone.request();
                              if (!status.isGranted) {
                                customSnackBar(
                                  message: "Microphone access is required for voice interaction",
                                  type: "E",
                                );
                                return;
                              }
                              vc.toggleAgentListening();
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (isListening)
                                  Container(
                                    width: isListening ? 140 : 100,
                                    height: isListening ? 140 : 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                Container(
                                  width: isListening ? 45 : 35,
                                  height: isListening ? 45 : 35,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  child: Icon(
                                    Icons.mic,
                                    size: isListening ? 25 : 20,
                                    color: Colors.white,
                                  ),
                                ),
                                if (isListening)
                                  Positioned(
                                    bottom: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text(
                                        "Listening...",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: AppFonts.poppins,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showChatBottomSheet(VoiceController vc) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return Container(
          height: Get.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 30,
                spreadRadius: 5,
                offset: Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                      ),
                      child: const Icon(
                        Icons.support_agent,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(() => Text(
                        vc.currentAgentName.value.isNotEmpty
                            ? vc.currentAgentName.value
                            : 'Connecting...',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: AppFonts.poppins,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 20),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.5),
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 20,
                                title: Text(
                                  'End Agent Session',
                                  style: TextStyle(
                                    fontFamily: AppFonts.poppins,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.indigo.shade800,
                                  ),
                                ),
                                content: Text(
                                  'Are you sure you want to end the agent session?',
                                  style: TextStyle(
                                    fontFamily: AppFonts.poppins,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontFamily: AppFonts.poppins,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.red.shade500,
                                          Colors.red.shade600,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        vc.stopAgentSession();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'End Session',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: AppFonts.poppins,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
              // Messages
              Expanded(
                child: Obx(() {
                  final messages = vc.agentMessages;
                  final List<Widget> chatBubbles = [];

                  // Add agent messages (no static greeting)
                  for (final message in messages) {
                    final isUser = message['sender'] == 'user';
                    String messageText = message['message'] ?? '';
                    if (!isUser && messageText.contains('**')) {
                      messageText = messageText.replaceAll(RegExp(r'^\*\*[^*]+\*\*:\s*'), '');
                    }
                    chatBubbles.add(
                      MessageBubble(
                        message: messageText,
                        isUser: isUser,
                        theme: Theme.of(context),
                      ),
                    );
                  }

                  // Show thinking animation
                  if (vc.isAgentProcessing.value) {
                    chatBubbles.add(
                      Container(
                        margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.indigo.shade200),
                        ),
                        child: Row(
                          children: [
                            SpinKitSpinningLines(
                              color: Colors.indigo.shade600,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Agent is thinking...',
                              style: TextStyle(
                                color: Colors.indigo.shade700,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppFonts.poppins,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView(
                    controller: vc.scrollController,
                    padding: const EdgeInsets.all(16),
                    children: chatBubbles,
                  );
                }),
              ),
              // Text Input
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20, // Adjust for keyboard + extra spacing
                  left: 20,
                  right: 20,
                  top: 20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.indigo.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.indigo.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: vc.agentChatTextController,
                          decoration: InputDecoration(
                            hintText: "Type a message",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontFamily: AppFonts.poppins,
                            ),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              vc.sendAgentChatMessage();
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.indigo.shade500,
                            Colors.purple.shade600,
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: vc.sendAgentChatMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Assuming MessageBubble is defined elsewhere, but including a basic version for completeness
class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final ThemeData theme;
  final bool isTyping;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isUser,
    required this.theme,
    this.isTyping = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: Get.width * 0.8),
        decoration: BoxDecoration(
          color: isUser
              ? ColorConstants.appThemeColor.withOpacity(0.15)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isUser
                ? ColorConstants.appThemeColor.withOpacity(0.3)
                : Colors.grey[200]!,
            width: 1.w,
          ),
        ),
        child: isTyping
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SpinKitThreeBounce(
              color: Colors.indigo.shade600,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              message,
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 14.sp,
                color: Colors.black87,
              ),
            ),
          ],
        )
            : Text(
          message,
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 14.sp,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}