import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/import_file/controller/import_file_controller.dart';

class ImportFileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ImportFileController());
  }
  
}