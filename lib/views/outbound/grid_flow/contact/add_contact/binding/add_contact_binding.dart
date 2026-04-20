import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/add_contact/controller/add_contact_controller.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/open_phonebook/controller/open_phonebook_controller.dart';

import '../../enter_detail/controller/enter_details_controller.dart';

class AddContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddContactController());
  }

}