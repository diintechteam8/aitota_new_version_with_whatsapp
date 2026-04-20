import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/inbound_icons_flow/calendar/controller/inbound_calendar_controller.dart';

class InboundCalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InboundCalendarController());
  }
}


