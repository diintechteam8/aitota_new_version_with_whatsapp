import 'package:aitota_business/core/app-export.dart';

import '../add_contact/controller/add_contact_controller.dart';
import '../group/controller/contact_group_controller.dart';

class OutboundContactController extends GetxController {
  // Optional: Add Rx variable to track current tab index
  var currentTabIndex = 0.obs;

  // Optional: Method to handle tab changes
  void changeTabIndex(int index) {
    currentTabIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    Get.find<AddContactController>();
    Get.find<ContactGroupController>();
  }

  @override
  void onClose() {
    // Add any cleanup logic here
    super.onClose();
  }
}