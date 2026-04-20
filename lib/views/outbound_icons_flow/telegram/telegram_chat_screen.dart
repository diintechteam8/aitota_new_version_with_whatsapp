import 'package:aitota_business/core/app-export.dart';
import 'controller/inbound_telegram_chat_controller.dart';

class InboundTelegramChatScreen extends GetView<InboundTelegramChatController> {
  const InboundTelegramChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      appBar: CustomAppBar(
        title: "Telegram Chat",
        titleStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.poppins,
          color: ColorConstants.white,
        ),
        showBackButton: true,
        onTapBack: () {
          Get.back();
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final message = controller.messages[index];
                final isSentByUser = message['isSentByUser'] as bool;
                return Align(
                  alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isSentByUser
                          ? const Color(0xFF3390EC)
                          : const Color(0xFF182533),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 3,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: isSentByUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['text'] as String,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: ColorConstants.white,
                            fontFamily: AppFonts.poppins,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          message['time'] as String,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white70,
                            fontFamily: AppFonts.poppins,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: const Color(0xFF17212B),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.white70),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: controller.textController,
                    style: TextStyle(color: ColorConstants.white),
                    decoration: InputDecoration(
                      hintText: 'Message...',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF0F1419),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.white70),
                  onPressed: controller.pickFile,
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF3390EC)),
                  onPressed: controller.sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}