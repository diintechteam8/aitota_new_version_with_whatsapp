import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/inbound_icons_flow/telegram/controller/inbound_telegram_chat_controller.dart';

class InboundTelegramChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InboundTelegramChatController());
  }
}


