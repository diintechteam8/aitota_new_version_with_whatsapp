// contact_detail_controller.dart
import 'package:aitota_business/core/app-export.dart';
import 'package:get/get.dart';

class ContactDetailController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxMap<String, dynamic> contact = <String, dynamic>{}.obs;
  dynamic rawContact;

  @override
  void onInit() {
    super.onInit();
    _receiveContactFromArguments();
  }

  void _receiveContactFromArguments() {
    final args = Get.arguments;

    debugPrint('CONTACT DETAIL - Raw args received: $args');

    if (args == null || args is! Map<String, dynamic>) {
      Get.snackbar('Error', 'No contact data');
      Get.back();
      return;
    }

    rawContact = args['rawContact'];

    // PRIORITY 1: Use contactMap if present (this comes from contact.toJson())
    if (args['contactMap'] != null && args['contactMap'] is Map<String, dynamic>) {
      final map = args['contactMap'] as Map<String, dynamic>;
      debugPrint('contactMap FOUND → dispositionCount = ${map['dispositionCount']}');
      contact.assignAll(map);
    }
    // PRIORITY 2: Fallback to the full args map (in case someone passed everything)
    else if (args.containsKey('dispositionCount') || args.containsKey('_id')) {
      debugPrint('Using full args as fallback (has dispositionCount)');
      contact.assignAll(args);
    }
    // PRIORITY 3: Worst case — use partial cardData
    else {
      debugPrint('Only partial data available');
      contact.assignAll(args);
    }

    // Ensure name
    if (contact['name'] == null || (contact['name'] as String).trim().isEmpty) {
      contact['name'] = 'Unnamed';
    }

    debugPrint('FINAL UI DATA → dispositionCount = ${contact['dispositionCount']}');
  }
}