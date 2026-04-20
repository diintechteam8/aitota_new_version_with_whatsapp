import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/data/model/inbound/inbound_lead_conversations_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class InboundLeadStatusDetailController extends GetxController {
  final Rx<LeadItem?> lead = Rx<LeadItem?>(null);
  final RxString status = ''.obs;
  final RxBool isPlaying = false.obs;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments as Map<String, dynamic>;
      lead.value = args['lead'] as LeadItem?;
      status.value = args['status'] as String? ?? 'Unknown';
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  void toggleAudio() async {
    if (lead.value?.transcript == null || lead.value?.transcript == 'N/A') {
      return;
    }

    try {
      if (isPlaying.value) {
        await _audioPlayer.pause();
        isPlaying.value = false;
      } else {
        // Assuming transcript contains an audio URL or path
        await _audioPlayer.play(UrlSource(lead.value!.transcript!));
        isPlaying.value = true;
        _audioPlayer.onPlayerComplete.listen((event) {
          isPlaying.value = false;
        });
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}