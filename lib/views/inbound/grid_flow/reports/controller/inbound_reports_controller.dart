import 'package:intl/intl.dart';
import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/services/api_services.dart';
import 'package:aitota_business/core/services/dio_client.dart';
import 'package:aitota_business/views/inbound/grid_flow/leads/controller/inbound_leads_controller.dart';

class InboundReportsController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final InboundLeadsController leadsController = Get.find<InboundLeadsController>();

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

  @override
  void onInit() {
    super.onInit();
    selectFilter('Today');
  }

  Future<void> refreshReports() async {
    String? filter;
    if (isTodaySelected.value) {
      filter = 'today';
    } else if (isYesterdaySelected.value) {
      filter = 'yesterday';
    } else if (isLast7DaysSelected.value) {
      filter = 'last7days';
    } else if (isCustomRangeSelected.value) {
      await updateData(
        startDate: DateFormat('yyyy-MM-dd').format(selectedRange.value.start),
        endDate: DateFormat('yyyy-MM-dd').format(selectedRange.value.end),
      );
      return;
    }
    if (filter != null) {
      await updateData(filter: filter);
    }
  }

  void selectFilter(String filter) {
    isTodaySelected.value = filter == 'Today';
    isYesterdaySelected.value = filter == 'Yesterday';
    isLast7DaysSelected.value = filter == 'Last 7 Days';
    isCustomRangeSelected.value = filter == 'Custom';

    if (filter == 'Today') {
      final today = DateTime.now();
      selectedRange.value = DateTimeRange(
        start: today.startOfDay,
        end: today.endOfDay,
      );
      updateData(filter: 'today');
    } else if (filter == 'Yesterday') {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      selectedRange.value = DateTimeRange(
        start: yesterday.startOfDay,
        end: yesterday.endOfDay,
      );
      updateData(filter: 'yesterday');
    } else if (filter == 'Last 7 Days') {
      selectedRange.value = DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 7)).startOfDay,
        end: DateTime.now().endOfDay,
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
      updateData(
        startDate: DateFormat('yyyy-MM-dd').format(selectedRange.value.start),
        endDate: DateFormat('yyyy-MM-dd').format(selectedRange.value.end),
      );
    }
  }

  String formattedDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  Future<void> updateData({String? filter, String? startDate, String? endDate}) async {
    isLoading.value = true;
    try {
      // Fetch report data
      final response = await apiService.getInboundCallStaticsReports(
        filter: filter,
        startDate: startDate,
        endDate: endDate,
      );

      // Call fetchLeads from InboundLeadsController with the same parameters
      await leadsController.fetchLeads(
        filter: filter,
        startDate: startDate != null ? DateTime.parse(startDate).toIso8601String() : null,
        endDate: endDate != null
            ? DateTime.parse(endDate)
            .add(const Duration(hours: 23, minutes: 59, seconds: 59, milliseconds: 999))
            .toIso8601String()
            : null,
      );

      if (response.success && response.data != null) {
        totalCalls.value = response.data!.totalCalls;
        connectedCalls.value = response.data!.totalConnected;
        notConnectedCalls.value = response.data!.totalNotConnected;
        totalConversationTime.value = response.data!.totalConversationTime.toDouble();
        avgTalkTime.value = response.data!.avgCallDuration;
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

extension DateTimeExtension on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
}