import 'package:get/get.dart';
import 'package:aitota_business/core/app-export.dart';
import '../../myDial/grid_flow/call_logs/calls/controller/calls_controller.dart';

class BottomBarController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxInt numberClick = 0.obs;
  Rx<DateTime> lastTime = DateTime.now().obs;
  DateTime? _lastTapTime;

  bool _hasUploaded = false; // ✅ ensures upload runs only once

  @override
  void onInit() {
    super.onInit();
    currentIndex.value = 0;

    // ✅ Upload call logs only once when BottomBar loads
    _uploadCallLogsOnce();
  }

  void _uploadCallLogsOnce() async {
    if (_hasUploaded) return;
    _hasUploaded = true;

    if (Get.isRegistered<CallsController>()) {
      try {
        print("📤 Uploading call logs from BottomBarController...");
        await Get.find<CallsController>().uploadCallLogs();
        print("✅ Call logs uploaded successfully (BottomBar init)");
      } catch (e) {
        print("❌ Failed to upload call logs: $e");
      }
    } else {
      print("⚠️ CallsController not found, skipping upload");
    }
  }

  void changeIndex(int index) {
    final now = DateTime.now();
    if (_lastTapTime != null &&
        now.difference(_lastTapTime!).inMilliseconds < 300) {
      return;
    }
    _lastTapTime = now;
    currentIndex.value = index;
  }

  void resetToHome() {
    changeIndex(0);
  }
}
