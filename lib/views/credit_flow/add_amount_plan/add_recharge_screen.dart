import '../../../core/app-export.dart';
import 'controller/add_recharge_controller.dart';

class AddRechargeScreen extends GetView<AddRechargeController> {
  const AddRechargeScreen({super.key});

  static const primaryColor = Color(0xffe64d53);
  static const accentGreen = Color(0xFF22C55E);
  static const cardBorder = Color(0x1A000000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: CustomAppBar(
        title: "Choose Your Plan",
        titleStyle: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        showBackButton: true,
        onTapBack: () => Get.back(),
      ),
      body: SafeArea(
        top: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(primaryColor),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.only(
                left: 16.w, right: 16.w, top: 12.h, bottom: 12.h),
            itemCount: controller.plans.length,
            itemBuilder: (context, index) {
              final plan = controller.plans[index];

              return Obx(() {
                final isSelected = controller.selectedIndex.value == index;

                return GestureDetector(
                  onTap: () {
                    print("Card tapped at index: $index");
                    controller.selectPlan(index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? accentGreen : cardBorder,
                        width: isSelected ? 2.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? accentGreen.withOpacity(0.15)
                              : Colors.black.withOpacity(0.08),
                          blurRadius: isSelected ? 12 : 8,
                          offset: const Offset(0, 4),
                          spreadRadius: isSelected ? 2 : 0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Top Row (credits + plan name)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${plan.credits}",
                              style: const TextStyle(
                                fontFamily: AppFonts.poppins,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Credits",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? accentGreen.withOpacity(0.15)
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? accentGreen
                                      : Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                plan.planName,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? accentGreen
                                      : Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        /// Price Row
                        Row(
                          children: [
                            Text(
                              "₹${plan.mrp}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "₹${plan.offerPrice}",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: primaryColor,
                              ),
                            ),
                            if (plan.includeGST) ...[
                              const SizedBox(width: 2),
                              Text(
                                "+GST",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                            if (plan.bonusCredits > 0) ...[
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.deepPurple.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  "+${plan.bonusCredits} Bonus",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 16),

                        /// Benefits Section
                        Row(
                          children: [
                            Text(
                              "Benefits:",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            Obx(() {
                              final isExpanded =
                                  controller.expandedCards[index] ?? false;
                              return GestureDetector(
                                onTap: () => controller.toggleExpanded(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    isExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    size: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                        const SizedBox(height: 8),

                        Obx(() {
                          final isExpanded =
                              controller.expandedCards[index] ?? false;
                          final featuresToShow = isExpanded
                              ? plan.features
                              : plan.features.take(2).toList();

                          return Column(
                            children: featuresToShow
                                .map((feature) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color:
                                                  accentGreen.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.check_circle,
                                              size: 16,
                                              color: accentGreen,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              feature,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          );
                        }),

                        if (!(controller.expandedCards[index] ?? false) &&
                            plan.features.length > 2) ...[
                          const SizedBox(height: 8),
                          Text(
                            "Tap to see ${plan.features.length - 2} more benefits",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        /// Selection indicator
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? accentGreen.withOpacity(0.1)
                                : Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  isSelected ? accentGreen : Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                size: 18,
                                color:
                                    isSelected ? accentGreen : Colors.grey[400],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isSelected ? "Selected Plan" : "Select This Plan",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? accentGreen
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          );
        }),
      ),
      bottomNavigationBar: Obx(() {
        final hasSelection = controller.selectedIndex.value >= 0;
        final selectedPlan = hasSelection
            ? controller.plans[controller.selectedIndex.value]
            : null;

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 15,
                offset: Offset(0, -6),
              ),
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor:
              hasSelection ? primaryColor : const Color(0xFFCBD5E1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: controller.isLoading.value || !hasSelection
                ? null
                : () {
              controller.initiatePayment(context: context);
            },
            child: Text(
              hasSelection
                  ? "Pay ₹${selectedPlan!.offerPrice}"
                  : "Select a Plan to Continue",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        );
      }),
    );
  }
}