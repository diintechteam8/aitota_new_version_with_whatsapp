


import 'package:aitota_business/core/app-export.dart';

class InboundTelegramChatController extends GetxController {
  final textController = TextEditingController();
  final messages = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Sample messages for demo
    messages.addAll([
      {'text': 'Hello! Welcome to Telegram support', 'time': '10:30 AM', 'isSentByUser': false},
      {'text': 'Hi! I need help with my query.', 'time': '10:32 AM', 'isSentByUser': true},
      {'text': 'Sure! How can I assist you today?', 'time': '10:33 AM', 'isSentByUser': false},
    ]);
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf', 'doc', 'docx'],
      );
      if (result != null && result.files.single.name != null) {
        final now = DateTime.now();
        final time = '${now.hour % 12}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';
        final fileName = result.files.single.name;

        messages.add({
          'text': 'File: $fileName',
          'time': time,
          'isSentByUser': true,
          'isFile': true,
        });

        // Simulate a reply
        Future.delayed(const Duration(seconds: 1), () {
          messages.add({
            'text': 'File received: $fileName',
            'time': '${now.hour % 12}:${(now.minute + 1).toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}',
            'isSentByUser': false,
          });
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick file: $e');
    }
  }

  void sendMessage() {
    if (textController.text.trim().isNotEmpty) {
      final now = DateTime.now();
      final time = '${now.hour % 12}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';
      messages.add({
        'text': textController.text.trim(),
        'time': time,
        'isSentByUser': true,
      });
      textController.clear();

      // Simulate a reply
      Future.delayed(const Duration(seconds: 1), () {
        messages.add({
          'text': 'Thank you for your message. We will get back to you soon.',
          'time': '${now.hour % 12}:${(now.minute + 1).toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}',
          'isSentByUser': false,
        });
      });
    }
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}