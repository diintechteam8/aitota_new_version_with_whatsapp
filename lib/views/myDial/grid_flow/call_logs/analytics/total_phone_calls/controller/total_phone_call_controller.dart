// total_phone_call_controller.dart
import 'package:aitota_business/views/myDial/grid_flow/call_logs/analytics/controller/call_analytics_controller.dart';
import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/services/api_services.dart';
import 'package:aitota_business/core/services/dio_client.dart';
import '../../../../../../../data/model/myDial/analysis_models/call_analytics_analysis_model.dart';

class TotalPhoneCallsController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  late final AnalyticsNavigationData navData;

  final RxBool isLoading = false.obs;

  // ────────────────────── Stats (unchanged) ──────────────────────
  final RxInt incomingCount = 0.obs;
  final RxInt outgoingCount = 0.obs;
  final RxInt missedCount = 0.obs;
  final RxInt rejectedCount = 0.obs;
  final RxInt totalCalls = 0.obs;
  final RxInt incomingDuration = 0.obs;
  final RxInt outgoingDuration = 0.obs;
  final RxInt totalDuration = 0.obs;

  @override
  void onInit() {
    super.onInit();
    navData = Get.arguments as AnalyticsNavigationData;
    _loadSummaryData();
  }

  // ─────────────────────────────────────────────────────────────────────
  // PUBLIC METHOD – used by the list screens (Incoming / Outgoing …)
  // ─────────────────────────────────────────────────────────────────────
  Future<List<CallLogDetailData>> fetchCallLogDetails(List<String> callLogIds) async {
    if (callLogIds.isEmpty) return <CallLogDetailData>[];

    final futures = callLogIds.map((id) async {
      try {
        final res = await apiService.getCallLogDetail(id);
        if (res.success && res.data != null) return res.data!;
      } catch (e) {
        debugPrint('Error fetching call log $id: $e');
      }
      return null;
    });

    final results = await Future.wait(futures);
    return results.whereType<CallLogDetailData>().toList();
  }

  // ─────────────────────────────────────────────────────────────────────
  // PRIVATE – load summary (now re‑uses the public method)
  // ─────────────────────────────────────────────────────────────────────
  Future<void> _loadSummaryData() async {
    isLoading.value = true;
    try {
      final List<String> callLogIds =
          (navData.extra['callLogIds'] as List<dynamic>?)?.cast<String>() ?? [];

      if (callLogIds.isEmpty) {
        _resetStats();
        return;
      }

      final validCalls = await fetchCallLogDetails(callLogIds);
      _calculateStats(validCalls);
    } catch (e) {
      debugPrint('Error in _loadSummaryData: $e');
      _resetStats();
    } finally {
      isLoading.value = false;
    }
  }

  // ────────────────────── Stats calculation (unchanged) ──────────────────────
  void _calculateStats(List<CallLogDetailData> calls) {
    incomingCount.value = 0;
    outgoingCount.value = 0;
    missedCount.value = 0;
    rejectedCount.value = 0;
    incomingDuration.value = 0;
    outgoingDuration.value = 0;
    totalDuration.value = 0;

    for (final call in calls) {
      final isIncoming = call.direction == 'incoming';
      final durationSec = call.durationSeconds ?? 0;

      if (isIncoming) {
        incomingCount.value++;
        incomingDuration.value += durationSec;

        if (durationSec == 0) {
          missedCount.value++;
        } else if (durationSec > 0 && durationSec <= 5) {
          rejectedCount.value++;
        }
      } else {
        outgoingCount.value++;
        outgoingDuration.value += durationSec;
      }

      totalDuration.value += durationSec;
    }

    totalCalls.value = calls.length;
  }

  void _resetStats() {
    incomingCount.value = outgoingCount.value = missedCount.value =
        rejectedCount.value = totalCalls.value = 0;
    incomingDuration.value = outgoingDuration.value = totalDuration.value = 0;
  }

  String formatDuration(int seconds) {
    if (seconds <= 0) return '-';
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    final parts = <String>[];
    if (h > 0) parts.add('${h}h');
    if (m > 0) parts.add('${m}m');
    if (s > 0 || parts.isEmpty) parts.add('${s}s');
    return parts.join(' ');
  }

  double getPercentage(int part) {
    if (totalCalls.value == 0) return 0.0;
    return (part / totalCalls.value) * 100;
  }
}