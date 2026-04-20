import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/ai_agent/controller/ai_agent_controller.dart';
import 'package:aitota_business/routes/app_routes.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'controller.dart';

class VoiceScreen extends StatefulWidget {
  final bool initialChatMode;
  final bool isFromBottomNav;
  final String? questionId;
  final String? welcomeAiMessages;
  final String? welcomeAiFAQsForChat;
  final bool? isRagChatAvailable;

  const VoiceScreen({
    super.key,
    this.initialChatMode = false,
    this.isFromBottomNav = false,
    this.questionId,
    this.welcomeAiMessages,
    this.welcomeAiFAQsForChat,
    this.isRagChatAvailable = true,
  });

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late VoiceController controller;
  bool _isControllerInitialized = false;
  late AudioPlayer welcomePlayer;
  AnimationController? _micPulseController;
  AnimationController? _waveController;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _micPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final msg = widget.welcomeAiMessages;
      if (msg != null && msg.isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 300));
        await controller.flutterTts.setLanguage(
          controller.selectedLanguageLabel.value,
        );
        await controller.flutterTts.speak(msg);
      }
    });
  }

  void _initializeController() {
    if (!_isControllerInitialized) {
      if (Get.isRegistered<VoiceController>()) {
        Get.delete<VoiceController>(force: true);
      }
      controller = Get.put(
        VoiceController(
          initialChatMode: widget.initialChatMode,
          questionId: widget.questionId,
          isRagChatAvailable: widget.isRagChatAvailable,
        ),
        permanent: widget.isFromBottomNav,
      );
      controller.onAgentConnected = _showAgentChatBottomSheet;
      _isControllerInitialized = true;
    }
  }

  @override
  void dispose() {
    _micPulseController?.dispose();
    _waveController?.dispose();
    if (!widget.isFromBottomNav) {
      if (Get.isRegistered<VoiceController>()) {
        if (controller.speech.isListening) {
          controller.speech.stop();
        }
        if (controller.isPlayingResponse.value) {
          controller.player?.stop();
        }
        Get.delete<VoiceController>(force: true);
      }
    }
    super.dispose();
  }

  @override
  bool get wantKeepAlive => widget.isFromBottomNav;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!_isControllerInitialized) {
      _initializeController();
    }
    final theme = Theme.of(context);
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        if (!widget.isFromBottomNav) {
          if (controller.speech.isListening) {
            await controller.speech.stop();
          }
          if (controller.isPlayingResponse.value) {
            await controller.player?.stop();
          }
          if (Get.isRegistered<VoiceController>()) {
            Get.delete<VoiceController>(force: true);
          }
        }
      },
      child: Scaffold(
        backgroundColor: ColorConstants.greyBG,
        drawer: CustomDrawer(controller: controller),
        floatingActionButton: Obx(() => controller.isAgentChatActive.value
            ? CustomFloatingActionButton(
                onPressed: _showAgentChatBottomSheet,
                isWebSocketConnected: controller.isWebSocketConnected.value,
              )
            : const SizedBox.shrink()),
        appBar: CustomAppBar(
          height: 50.h,
          styleType: Style.bgGradientWhatsApp, // WhatsApp gradient
          title: "Agent",
          titleStyle: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500),
          showBackButton: true,
          onTapBack: () => Get.back(),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
              onPressed: _showScannerDialog,
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorConstants.appThemeColor.withOpacity(0.05),
                  ColorConstants.greyBG,
                  ColorConstants.appThemeColor.withOpacity(0.03),
                ],
                stops: const [0.0, 0.3, 1.0],
              ),
            ),
            child: Stack(
              children: [
                const Positioned.fill(
                  child: CustomPaint(
                    painter: SubtleBackgroundPainter(
                      baseColor: ColorConstants.appThemeColor,
                    ),
                    size: Size.infinite,
                  ),
                ),
                Positioned.fill(
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomChatList(
                          controller: controller,
                          theme: theme,
                          welcomeMessage: widget.welcomeAiMessages,
                          micPulseController: _micPulseController,
                          waveController: _waveController,
                        ),
                      ),
                      Obx(() => controller.isAgentChatActive.value
                          ? const SizedBox.shrink()
                          : AnimatedBottomBarWrapper(
                              controller: controller,
                              theme: theme,
                              bottomBarBuilder: (controller, theme) =>
                                  CustomBottomBar(
                                controller: controller,
                                theme: theme,
                                micPulseController: _micPulseController,
                              ),
                            )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showScannerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomScannerDialog(
        onDetect: _handleScannedCode,
      ),
    );
  }

  void _handleScannedCode(String code) {
    String agentId = code;
    if (code.startsWith('{') && code.endsWith('}')) {
      try {
        final Map<String, dynamic> jsonData = jsonDecode(code);
        agentId = jsonData['agentId'] ?? code;
      } catch (e) {
        debugPrint('Error parsing QR code JSON: $e');
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
      } catch (e) {
        agentId = code;
        throw Exception(e.toString());
      }
    }
    debugPrint('Extracted agent ID: $agentId');
    controller.connectToWebSocket(agentId);
  }

  void _showAgentChatBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => CustomAgentChatBottomSheet(
        controller: controller,
        theme: Theme.of(context),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  final VoiceController controller;

  const CustomDrawer({super.key, required this.controller});

  String _formatDateDDMMYY(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      String two(int n) => n.toString().padLeft(2, '0');
      return '${two(dt.day)}/${two(dt.month)}/${two(dt.year % 100)}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorConstants.greyBG,
      elevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                gradient: ColorConstants.whatsappGradient, // WhatsApp gradient
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: ColorConstants.whatsappGradient,
                    ),
                    child: const Icon(Icons.support_agent, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Agent',
                          style: TextStyle(
                            fontFamily: AppFonts.playfair,
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Obx(() => Text(
                              controller.isWebSocketConnected.value
                                  ? 'Online'
                                  : 'Offline',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 12,
                              ),
                            )),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Obx(() {
                final selected = controller.drawerTab.value;
                return Row(
                  children: [
                    DrawerTabButton(
                      title: 'Agents',
                      icon: Icons.people_alt,
                      selected: selected == 'agents',
                      onTap: () {
                        controller.drawerTab.value = 'agents';
                        final aiCtrl = Get.put(AiAgentController());
                        aiCtrl.fetchAgentData();
                      },
                    ),
                    const SizedBox(width: 8),
                    DrawerTabButton(
                      title: 'History',
                      icon: Icons.history,
                      selected: selected == 'history',
                      onTap: () async {
                        controller.drawerTab.value = 'history';
                        await controller.fetchAgentChatHistory();
                      },
                    ),
                  ],
                );
              }),
            ),
            Expanded(
              child: Obx(() {
                if (controller.drawerTab.value == 'agents') {
                  final aiCtrl = Get.put(AiAgentController());
                  if (aiCtrl.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: ColorConstants.appThemeColor,
                      ),
                    );
                  }
                  if (aiCtrl.agentDataList.isEmpty) {
                    return Center(
                      child: Text(
                        'No agents found',
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          color: ColorConstants.grey,
                        ),
                      ),
                    );
                  }
                  final activeAgents = aiCtrl.agentDataList
                      .where((a) => a.isActive == true)
                      .toList();
                  final inactiveAgents = aiCtrl.agentDataList
                      .where((a) => a.isActive != true)
                      .toList();
                  final ordered = [...activeAgents, ...inactiveAgents];
                  return ListView.separated(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: ordered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final agent = ordered[index];
                      final bool isActive = agent.isActive == true;
                      return DrawerListTile(
                        title: agent.agentName ?? 'Unknown Agent',
                        subtitle: null,
                        leading: Icons.support_agent,
                        inactive: !isActive,
                        trailing: Icons.chevron_right,
                        showStatusBadge: true,
                        isStatusActive: isActive,
                        onTap: () {
                          Get.back();
                          Get.toNamed(AppRoutes.aiAiAgentDetailScreen,
                              arguments: agent);
                        },
                      );
                    },
                  );
                } else {
                  if (controller.isDrawerLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: ColorConstants.appThemeColor,
                      ),
                    );
                  }
                  if (controller.agentHistoryList.isEmpty) {
                    return Center(
                      child: Text(
                        'No history found',
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          color: ColorConstants.grey,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: controller.agentHistoryList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = controller.agentHistoryList[index];
                      return DrawerListTile(
                        title: (item.agent?.email != null &&
                                item.agent!.email!.isNotEmpty)
                            ? item.agent!.email!.first
                            : 'Agent',
                        subtitle: _formatDateDDMMYY(item.lastActivityAt),
                        leading: Icons.chat_bubble_outline,
                        trailing: Icons.chevron_right,
                        showStatusBadge: false,
                        onTap: () async {
                          Get.back();
                          await controller.loadHistoryChat(item.agentId ?? '');
                        },
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isWebSocketConnected;

  const CustomFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.isWebSocketConnected,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'voice_ai_fab', // Added unique tag to fix Hero conflict
      onPressed: onPressed,
      backgroundColor: ColorConstants.appThemeColor,
      child: Stack(
        children: [
          const Icon(Icons.support_agent, color: Colors.white),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isWebSocketConnected ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubtleBackgroundPainter extends CustomPainter {
  final Color baseColor;
  const SubtleBackgroundPainter(
      {this.baseColor = ColorConstants.appThemeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    const double spacing = 60.0;
    const double dotSize = 1.5;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        paint.color = baseColor.withOpacity(0.06);
        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }

    final Paint linePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = baseColor.withOpacity(0.05);

    for (double x = spacing; x < size.width - spacing; x += spacing * 2) {
      for (double y = spacing; y < size.height - spacing; y += spacing * 2) {
        canvas.drawLine(
          Offset(x, y),
          Offset(x + spacing, y),
          linePaint,
        );
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
