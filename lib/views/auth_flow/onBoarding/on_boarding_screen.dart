import 'package:aitota_business/core/utils/widgets/app_widgets/custom_button.dart'
    show CustomButton, ButtonVariant, ButtonShape;
import '../../../core/app-export.dart';
import 'controller/on_boarding_controller.dart';

class OnBoardingScreen extends GetView<OnboardingController> {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.homeBackgroundColor,
        body: Stack(
          children: [
            // Page View with Parallax Effect
            PageView.builder(
              controller: controller.pageController,
              itemCount: controller.pages.length,
              onPageChanged: controller.onPageChanged,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: controller.pageController,
                  builder: (context, child) {
                    double pageOffset = 0;
                    if (controller.pageController.position.haveDimensions) {
                      pageOffset = controller.pageController.page! - index;
                    }
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(controller.pages[index]["image"]),
                          fit: BoxFit.fill, // Changed to coverAspect to prevent stretching
                          // alignment: FractionalOffset(
                          //   0.5 + (pageOffset * 0.3),
                          //   0.5,
                          // ),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // Bottom Controls
            Positioned(
              bottom: 40.h,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      // Page Indicator
                      Obx(
                            () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            controller.pages.length,
                                (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              width: controller.currentPage.value == index
                                  ? 24.w
                                  : 8.w,
                              height: 8.h,
                              decoration: BoxDecoration(
                                color: controller.currentPage.value == index
                                    ? ColorConstants.white
                                    : ColorConstants.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(4.r),
                                boxShadow:
                                controller.currentPage.value == index
                                    ? [
                                  BoxShadow(
                                    color: ColorConstants.appThemeColor
                                        .withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ]
                                    : null,
                              ),
                            ),
                          ),
                        ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Empty space for balance
                          SizedBox(width: 60.w),

                          // Next Button (Circular with Right Arrow or Checkmark)
                          Obx(
                                () => CustomButton(
                              onTap: controller.nextPage,
                              variant: ButtonVariant.FillActive,
                              shape: ButtonShape.Circle,
                              width: 60.w,
                              height: 60.h,
                              child: Icon(
                                controller.currentPage.value ==
                                    controller.pages.length - 1
                                    ? Icons.check
                                    : Icons.arrow_forward,
                                color: ColorConstants.white,
                                size: 24.sp,
                              ),
                            ).animate().scale(
                              duration: 700.ms,
                              curve: Curves.easeOutQuad,
                              delay: 400.ms,
                            ),
                          ),

                          // Skip Button (Moved to the right)
                          Obx(
                                () => controller.currentPage.value !=
                                controller.pages.length - 1
                                ? TextButton(
                              onPressed: controller.skipToEnd,
                              child: Text(
                                "Skip",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorConstants.white
                                      .withOpacity(0.8),
                                  fontFamily: AppFonts.poppins,
                                ),
                              ),
                            ).animate().fadeIn(
                              duration: 600.ms,
                              delay: 350.ms,
                            )
                                : SizedBox(width: 60.w),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}