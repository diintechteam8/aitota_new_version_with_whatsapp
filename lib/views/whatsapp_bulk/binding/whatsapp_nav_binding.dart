import 'package:get/get.dart';
import '../controller/whatsapp_nav_controller.dart';
import '../controller/whatsapp_bulk_controller.dart';
import '../audience/controller/audience_selection_controller.dart';
import '../inbox/controller/whatsapp_inbox_controller.dart';
import '../templates/controller/whatsapp_templates_controller.dart';

class WhatsAppNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WhatsAppNavController>(() => WhatsAppNavController());
    Get.lazyPut<WhatsAppBulkController>(() => WhatsAppBulkController());
    Get.lazyPut<AudienceSelectionController>(() => AudienceSelectionController());
    Get.lazyPut<WhatsAppInboxController>(() => WhatsAppInboxController());
    Get.lazyPut<WhatsAppTemplatesController>(() => WhatsAppTemplatesController());
  }
}
