import 'package:get/get.dart';
import '../../../../../core/app-export.dart';
import '../../../../../core/services/api_repository.dart';
import '../../../../../data/model/whatsapp_bulk/whats_ai_campaign_model.dart';
import '../../../../../routes/app_routes.dart';

class CampaignListController extends GetxController {
  final ApiRepository apiRepository;

  CampaignListController({required this.apiRepository});

  var campaigns = <WhatsAiCampaign>[].obs;
  var isLoading = false.obs;
  var errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchCampaigns();
  }

  Future<void> fetchCampaigns() async {
    isLoading.value = true;
    errorMessage.value = "";
    try {
      final response = await apiRepository.getWhatsAiCampaigns();
      if (response.success == true && response.data?.campaigns != null) {
        campaigns.value = response.data!.campaigns!;
      } else {
        errorMessage.value = response.message ?? "Failed to load campaigns";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void createNewCampaign() {
    Get.toNamed(AppRoutes.addOutboundCampaignScreen);
  }
}
