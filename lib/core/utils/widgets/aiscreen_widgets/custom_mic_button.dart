import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../views/voice_screens/voice_screen/controller.dart';
import '../../../app-export.dart';

class CustomMicButton extends StatelessWidget {
  final VoiceController controller;
  final bool isListening;
  final bool isProcessing;
  final AnimationController? micPulseController;
  final bool isAgentMic;

  const CustomMicButton({
    super.key,
    required this.controller,
    required this.isListening,
    required this.isProcessing,
    this.micPulseController,
    this.isAgentMic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -15),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        width: isListening ? 140 : 100,
        height: isListening ? 140 : 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isListening
                ? [
                    ColorConstants.appThemeColor.withOpacity(0.95),
                    ColorConstants.appThemeColor.withOpacity(0.8),
                    ColorConstants.appThemeColor.withOpacity(0.95),
                  ]
                : [
                    ColorConstants.appThemeColor,
                    ColorConstants.appThemeColor.withOpacity(0.85),
                  ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: ColorConstants.appThemeColor
                  .withOpacity(isListening ? 0.35 : 0.25),
              blurRadius: isListening ? 35 : 25,
              spreadRadius: isListening ? 8 : 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(isListening ? 70 : 50),
            onTap: isProcessing
                ? null
                : () {
                    if (isAgentMic) {
                      controller.toggleAgentListening();
                    } else {
                      if (controller.isChatMode.value) {
                        controller.toggleChatMode();
                      } else {
                        controller.toggleListening();
                      }
                    }
                  },
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isListening && micPulseController != null)
                  AnimatedBuilder(
                    animation: micPulseController!,
                    builder: (context, child) {
                      return Container(
                        width: isListening ? 160 : 120,
                        height: isListening ? 160 : 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(
                                0.3 - (micPulseController!.value * 0.2)),
                            width: 2,
                          ),
                        ),
                      );
                    },
                  ),
                if (isListening && micPulseController != null)
                  AnimatedBuilder(
                    animation: micPulseController!,
                    builder: (context, child) {
                      return Container(
                        width: isListening ? 120 : 80,
                        height: isListening ? 120 : 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(
                                0.2 - (micPulseController!.value * 0.15)),
                            width: 1.5,
                          ),
                        ),
                      );
                    },
                  ),
                if (isListening)
                  SpinKitSpinningLines(
                    color: Colors.white.withOpacity(0.9),
                    size: 100.0,
                  ),
                Container(
                  width: isListening ? 50 : 40,
                  height: isListening ? 50 : 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.mic,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
                if (isListening)
                  Positioned(
                    bottom: 15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Listening...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
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
    );
  }
}
