import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/inbound_icons_flow/email/controller/inbound_email_controller.dart';

class InboundEmailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InboundEmailController());
  }
}