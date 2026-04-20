import 'package:intl/intl.dart';
import '../../../../../../core/app-export.dart';
import '../../../../../../data/model/myDial/analysis_models/call_analytics_analysis_model.dart';
import '../../../../../../data/model/myDial/call_filter_response_model.dart';
import '../../../../../../data/model/myDial/call_log_model.dart';
import '../../../../../../core/services/api_services.dart';
import '../../../../../../core/services/dio_client.dart';

class AnalyticsNavigationData {
  String title;
  DateTimeRange dateRange;
  String filterType;
  DateTime? customFrom;
  DateTime? customTo;
  final Map<String, dynamic> extra;
  List<CallLog> filteredLogs;

  AnalyticsNavigationData({
    required this.title,
    required this.dateRange,
    required this.filterType,
    this.customFrom,
    this.customTo,
    this.extra = const {},
    this.filteredLogs = const [],
  });

  AnalyticsNavigationData copyWith({
    String? title,
    DateTimeRange? dateRange,
    String? filterType,
    DateTime? customFrom,
    DateTime? customTo,
    Map<String, dynamic>? extra,
    List<CallLog>? filteredLogs,
  }) {
    return AnalyticsNavigationData(
      title: title ?? this.title,
      dateRange: dateRange ?? this.dateRange,
      filterType: filterType ?? this.filterType,
      customFrom: customFrom ?? this.customFrom,
      customTo: customTo ?? this.customTo,
      extra: extra ?? this.extra,
      filteredLogs: filteredLogs ?? this.filteredLogs,
    );
  }

  @override
  String toString() {
    return 'AnalyticsNavigationData(title: $title, filter: $filterType, range: $dateRange)';
  }
}

class CallAnalyticsController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);

  // ==================== SUMMARY VALUES ====================
  final totalCalls = 0.obs;
  final incomingCalls = 0.obs;
  final outgoingCalls = 0.obs;
  final missedCalls = 0.obs;
  final rejectedCalls = 0.obs;
  final neverAttendedCalls = 0.obs;
  final notPickedByClient = 0.obs;
  final totalTalkTime = 0.0.obs;
  final incomingTalkTime = 0.0.obs;
  final outgoingTalkTime = 0.0.obs;

  // ==================== ANALYSIS VALUES ====================
  final topCaller = ''.obs;
  final longestCallDuration = 0.obs;
  final longestCallName = ''.obs;
  final longestCallId = ''.obs;
  final mostTalkTimeContact = ''.obs;
  final highestDurationCallId = ''.obs;
  final averageCallDuration = 0.0.obs;
  final top10ByCount = <Map<String, dynamic>>[].obs;
  final top10ByDuration = <Map<String, dynamic>>[].obs;

  // ==================== UI STATE ====================
  final isLoading = false.obs;

  // FILTERS
  final isYesterdaySelected = false.obs;
  final isTodaySelected = true.obs;
  final isLast7DaysSelected = false.obs;
  final isCustomRangeSelected = false.obs;

  final selectedRange = Rx<DateTimeRange>(
    DateTimeRange(start: DateTime.now(), end: DateTime.now()),
  );
  final dateError = ''.obs;

  // ==================== NEW: REAL CALL LOGS FROM SERVER ====================
  final filteredCallLogItems = <CallLogSimple>[].obs;   // <-- Mongo _id + direction + status

  @override
  void onInit() {
    super.onInit();
    refreshAnalytics();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // ==============================================================
  // 1. SUMMARY
  // ==============================================================
  Future<void> _loadSummaryData(String period) async {
    try {
      isLoading.value = true;

      String range = period;
      String? start, end;

      if (period == 'custom') {
        range = 'custom';
        start = formattedDate(selectedRange.value.start);
        end = formattedDate(selectedRange.value.end);
      }

      final summaryResponse = await apiService.getCallLogsSummary(
        range: range,
        start: start,
        end: end,
      );

      if (summaryResponse.success) {
        final data = summaryResponse.data;

        totalCalls.value = data.total.count;
        incomingCalls.value = data.incoming.count;
        outgoingCalls.value = data.outgoing.count;
        missedCalls.value = data.missed.count;
        rejectedCalls.value = data.rejected.count;
        neverAttendedCalls.value = data.neverAttended.count;
        notPickedByClient.value = data.notPickedByClient.count;

        totalTalkTime.value = (data.total.durationSeconds ?? 0).toDouble();
        incomingTalkTime.value = (data.incoming.durationSeconds ?? 0).toDouble();
        outgoingTalkTime.value = (data.outgoing.durationSeconds ?? 0).toDouble();
      }
    } catch (e) {
      debugPrint("Error loading summary data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ==============================================================
  // 2. ANALYSIS
  // ==============================================================
  Future<void> _loadAnalysisData(String period) async {
    try {
      isLoading.value = true;

      String range = period;
      String? start, end;

      if (period == 'custom') {
        range = 'custom';
        start = formattedDate(selectedRange.value.start);
        end = formattedDate(selectedRange.value.end);
      }

      final analysisTypes = [
        'top_caller',
        'longest_call',
        'highest_total_duration',
        'average_duration',
        'top10_frequent',
        'top10_duration'
      ];

      final analysisResponses = await Future.wait(
        analysisTypes.map((type) => apiService.getCallLogsAnalysis(
          range: range,
          type: type,
          start: start,
          end: end,
        )),
      );

      for (var i = 0; i < analysisTypes.length; i++) {
        final type = analysisTypes[i];
        final response = analysisResponses[i];

        if (response.success) {
          _processAnalysisData(type, response.data);
        }
      }
    } catch (e) {
      debugPrint("Error loading analysis data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _processAnalysisData(String type, dynamic data) {
    switch (type) {
      case 'top_caller':
        final items = (data as List<dynamic>).cast<Map<String, dynamic>>();
        if (items.isNotEmpty) {
          topCaller.value = items.first['_id'] ?? '-';
        }
        break;

      case 'longest_call':
        final items = (data as List<dynamic>).cast<Map<String, dynamic>>();
        if (items.isNotEmpty) {
          final item = LongestCallItem.fromJson(items.first);
          longestCallDuration.value = item.durationSeconds;
          longestCallName.value = item.phoneNumber ?? item.id;
          longestCallId.value = item.id;
        }
        break;

      case 'highest_total_duration':
        final items = (data as List<dynamic>).cast<Map<String, dynamic>>();
        if (items.isNotEmpty) {
          final item = HighestTotalDurationItem.fromJson(items.first);
          mostTalkTimeContact.value = item.phoneNumber;
          highestDurationCallId.value = item.id;
        }
        break;

      case 'average_duration':
        final avgData = AverageDurationModel.fromJson(data);
        averageCallDuration.value = avgData.perCall.avgDuration;
        break;

      case 'top10_frequent':
        final freqData = Top10FrequentModel.fromJson(data);
        top10ByCount.assignAll(
          freqData.all.map((item) => {
            'id': item.id,
            'name': item.id,
            'count': item.count,
          }).toList(),
        );
        break;

      case 'top10_duration':
        final durationData = Top10FrequentModel.fromJson(data);
        top10ByDuration.assignAll(
          durationData.all.map((item) => {
            'id': item.id,
            'name': item.id,
            'duration': item.totalDuration ?? 0,
          }).toList(),
        );
        break;
    }
  }


/// Returns the first call-log _id for the given phone number (top caller)
String topCallerCallLogId() {
  final topPhone = topCaller.value;
  if (topPhone.isEmpty) return '';

  return filteredCallLogItems
          .where((log) => log.phoneNumber == topPhone)
          .firstOrNull
          ?.id ??
      '';
}

/// Returns first call-log _id for the contact with highest total duration
String highestDurationCallLogId() {
  final topPhone = mostTalkTimeContact.value;
  if (topPhone.isEmpty) return '';

  return filteredCallLogItems
          .where((log) => log.phoneNumber == topPhone)
          .firstOrNull
          ?.id ??
      '';
}

  // ==============================================================
  // 3. NEW: FILTERED LIST FROM SERVER (REAL IDs)
  // ==============================================================
  Future<void> _loadFilteredCallLogs(String period) async {
    try {
      isLoading.value = true;

      String range = period;
      DateTime? start, end;

      if (period == 'custom') {
        range = 'custom';
        start = selectedRange.value.start;
        end = selectedRange.value.end;
      }

      final resp = await apiService.getFilteredCallLogs(
        range: range,
        limit: 500,               // enough for all cards
        start: start,
        end: end,
      );

      if (resp.success) {
        filteredCallLogItems.assignAll(resp.data.items);
      }
    } catch (e) {
      debugPrint('Filtered logs error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ==============================================================
  // 4. REFRESH – ALL THREE IN PARALLEL
  // ==============================================================
  Future<void> refreshAnalytics({bool force = false}) async {
    if (isLoading.value && !force) {
      print("Analytics refresh skipped: already loading");
      return;
    }

    final currentPeriod = currentFilterKey;
    await Future.wait([
      _loadSummaryData(currentPeriod),
      _loadAnalysisData(currentPeriod),
      _loadFilteredCallLogs(currentPeriod),   // <-- NEW
    ]);
  }

  // ==============================================================
  // 5. FILTER SELECTION
  // ==============================================================
  void selectFilter(String label) {
    isYesterdaySelected.value = label == 'Yesterday';
    isTodaySelected.value = label == 'Today';
    isLast7DaysSelected.value = label == 'Last 7 Days';
    isCustomRangeSelected.value = false;

    final period = label == 'Yesterday'
        ? 'yesterday'
        : label == 'Last 7 Days'
            ? 'last7'
            : 'today';

    refreshAnalytics();
  }

  void confirmCustomRange() {
    if (!validateDateRange()) return;

    isCustomRangeSelected.value = true;
    isTodaySelected.value = isYesterdaySelected.value = isLast7DaysSelected.value = false;
    refreshAnalytics();
  }

  // ==============================================================
  // 6. DATE HELPERS
  // ==============================================================
  void selectStartDate(DateTime date) => selectedRange.value =
      DateTimeRange(start: date, end: selectedRange.value.end);

  void selectEndDate(DateTime date) => selectedRange.value =
      DateTimeRange(start: selectedRange.value.start, end: date);

  bool validateDateRange() {
    if (selectedRange.value.end.isBefore(selectedRange.value.start)) {
      dateError.value = 'End date must be after start date';
      return false;
    }
    dateError.value = '';
    return true;
  }

  String formattedDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  void initializeCalendarRange() {
    selectedRange.value = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 6)),
      end: DateTime.now(),
    );
    dateError.value = '';
  }

  // ==============================================================
  // 7. CURRENT FILTER KEY & RANGE
  // ==============================================================
  String get currentFilterKey {
    if (isCustomRangeSelected.value) return 'custom';
    if (isTodaySelected.value) return 'today';
    if (isYesterdaySelected.value) return 'yesterday';
    if (isLast7DaysSelected.value) return 'last7';
    return 'today';
  }

  DateTimeRange get currentDateRange {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return switch (currentFilterKey) {
      'today' => DateTimeRange(start: today, end: now),
      'yesterday' => DateTimeRange(
          start: today.subtract(const Duration(days: 1)),
          end: today.subtract(const Duration(seconds: 1))),
      'last7' => DateTimeRange(start: today.subtract(const Duration(days: 6)), end: now),
      'custom' => selectedRange.value,
      _ => DateTimeRange(start: today, end: now),
    };
  }

  // ==============================================================
  // 8. NAVIGATION DATA – PASS REAL IDs + FILTER PARAMS
  // ==============================================================
  AnalyticsNavigationData getNavigationData({
    required String title,
    Map<String, dynamic> extra = const {},
    String? direction,
    String? status,
  }) {
    // Filter the server-side list by direction/status
    final ids = filteredCallLogItems
        .where((e) =>
            (direction == null || e.direction.toLowerCase() == direction) &&
            (status == null || e.status.toLowerCase() == status))
        .map((e) => e.id)
        .toList();

    final updatedExtra = Map<String, dynamic>.from(extra)
      ..addAll({
        'callLogIds': ids,
        if (direction != null) 'direction': direction,
        if (status != null) 'status': status,
      });

    return AnalyticsNavigationData(
      title: title,
      dateRange: currentDateRange,
      filterType: currentFilterKey,
      extra: updatedExtra,
    );
  }

  // ==============================================================
  // 9. (REMOVED) – Fake ID logic from CallsController
  // ==============================================================
  // The method `_getCallLogIdsFromCallsController()` and related code
  // have been **deleted**. We now use real MongoDB `_id`s from the server.
}