import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/more_flow/more_screen/help&support/controller/help_support_controller.dart';

class HelpSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HelpSupportController());
  }

}