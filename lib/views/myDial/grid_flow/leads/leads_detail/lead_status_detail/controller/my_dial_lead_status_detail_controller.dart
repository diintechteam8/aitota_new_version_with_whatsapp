import 'package:aitota_business/core/app-export.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import '../../../../../../../data/model/myDial/my_dial_leads_model.dart';

class MyDialLeadStatusDetailController extends GetxController {
  final Rx<LeadData?> lead = Rx<LeadData?>(null);
  final RxString actualStatus = ''.obs;
  final RxBool isPlaying = false.obs;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments as Map<String, dynamic>;

      lead.value = args['lead'] as LeadData?;
      // Use actual leadStatus from LeadData, NOT group title
      actualStatus.value = lead.value?.leadStatus ?? 'Unknown';
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

}