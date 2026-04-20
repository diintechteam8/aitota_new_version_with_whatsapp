import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/more_flow/more_screen/controller/more_controller.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/enter_detail/controller/enter_details_controller.dart';
import '../controller/contact_group_controller.dart';

class ContactGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MoreController());
    Get.lazyPut(() => ContactGroupController());
    Get.lazyPut(() => EnterDetailsController());
  }

}