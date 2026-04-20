import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/auth_flow/pending_approval/controller/pending_approval_controller.dart';

class ApprovalPendingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApprovalPendingController());
  }

}