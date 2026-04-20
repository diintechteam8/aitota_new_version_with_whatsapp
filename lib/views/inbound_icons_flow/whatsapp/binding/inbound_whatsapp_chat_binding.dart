import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/inbound_icons_flow/whatsapp/controller/inbound_whatsapp_chat_controller.dart';

class InboundWhatsappChatBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => InboundWhatsappChatController());
  }

}