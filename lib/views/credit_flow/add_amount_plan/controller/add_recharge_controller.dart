import 'package:aitota_business/core/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../data/model/payment/add_recharge_model.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';

class AddAmount {
  final String id;
  final String planName;
  final int credits;
  final int mrp;
  final int offerPrice;
  final int bonusCredits;
  final List<String> features;
  final bool includeGST; // New field to indicate if GST is included

  AddAmount({
    required this.id,
    required this.planName,
    required this.credits,
    required this.mrp,
    required this.offerPrice,
    required this.bonusCredits,
    required this.features,
    this.includeGST = true, // Default to true for existing plans
  });
}

class AppRoutes {
  static const String paymentSuccessfulScreen = '/payment_successful_screen';
  static const String paymentFailedScreen = '/payment_failed_screen';
}

class AddRechargeController extends GetxController {
  var isLoading = false.obs;
  var plans = <AddAmount>[].obs;
  var selectedIndex = (-1).obs;
  var expandedCards = <int, bool>{}.obs;
  final ApiService apiService = ApiService(dio: DioClient().dio);

  /// Cashfree App ID
  final String cashfreeAppId = "6629376f2a72c7bd17e5b5f8e4739266";

  @override
  void onInit() {
    super.onInit();
    loadStaticPlans();
    for (int i = 0; i < 4; i++) {
      // Updated to 4 due to new plan
      expandedCards[i] = false;
    }
  }

  void loadStaticPlans() {
    plans.value = [
      AddAmount(
        id: "basic",
        planName: "Basic",
        credits: 1000,
        mrp: 1000,
        offerPrice: 1180,
        bonusCredits: 0,
        features: [
          "Call Support",
          "WhatsApp Integration",
          "Email Notifications",
          "Basic Analytics"
        ],
      ),
      AddAmount(
        id: "professional",
        planName: "Professional",
        credits: 5000,
        mrp: 5000,
        offerPrice: 5900,
        bonusCredits: 500,
        features: [
          "Telegram Integration",
          "Advanced Analytics",
          "Priority Support",
          "500 Bonus Credits"
        ],
      ),
      AddAmount(
        id: "enterprise",
        planName: "Enterprise",
        credits: 10000,
        mrp: 10000,
        offerPrice: 11800,
        bonusCredits: 1000,
        features: [
          "Custom Integrations",
          "Dedicated Support",
          "Advanced Reporting",
          "1000 Bonus Credits"
        ],
      ),
      AddAmount(
        id: "test",
        planName: "Test Plan",
        credits: 100,
        mrp: 1,
        offerPrice: 1,
        bonusCredits: 0,
        features: ["Test Mode Access", "Basic Support"],
        includeGST: false, // No GST for test plan
      ),
    ];
  }

  void selectPlan(int index) => selectedIndex.value = index;
  void toggleExpanded(int index) =>
      expandedCards[index] = !(expandedCards[index] ?? false);

  /// Step 1: Call backend to create order
  Future<void> initiatePayment({required BuildContext context}) async {
    if (selectedIndex.value == -1) {
      return;
    }

    try {
      isLoading.value = true;
      final selectedPlan = plans[selectedIndex.value];

      final request = {
        "amount": selectedPlan.offerPrice,
        "plankey": selectedPlan.id,
      };

      print("AddResq:${request.toString()}");
      final AddRechargeModel response =
          await apiService.addRechargePlan(request);
      print("AddRes:${response.toString()}");
      print("Response success: ${response.success}");
      print("Response orderToken: ${response.orderToken}");
      print("Response orderId: ${response.orderId}");
      print("Response customerName: ${response.customerName}");
      print("Response customerEmail: ${response.customerEmail}");
      print("Response customerPhone: ${response.customerPhone}");

      if (response.success == true &&
          response.orderToken != null &&
          response.orderId != null) {
        print("Starting Cashfree payment with session: ${response.orderToken}");
        print("Order ID: ${response.orderId}");

        /// Step 2: Start Cashfree Payment
        await startCashfreePayment(
          sessionId: response.orderToken!,
          orderId: response.orderId!,
          customerName: response.customerName ?? "Customer",
          customerPhone: response.customerPhone ?? "9999999999",
          customerEmail: response.customerEmail ?? "test@example.com",
          selectedPlan: selectedPlan,
        );
      } else {
        customSnackBar(message: "Failed to create order", type: "E");
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Step 2: Start Cashfree SDK - Direct status handling without backend calls
  Future<void> startCashfreePayment({
    required String sessionId,
    required String orderId,
    required String customerName,
    required String customerPhone,
    required String customerEmail,
    required AddAmount selectedPlan,
  }) async {
    try {
      print("🚀 [${DateTime.now()}] STARTING CASHFREE PAYMENT 🚀");
      print("💡 [DEBUG] Session ID: $sessionId");
      print("💡 [DEBUG] Order ID: $orderId");
      print(
          "Customer Info => Name: $customerName, Phone: $customerPhone, Email: $customerEmail");

      // Step 1: Create Cashfree session
      CFSession session = CFSessionBuilder()
          .setOrderId(orderId)
          .setPaymentSessionId(sessionId)
          .setEnvironment(CFEnvironment.PRODUCTION)
          .build();

      // Step 2: Create Drop Checkout payment
      var dropCheckoutPayment =
          CFDropCheckoutPaymentBuilder().setSession(session).build();

      CFPaymentGatewayService cfPaymentGatewayService =
          CFPaymentGatewayService();

      // Step 3: Set callbacks - Direct Cashfree status handling
      cfPaymentGatewayService.setCallback(
        (orderId) async {
          try {
            print(
                "✅ [${DateTime.now()}] Payment successful for order: $orderId");
            print("🎯 [INFO] Navigating to success screen...");

            Get.back();

            Get.toNamed(
              AppRoutes.paymentSuccessfulScreen,
              arguments: {
                'plan': selectedPlan,
                'orderId': orderId,
                'customerName': customerName,
                'customerPhone': customerPhone,
                'customerEmail': customerEmail,
              },
            );

            print(
                "✅ [${DateTime.now()}] Successfully navigated to payment success screen");
          } catch (callbackError) {
            print(
                "❌ [${DateTime.now()}] Error in success callback: $callbackError");
            try {
              Get.back();
              Get.toNamed(
                AppRoutes.paymentSuccessfulScreen,
                arguments: {
                  'plan': selectedPlan,
                  'orderId': orderId,
                  'customerName': customerName,
                  'customerPhone': customerPhone,
                  'customerEmail': customerEmail,
                },
              );
            } catch (e) {
              throw Exception(e.toString());
            }
          }
        },
        (error, orderId) {
          try {
            print("❌ [${DateTime.now()}] Payment failed for order $orderId");
            print("Error code: ${error.getCode()}");
            print("Error message: ${error.getMessage()}");
            print("🎯 [INFO] Navigating to failure screen...");

            Get.back();

            Get.toNamed(
              AppRoutes.paymentFailedScreen,
              arguments: {
                'plan': selectedPlan,
                'orderId': orderId,
                'errorCode': error.getCode(),
                'errorMessage': error.getMessage(),
              },
            );

            print(
                "✅ [${DateTime.now()}] Successfully navigated to payment failed screen");
          } catch (callbackError) {
            print(
                "❌ [${DateTime.now()}] Error in failure callback: $callbackError");
            try {
              Get.back();
              Get.toNamed(
                AppRoutes.paymentFailedScreen,
                arguments: {
                  'plan': selectedPlan,
                  'orderId': orderId,
                  'errorCode': 'UNKNOWN',
                  'errorMessage': 'Payment failed with unknown error',
                },
              );
            } catch (e) {
              print("❌ [${DateTime.now()}] Navigation failed: $e");
            }
          }
        },
      );

      print("✅ [${DateTime.now()}] Callbacks set successfully");
      print("🚀 [INFO] Starting payment...");

      // Step 4: Start payment
      cfPaymentGatewayService.doPayment(dropCheckoutPayment);

      print("✅ [${DateTime.now()}] Payment initiated successfully");
    } catch (e, stackTrace) {
      print("❌ [${DateTime.now()}] Cashfree Error: $e");
      print("StackTrace: $stackTrace");

      Get.snackbar(
        "Payment Error",
        "Failed to initialize payment: $e",
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      Get.toNamed(
        AppRoutes.paymentFailedScreen,
        arguments: {
          'plan': selectedPlan,
          'orderId': orderId,
          'errorCode': 'SETUP_ERROR',
          'errorMessage': 'Failed to initialize payment: $e',
        },
      );
    }
  }
}
