import 'package:aitota_business/core/app-export.dart' hide Data;
import 'package:audioplayers/audioplayers.dart';
import '../../../../../../data/model/inbound/inbound_conversation_model.dart';

class InboundConversationsDetailController extends GetxController {
  final conversation = Rxn<InboundConversationData>();
  final clientName = Rxn<ClientName>(); // Store clientName
  final AudioPlayer _audioPlayer = AudioPlayer();
  final isPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      conversation.value = Get.arguments['conversation'] as InboundConversationData?;
      clientName.value = Get.arguments['clientName'] as ClientName?;
    }
  }

  void toggleAudio() async {
    if (conversation.value?.transcript == null || conversation.value!.transcript == 'N/A') return;

    if (isPlaying.value) {
      await _audioPlayer.pause();
      isPlaying.value = false;
    } else {
      // Assuming transcript might contain the audio path or URL
      await _audioPlayer.play(DeviceFileSource(conversation.value!.transcript!));
      isPlaying.value = true;
    }

    _audioPlayer.onPlayerComplete.listen((event) {
      isPlaying.value = false;
    });
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}