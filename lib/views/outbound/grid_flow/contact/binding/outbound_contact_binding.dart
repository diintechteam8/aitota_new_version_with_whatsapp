import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/add_contact/controller/add_contact_controller.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/controller/outbound_contact_controller.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/group/controller/contact_group_controller.dart';

class OutboundContactBinding extends Bindings {
  @override
  void dependencies() {
    print('OutboundContactBinding dependencies called');
    Get.lazyPut(() => OutboundContactController());
    Get.lazyPut(() => ContactGroupController());
    Get.lazyPut(() => AddContactController());

  }

}