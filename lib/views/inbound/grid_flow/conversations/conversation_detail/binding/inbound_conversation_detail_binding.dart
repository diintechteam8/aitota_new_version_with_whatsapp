import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/inbound/grid_flow/conversations/conversation_detail/controller/inbound_conversation_detail_controller.dart';

class InboundConversationDetailBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => InboundConversationsDetailController());
  }
}