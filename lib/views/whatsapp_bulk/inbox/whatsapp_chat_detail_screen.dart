import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/app-export.dart';
import 'controller/whatsapp_inbox_controller.dart';

class WhatsAppChatDetailScreen extends StatefulWidget {
  final String chatId;
  const WhatsAppChatDetailScreen({super.key, required this.chatId});

  @override
  State<WhatsAppChatDetailScreen> createState() => _WhatsAppChatDetailScreenState();
}

class _WhatsAppChatDetailScreenState extends State<WhatsAppChatDetailScreen> {
  final controller = Get.find<WhatsAppInboxController>();
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chat = controller.chats.firstWhere((c) => c["id"] == widget.chatId);

    return Scaffold(
      backgroundColor: const Color(0xffECE5DD), // WhatsApp chat background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration:  BoxDecoration(
            gradient: ColorConstants.whatsappGradient,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chat["name"],
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              "online",
              style: TextStyle(fontSize: 10.sp, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final currentChat = controller.chats.firstWhere((c) => c["id"] == widget.chatId);
              final messages = currentChat["messages"] as List;
              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return _buildMessageBubble(msg["text"], msg["isMe"], msg["time"]);
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _buildInputArea(),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isMe, String time) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        constraints: BoxConstraints(maxWidth: Get.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xffDCF8C6) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 1)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(text, style: TextStyle(fontSize: 14.sp, color: Colors.black87)),
            SizedBox(height: 2.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(time, style: TextStyle(fontSize: 9.sp, color: Colors.grey)),
                if (isMe) ...[
                  SizedBox(width: 4.w),
                  const Icon(Icons.done_all, color: Colors.blue, size: 12),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(8.w),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: "Type a message",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          CircleAvatar(
            backgroundColor: ColorConstants.whatsappGradientDark,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  controller.sendMessage(widget.chatId, textController.text);
                  textController.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
