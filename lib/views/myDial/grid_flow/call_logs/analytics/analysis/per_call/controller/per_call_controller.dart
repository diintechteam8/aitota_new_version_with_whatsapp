import '../../../../../../../../core/app-export.dart';
import '../../../../../../../../core/services/api_services.dart';
import '../../../../../../../../core/services/dio_client.dart';
import '../../../../../../../../data/model/myDial/analysis_models/call_analytics_analysis_model.dart';
import '../../../controller/call_analytics_controller.dart';

class PerCallController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);

  // UI
  final isLoading = false.obs;

  // Stats
  final numberOfDays = 0.obs;
  final totalDuration = '0s'.obs;
  final avgDurationPerDay = '0s'.obs;

  final incomingCalls = 0.obs;
  final incomingDuration = '0s'.obs;
  final incomingAvgDuration = '0s'.obs;

  final outgoingCalls = 0.obs;
  final outgoingDuration = '0s'.obs;
  final outgoingAvgDuration = '0s'.obs;

  final totalCalls = 0.obs;
  final totalCallsDuration = '0s'.obs;
  final totalCallsAvgDuration = '0s'.obs;

  // Navigation
  late final List<String> callLogIds;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as AnalyticsNavigationData;
    callLogIds = List<String>.from(args.extra['callLogIds'] ?? []);

    if (callLogIds.isNotEmpty) {
      fetchAndCalculate();
    }
  }

  Future<void> fetchAndCalculate() async {
    if (callLogIds.isEmpty) {
      _resetStats();
      return;
    }

    try {
      isLoading.value = true;
      final List<CallLogDetailData> details = [];

      for (final id in callLogIds) {
        try {
          final model = await apiService.getCallLogDetail(id);
          if (model.success && model.data != null) {
            details.add(model.data!);
          }
        } catch (e) {
          debugPrint('Error loading call $id: $e');
        }
      }

      _calculateFromDetails(details);
    } catch (e) {
      debugPrint('PerCall error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateFromDetails(List<CallLogDetailData> details) {
    if (details.isEmpty) {
      _resetStats();
      return;
    }

  // Parse startedAt string → DateTime
    final dates = details.map((e) {
      final date = DateTime.parse(e.startedAt);
      return DateTime(date.year, date.month, date.day);
    }).toSet();
    
    final daysCount = dates.length;

    final totalSeconds = details.fold(0, (sum, d) => sum + d.durationSeconds);

    final incoming = details.where((d) => d.direction.toLowerCase() == 'incoming').toList();
    final incCalls = incoming.length;
    final incSec = incoming.fold(0, (s, d) => s + d.durationSeconds);

    final outgoing = details.where((d) => d.direction.toLowerCase() == 'outgoing').toList();
    final outCalls = outgoing.length;
    final outSec = outgoing.fold(0, (s, d) => s + d.durationSeconds);

    numberOfDays.value = daysCount;
    totalDuration.value = _format(totalSeconds);
    avgDurationPerDay.value = daysCount > 0 ? _format(totalSeconds ~/ daysCount) : '0s';

    incomingCalls.value = incCalls;
    incomingDuration.value = _format(incSec);
    incomingAvgDuration.value = incCalls > 0 ? _format(incSec ~/ incCalls) : '0s';

    outgoingCalls.value = outCalls;
    outgoingDuration.value = _format(outSec);
    outgoingAvgDuration.value = outCalls > 0 ? _format(outSec ~/ outCalls) : '0s';

    totalCalls.value = incCalls + outCalls;
    totalCallsDuration.value = _format(incSec + outSec);
    totalCallsAvgDuration.value = (incCalls + outCalls) > 0
        ? _format((incSec + outSec) ~/ (incCalls + outCalls))
        : '0s';
  }

  void _resetStats() {
    numberOfDays.value = 0;
    totalDuration.value = avgDurationPerDay.value = '0s';
    incomingCalls.value = outgoingCalls.value = totalCalls.value = 0;
    incomingDuration.value = incomingAvgDuration.value = '0s';
    outgoingDuration.value = outgoingAvgDuration.value = '0s';
    totalCallsDuration.value = totalCallsAvgDuration.value = '0s';
  }

  String _format(int seconds) {
    if (seconds == 0) return '0s';
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) return '${h}h ${m}m ${s}s';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }
}