import 'package:aitota_business/core/app-export.dart';
import '../controller/outbound_conversation_detail_controller.dart';

class OutboundConversationDetailBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => OutboundConversationsDetailController());
  }
}