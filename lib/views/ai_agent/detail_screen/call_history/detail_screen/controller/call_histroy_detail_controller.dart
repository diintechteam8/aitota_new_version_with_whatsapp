import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/utils/snack_bar.dart';
import 'package:aitota_business/data/model/ai_agent/history_call_logs_model.dart';
import 'package:audioplayers/audioplayers.dart';


class CallHistoryDetailController extends GetxController {
  final log = Rxn<Logs>(); // Reactive Logs object, nullable
  final AudioPlayer _audioPlayer = AudioPlayer();
  final isPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    print("HistoryLogs:${arguments.toString()}");
    if (arguments != null && arguments is Logs) {
      log.value = arguments;

    } else {
      Get.back();
      customSnackBar(message: "No call log data provided", type: "E");
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  // Future<void> playAudio() async {
  //   if (log.value?.audioUrl == null) {
  //     customSnackBar(message: "No audio available for this call", type: "E");
  //     return;
  //   }
  //
  //   try {
  //     if (isPlaying.value) {
  //       await _audioPlayer.stop();
  //       isPlaying.value = false;
  //     } else {
  //       await _audioPlayer.setUrl(log.value!.audioUrl!);
  //       await _audioPlayer.play();
  //       isPlaying.value = true;
  //       _audioPlayer.playerStateStream.listen((state) {
  //         // if (state.processingState == ProcessingState.completed) {
  //         //   isPlaying.value = false;
  //         // }
  //       });
  //     }
  //   } catch (e) {
  //     customSnackBar(message: "Failed to play audio: $e", type: "E");
  //     isPlaying.value = false;
  //   }
  // }
}