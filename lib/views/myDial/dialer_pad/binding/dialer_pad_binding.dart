import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/myDial/dialer_pad/controller/dialer_pad_controller.dart';

class DialerPadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DialerPadController());
  }

}