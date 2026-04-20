import 'package:intl/intl.dart';
import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/services/api_services.dart';
import 'package:aitota_business/core/services/dio_client.dart';
import 'package:aitota_business/views/myDial/grid_flow/leads/controller/my_dial_leads_controller.dart';
import 'package:flutter/material.dart';

class MyDialReportsController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  late final MyDialLeadsController leadsController;

  final isTodaySelected = true.obs;
  final isYesterdaySelected = false.obs;
  final isLast7DaysSelected = false.obs;
  final isCustomRangeSelected = false.obs;

  final selectedRange = Rx<DateTimeRange>(
    DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 1)),
      end: DateTime.now(),
    ),
  );
  final dateError = ''.obs;

  final totalCalls = 0.obs;
  final connectedCalls = 0.obs;
  final notConnectedCalls = 0.obs;
  final avgTalkTime = 0.0.obs;
  final totalConversationTime = 0.0.obs;

  final isLoading = false.obs;

// CHANGE DEFAULT: from 'not_connected' → 'connected'
  final RxString selectedCategory = 'connected'.obs; // ← NOW CONNECTED
  final RxString selectedConnectedTab = 'interested'.obs;

  @override
  void onInit() {
    super.onInit();
    leadsController = Get.find<MyDialLeadsController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectFilter('Today');
      // Ensure Connected tab is active on init
      selectedCategory.value = 'connected';
      selectedConnectedTab.value = 'interested';
    });
  }

  Future<void> refreshReports() async {
    String? filter;
    String? startDate;
    String? endDate;

    if (isTodaySelected.value) {
      filter = 'today';
    } else if (isYesterdaySelected.value) {
      filter = 'yesterday';
    } else if (isLast7DaysSelected.value) {
      filter = 'last7days';
    } else if (isCustomRangeSelected.value) {
      startDate = DateFormat('yyyy-MM-dd').format(selectedRange.value.start);
      endDate = DateFormat('yyyy-MM-dd').format(selectedRange.value.end);
    }

    await updateData(filter: filter, startDate: startDate, endDate: endDate);
  }

  void selectFilter(String filter) {
    isTodaySelected.value = filter == 'Today';
    isYesterdaySelected.value = filter == 'Yesterday';
    isLast7DaysSelected.value = filter == 'Last 7 Days';
    isCustomRangeSelected.value = filter == 'Custom';

    final now = DateTime.now();
    if (filter == 'Today') {
      selectedRange.value = DateTimeRange(
        start: now.startOfDay,
        end: now.endOfDay,
      );
      updateData(filter: 'today');
    } else if (filter == 'Yesterday') {
      final yesterday = now.subtract(const Duration(days: 1));
      selectedRange.value = DateTimeRange(
        start: yesterday.startOfDay,
        end: yesterday.endOfDay,
      );
      updateData(filter: 'yesterday');
    } else if (filter == 'Last 7 Days') {
      selectedRange.value = DateTimeRange(
        start: now.subtract(const Duration(days: 7)).startOfDay,
        end: now.endOfDay,
      );
      updateData(filter: 'last7days');
    }
  }

  void initializeCalendarRange() {
    selectedRange.value = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 7)).startOfDay,
      end: DateTime.now().endOfDay,
    );
    dateError.value = '';
  }

  void selectStartDate(DateTime date) {
    selectedRange.value = DateTimeRange(
      start: date.startOfDay,
      end: selectedRange.value.end,
    );
  }

  void selectEndDate(DateTime date) {
    selectedRange.value = DateTimeRange(
      start: selectedRange.value.start,
      end: date.endOfDay,
    );
  }

  bool validateDateRange() {
    if (selectedRange.value.end.isBefore(selectedRange.value.start)) {
      dateError.value = 'End date must be after start date';
      return false;
    }
    dateError.value = '';
    return true;
  }

  void confirmCustomRange() {
    if (validateDateRange()) {
      isTodaySelected.value = false;
      isYesterdaySelected.value = false;
      isLast7DaysSelected.value = false;
      isCustomRangeSelected.value = true;
      final startDate =
          DateFormat('yyyy-MM-dd').format(selectedRange.value.start);
      final endDate = DateFormat('yyyy-MM-dd').format(selectedRange.value.end);
      updateData(startDate: startDate, endDate: endDate);
    }
  }

  String formattedDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  Future<void> updateData(
      {String? filter, String? startDate, String? endDate}) async {
    isLoading.value = true;
    try {
      final response = await apiService.getDialReports(
        filter: filter,
        startDate: startDate,
        endDate: endDate,
      );

      if (response.success == true && response.data != null) {
        totalCalls.value = response.data!.totalCalls ?? 0;
        connectedCalls.value = response.data!.totalConnected ?? 0;
        notConnectedCalls.value = response.data!.totalNotConnected ?? 0;
        totalConversationTime.value =
            (response.data!.totalConversationTime ?? 0).toDouble();
        avgTalkTime.value = (response.data!.avgCallDuration ?? 0).toDouble();
      } else {
        resetData();
      }
    } catch (e) {
      resetData();
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void resetData() {
    totalCalls.value = 0;
    connectedCalls.value = 0;
    notConnectedCalls.value = 0;
    avgTalkTime.value = 0.0;
    totalConversationTime.value = 0.0;
  }
}
