import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/services/api_services.dart';
import 'package:aitota_business/core/services/dio_client.dart';
import '../../../../../../data/model/myDial/my_dial_leads_model.dart';

class MyDialLeadsDetailController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final leads = <LeadData>[].obs;
  final isLoading = false.obs;
  String status = 'All';

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments as Map<String, dynamic>;
      status = args['status'] ?? 'All';
      if (args['leads'] is List) {
        leads.assignAll((args['leads'] as List<dynamic>).cast<LeadData>());
      } else {
        leads.assignAll([]);
        print('Error: Leads argument is not a list, received: ${args['leads']}');
      }
    } else {
      print('Error: No arguments provided to MyDialLeadsDetailController');
    }
  }
}