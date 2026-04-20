import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/add_contact/controller/add_contact_controller.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/enter_detail/controller/enter_details_controller.dart';

class EnterDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EnterDetailsController());
    Get.lazyPut(() => AddContactController());
  }

}