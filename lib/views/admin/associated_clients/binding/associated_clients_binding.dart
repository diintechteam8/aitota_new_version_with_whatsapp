import 'package:get/get.dart';
import '../controller/associated_clients_controller.dart';

class AssociatedClientsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssociatedClientsController>(
        () => AssociatedClientsController());
  }
}
