import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/myDial/grid_flow/myAssign/direct/detail/contact_detail/controller/contact_detail_controller.dart';

class ContactDetailBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ContactDetailController());
  }

}