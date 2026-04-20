import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/services/api_services.dart';
import 'package:aitota_business/core/services/dio_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileController extends GetxController {
  // -----------------------------------------------------------------
  //  Loading & Controllers
  // -----------------------------------------------------------------
  var isLoading = true.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final cityController = TextEditingController();
  final businessNameController = TextEditingController();
  final pincodeController = TextEditingController();
  final addressController = TextEditingController();
  final gstController = TextEditingController();
  final panController = TextEditingController();
  final roleController = TextEditingController();

  // -----------------------------------------------------------------
  //  Change-trackers
  // -----------------------------------------------------------------
  var isNameChanged = false.obs;
  var isEmailChanged = false.obs;
  var isMobileNumberChanged = false.obs;
  var isCityChanged = false.obs;
  var isBusinessNameChanged = false.obs;
  var isPincodeChanged = false.obs;
  var isAddressChanged = false.obs;
  var isGstChanged = false.obs;
  var isPanChanged = false.obs;
  var isRoleChanged = false.obs;

  // -----------------------------------------------------------------
  //  Initial values
  // -----------------------------------------------------------------
  String initialName = '';
  String initialEmail = '';
  String initialMobileNumber = '';
  String initialCity = '';
  String initialBusinessName = '';
  String initialPincode = '';
  String initialAddress = '';
  String initialGst = '';
  String initialPan = '';
  String initialRole = '';

  // -----------------------------------------------------------------
  //  Role visibility flag – **true only for "client"**
  // -----------------------------------------------------------------
  var isClientRole = false.obs;

  // -----------------------------------------------------------------
  //  Services
  // -----------------------------------------------------------------
  final secureStorage = const FlutterSecureStorage();
  final ApiService apiService = ApiService(dio: DioClient().dio);

  // -----------------------------------------------------------------
  //  Lifecycle
  // -----------------------------------------------------------------
  @override
  void onInit() {
    super.onInit();
    loadProfileData();

    // Change listeners
    nameController.addListener(() => isNameChanged.value = nameController.text != initialName);
    emailController.addListener(() => isEmailChanged.value = emailController.text != initialEmail);
    mobileNumberController.addListener(() => isMobileNumberChanged.value = mobileNumberController.text != initialMobileNumber);
    cityController.addListener(() => isCityChanged.value = cityController.text != initialCity);
    businessNameController.addListener(() => isBusinessNameChanged.value = businessNameController.text != initialBusinessName);
    pincodeController.addListener(() => isPincodeChanged.value = pincodeController.text != initialPincode);
    addressController.addListener(() => isAddressChanged.value = addressController.text != initialAddress);
    gstController.addListener(() => isGstChanged.value = gstController.text != initialGst);
    panController.addListener(() => isPanChanged.value = panController.text != initialPan);
    roleController.addListener(() => isRoleChanged.value = roleController.text != initialRole);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    mobileNumberController.dispose();
    cityController.dispose();
    businessNameController.dispose();
    pincodeController.dispose();
    addressController.dispose();
    gstController.dispose();
    panController.dispose();
    roleController.dispose();
    super.onClose();
  }

  // -----------------------------------------------------------------
  //  Load profile
  // -----------------------------------------------------------------
  Future<void> loadProfileData() async {
    try {
      isLoading.value = true;
      final profileId = await secureStorage.read(key: Constants.profileId);
      if (profileId == null || profileId.isEmpty) return;

      final response = await apiService.getUserProfile(profileId);
      if (response.success == true && response.profile != null) {
        final profile = response.profile!;
        final role = (response.role ?? '').trim();   // <-- trim any spaces

        // Populate fields
        nameController.text = initialName = profile.contactName ?? '';
        emailController.text = initialEmail = response.email ?? '';
        mobileNumberController.text = initialMobileNumber = profile.contactNumber ?? '';
        cityController.text = initialCity = profile.city ?? '';
        businessNameController.text = initialBusinessName = profile.businessName ?? '';
        pincodeController.text = initialPincode = profile.pincode ?? '';
        addressController.text = initialAddress = profile.address ?? '';
        gstController.text = initialGst = profile.gstNo ?? '';
        panController.text = initialPan = profile.panNo ?? '';
        roleController.text = initialRole = role;

        // **CRITICAL** – set flag **exactly** to true only for "client"
        isClientRole.value = role.toLowerCase() == 'client';
        print('Role from API: "$role" → showRoleField = ${isClientRole.value}');
      }
    } catch (e) {
      print('Profile load error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // -----------------------------------------------------------------
  //  Generic field updater (no snackbar)
  // -----------------------------------------------------------------
  Future<void> _updateField(
    String field,
    String value,
    RxBool isChanged,
    VoidCallback updateInitial,
  ) async {
    try {
      final profileId = await secureStorage.read(key: Constants.profileId);
      if (profileId == null) return;

      final response = await apiService.updateUserProfile(profileId, {field: value});
      if (response.success == true) {
        isChanged.value = false;
        updateInitial();
        if (field == 'role') {
          isClientRole.value = value.trim().toLowerCase() == 'client';
        }
      } else {
        print('Update $field failed');
      }
    } catch (e) {
      print('Update $field error: $e');
    }
  }

  // -----------------------------------------------------------------
  //  Individual updaters
  // -----------------------------------------------------------------
  Future<void> updateName(String v) => _updateField('contactName', v, isNameChanged, () => initialName = v);
  Future<void> updateMobile(String v) async {
    if (!RegExp(r'^\d{10}$').hasMatch(v)) return;
    await _updateField('contactNumber', v, isMobileNumberChanged, () => initialMobileNumber = v);
  }
  Future<void> updateCity(String v) => _updateField('city', v, isCityChanged, () => initialCity = v);
  Future<void> updateBusinessName(String v) => _updateField('businessName', v, isBusinessNameChanged, () => initialBusinessName = v);
  Future<void> updatePincode(String v) async {
    if (!RegExp(r'^\d{6}$').hasMatch(v)) return;
    await _updateField('pincode', v, isPincodeChanged, () => initialPincode = v);
  }
  Future<void> updateAddress(String v) => _updateField('address', v, isAddressChanged, () => initialAddress = v);
  Future<void> updateRole(String v) => _updateField('role', v, isRoleChanged, () {
        initialRole = v;
        isClientRole.value = v.trim().toLowerCase() == 'client';
      });

  // -----------------------------------------------------------------
  //  Bulk save
  // -----------------------------------------------------------------
  Future<void> saveAllChanges() async {
    try {
      final profileId = await secureStorage.read(key: Constants.profileId);
      if (profileId == null) return;

      final Map<String, dynamic> payload = {};
      if (isNameChanged.value) payload['contactName'] = nameController.text;
      if (isEmailChanged.value) payload['email'] = emailController.text;
      if (isMobileNumberChanged.value) payload['contactNumber'] = mobileNumberController.text;
      if (isCityChanged.value) payload['city'] = cityController.text;
      if (isBusinessNameChanged.value) payload['businessName'] = businessNameController.text;
      if (isPincodeChanged.value) payload['pincode'] = pincodeController.text;
      if (isAddressChanged.value) payload['address'] = addressController.text;
      if (isPanChanged.value) payload['panNo'] = panController.text;
      if (isGstChanged.value) payload['gstNo'] = gstController.text;
      if (isRoleChanged.value && isClientRole.value) payload['role'] = roleController.text;

      if (payload.isEmpty) return;

      final response = await apiService.updateUserProfile(profileId, payload);
      if (response.success == true) {
        // update initials
        if (payload.containsKey('contactName')) initialName = nameController.text;
        if (payload.containsKey('contactNumber')) initialMobileNumber = mobileNumberController.text;
        if (payload.containsKey('city')) initialCity = cityController.text;
        if (payload.containsKey('businessName')) initialBusinessName = businessNameController.text;
        if (payload.containsKey('pincode')) initialPincode = pincodeController.text;
        if (payload.containsKey('address')) initialAddress = addressController.text;
        if (payload.containsKey('role')) {
          initialRole = roleController.text;
          isClientRole.value = roleController.text.trim().toLowerCase() == 'client';
        }

        // reset flags
        isNameChanged.value = false;
        isMobileNumberChanged.value = false;
        isCityChanged.value = false;
        isBusinessNameChanged.value = false;
        isPincodeChanged.value = false;
        isAddressChanged.value = false;
        isRoleChanged.value = false;
      } else {
        print('Bulk save failed');
      }
    } catch (e) {
      print('Bulk save error: $e');
    }
  }
}