import 'package:get/get.dart';
import '../../../../../../data/model/outbound/outbound_leads_model.dart';

class OutboundLeadsDetailController extends GetxController {
  final leads = <LeadItem>[].obs;
  final isLoading = false.obs;
  String status = 'All';

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments as Map<String, dynamic>;
      status = args['status'] ?? 'All';
      leads.assignAll((args['leads'] as List<dynamic>).cast<LeadItem>());
    }
  }
}