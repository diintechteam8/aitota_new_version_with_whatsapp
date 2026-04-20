import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/widgets/common_widgets/shimmer_loading.dart';
import '../../../../core/app-export.dart';
import 'controller/whatsapp_inbox_controller.dart';
import 'whatsapp_chat_detail_screen.dart';

class WhatsAppInboxScreen extends GetView<WhatsAppInboxController> {
  const WhatsAppInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration:  BoxDecoration(
            gradient: ColorConstants.whatsappGradient,
          ),
        ),
        title: Text(
          'Live Chat Inbox',
          style: TextStyle(
            fontSize: 18.sp,
            fontFamily: AppFonts.playfair,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.chats.isEmpty) {
          return ListView.separated(
            itemCount: 10,
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 80),
            itemBuilder: (context, index) =>
                BaseShimmer(child: ChatTileShimmer()),
          );
        }
        return ListView.separated(
          itemCount: controller.chats.length,
          separatorBuilder: (context, index) => const Divider(height: 1, indent: 80),
          itemBuilder: (context, index) {
            final chat = controller.chats[index];
            return _buildChatTile(chat);
          },
        );
      }),
    );
  }

  Widget _buildChatTile(Map<String, dynamic> chat) {
    return ListTile(
      onTap: () {
        controller.markAsRead(chat["id"]);
        Get.to(() => WhatsAppChatDetailScreen(chatId: chat["id"]));
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: ColorConstants.whatsappGradientDark.withOpacity(0.1),
        child: Text(
          chat["name"][0],
          style: const TextStyle(fontWeight: FontWeight.bold, color: ColorConstants.whatsappGradientDark),
        ),
      ),
      title: Text(
        chat["name"],
        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        chat["lastMessage"],
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(chat["time"], style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
          if (chat["unread"] > 0) ...[
            SizedBox(height: 4.h),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: ColorConstants.whatsappGradientDark,
                shape: BoxShape.circle,
              ),
              child: Text(
                chat["unread"].toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
