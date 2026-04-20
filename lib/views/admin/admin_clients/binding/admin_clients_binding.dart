import 'package:get/get.dart';
import '../controller/admin_clients_controller.dart';

class AdminClientsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminClientsController>(() => AdminClientsController());
  }
}
