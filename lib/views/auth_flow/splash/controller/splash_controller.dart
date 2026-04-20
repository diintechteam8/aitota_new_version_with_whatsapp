import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../../../../core/app-export.dart';
import '../../../../core/services/role_provider.dart';
import '../../../../routes/app_routes.dart';

class SplashController extends GetxController with WidgetsBindingObserver {
  final _storage = const FlutterSecureStorage();
  bool _checking = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    checkSessionAndNavigate();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_checking) {
      checkSessionAndNavigate();
    }
  }

  Future<void> checkSessionAndNavigate() async {
    if (_checking) return;
    _checking = true;

    try {
      await Future.delayed(const Duration(milliseconds: 1200));

      final token = await _storage.read(key: Constants.token);
      final isLoggedIn = (await _storage.read(key: 'isLoggedIn')) == 'true';

      // ✅ Check for pending Auth Flow step (Persistence)
      final lastStep = await _storage.read(key: Constants.lastAuthStep);
      if (lastStep != null && lastStep.isNotEmpty) {
        print('--- Resuming Auth Flow at: $lastStep ---');
        final rawData = await _storage.read(key: Constants.lastAuthData);
        Map<String, dynamic> arguments = {};
        if (rawData != null && rawData.isNotEmpty) {
          try {
            arguments = jsonDecode(rawData);
          } catch (e) {
            print('Error decoding auth data: $e');
          }
        }
        Get.offAllNamed(lastStep, arguments: arguments);
        return;
      }

      if (token == null || token.isEmpty || !isLoggedIn) {
        print('SplashController - Navigating to loginScreen. Reason:');
        print('  -> Token exists: ${token != null && token.isNotEmpty}');
        print('  -> Token value: $token');
        print('  -> IsLoggedIn: $isLoggedIn');
        Get.offAllNamed(AppRoutes.loginScreen);
        return;
      }

      // Load role **synchronously** and push into provider
      final rawRole = await _storage.read(key: 'userRole');
      Get.find<RoleProvider>().setRole(rawRole);

      // ✅ Read profile completion status
      final isProfileCompleted = GetStorage().read(Constants.isProfileCompleted) ?? false;

      if (!isProfileCompleted) {
        print('SplashController - Profile incomplete, navigating to complete profile');
        Get.offAllNamed(AppRoutes.compeletProfileScreen);
        return;
      }

      // ✅ Role-Based Navigation from Splash
      if (rawRole == 'admin') {
        print('SplashController - Admin detected, navigating to admin clients');
        Get.offAllNamed(AppRoutes.adminClientsScreen);
      } else {
        Get.offAllNamed(AppRoutes.bottomBarScreen);
      }
    } catch (e, s) {
      debugPrint('Splash error: $e\n$s');
      Get.offAllNamed(AppRoutes.loginScreen);
    } finally {
      _checking = false;
    }
  }
}
