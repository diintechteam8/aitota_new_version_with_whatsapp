import 'dart:async';
import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/data/model/myDial/call_log_model.dart';
import 'package:call_log/call_log.dart' as device_call_log;
import '../../../../../../core/services/api_services.dart';
import '../../../../../../core/services/dio_client.dart';
import '../../../../../../core/utils/snack_bar.dart';
import '../../../../../../routes/app_routes.dart';
import '../../../leads/controller/my_dial_leads_controller.dart';
import '../../../reports/controller/my_dial_reports_controller.dart';
import '../../../saleDone/controller/my_dial_sale_controller.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../../../../../../data/model/myDial/upload_call_logs_model.dart';

class FollowUpSchedule {
  final DateTime scheduledDate;
  final String reason;

  FollowUpSchedule({
    required this.scheduledDate,
    required this.reason,
  });
}

class CallStatusData {
  final String category;
  final String reason;
  final DateTime? followUpDate;
  final String? timeSlot;

  CallStatusData({
    required this.category,
    required this.reason,
    this.followUpDate,
    this.timeSlot,
  });
}

class CallsController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final RxList<CallLog> callLogs = <CallLog>[].obs;
  final RxBool hasMore = true.obs;
  final RxBool isLoading = false.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final RxString selectedTimeSlot = ''.obs;
  final ScrollController scrollController = ScrollController();
  Timer? _syncTimer;
  Timer? _debounceTimer;
  int _offset = 0;

  // Default: Connected + Interested
  final RxString selectedCategory = 'connected'.obs;
  final RxString selectedConnectedTab = 'interested'.obs;
  final RxString selectedDisposition = ''.obs;
  final RxString selectedMiniDisposition = ''.obs;
  final RxString selectedReason = ''.obs;
  final RxBool needsFollowUp = false.obs;
  final RxBool isPermissionGranted = false.obs;

  final RxString selectedGender = ''.obs;  // <-- YEH ADD KARO
  // NEW: Loading state for Submit button
  final RxBool isSubmitting = false.obs;

  // Add near other RxString declarations (e.g., around line 52-60)
  final RxString explanation = ''.obs;

  CallLog? currentCallLog;
  final RxMap<String, FollowUpSchedule> followUpSchedules =
      <String, FollowUpSchedule>{}.obs;

  // Store call status data in memory
  final RxMap<String, CallStatusData> callStatusData =
      <String, CallStatusData>{}.obs;

  final GetStorage _storage = GetStorage();
  static const String _uploadedCallLogsKey = 'uploaded_call_logs_timestamps';
  final TextEditingController genderController = TextEditingController();
final TextEditingController ageController = TextEditingController();
final TextEditingController professionController = TextEditingController();
final TextEditingController pincodeController = TextEditingController();
final TextEditingController cityController = TextEditingController();
  // Add upload loading state
  final RxBool isUploading = false.obs;

  // Stage 1 - Not Connected dispositions with mini dispositions
  final Map<String, List<String>> notConnectedDispositions = {
    'DNP': [
      'No Response / Ringing',
      'Call Busy',
    ],
    'CNC': [
      'Not Reachable',
      'Switched off',
      'Out of Coverage Area',
    ],
    'Other': [
      'Call Disconnected Automatically',
      'Call Later / Network Issue',
    ],
  };

  // Stage 2 - Connected - Interested dispositions with mini dispositions
  final Map<String, List<String>> interestedDispositions = {
    'Hot Lead': [
      'Payment Pending',
      'Document Pending',
    ],
    'Warm Lead': [
      'Call Back Scheduled',
      'Information Shared',
      'Follow-up Required',
    ],
    'Follow Up': [
      'Call Back Due',
      'WhatsApp Sent / Brouchure Sent',
      'Interested - Waiting Confirmation',
    ],
    'Converted / Won': [
      'Admission Confirmed / Enrolled',
      'Payment Recieved',
      'Course Started',
    ],
  };

  // Stage 2 - Connected - Not Interested dispositions with mini dispositions
  final Map<String, List<String>> notInterestedDispositions = {
    'Close / Lost': [
      'Not Interested',
      'Joined Another Institute',
      'Dropped the Plan',
      'DND (Do Not Disturb)',
      'Unqualified lead (Fake / Not Relevent / Outside target area)',
      'Wrong Number',
      'Invalid Number',
    ],
    'Future Prospect': [
      'Postpone / Next Batch',
    ],
  };

@override
void onInit() {
  super.onInit();
  _setupScrollListener();
  _checkAndRequestPermission();

  // ⏳ Safety fallback: ensure UI doesn't stay stuck in loading forever
  Future.delayed(const Duration(seconds: 4), () {
    if (isLoading.value && callLogs.isEmpty) {
      isLoading.value = false; // force stop spinner after 4s
    }
  });

  // ✅ Upload call logs in background
  _uploadCallLogsInBackground();
}


  @override
  void onClose() {
    _syncTimer?.cancel();
    _debounceTimer?.cancel();
    scrollController.dispose();
    genderController.clear();
    selectedGender.value = '';
ageController.clear();
professionController.clear();
pincodeController.clear();
cityController.clear();
    super.onClose();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 200), () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          if (hasMore.value && !isLoading.value) {
            fetchCallLogs();
          }
        }
      });
    });
  }

Future<void> _checkAndRequestPermission() async {
  final status = await Permission.phone.status;

  if (status.isGranted) {
    isPermissionGranted.value = true; // ✅ Mark allowed
    await fetchCallLogs();
    return;
  }

  final newStatus = await Permission.phone.request();

  if (newStatus.isGranted) {
    isPermissionGranted.value = true;
    await fetchCallLogs();
    return;
  }

  // 🚫 Denied (temporary or permanent)
  isPermissionGranted.value = false;

  if (newStatus.isPermanentlyDenied) {
    await Get.defaultDialog(
      title: 'Permission Required',
      middleText:
          'Phone permission is permanently denied.\nPlease enable it manually from Settings to access your call logs.',
      confirm: TextButton(
        onPressed: () async {
          await openAppSettings();
          Get.back();
        },
        child: const Text('Open Settings', style: TextStyle(color: Colors.blue)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text('Cancel', style: TextStyle(color: Colors.red)),
      ),
    );
    return;
  }

  if (newStatus.isDenied) {
    await Get.defaultDialog(
      title: 'Permission Needed',
      middleText:
          'This app requires phone permission to view your call logs.\nPlease grant permission to continue.',
      confirm: TextButton(
        onPressed: () async {
          Get.back();
          await _checkAndRequestPermission();
        },
        child: const Text('Try Again', style: TextStyle(color: Colors.blue)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text('Cancel', style: TextStyle(color: Colors.red)),
      ),
    );
  }
}





  void updateSelectedDateWithTime() {
    final selectedDay = selectedDate.value;
    switch (selectedTimeSlot.value) {
      case 'Morning':
        selectedDate.value = DateTime(
            selectedDay.year, selectedDay.month, selectedDay.day, 9, 0);
        break;
      case 'Afternoon':
        selectedDate.value = DateTime(
            selectedDay.year, selectedDay.month, selectedDay.day, 14, 0);
        break;
      case 'Evening':
        selectedDate.value = DateTime(
            selectedDay.year, selectedDay.month, selectedDay.day, 18, 0);
        break;
      case 'Night':
        selectedDate.value = DateTime(
            selectedDay.year, selectedDay.month, selectedDay.day, 21, 0);
        break;
      default:
        selectedDate.value = selectedDay;
    }
  }

Future<void> fetchCallLogs() async {
  if (isLoading.value) return;
  isLoading.value = true;

  // ✅ Step 1: Request phone permission first
  final status = await Permission.phone.request();

  // ❌ Step 2: If permission not granted
  if (!status.isGranted) {
    isPermissionGranted.value = false;
    isLoading.value = false;

    // Safe dialog show only if screen still active
    if (Get.context != null && Get.isDialogOpen == false) {
      Future.microtask(() {
        Get.defaultDialog(
          title: 'Permission Required',
          middleText: 'Please grant phone permission to view your call logs.',
          confirm: TextButton(
            onPressed: () async {
              await openAppSettings();
              Get.back();
            },
            child: const Text('Open Settings',
                style: TextStyle(color: Colors.blue)),
          ),
          cancel: TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
        );
      });
    }

    return;
  }

  // ✅ Mark as granted
  isPermissionGranted.value = true;

  try {
    // ✅ Step 3: Fetch call logs
    final Iterable<device_call_log.CallLogEntry> entries =
        await device_call_log.CallLog.get();

    final int currentPageSize = _offset == 0 ? 5 : 8;

    final List<CallLog> newLogs = entries
        .skip(_offset)
        .take(currentPageSize)
        .map((entry) => CallLog(
              id: 'call-${entry.timestamp}',
              contactName: entry.name ?? 'Unknown',
              phoneNumber: entry.number ?? 'Unknown',
              isIncoming:
                  entry.callType == device_call_log.CallType.incoming,
              dateTime:
                  DateTime.fromMillisecondsSinceEpoch(entry.timestamp ?? 0),
              duration: Duration(seconds: entry.duration ?? 0),
            ))
        .toList();

    // ✅ Step 4: Pagination end or empty detection
    if (newLogs.isEmpty && callLogs.isEmpty) {
      hasMore.value = false;
    }
    if (newLogs.length < currentPageSize) {
      hasMore.value = false;
    }

    // ✅ Step 5: Add to list
    callLogs.addAll(newLogs);
    _offset += newLogs.length;

    await Future.delayed(const Duration(milliseconds: 100));
  } catch (e) {
    debugPrint('Error fetching call logs: $e');

    // ✅ Step 6: Safe dialog for errors (no crash)
    if (Get.context != null && Get.isDialogOpen == false) {
      Future.microtask(() {
        Get.defaultDialog(
          title: 'Error',
          middleText: 'Something went wrong while fetching call logs.',
          confirm: TextButton(
            onPressed: () => Get.back(),
            child:
                const Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        );
      });
    }
  } finally {
    isLoading.value = false;
  }
}



  Future<void> refreshCallLogs() async {
    _offset = 0;
    hasMore.value = true;
    callLogs.clear();
    await fetchCallLogs();
  }

  Future<void> syncCallLogs() async {
    await refreshCallLogs();
  }

  Future<void> makeCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw Exception();
    }
  }

  CallStatusData? getCallStatus(String phoneNumber) {
    return callStatusData[phoneNumber];
  }

  void loadStoredCallStatus(String phoneNumber) {
    final storedStatus = getCallStatus(phoneNumber);
    if (storedStatus != null) {
      selectedCategory.value = storedStatus.category;
      selectedReason.value = storedStatus.reason;

      if (storedStatus.reason.contains(' - ')) {
        final parts = storedStatus.reason.split(' - ');
        if (parts.length >= 2) {
          selectedDisposition.value = parts[0];
          selectedMiniDisposition.value = parts.sublist(1).join(' - ');
        }
      }

      if (storedStatus.category == 'connected') {
        if (interestedDispositions.containsKey(selectedDisposition.value)) {
          selectedConnectedTab.value = 'interested';
        } else if (notInterestedDispositions
            .containsKey(selectedDisposition.value)) {
          selectedConnectedTab.value = 'not_interested';
        }
      }

      if (storedStatus.followUpDate != null) {
        selectedDate.value = storedStatus.followUpDate!;
        needsFollowUp.value = true;
        selectedTimeSlot.value = storedStatus.timeSlot ?? '';
      }
    } else {
      selectedCategory.value = 'connected';
      selectedConnectedTab.value = 'interested';
      selectedDisposition.value = '';
      selectedMiniDisposition.value = '';
      selectedReason.value = '';
      needsFollowUp.value = false;
      selectedTimeSlot.value = '';
      selectedDate.value = DateTime.now();
    }
  }

  String _getSubCategory(
      String disposition, String category, String connectedTab) {
    if (category == 'not_connected') {
      switch (disposition.toLowerCase()) {
        case 'dnp':
          return 'dnp';
        case 'cnc':
          return 'cnc';
        case 'other':
          return 'other';
        default:
          return disposition.toLowerCase();
      }
    } else if (category == 'connected') {
      if (connectedTab == 'interested') {
        switch (disposition.toLowerCase()) {
          case 'hot lead':
            return 'hotLeads';
          case 'warm lead':
            return 'warmLeads';
          case 'follow up':
            return 'followUp';
          case 'converted / won':
            return 'converted';
          default:
            return disposition.toLowerCase();
        }
      } else if (connectedTab == 'not_interested') {
        switch (disposition.toLowerCase()) {
          case 'close / lost':
            return 'closedLost';
          case 'future prospect':
            return 'futureProspect';
          default:
            return disposition.toLowerCase();
        }
      }
    }
    return disposition.toLowerCase();
  }

  String _getLeadStatus(String miniDisposition) {
    final Map<String, String> leadStatusMappings = {
      'No Response / Ringing': 'no_response',
      'Call Busy': 'call_busy',
      'Not Reachable': 'not_reachable',
      'Switched off': 'switched_off',
      'Out of Coverage Area': 'out_of_coverage',
      'Call Disconnected Automatically': 'call_disconnected',
      'Call Later / Network Issue': 'call_later',
      'Payment Pending': 'payment_pending',
      'Document Pending': 'Document_pending',
      'Call Back Scheduled': 'call_back_schedule',
      'Information Shared': 'information_shared',
      'Follow-up Required': 'follow_up_required',
      'Call Back Due': 'call_back_due',
      'WhatsApp Sent / Brouchure Sent': 'whatsapp_sent',
      'Interested - Waiting Confirmation': 'interested_waiting_confimation',
      'Admission Confirmed / Enrolled': 'admission_confirmed',
      'Payment Recieved': 'payment_recieved',
      'Course Started': 'course_started',
      'Not Interested': 'not_interested',
      'Joined Another Institute': 'joined_another_institute',
      'Dropped the Plan': 'dropped_the_plan',
      'DND (Do Not Disturb)': 'dnd',
      'Unqualified lead (Fake / Not Relevent / Outside target area)':
          'unqualified_lead',
      'Wrong Number': 'wrong_number',
      'Invalid Number': 'invalid_number',
      'Postpone / Next Batch': 'postpone',
    };

    if (leadStatusMappings.containsKey(miniDisposition)) {
      return leadStatusMappings[miniDisposition]!;
    }

    String normalized = miniDisposition
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');

    return normalized;
  }

  Future<void> submitReason(CallLog callLog) async {
    if (selectedDisposition.value.isEmpty ||
        selectedMiniDisposition.value.isEmpty) {
      customSnackBar(
          message: "Please select a disposition and mini disposition",
          type: "I");
      return;
    }

    if (needsFollowUp.value && selectedTimeSlot.value.isEmpty) {
      customSnackBar(message: "Please select a follow-up time", type: "I");
      return;
    }

    // Add validation for explanation word count
    final explanationWords = explanation.value.trim().split(' ').where((w) => w.isNotEmpty).length;
    if (explanationWords <= 2) {
      customSnackBar(message: "Please provide a brief explanation with more than 2 words", type: "I");
      return;
    }

    isSubmitting.value = true; // Start loading

    final String category = selectedCategory.value.toLowerCase();
    final String subCategory = _getSubCategory(
        selectedDisposition.value, category, selectedConnectedTab.value);
    final String leadStatus = _getLeadStatus(selectedMiniDisposition.value);

    final DateTime dateToSend =
        needsFollowUp.value ? selectedDate.value : callLog.dateTime;

    final contactNameToSend =
        (callLog.contactName.trim().isEmpty || callLog.contactName == 'Unknown')
            ? ''
            : callLog.contactName.trim();

    final Map<String, dynamic> request = {
      'category': category,
      'subCategory': subCategory,
      'leadStatus': leadStatus,
      'phoneNumber': callLog.phoneNumber,
      'contactName': contactNameToSend,
      'duration': callLog.duration.inSeconds.toString(),
      'date': (needsFollowUp.value ? selectedDate.value : callLog.dateTime)
          .toUtc()
          .toIso8601String(),
      'explanation': explanation.value.trim(),
      // 'gender': genderController.text.trim(),
      'gender': selectedGender.value.isEmpty ? '' : selectedGender.value,
      'age': ageController.text.trim(),
      'profession': professionController.text.trim(),
      'pincode': pincodeController.text.trim(),
      'city': cityController.text.trim(),
    };

    print("ReasonREq: ${request.toString()}");

    try {
      final response = await apiService.addDispositionCallLogs(request);
      _closeAllBottomSheets();
      await Future.delayed(const Duration(milliseconds: 300));

      if (response.success == true) {
        callStatusData[callLog.phoneNumber] = CallStatusData(
          category: selectedCategory.value,
          reason: selectedReason.value,
          followUpDate: needsFollowUp.value ? selectedDate.value : null,
          timeSlot: needsFollowUp.value ? selectedTimeSlot.value : null,
        );

        if (needsFollowUp.value) {
          followUpSchedules[callLog.phoneNumber] = FollowUpSchedule(
            scheduledDate: selectedDate.value,
            reason: selectedReason.value,
          );
        }

        if (Get.isRegistered<MyDialLeadsController>()) {
          Get.find<MyDialLeadsController>().refreshLeads();
        }
        if (Get.isRegistered<MyDialReportsController>()) {
          Get.find<MyDialReportsController>().refreshReports();
        }
        if (Get.isRegistered<MyDialSaleController>()) {
          Get.find<MyDialSaleController>().refreshSales();
        }

        customSnackBar(message: "Reason submitted successfully", type: "S");
      } else {
        throw Exception("API returned false");
      }
    } catch (e) {
      _closeAllBottomSheets();
      throw Exception(e.toString());
    } finally {
      isSubmitting.value = false; // Stop loading

      selectedCategory.value = 'connected';
      selectedConnectedTab.value = 'interested';
      selectedDisposition.value = '';
      selectedMiniDisposition.value = '';
      selectedReason.value = '';
      needsFollowUp.value = false;
      selectedTimeSlot.value = '';
      selectedDate.value = DateTime.now();
      explanation.value = '';  // Reset explanation
      currentCallLog = null;
    }
  }

  void onDialerPadTap() {
    Get.toNamed(AppRoutes.myDialerPadScreen);
  }

  void _closeAllBottomSheets() {
    while (Get.isBottomSheetOpen!) {
      Get.back();
    }
  }

  Future<void> _uploadCallLogsInBackground() async {
    try {
      // Small delay to ensure app is fully initialized
      await Future.delayed(const Duration(seconds: 2));
      
      // Check if we should upload (only if user is logged in and has profile)
      final profileId = await _getCurrentProfileId();
      if (profileId == null) return; // Skip if no user logged in

      await uploadCallLogs();
    } catch (e) {
      print('Background upload failed: $e');
      // Don't show error to user for background upload
    }
  }

  Future<String?> _getCurrentProfileId() async {
    try {
      final secureStorage = FlutterSecureStorage();
      return await secureStorage.read(key: Constants.profileId);
    } catch (e) {
      return null;
    }
  }

  Set<int> _getUploadedTimestamps() {
    final timestamps = _storage.read<List<dynamic>>(_uploadedCallLogsKey) ?? [];
    return timestamps.map((t) => t as int).toSet();
  }

  void _saveUploadedTimestamps(Set<int> timestamps) {
    _storage.write(_uploadedCallLogsKey, timestamps.toList());
  }

  Future<void> uploadCallLogs() async {
    if (isUploading.value) return;

    try {
      isUploading.value = true;

      // Get device info
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final deviceId = androidInfo.id ?? 'unknown-device';

      // Get user profile
      final profileId = await _getCurrentProfileId();
      if (profileId == null) {
        throw Exception('No user profile found');
      }

      final profile = await apiService.getUserProfile(profileId);
      if (profile.profile == null) {
        throw Exception('User profile not found');
      }

      final userProfile = profile.profile!;

      // Create mobile user
      final mobileUser = MobileUser(
        deviceId: deviceId,
        name: userProfile.contactName ?? 'Unknown',
        phoneNumber: userProfile.contactNumber ?? '',
        email: userProfile.email ?? '',
      );

      // Get all call logs from device
      final Iterable<device_call_log.CallLogEntry> entries =
          await device_call_log.CallLog.get();

      // Get already uploaded timestamps
      final uploadedTimestamps = _getUploadedTimestamps();

      // Filter out already uploaded call logs
      final newEntries = entries.where((entry) {
        final timestamp = entry.timestamp ?? 0;
        return !uploadedTimestamps.contains(timestamp);
      }).toList();

      if (newEntries.isEmpty) {
        print('No new call logs to upload');
        return; // Nothing to upload
      }

      // Convert to upload format
      final uploadCallLogsList = newEntries.map((entry) {
        final externalId = 'call-${entry.timestamp}';
        final direction = entry.callType == device_call_log.CallType.incoming 
            ? 'incoming' 
            : 'outgoing';
        const status = 'connected'; // Default status, could be enhanced
        final startedAt = DateTime.fromMillisecondsSinceEpoch(entry.timestamp ?? 0);
        final duration = Duration(seconds: entry.duration ?? 0);
        final endedAt = startedAt.add(duration);

        return UploadCallLog(
          externalId: externalId,
          phoneNumber: entry.number ?? 'Unknown',
          contactName: entry.name,
          direction: direction,
          status: status,
          startedAt: startedAt.toUtc().toIso8601String(),
          endedAt: endedAt.toUtc().toIso8601String(),
          notes: null,
          metadata: {
            'duration': duration.inSeconds,
            'timestamp': entry.timestamp,
          },
        );
      }).toList();

      // Create request
      final request = UploadCallLogsRequest(
        mobileUser: mobileUser,
        contacts: [], // Optional: can be populated if you have contacts data
        callLogs: uploadCallLogsList,
      );
    print("ReasonREq: ${request.toString()}");
      // Upload
      final response = await apiService.uploadCallLogs(request);

      if (response.success) {
        // Mark these call logs as uploaded
        final newTimestamps = newEntries.map((entry) => entry.timestamp ?? 0).toSet();
        final updatedTimestamps = uploadedTimestamps..addAll(newTimestamps);
        _saveUploadedTimestamps(updatedTimestamps);

        print('Call logs uploaded successfully. ${response.data?.callLogsUpserted ?? 0} logs uploaded.');
        
        // Only show success message if this was a manual upload (not background)
        // You can add a parameter to distinguish between manual and automatic uploads
      } else {
        throw Exception('Upload failed');
      }

    } catch (e) {
      print('Failed to upload call logs: ${e.toString()}');
      // Don't show error snackbar for background uploads
      rethrow; // Re-throw for manual uploads
    } finally {
      isUploading.value = false;
    }
  }
}
