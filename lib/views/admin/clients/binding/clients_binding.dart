import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/admin/clients/controller/clients_controller.dart';

class ClientsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ClientsController());
  }

}