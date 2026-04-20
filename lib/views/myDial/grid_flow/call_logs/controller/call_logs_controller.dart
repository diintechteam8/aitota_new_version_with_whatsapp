import '../../../../../core/app-export.dart';

// class CallLog {
//   final String contactName;
//   final String phoneNumber;
//   final bool isIncoming;
//   final DateTime dateTime;
//   final Duration duration;

//   CallLog({
//     required this.contactName,
//     required this.phoneNumber,
//     required this.isIncoming,
//     required this.dateTime,
//     required this.duration,
//   });
// }

// class FollowUpSchedule {
//   final DateTime scheduledDate;
//   final String reason;

//   FollowUpSchedule({
//     required this.scheduledDate,
//     required this.reason,
//   });
// }

// class CallStatusData {
//   final String category;
//   final String reason;
//   final DateTime? followUpDate;
//   final String? timeSlot;

//   CallStatusData({
//     required this.category,
//     required this.reason,
//     this.followUpDate,
//     this.timeSlot,
//   });
// }

class CallLogsController extends GetxController {
  // final ApiService apiService = ApiService(dio: DioClient().dio);
  // final RxList<CallLog> callLogs = <CallLog>[].obs;
  // final RxBool hasMore = true.obs;
  // final RxBool isLoading = false.obs;
  // final Rx<DateTime> selectedDate = DateTime.now().obs;
  // final Rx<DateTime> focusedDay = DateTime.now().obs;
  // final RxString selectedTimeSlot = ''.obs;
  // final ScrollController scrollController = ScrollController();
  // Timer? _syncTimer;
  // Timer? _debounceTimer; // For debouncing scroll events
  // int _offset = 0;

  // final RxString selectedCategory = 'connected'.obs;
  // final RxString selectedReason = ''.obs;
  // final RxBool needsFollowUp = false.obs;
  // CallLog? currentCallLog;
  // final RxMap<String, FollowUpSchedule> followUpSchedules = <String, FollowUpSchedule>{}.obs;

  // // Store call status data in memory
  // final RxMap<String, CallStatusData> callStatusData = <String, CallStatusData>{}.obs;

  // final Map<String, List<String>> connectedGroupedReasons = {
  //   'Interested': [
  //     'Very Interested',
  //     'Maybe',
  //     'Other',
  //   ],
  //   'Follow-up': [
  //     'Hot Followup',
  //     'Cold Followup',
  //     'Schedule',
  //     'Other',
  //   ],
  //   'Not Interested': [
  //     'Junk Lead',
  //     'Not Required',
  //     'Enrolled Other',
  //     'Decline',
  //     'Not Eligible',
  //     'Wrong Number',
  //     'Other',
  //   ],
  // };

  // final List<String> notConnectedReasons = [
  //   'Busy Line',
  //   'Did Not Answer',
  //   'Number Switched Off',
  //   'Wrong Number',
  //   'Invalid Number',
  //   'Call Disconnected',
  //   'Network Error',
  //   'Not Reachable',
  //   'Other',
  // ];

  // final List<String> saleDoneReasons = [
  //   'Enrolled',
  //   'Deal Closed',
  //   'Other',
  // ];

  // @override
  // void onInit() {
  //   super.onInit();
  //   _setupScrollListener();
  //   fetchCallLogs();
  //   _startBackgroundSync();
  // }

  // @override
  // void onClose() {
  //   _syncTimer?.cancel();
  //   _debounceTimer?.cancel();
  //   scrollController.dispose();
  //   super.onClose();
  // }

  // void _setupScrollListener() {
  //   scrollController.addListener(() {
  //     if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
  //     _debounceTimer = Timer(const Duration(milliseconds: 200), () {
  //       if (scrollController.position.pixels >=
  //           scrollController.position.maxScrollExtent - 200) {
  //         if (hasMore.value && !isLoading.value) {
  //           fetchCallLogs();
  //         }
  //       }
  //     });
  //   });
  // }

  // void updateSelectedDateWithTime() {
  //   final selectedDay = selectedDate.value;
  //   switch (selectedTimeSlot.value) {
  //     case 'Morning':
  //       selectedDate.value = DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 9, 0);
  //       break;
  //     case 'Afternoon':
  //       selectedDate.value = DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 14, 0);
  //       break;
  //     case 'Evening':
  //       selectedDate.value = DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 18, 0);
  //       break;
  //     case 'Night':
  //       selectedDate.value = DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 21, 0);
  //       break;
  //     default:
  //       selectedDate.value = selectedDay; // Fallback to date only
  //   }
  // }

  // Future<void> fetchCallLogs() async {
  //   if (isLoading.value) return;
  //   isLoading.value = true;

  //   final status = await Permission.phone.request();
  //   if (!status.isGranted) {
  //     isLoading.value = false;
  //     Get.defaultDialog(
  //       title: 'Permission Required',
  //       middleText: 'Please grant phone permission to view call logs.',
  //       confirm: TextButton(
  //         onPressed: () {
  //           openAppSettings();
  //           Get.back();
  //         },
  //         child: const Text('Open Settings', style: TextStyle(color: Colors.blue)),
  //       ),
  //       cancel: TextButton(
  //         onPressed: () => Get.back(),
  //         child: const Text('Cancel'),
  //       ),
  //     );
  //     return;
  //   }

  //   try {
  //     final Iterable<device_call_log.CallLogEntry> entries = await device_call_log.CallLog.get();

  //     final int currentPageSize = _offset == 0 ? 5 : 8;

  //     final List<CallLog> newLogs = entries
  //         .skip(_offset)
  //         .take(currentPageSize)
  //         .map((entry) => CallLog(
  //       contactName: entry.name ?? 'Unknown',
  //       phoneNumber: entry.number ?? 'Unknown',
  //       isIncoming: entry.callType == device_call_log.CallType.incoming,
  //       dateTime: DateTime.fromMillisecondsSinceEpoch(entry.timestamp ?? 0),
  //       duration: Duration(seconds: entry.duration ?? 0),
  //     ))
  //         .toList();

  //     if (newLogs.length < currentPageSize) {
  //       hasMore.value = false;
  //     }

  //     callLogs.addAll(newLogs);
  //     _offset += newLogs.length;

  //     await Future.delayed(const Duration(milliseconds: 100));
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // Future<void> refreshCallLogs() async {
  //   _offset = 0;
  //   hasMore.value = true;
  //   callLogs.clear();
  //   await fetchCallLogs();
  // }

  // Future<void> syncCallLogs() async {
  //   await refreshCallLogs();
  // }

  // void _startBackgroundSync() {
  //   _syncTimer?.cancel();
  //   _syncTimer = Timer.periodic(const Duration(minutes: 5), (_) async {
  //     if (!isLoading.value) await syncCallLogs();
  //   });
  // }

  // Future<void> makeCall(String phoneNumber) async {
  //   final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
  //   if (await canLaunchUrl(phoneUri)) {
  //     await launchUrl(phoneUri);
  //   } else {
  //     throw Exception();
  //   }
  // }

  // // Get stored call status for a phone number
  // CallStatusData? getCallStatus(String phoneNumber) {
  //   return callStatusData[phoneNumber];
  // }

  // // Load stored call status when opening reason form
  // void loadStoredCallStatus(String phoneNumber) {
  //   final storedStatus = getCallStatus(phoneNumber);
  //   if (storedStatus != null) {
  //     selectedCategory.value = storedStatus.category;
  //     selectedReason.value = storedStatus.reason;
  //     if (storedStatus.followUpDate != null) {
  //       selectedDate.value = storedStatus.followUpDate!;
  //       needsFollowUp.value = true;
  //       selectedTimeSlot.value = storedStatus.timeSlot ?? '';
  //     }
  //   } else {
  //     // Reset to default values
  //     selectedCategory.value = 'connected';
  //     selectedReason.value = '';
  //     needsFollowUp.value = false;
  //     selectedTimeSlot.value = '';
  //     selectedDate.value = DateTime.now();
  //   }
  // }

  // Future<void> submitReason(CallLog callLog) async {
  //   if (selectedReason.value.isEmpty) {
  //     customSnackBar(message: "Please select a reason", type: "I");
  //     return;
  //   }

  //   if (needsFollowUp.value && selectedTimeSlot.value.isEmpty) {
  //     customSnackBar(message: "Please select a follow-up time", type: "I");
  //     return;
  //   }

  //   // Prepare the request object
  //   String leadStatus = selectedReason.value.toLowerCase();
  //   String? otherReason;

  //   // Handle "Other" reasons
  //   if (selectedReason.value.contains(' - Other: ')) {
  //     final parts = selectedReason.value.split(' - Other: ');
  //     if (parts.length == 2) {
  //       leadStatus = parts[0].toLowerCase();
  //       otherReason = parts[1];
  //     }
  //   } else if (selectedReason.value.endsWith(' - Other')) {
  //     leadStatus = selectedReason.value.replaceAll(' - Other', '').toLowerCase();
  //     otherReason = '';
  //   }

  //   final request = {
  //     'category': selectedCategory.value.toLowerCase(),
  //     'leadStatus': leadStatus,
  //     if (otherReason != null) 'other': otherReason,
  //     'phoneNumber': callLog.phoneNumber,
  //     'contactName': callLog.contactName,
  //     'date': DateFormat('yyyy-MM-dd HH:mm').format(callLog.dateTime), // Add call date
  //     'duration': callLog.duration.inSeconds.toString(),
  //     if (needsFollowUp.value) 'date': DateFormat('yyyy-MM-dd HH:mm').format(selectedDate.value),
  //   };

  //   print("ReasonREq:${request.toString()}");
  //   try {
  //     final response = await apiService.addDispositionCallLogs(request);
  //     _closeAllBottomSheets();
  //     await Future.delayed(const Duration(milliseconds: 300));
  //     if (response.success == true) {
  //       // Store call status data in memory
  //       callStatusData[callLog.phoneNumber] = CallStatusData(
  //         category: selectedCategory.value,
  //         reason: selectedReason.value,
  //         followUpDate: needsFollowUp.value ? selectedDate.value : null,
  //         timeSlot: needsFollowUp.value ? selectedTimeSlot.value : null,
  //       );

  //       if (needsFollowUp.value) {
  //         followUpSchedules[callLog.phoneNumber] = FollowUpSchedule(
  //           scheduledDate: selectedDate.value,
  //           reason: selectedReason.value,
  //         );
  //       }

  //       /// REFRESH LEADS, REPORTS, SALE SCREENS
  //       if (Get.isRegistered<MyDialLeadsController>()) {
  //         Get.find<MyDialLeadsController>().refreshLeads();
  //       }
  //       if (Get.isRegistered<MyDialReportsController>()) {
  //         Get.find<MyDialReportsController>().refreshReports();
  //       }
  //       if (Get.isRegistered<MyDialSaleController>()) {
  //         Get.find<MyDialSaleController>().refreshSales();
  //       }
  //       customSnackBar(message: "Reason submitted successfully", type: "S");
  //     } else {
  //       throw Exception();
  //     }
  //   } catch (e) {
  //     _closeAllBottomSheets();
  //     await Future.delayed(const Duration(milliseconds: 300));
  //     throw Exception(e.toString());
  //   } finally {
  //     // Reset state
  //     selectedCategory.value = 'connected';
  //     selectedReason.value = '';
  //     needsFollowUp.value = false;
  //     selectedTimeSlot.value = '';
  //     selectedDate.value = DateTime.now();
  //     currentCallLog = null;
  //   }
  // }

  // void onDialerPadTap() {
  //   Get.toNamed(AppRoutes.myDialerPadScreen);
  // }

  // void _closeAllBottomSheets() {
  //   while (Get.isBottomSheetOpen!) {
  //     Get.back();
  //   }
  // }
}
