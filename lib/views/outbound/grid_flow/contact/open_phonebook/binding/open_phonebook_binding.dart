import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/open_phonebook/controller/open_phonebook_controller.dart';

class OpenPhoneBookBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OpenPhoneBookController());
  }
  
}