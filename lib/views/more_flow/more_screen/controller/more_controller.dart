import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/app-export.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../core/services/role_provider.dart';
import '../../../../routes/app_routes.dart';
import '../../../../data/model/more/get_all_human_agents.dart';
import '../../../../data/model/more/get_team_clients.dart';

class MoreController extends GetxController {
  // User profile details
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userNumber = ''.obs;
  final RxString userRole = ''.obs;
  final RxString userProfileImage = ''.obs;
  final RxString businessName = ''.obs;

  // NEW: Client logo (only for client role)
  final RxString clientLogo = ''.obs;
  // Admin token availability (to show Admin's Clients section)
  final RxBool hasAdminToken = false.obs;

  final secureStorage = FlutterSecureStorage();
  final GoogleSignIn _googleSignIn = Get.find<GoogleSignIn>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final storage = GetStorage();

  // Loading flags
  final RxBool isProfileLoading = false.obs;
  final RxBool isCreditsLoading = false.obs;

  // UI helpers
  final RxString currentSection = ''.obs;
  final RxInt totalCredits = 0.obs;
  final RxInt tasksCompleted = 0.obs;

  // Role-based data
  final RxList<HumanAgent> humanAgents = <HumanAgent>[].obs;
  final RxList<Association> associatedClients = <Association>[].obs;
  final RxBool isHumanAgentsLoading = false.obs;
  final RxBool isAssociatedClientsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    userName.value = '';
    userEmail.value = '';
    userNumber.value = '';
    userRole.value = '';
    userProfileImage.value = '';
    businessName.value = '';
    clientLogo.value = ''; // init

    loadUserData();
  }

  void loadUserData() {
    isProfileLoading.value = true;
    isCreditsLoading.value = true;
    isHumanAgentsLoading.value = true;
    isAssociatedClientsLoading.value = true;

    print('🚀 MoreController - Starting to load user data...');
    Future.wait([
      _loadUserProfile(),
      _loadCreditsData(),
      _loadRoleBasedData(),
    ]).then((_) {
      humanAgents.refresh();
      associatedClients.refresh();
      print('✅ MoreController - All data loaded successfully ${userRole.value}');
    });
  }

  Future<void> _loadUserProfile() async {
    try {
      isProfileLoading.value = true;
      await fetchProfileData();
    } catch (e) {
      print('MoreController - Error in _loadUserProfile: $e');
    } finally {
      isProfileLoading.value = false;
    }
  }

  Future<void> _loadCreditsData() async {
    try {
      isCreditsLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      String? userId = storage.read(Constants.googleId);
      if (userId == null || userId.isEmpty) {
        storage.write(Constants.googleId, 'dummy_user_id');
      }
      totalCredits.value = 1000;
      tasksCompleted.value = 50;
    } catch (e) {
      print('MoreController - Error in _loadCreditsData: $e');
    } finally {
      isCreditsLoading.value = false;
    }
  }

  Future<void> fetchProfileData() async {
    try {
      String? profileId = await secureStorage.read(key: Constants.profileId);
      if (profileId == null || profileId.isEmpty) {
        throw Exception("No user ID found");
      }

      print('📡 MoreController - Fetching Profile Data for ID: $profileId');
      final response = await apiService.getUserProfile(profileId);

      if (response.success == true && response.profile != null) {
        print('✅ MoreController - Profile Data received: ${response.profile?.businessName}');
        userEmail.value = response.email ?? '';
        userName.value = response.profile?.contactName ?? '';
        userNumber.value = response.profile?.contactNumber ?? '';
        userRole.value = response.role ?? '';

        // ---- NEW: Load clientLogo only for client ----
        if (userRole.value == 'client') {
          clientLogo.value = response.profile?.clientLogo ?? '';
          print('MoreController - clientLogo: ${clientLogo.value}');
        } else {
          clientLogo.value = '';
        }

        // Refresh all
        businessName.refresh();
        userEmail.refresh();
        userName.refresh();
        userNumber.refresh();
        userRole.refresh();
        clientLogo.refresh();

        Get.find<RoleProvider>().setRole(userRole.value);

        // Load admin token availability for UI
        final bool flag = storage.read(Constants.hasAdminToken) ?? false;
        hasAdminToken.value = flag;
      } else {
        throw Exception("Failed to fetch user profile");
      }
    } catch (e) {
      print('MoreController - Error in fetchProfileData: $e');
      rethrow;
    }
  }

  Future<void> _loadRoleBasedData() async {
    try {
      if (userRole.value.isEmpty) {
        await Future.doWhile(() async {
          await Future.delayed(const Duration(milliseconds: 100));
          return userRole.value.isEmpty && isProfileLoading.value;
        });
      }

      if (userRole.value == 'client') {
        await _loadHumanAgents();
      } else if (userRole.value == 'executive' ||
          userRole.value == 'humanAgent') {
        await _loadAssociatedClients();
      }
    } catch (e) {
      print('MoreController - Error in _loadRoleBasedData: $e');
    } finally {
      isHumanAgentsLoading.value = false;
      isAssociatedClientsLoading.value = false;
    }
  }

  Future<void> _loadHumanAgents() async {
    try {
      print('📡 MoreController - Fetching Human Agents List...');
      isHumanAgentsLoading.value = true;
      final response = await apiService.getHumanAgents();
      if (response.success == true && response.data != null) {
        print('✅ MoreController - Received ${response.data!.length} Human Agents');
        humanAgents.assignAll(response.data!);
      } else {
        humanAgents.clear();
      }
    } catch (e) {
      humanAgents.clear();
    } finally {
      isHumanAgentsLoading.value = false;
      humanAgents.refresh();
    }
  }

  Future<void> _loadAssociatedClients() async {
    try {
      print('📡 MoreController - Fetching Associated Clients List...');
      isAssociatedClientsLoading.value = true;
      final response = await apiService.getAssociatedClients();
      if (response.success == true && response.associations != null) {
        print('✅ MoreController - Received ${response.associations!.length} Associated Clients');
        associatedClients.assignAll(response.associations!);
      } else {
        associatedClients.clear();
      }
    } catch (e) {
      associatedClients.clear();
    } finally {
      isAssociatedClientsLoading.value = false;
      associatedClients.refresh();
    }
  }

  void refreshSettings() {
    loadUserData();
  }

  void onProfileInfoTap() {
    currentSection.value = 'Profile Info';
    Get.toNamed(AppRoutes.profileScreen);
  }

  void onHelpSupportTap() {
    currentSection.value = 'Help & Support';
    Get.toNamed(AppRoutes.helpSupportScreen);
  }

  void onHumanAgentsTap() {
    Get.toNamed(AppRoutes.humanAgentsScreen);
  }

  void onAssociatedClientsTap() {
    Get.toNamed(AppRoutes.associatedClientsScreen);
  }

  void onLogoutTap() {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: ColorConstants.white,
      builder: (BuildContext context) {
        final padding = MediaQuery.of(context).padding;
        return Padding(
          padding: EdgeInsets.only(bottom: padding.bottom, left: 16.w, right: 16.w, top: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout,
                  size: 25.w, color: ColorConstants.appThemeColor),
              const SizedBox(height: 12),
              Text(
                "Are you sure you want to logout?",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.poppins,
                  color: ColorConstants.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "You will need to log in again to continue using the app.",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: AppFonts.poppins,
                  color: ColorConstants.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: ColorConstants.lightGrey),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 14.sp,
                          color: ColorConstants.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.appThemeColor,
                        foregroundColor: ColorConstants.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        await logoutUser();
                      },
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
            ],
          ),
        );
      },
    );
  }

  Future<void> logoutUser() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await storage.erase();
      await secureStorage.deleteAll();

      // Reset all
      userName.value = '';
      userEmail.value = '';
      userNumber.value = '';
      userRole.value = '';
      userProfileImage.value = '';
      businessName.value = '';
      clientLogo.value = '';
      totalCredits.value = 0;
      tasksCompleted.value = 0;
      currentSection.value = '';
      humanAgents.clear();
      associatedClients.clear();

      final storage1 = const FlutterSecureStorage();
      await storage1.write(key: 'isLoggedIn', value: 'false');

      Get.offAllNamed(AppRoutes.loginScreen);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
