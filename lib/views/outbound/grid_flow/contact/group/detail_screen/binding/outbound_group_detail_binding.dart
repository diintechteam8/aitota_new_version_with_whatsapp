import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/group/detail_screen/controller/outbound_group_detail_controller.dart';

class OutboundGroupDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OutboundGroupDetailController());
  }

}