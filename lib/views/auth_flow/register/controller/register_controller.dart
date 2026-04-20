import 'dart:convert';
import 'package:aitota_business/routes/app_routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/app-export.dart';
import '../../../../core/services/api_endpoints.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../../../data/model/auth_models/register_step3_model.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final GetStorage storage = GetStorage();
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final secureStorage = const FlutterSecureStorage();

  final businessNameController = TextEditingController();
  final businessTypeController = TextEditingController();
  final contactNameController = TextEditingController();
  final contactNumberController = TextEditingController();
  final pinCodeController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final websiteController = TextEditingController();
  final panCardController = TextEditingController();
  final gstController = TextEditingController();
  final annualTurnoverController = TextEditingController();
  final emailController = TextEditingController();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var selectedBusinessType = ''.obs;
  var selectedState = ''.obs;
  var selectedAnnualTurnover = ''.obs;
  var businessTypeSearchQuery = ''.obs;
  var stateSearchQuery = ''.obs;

  final List<String> businessTypes = [
    'Accounting Services', 'Advertising Agency', 'Airline Services', 'App Developers', 'Apparel & Clothing Store',
    'Architectural Firm', 'Art Gallery', 'Auto Dealership', 'Auto Repair Shop', 'Bakery', 'Banks & Financial Services',
    'Barbershop', 'Beauty Salon', 'Bookstore', 'BPO Services', 'Building Contractors', 'Café', 'Car Rental Services',
    'Catering Services', 'Cleaning Services', 'Coaching Center', 'Colleges & Universities', 'Community Center',
    'Computer Repair Services', 'Construction Company', 'Consulting Firm', 'Courier Services', 'Coworking Space',
    'Credit Card Services', 'Customer Support Center', 'Dance Academy', 'Data Entry Services', 'Daycare Services',
    'Dentist Clinic', 'Design Studio', 'Digital Marketing Agency', 'Doctors Clinic', 'Driving School',
    'E-commerce Store', 'Education & Training Institute', 'Electrician Services', 'Electronics Store',
    'Employment Agency', 'Event Management', 'Export & Import Business', 'Fabric Store', 'Fashion Boutique',
    'Financial Advisory', 'Fitness Center / Gym', 'Florist', 'Freelancer Services', 'Furniture Store',
    'Gas Agency', 'General Store', 'Government Helpline', 'Graphic Design Studio', 'Grocery Store',
    'Gym Equipment Provider', 'Healthcare & Clinic', 'Home Appliance Repair', 'Home Automation Service',
    'Home Tutor Service', 'Hospital', 'Hotel & Hospitality', 'HR Consultancy', 'HVAC Services',
    'Immigration Consultant', 'Industrial Supplier', 'Insurance Agency', 'Interior Design', 'Investment Firm',
    'IT Services & Support', 'Jewelry Store', 'Job Portal', 'Language Institute', 'Laundry Services',
    'Law Firm', 'Library', 'Loan Provider', 'Locksmith Services', 'Logistics & Delivery', 'Maintenance Services',
    'Makeup Artist', 'Manufacturing Unit', 'Marketing Consultancy', 'Matrimonial Services', 'Mobile Repair Shop',
    'NGO / Nonprofit', 'Nursing Home', 'Online Learning Platform', 'Online Retailer', 'Optician',
    'Packers and Movers', 'Painting Contractor', 'Pet Care Services', 'Pharmacy', 'Photography Studio',
    'Plumbing Services', 'Political Campaigns', 'Real Estate Agency', 'Recruitment Agency', 'Repair Services',
    'Restaurant & Café', 'Retail Grocery Store', 'Software Development', 'Tax Consultant',
    'Telecommunications Services', 'Transportation & Fleet Services', 'Travel Agency', 'Others',
  ];

  final List<String> states = [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh', 'Goa', 'Gujarat', 'Haryana',
    'Himachal Pradesh', 'Jharkhand', 'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur',
    'Meghalaya', 'Mizoram', 'Nagaland', 'Odisha', 'Punjab', 'Rajasthan', 'Sikkim', 'Tamil Nadu',
    'Telangana', 'Tripura', 'Uttar Pradesh', 'Uttarakhand', 'West Bengal', 'Andaman and Nicobar Islands',
    'Chandigarh', 'Dadra and Nagar Haveli and Daman and Diu', 'Delhi', 'Jammu and Kashmir', 'Ladakh',
    'Lakshadweep', 'Puducherry',
  ];

  final List<String> annualTurnoverRanges = [
    '0-50 Lakh', '50 Lakh-1 Cr', '1 Cr-5 Cr', '5 Cr-10 Cr', '10 Cr+',
  ];

  @override
  void onInit() {
    super.onInit();
    _prefillData();
  }

  Future<void> _prefillData() async {
    // 1. Try to get from arguments
    if (Get.arguments != null) {
      if (Get.arguments['email'] != null) {
        emailController.text = Get.arguments['email'];
      }
      if (Get.arguments['phone'] != null) {
        contactNumberController.text = Get.arguments['phone'];
      }
    }

    // 2. If still empty, try to get from secure storage (persistence)
    if (emailController.text.isEmpty || contactNumberController.text.isEmpty) {
      final rawData = await secureStorage.read(key: Constants.lastAuthData);
      if (rawData != null && rawData.isNotEmpty) {
        try {
          final data = jsonDecode(rawData);
          if (emailController.text.isEmpty && data['email'] != null) {
            emailController.text = data['email'];
          }
          if (contactNumberController.text.isEmpty && data['phone'] != null) {
            contactNumberController.text = data['phone'];
          }
        } catch (e) {
          print('Error decoding prefill data: $e');
        }
      }
    }
  }

  @override
  void onClose() {
    businessNameController.dispose();
    businessTypeController.dispose();
    contactNameController.dispose();
    contactNumberController.dispose();
    pinCodeController.dispose();
    stateController.dispose();
    cityController.dispose();
    websiteController.dispose();
    panCardController.dispose();
    gstController.dispose();
    annualTurnoverController.dispose();
    emailController.dispose();
    super.onClose();
  }

  void showBusinessTypeBottomSheet() {
    businessTypeSearchQuery.value = '';
    Get.bottomSheet(
      _buildBottomSheet(
        title: 'Select Business Type',
        items: businessTypes,
        selectedItem: selectedBusinessType,
        searchQuery: businessTypeSearchQuery,
        onItemSelected: (value) {
          selectedBusinessType.value = value;
          businessTypeController.text = value;
          Get.back();
        },
      ),
      isScrollControlled: true,
      backgroundColor: ColorConstants.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
    );
  }

  void showStateBottomSheet() {
    stateSearchQuery.value = '';
    Get.bottomSheet(
      _buildBottomSheet(
        title: 'Select State',
        items: states,
        selectedItem: selectedState,
        searchQuery: stateSearchQuery,
        onItemSelected: (value) {
          selectedState.value = value;
          stateController.text = value;
          Get.back();
        },
      ),
      isScrollControlled: true,
      backgroundColor: ColorConstants.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
    );
  }

  void showAnnualTurnoverBottomSheet() {
    Get.bottomSheet(
      _buildBottomSheet(
        title: 'Select Annual Turnover',
        items: annualTurnoverRanges,
        selectedItem: selectedAnnualTurnover,
        onItemSelected: (value) {
          selectedAnnualTurnover.value = value;
          annualTurnoverController.text = value;
          Get.back();
        },
      ),
      isScrollControlled: true,
      backgroundColor: ColorConstants.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
    );
  }

  Widget _buildBottomSheet({
    required String title,
    required List<String> items,
    required RxString selectedItem,
    RxString? searchQuery,
    required Function(String) onItemSelected,
  }) {
    return Container(
      constraints: BoxConstraints(maxHeight: 0.7.sh),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, fontFamily: AppFonts.poppins, color: ColorConstants.colorHeading)),
                IconButton(icon: Icon(Icons.close, size: 24.sp, color: ColorConstants.grey), onPressed: () => Get.back()),
              ],
            ),
          ),
          if (searchQuery != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: TextField(
                onChanged: (v) => searchQuery.value = v,
                decoration: InputDecoration(
                  hintText: 'Search $title',
                  hintStyle: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.poppins, color: ColorConstants.grey),
                  prefixIcon: Icon(Icons.search, size: 20.sp, color: ColorConstants.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: ColorConstants.grey.withOpacity(0.3))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: ColorConstants.grey.withOpacity(0.3))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: ColorConstants.appThemeColor)),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                style: TextStyle(fontSize: 14.sp, fontFamily: AppFonts.poppins, color: ColorConstants.colorHeading),
              ),
            ),
          Divider(height: 1.h, color: ColorConstants.grey.withOpacity(0.2)),
          Expanded(
            child: Obx(() {
              final query = searchQuery?.value.toLowerCase() ?? '';
              // Accessing selectedItem to ensure Obx registers a dependency 
              // even if searchQuery is null and ListView.builder hasn't built items yet.
              final _ = selectedItem.value;
              final filtered = query.isEmpty
                  ? items
                  : items.where((i) => i.toLowerCase().startsWith(query)).toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
              return ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (ctx, i) => RadioListTile<String>(
                  value: filtered[i],
                  groupValue: selectedItem.value,
                  onChanged: (v) => v != null ? onItemSelected(v) : null,
                  title: Text(filtered[i], style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, fontFamily: AppFonts.poppins, color: ColorConstants.colorHeading)),
                  activeColor: ColorConstants.appThemeColor,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                ),
              );
            }),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Future<void> register() async {
    try {
      isLoading.value = true;
      print("--- DEBUG: Register Method (Step 3) Started ---");

      final request = RegisterStep3Request(
        clientId: Constants.clientId,
        email: emailController.text.trim(),
        businessName: businessNameController.text.trim(),
        businessType: businessTypeController.text.trim(),
        contactNumber: '+91${contactNumberController.text.trim()}',
        contactName: contactNameController.text.trim(),
        pincode: pinCodeController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        website: websiteController.text.trim(),
        pancard: panCardController.text.trim(),
        gst: gstController.text.trim(),
        annualTurnover: annualTurnoverController.text.trim(),
      );

      print("================= REGISTER API REQUEST =================");
      print("URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.registerStep3}");
      print("Request Data: ${jsonEncode(request.toJson())}");
      print("======================================================");

      final response = await apiService.registerStep3(request);

      print("================= REGISTER API RESPONSE =================");
      print("Success: ${response.success}");
      print("Message: ${response.message}");
      print("Next Step: ${response.nextStep}");
      print("Token: ${response.token != null ? 'PRESENT' : 'MISSING'}");
      print("=========================================================");

      if (response.success == true) {
        // Store Token if present
        if (response.token != null && response.token!.isNotEmpty) {
          await secureStorage.write(key: Constants.token, value: response.token);
          print('--- Token Saved Successfully ---');
        }

        await storage.write(Constants.isProfileCompleted,
            response.user?.isProfileCompleted ?? true);

        if (response.nextStep == 'completed' || response.user?.isProfileCompleted == true) {
          print('--- Clearing Auth Step (Registration Complete) ---');
          await secureStorage.delete(key: Constants.lastAuthStep);
          await secureStorage.delete(key: Constants.lastAuthData);
          Get.offAllNamed(AppRoutes.pendingApprovalScreen);
        } else {
          customSnackBar(message: response.message ?? 'Registration state incomplete.', type: 'W');
        }
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        customSnackBar(message: 'Profile already exists for this client.', type: 'E');
      } else {
        print('Registration error: ${e.message}');
        customSnackBar(message: 'Registration failed: ${e.message}', type: 'E');
      }
    } catch (e) {
      print('General error: $e');
      customSnackBar(message: 'Something went wrong: $e', type: 'E');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onSubmit() async {
    print("================ CLICKED: REGISTER BUTTON ================");
    bool isValid = formKey.currentState!.validate();
    print("--- DEBUG: Form Validation Result: $isValid ---");
    
    if (isValid) {
      await register();
    } else {
      print("⚠️ ABORTING: Form validation failed. Check UI for error messages.");
    }
  }
}