import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/routes/app_routes.dart';
import '../../../../../../data/model/inbound/inbound_lead_conversations_model.dart';

class InboundReportStatusController extends GetxController {
  late final String title;
  final leads = <LeadItem>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>?;
    print('Arguments received: $arguments');
    title = arguments?['title'] ?? 'Details';

    final LeadCategory? leadCategory = arguments?['leadCategory'] as LeadCategory?;
    _loadLeads(leadCategory);
  }

  void _loadLeads(LeadCategory? leadCategory) {
    leads.clear();
    if (leadCategory != null && leadCategory.data != null) {
      leads.assignAll(leadCategory.data!);
    }
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    final arguments = Get.arguments as Map<String, dynamic>?;
    final LeadCategory? leadCategory = arguments?['leadCategory'] as LeadCategory?;
    _loadLeads(leadCategory);
    isLoading.value = false;
  }

  void onItemTap(LeadItem lead) {
    final arguments = Get.arguments as Map<String, dynamic>?;
    final LeadCategory? leadCategory = arguments?['leadCategory'] as LeadCategory?;
    Get.toNamed(
      AppRoutes.inboundReportsStatusDetailScreen,
      arguments: {
        'lead': lead,
        'leadCategory': leadCategory,
      },
    );
  }
}