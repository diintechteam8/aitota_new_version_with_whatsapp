import 'package:aitota_business/core/app-export.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../../../../data/model/outbound/outbound_leads_model.dart';

class OutboundReportStatusDetailController extends GetxController {
  final lead = Rxn<LeadItem>();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final isPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      lead.value = arguments['lead'] as LeadItem?;
      print("Received lead: ${lead.value?.toJson()}");
    }
  }

  void toggleAudio() async {
    // Since audioPath is not available in LeadItem, disable audio playback for now
    // If audioPath is added to the model later, update this logic
    print("Audio playback not supported: audioPath not available in LeadItem");
    return;
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}