import 'package:get/get.dart';

class WhatsAppNavController extends GetxController {
  RxInt selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  void resetToIndex(int index) {
    selectedIndex.value = index;
  }
}
