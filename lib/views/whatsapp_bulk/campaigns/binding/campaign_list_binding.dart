import 'package:get/get.dart';
import '../controller/campaign_list_controller.dart';
import '../../../../../core/services/api_repository.dart';

class CampaignListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CampaignListController>(
      () => CampaignListController(
        apiRepository: Get.find<ApiRepository>(),
      ),
    );
  }
}
