import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/more_flow/more_screen/controller/more_controller.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/enter_detail/controller/enter_details_controller.dart';

import '../controller/direct_group_controller.dart';

class DirectGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MoreController());
    Get.lazyPut(() => DirectGroupController());
    Get.lazyPut(() => EnterDetailsController());
  }
}
