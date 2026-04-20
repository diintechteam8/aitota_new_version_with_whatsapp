import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/inbound_icons_flow/whatsapp/controller/inbound_whatsapp_chat_controller.dart';

class InboundWhatsappChatScreen extends GetView<InboundWhatsappChatController> {
  const InboundWhatsappChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5DD),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF075E54),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            title: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF25D366),
                  radius: 18,
                  child: Text(
                    controller.phoneE164.isNotEmpty
                        ? controller.phoneE164[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    controller.phoneE164,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.poppins,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              Obx(() => IconButton(
                icon: controller.isLoading.value
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.refresh, color: Colors.white),
                onPressed: controller.isLoading.value
                    ? null
                    : controller.refreshMessages,
              )),
            ],
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.messages.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF075E54),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: controller.refreshMessages,
                  color: const Color(0xFF075E54),
                  child: ListView.builder(
                    reverse: true,
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 8),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller
                          .messages[controller.messages.length - 1 - index];
                      final isSentByUser =
                          message['isSentByUser'] as bool? ?? false;
                      return Align(
                        alignment: isSentByUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 6,
                            bottom: 6,
                            left: isSentByUser ? 30 : 16,
                            right: isSentByUser ? 16 : 30,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSentByUser
                                ? const Color(0xFFDCF8C6)
                                : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft:
                              Radius.circular(isSentByUser ? 16 : 4),
                              bottomRight:
                              Radius.circular(isSentByUser ? 4 : 16),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: isSentByUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              _LinkText(
                                text: (message['text'] ?? '') as String,
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  height: 1.3,
                                ),
                                linkStyle: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF1E88E5),
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                (message['time'] ?? '') as String,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              color: Colors.grey[200],
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline,
                        color: Colors.grey),
                    onPressed: controller.openTemplatesSheet,
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller.textController,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                      ),
                    ),
                  ),
                  Obx(() => IconButton(
                    icon: controller.isSending.value
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF075E54),
                      ),
                    )
                        : const Icon(Icons.send,
                        color: Color(0xFF075E54)),
                    onPressed: controller.isSending.value
                        ? null
                        : controller.sendMessage,
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkText extends StatelessWidget {
  const _LinkText({
    required this.text,
    this.textStyle,
    this.linkStyle,
  });

  final String text;
  final TextStyle? textStyle;
  final TextStyle? linkStyle;

  static final RegExp _urlRegex =
  RegExp(r'(https?:\/\/[^\s]+)', caseSensitive: false);

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    final matches = _urlRegex.allMatches(text).toList();
    if (matches.isEmpty) {
      return Text(text, style: textStyle);
    }

    int currentIndex = 0;
    for (final m in matches) {
      if (m.start > currentIndex) {
        spans.add(TextSpan(
            text: text.substring(currentIndex, m.start), style: textStyle));
      }
      final url = text.substring(m.start, m.end);
      spans.add(TextSpan(
        text: url,
        style: linkStyle ?? const TextStyle(color: Colors.blue),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            final uri = Uri.tryParse(url);
            if (uri != null) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
      ));
      currentIndex = m.end;
    }
    if (currentIndex < text.length) {
      spans.add(
          TextSpan(text: text.substring(currentIndex), style: textStyle));
    }

    return Text.rich(TextSpan(children: spans));
  }
}