import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/inbound/grid_flow/setting/controller/inbound_settings_controller.dart';

class InboundSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InboundSettingsController());
  }

}