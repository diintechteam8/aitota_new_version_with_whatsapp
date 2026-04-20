import 'package:aitota_business/views/inbound/grid_flow/conversations/controller/inbound_converstations_controller.dart';

import '../../../../../core/app-export.dart';
import '../controller/outbound_conversations_controller.dart';

class  OutboundConversationsBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => OutboundConversationsController());
  }

}