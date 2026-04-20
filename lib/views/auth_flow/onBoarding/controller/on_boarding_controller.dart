import 'package:aitota_business/routes/app_routes.dart';
import '../../../../core/app-export.dart';


class OnboardingController extends GetxController {
  var currentPage = 0.obs;
  late PageController pageController;
  final GetStorage storage = GetStorage();

  final List<Map<String, dynamic>> pages = [
    {
      "image": ImageConstant.onboarding1,
      "title": "Welcome to Aitota",
      "subtitle": "Discover a world of opportunities with our platform"
    },
    {
      "image": ImageConstant.onboarding2,
      "title": "Connect & Grow",
      "subtitle": "Build your network and expand your business"
    },
    {
      "image": ImageConstant.onboarding3,
      "title": "Get Started Now",
      "subtitle": "Join our community and start your journey"
    },
  ];

  @override
  void onInit() {
    pageController = PageController();
    super.onInit();
  }

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutQuint,
      );
    } else {
      // Mark onboarding as completed
      storage.write(Constants.isOnboardingCompleted, true);
      // Navigate to LoginScreen
      Get.offAllNamed(
            AppRoutes.loginScreen, // Instantiate LoginScreen
      );
    }
  }

  void skipToEnd() {
    pageController.jumpToPage(pages.length - 1);
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}