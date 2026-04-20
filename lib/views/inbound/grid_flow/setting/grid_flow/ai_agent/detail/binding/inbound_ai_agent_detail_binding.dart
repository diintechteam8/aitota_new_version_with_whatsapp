import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/inbound/grid_flow/setting/grid_flow/ai_agent/detail/controller/inbound_ai_agent_detail_controller.dart';

class InboundAiAgentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InboundAiAgentDetailController());
  }

}