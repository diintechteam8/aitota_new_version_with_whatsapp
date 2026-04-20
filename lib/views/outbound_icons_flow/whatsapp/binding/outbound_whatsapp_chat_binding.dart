import 'package:aitota_business/core/app-export.dart';
import '../controller/outbound_whatsapp_chat_controller.dart';

class OutboundWhatsappChatBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => OutboundWhatsappChatController());
  }

}