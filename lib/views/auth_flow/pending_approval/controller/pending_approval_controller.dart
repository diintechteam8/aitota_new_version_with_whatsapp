import 'dart:async';
import 'package:aitota_business/routes/app_routes.dart';
import '../../../../core/app-export.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../data/model/auth_models/pending_approval_model.dart';

class ApprovalPendingController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Timer? _pollingTimer;
  final Rx<PendingApprovalModel?> pendingApproval =
      Rx<PendingApprovalModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingApproval();
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      fetchPendingApproval();
    });
  }

  Future<void> fetchPendingApproval() async {
    try {
      isLoading.value = true;

      final result = await apiService.getPendingApproval();
      pendingApproval.value = result;

      if (result.success == true && result.data?.isApproved == true) {
        _pollingTimer?.cancel();
        await secureStorage.write(key: 'isLoggedIn', value: 'true');
        Get.offAllNamed(AppRoutes.bottomBarScreen);
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }

  void onBackToHome() {
    _pollingTimer?.cancel();
    Get.offAllNamed(AppRoutes.loginScreen);
  }
}
