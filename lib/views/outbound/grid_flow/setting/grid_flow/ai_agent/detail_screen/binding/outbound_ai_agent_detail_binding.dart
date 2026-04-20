import 'package:aitota_business/views/outbound/grid_flow/setting/grid_flow/ai_agent/detail_screen/controller/outbound_ai_agnt_detail_controller.dart';

import '../../../../../../../../core/app-export.dart';

class OutboundAiAgentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OutboundAiAgentDetailController());
  }

}