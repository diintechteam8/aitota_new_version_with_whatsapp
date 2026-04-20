import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/services/api_services.dart';
import 'package:aitota_business/core/services/dio_client.dart';
import '../../../../../../data/model/inbound/inbound_lead_conversations_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';

class InboundLeadsDetailController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final leads = <LeadItem>[].obs;
  final isLoading = false.obs;
  String status = 'All';

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments as Map<String, dynamic>;
      print("ReceivedArgumetn:${args.toString()}");
      status = args['status'] ?? 'All';
      leads.assignAll((args['leads'] as List<dynamic>).cast<LeadItem>());
    }
  }

}