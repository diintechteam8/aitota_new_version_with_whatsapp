import 'package:aitota_business/views/inbound/grid_flow/conversations/controller/inbound_converstations_controller.dart';

import '../../../../../core/app-export.dart';

class  InboundConversationsBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => InboundConversationsController());
  }

}