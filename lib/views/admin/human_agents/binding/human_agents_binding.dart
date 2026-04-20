import 'package:get/get.dart';
import '../controller/human_agents_controller.dart';

class HumanAgentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HumanAgentsController>(() => HumanAgentsController());
  }
}
