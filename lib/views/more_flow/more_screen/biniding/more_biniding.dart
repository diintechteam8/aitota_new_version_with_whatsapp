import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/more_flow/more_screen/controller/more_controller.dart';

class UsersProfileBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => MoreController());
  }

}