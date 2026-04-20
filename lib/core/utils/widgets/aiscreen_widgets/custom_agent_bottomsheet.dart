import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import '../../../../views/ai_agent/controller/ai_agent_controller.dart';
import '../../../../views/outbound/grid_flow/setting/grid_flow/ai_agent/detail_screen/outbound_ai_agent_detail_screen.dart';
import '../../../../views/voice_screens/voice_screen/controller.dart';
import '../../../app-export.dart';
import 'custom_mic_button.dart';

class CustomAgentChatBottomSheet extends StatelessWidget {
  final VoiceController controller;
  final ThemeData theme;
  final AnimationController? micPulseController; // Added parameter

  const CustomAgentChatBottomSheet({
    super.key,
    required this.controller,
    required this.theme,
    this.micPulseController, // Added parameter
  });

  @override
  Widget build(BuildContext context) {
    final headerGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        ColorConstants.appThemeColor,
        ColorConstants.appThemeColor.withOpacity(0.9),
      ],
    );

    final avatarGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        ColorConstants.appThemeColor.withOpacity(0.95),
        ColorConstants.appThemeColor.withOpacity(0.8),
      ],
    );

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
            color: Colors.black12,
            blurRadius: 30,
            spreadRadius: 5,
            offset: Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: headerGradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: avatarGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: ColorConstants.appThemeColor.withOpacity(0.25),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.support_agent,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Agent',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.85),
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.poppins,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(() => Text(
                            controller.currentAgentName.value.isNotEmpty
                                ? controller.currentAgentName.value
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
                    ],
                  ),
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
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 20),
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
                                color: ColorConstants.appThemeColor,
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
                                  color: Colors.red.shade600,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    controller.stopAgentSession();
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
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final messages = controller.agentMessages;
              final List<Widget> chatBubbles = [];
              final aiCtrl = Get.find<AiAgentController>();
              final agentGreeting = aiCtrl.agentDataList
                      .where((agent) =>
                          agent.id == controller.currentAgentId.value)
                      .firstOrNull
                      ?.firstMessage ??
                  'नमस्ते! मैं आपकी कैसे मदद कर सकता हूँ?';
              chatBubbles.add(
                MessageBubble(
                  message: agentGreeting,
                  isUser: false,
                  theme: theme,
                ),
              );
              for (final message in messages) {
                final isUser = message['sender'] == 'user';
                String messageText = message['message'] ?? '';
                if (!isUser && messageText.contains('**')) {
                  messageText =
                      messageText.replaceAll(RegExp(r'^\*\*[^*]+\*\*:\s*'), '');
                }
                chatBubbles.add(
                  MessageBubble(
                    message: messageText,
                    isUser: isUser,
                    theme: theme,
                  ),
                );
              }
              if (controller.isAgentProcessing.value) {
                chatBubbles.add(
                  Container(
                    margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorConstants.appThemeColor.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color:
                              ColorConstants.appThemeColor.withOpacity(0.25)),
                    ),
                    child: Row(
                      children: [
                        SpinKitSpinningLines(
                          color: ColorConstants.appThemeColor,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Agent is thinking...',
                          style: TextStyle(
                            color: ColorConstants.appThemeColor,
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
                controller: controller.scrollController,
                padding: const EdgeInsets.all(16),
                children: chatBubbles,
              );
            }),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: ColorConstants.appThemeColor.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Obx(() {
              final isListening = controller.isAgentListening.value;
              final isProcessing = controller.isAgentProcessing.value;
              final isChatMode = controller.isChatMode.value;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isProcessing
                          ? ColorConstants.appThemeColor.withOpacity(0.12)
                          : ColorConstants.appThemeColor.withOpacity(0.08),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isProcessing
                            ? ColorConstants.appThemeColor.withOpacity(0.35)
                            : ColorConstants.appThemeColor.withOpacity(0.25),
                      ),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: isProcessing
                          ? SpinKitSpinningLines(
                              color: ColorConstants.appThemeColor,
                              size: 20,
                            )
                          : Icon(
                              isChatMode ? Icons.mic : Icons.chat,
                              size: 20,
                              color: ColorConstants.appThemeColor,
                            ),
                      onPressed: isProcessing
                          ? null
                          : () => controller.toggleChatMode(),
                    ),
                  ),
                  SizedBox(width: Get.width * 0.03),
                  Expanded(
                    child: Center(
                      child: isChatMode
                          ? Row(
                              children: [
                                Expanded(
                                  flex: 9,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: ColorConstants.appThemeColor
                                            .withOpacity(0.25),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: ColorConstants.appThemeColor
                                              .withOpacity(0.08),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      controller:
                                          controller.agentChatTextController,
                                      decoration: InputDecoration(
                                        hintText: "Type a message",
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontFamily: AppFonts.poppins,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: ColorConstants.appThemeColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: ColorConstants.appThemeColor
                                            .withOpacity(0.3),
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
                                    onPressed: controller.sendAgentChatMessage,
                                  ),
                                ),
                              ],
                            )
                          : CustomMicButton(
                              controller: controller,
                              isListening: isListening,
                              isProcessing: isProcessing,
                              micPulseController:
                                  micPulseController, // Pass the controller
                              isAgentMic: true,
                            ),
                    ),
                  ),
                  isChatMode
                      ? const SizedBox(width: 0)
                      : const SizedBox(width: 20),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
