import '../../../../views/voice_screens/voice_screen/controller.dart';
import '../../../app-export.dart';
import 'dart:math' as math;

import 'custom_mic_button.dart';

class AnimatedBottomBarWrapper extends StatefulWidget {
  final VoiceController controller;
  final ThemeData theme;
  final Widget Function(VoiceController, ThemeData) bottomBarBuilder;

  const AnimatedBottomBarWrapper({
    super.key,
    required this.controller,
    required this.theme,
    required this.bottomBarBuilder,
  });

  @override
  _AnimatedBottomBarWrapperState createState() =>
      _AnimatedBottomBarWrapperState();
}

class _AnimatedBottomBarWrapperState extends State<AnimatedBottomBarWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start from below
      end: Offset.zero, // End at original position
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward(); // Start animation
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: widget.bottomBarBuilder(widget.controller, widget.theme),
    );
  }
}

class AiNeuralBackground extends StatefulWidget {
  const AiNeuralBackground({super.key});

  @override
  State<AiNeuralBackground> createState() => _AiNeuralBackgroundState();
}

class _AiNeuralBackgroundState extends State<AiNeuralBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _EnhancedNeuralNetPainter(progress: _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _EnhancedNeuralNetPainter extends CustomPainter {
  final double progress;
  _EnhancedNeuralNetPainter({required this.progress});

  final List<Color> dotColors = [
    ColorConstants.appThemeColor.withOpacity(0.06),
    ColorConstants.appThemeColor1.withOpacity(0.06),
    ColorConstants.appThemeColor.withOpacity(0.05),
    ColorConstants.appThemeColor1.withOpacity(0.05),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final Paint nodePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    final Paint linkPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const int cols = 10;
    const int rows = 15;
    final double cellW = size.width / cols;
    final double cellH = size.height / rows;

    // Draw enhanced dynamic links with flowing effect
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        final double phase = progress * 2 * math.pi;
        final Offset p = Offset(
          x * cellW + cellW * 0.5 + math.sin(phase + (x + y) * 0.5) * 8,
          y * cellH + cellH * 0.5 + math.cos(phase + (x - y) * 0.5) * 8,
        );

        // Connect to neighbors with flowing effect
        if (x < cols - 1) {
          final Offset pr = Offset(
            (x + 1) * cellW +
                cellW * 0.5 +
                math.sin(phase + (x + 1 + y) * 0.5) * 8,
            y * cellH + cellH * 0.5 + math.cos(phase + (x + 1 - y) * 0.5) * 8,
          );

          // Create flowing gradient effect
          final gradient = LinearGradient(
            colors: [
              ColorConstants.appThemeColor.withOpacity(0.08),
              ColorConstants.appThemeColor1.withOpacity(0.06),
              ColorConstants.appThemeColor.withOpacity(0.08),
            ],
          ).createShader(Rect.fromPoints(p, pr));

          linkPaint.shader = gradient;
          canvas.drawLine(p, pr, linkPaint);
        }

        if (y < rows - 1) {
          final Offset pb = Offset(
            x * cellW + cellW * 0.5 + math.sin(phase + (x + y + 1) * 0.5) * 8,
            (y + 1) * cellH +
                cellH * 0.5 +
                math.cos(phase + (x - (y + 1)) * 0.5) * 8,
          );

          final gradient = LinearGradient(
            colors: [
              ColorConstants.appThemeColor.withOpacity(0.07),
              ColorConstants.appThemeColor1.withOpacity(0.05),
              ColorConstants.appThemeColor.withOpacity(0.07),
            ],
          ).createShader(Rect.fromPoints(p, pb));

          linkPaint.shader = gradient;
          canvas.drawLine(p, pb, linkPaint);
        }
      }
    }

    // Draw enhanced pulsating nodes with glow effect
    int i = 0;
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        final double phase = progress * 2 * math.pi;
        final Offset p = Offset(
          x * cellW + cellW * 0.5 + math.sin(phase + (x + y) * 0.5) * 8,
          y * cellH + cellH * 0.5 + math.cos(phase + (x - y) * 0.5) * 8,
        );

        final double r =
            (math.sin(phase + (x * 0.8 + y * 0.6)) * 0.5 + 0.5) * 3.0 + 3.0;

        // Draw glow effect
        final glowPaint = Paint()
          ..color = dotColors[i % dotColors.length].withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawCircle(p, r + 4, glowPaint);

        // Draw main node
        nodePaint.color = dotColors[i % dotColors.length];
        canvas.drawCircle(p, r, nodePaint);

        i++;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _EnhancedNeuralNetPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Add the background painter class here, outside the main class
class SubtleBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    // Draw very subtle dots in a grid pattern
    const double spacing = 60.0;
    const double dotSize = 1.5;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        paint.color =
            ColorConstants.appThemeColor.withOpacity(0.03); // Very subtle
        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }

    // Draw subtle lines connecting some dots
    final Paint linePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color =
          ColorConstants.appThemeColor.withOpacity(0.02); // Very subtle lines

    for (double x = spacing; x < size.width - spacing; x += spacing * 2) {
      for (double y = spacing; y < size.height - spacing; y += spacing * 2) {
        // Connect to right neighbor
        canvas.drawLine(
          Offset(x, y),
          Offset(x + spacing, y),
          linePaint,
        );
        // Connect to bottom neighbor
        canvas.drawLine(
          Offset(x, y),
          Offset(x, y + spacing),
          linePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CustomBottomBar extends StatelessWidget {
  final VoiceController controller;
  final ThemeData theme;
  final AnimationController? micPulseController; // Added parameter

  const CustomBottomBar({
    super.key,
    required this.controller,
    required this.theme,
    this.micPulseController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: Get.width * 0.02,
        bottom: Get.width * 0.15 + Get.mediaQuery.viewInsets.bottom,
        right: Get.width * 0.03,
        left: Get.width * 0.03,
      ),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Obx(() {
        final isListening = controller.isListening.value;
        final isProcessing =
            controller.isLoading.value || controller.isPlayingResponse.value;
        final isChatMode = controller.isChatMode.value;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: ColorConstants.appThemeColor.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                    color: ColorConstants.appThemeColor.withOpacity(0.4)),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  isChatMode ? Icons.mic : Icons.chat,
                  size: 20,
                  color: ColorConstants.appThemeColor,
                ),
                onPressed: () => controller.toggleChatMode(),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                    color: ColorConstants.appThemeColor
                                        .withOpacity(0.4)),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorConstants.appThemeColor
                                        .withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: controller.chatTextController,
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
                              gradient: LinearGradient(
                                colors: [
                                  ColorConstants.appThemeColor,
                                  ColorConstants.appThemeColor1,
                                ],
                              ),
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
                              onPressed: controller.sendChatMessage,
                            ),
                          ),
                        ],
                      )
                    : CustomMicButton(
                        controller: controller,
                        isListening: isListening,
                        isProcessing: isProcessing,
                        micPulseController:
                            micPulseController, // Pass micPulseController
                      ),
              ),
            ),
            isChatMode ? const SizedBox(width: 0) : const SizedBox(width: 20),
          ],
        );
      }),
    );
  }
}
