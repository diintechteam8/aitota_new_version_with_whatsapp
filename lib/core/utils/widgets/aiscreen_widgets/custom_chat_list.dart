import 'dart:math' as math;
import '../../../../views/outbound/grid_flow/setting/grid_flow/ai_agent/detail_screen/outbound_ai_agent_detail_screen.dart';
import '../../../../views/voice_screens/voice_screen/controller.dart';
import '../../../app-export.dart';

class CustomChatList extends StatelessWidget {
  final VoiceController controller;
  final ThemeData theme;
  final String? welcomeMessage;
  final AnimationController? micPulseController; // Added parameter
  final AnimationController? waveController; // Added parameter

  const CustomChatList({
    super.key,
    required this.controller,
    required this.theme,
    this.welcomeMessage,
    this.micPulseController,
    this.waveController,
  });

  Widget _buildAIWavesOverlay(AnimationController? waveController) {
    if (waveController == null) {
      return const SizedBox.shrink();
    }
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return AnimatedBuilder(
                    animation: waveController,
                    builder: (context, child) {
                      final delay = index * 0.2;
                      final waveHeight = (math.sin(
                                      (waveController.value * 2 * math.pi) +
                                          delay) *
                                  0.5 +
                              0.5) *
                          80;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: waveHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              ColorConstants.appThemeColor.withOpacity(0.85),
                              ColorConstants.appThemeColor.withOpacity(0.55),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "AI is thinking...",
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ColorConstants.appThemeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting(AnimationController? micPulseController) {
    if (micPulseController == null) {
      return const SizedBox.shrink();
    }
    return AnimatedBuilder(
      animation: micPulseController,
      builder: (context, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Hi, I'm your personal assistant",
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: ColorConstants.appThemeColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "Ask me to call, follow up, or answer questions.",
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 16,
                color: ColorConstants.appThemeColor.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: micPulseController,
                  builder: (context, child) {
                    final delay = index * 0.3;
                    final scale = (math.sin(
                                (micPulseController.value * 2 * math.pi) +
                                    delay) *
                            0.3 +
                        0.7);
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 16 * scale,
                      height: 16 * scale,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            ColorConstants.appThemeColor.withOpacity(0.9),
                            ColorConstants.appThemeColor.withOpacity(0.6),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final messages = controller.messages;
      final showThinking = controller.showThinkingBubble.value;
      final isPlaying = controller.isPlayingResponse.value;
      final List<Widget> chatBubbles = [];

      if (messages.isEmpty) {
        final dynamicWelcome = welcomeMessage;
        if (dynamicWelcome != null && dynamicWelcome.isNotEmpty) {
          chatBubbles.add(
            MessageBubble(
              message: dynamicWelcome,
              isUser: false,
              theme: theme,
            ),
          );
        }
      } else {
        for (final message in messages) {
          final isUser = message['sender'] == 'user';
          chatBubbles.add(
            MessageBubble(
              message: message['message'] ?? '',
              isUser: isUser,
              theme: theme,
            ),
          );
        }
        if (showThinking) {
          chatBubbles.add(
            MessageBubble(
              message: "Thinking...",
              isUser: false,
              theme: theme,
              isTyping: true,
            ),
          );
        }
      }

      if (messages.isEmpty &&
          (welcomeMessage == null || welcomeMessage!.isEmpty)) {
        return Center(child: _buildGreeting(micPulseController));
      }

      return Stack(
        children: [
          ListView(
            controller: controller.scrollController,
            padding: EdgeInsets.only(
              left: Get.width * 0.05,
              right: Get.width * 0.05,
              top: 16,
              bottom: Get.width * 0.20,
            ),
            children: chatBubbles,
          ),
          if (showThinking && !isPlaying) _buildAIWavesOverlay(waveController),
        ],
      );
    });
  }
}
