import 'package:get/get.dart';

class WhatsAppInboxController extends GetxController {
  RxList<Map<String, dynamic>> chats = <Map<String, dynamic>>[
    {
      "id": "1",
      "name": "Aman Kumar",
      "number": "+91 9876543210",
      "lastMessage": "Interested in the festival offer!",
      "time": "10:30 AM",
      "unread": 2,
      "messages": [
        {"text": "Hello, interested in the festival offer!", "isMe": false, "time": "10:25 AM"},
        {"text": "Can I get more details on the 50% discount?", "isMe": false, "time": "10:30 AM"},
      ]
    },
    {
      "id": "2",
      "name": "Rahul Sharma",
      "number": "+91 9123456789",
      "lastMessage": "Is shipping free for Noida?",
      "time": "Yesterday",
      "unread": 0,
      "messages": [
        {"text": "Is shipping free for Noida?", "isMe": false, "time": "Yesterday"},
      ]
    },
    {
      "id": "3",
      "name": "Priya Singh",
      "number": "+91 8888888888",
      "lastMessage": "Order #543 is not delivered yet.",
      "time": "Monday",
      "unread": 5,
      "messages": [
        {"text": "Order #543 is not delivered yet.", "isMe": false, "time": "Monday"},
      ]
    },
  ].obs;

  RxBool isLoading = false.obs;

  void markAsRead(String id) {
    int index = chats.indexWhere((c) => c["id"] == id);
    if (index != -1) {
      chats[index]["unread"] = 0;
      chats.refresh();
    }
  }

  void sendMessage(String chatId, String text) {
    int index = chats.indexWhere((c) => c["id"] == chatId);
    if (index != -1) {
      chats[index]["messages"].add({
        "text": text,
        "isMe": true,
        "time": "Just now",
      });
      chats[index]["lastMessage"] = text;
      chats.refresh();
    }
  }
}
