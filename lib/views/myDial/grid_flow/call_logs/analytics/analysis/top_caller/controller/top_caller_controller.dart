import '../../../../../../../../core/app-export.dart';
import '../../../../../../../../core/services/api_services.dart';
import '../../../../../../../../core/services/dio_client.dart';
import '../../../../../../../../data/model/myDial/analysis_models/call_analytics_analysis_model.dart';
import '../../../../../../../../data/model/myDial/analysis_models/call_stats_model.dart';
import '../../../controller/call_analytics_controller.dart';
import 'package:intl/intl.dart';

class TopCallerController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);

  final isLoading = false.obs;
  final currentStats = Rxn<CallStatsModel>();

  late final String callLogId;
  late final String screenTitle;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as AnalyticsNavigationData;
    callLogId = args.extra['callLogId'] as String? ?? '';
    final type = args.extra['type'] as String? ?? 'top_caller';

    screenTitle = _getTitle(type);

    if (callLogId.isNotEmpty) {
      fetchCallDetail();
    } else {
      currentStats.value = CallStatsModel(name: 'No Data', phoneNumber: '', stats: []);
    }
  }

  Future<void> fetchCallDetail() async {
    try {
      isLoading.value = true;
      final model = await apiService.getCallLogDetail(callLogId);

      if (model.success && model.data != null) {
        currentStats.value = _buildStats(model.data!, args: Get.arguments);
      } else {
        currentStats.value = CallStatsModel(name: 'No Data', phoneNumber: '', stats: []);
      }
    } catch (e) {
      debugPrint('Error loading call detail: $e');
      currentStats.value = CallStatsModel(name: 'Error', phoneNumber: '', stats: []);
    } finally {
      isLoading.value = false;
    }
  }

  CallStatsModel _buildStats(CallLogDetailData data, {required AnalyticsNavigationData args}) {
    final name = data.contact?.name ?? 'Unknown';
    final type = args.extra['type'] as String? ?? 'top_caller';
    final highlightDuration = args.extra['highlightDuration'] as int?;
    final highlightName = args.extra['highlightName'] as String?;

    final isIncoming = data.direction.toLowerCase() == 'incoming' || data.direction.toLowerCase() == 'inbound';

    final baseStats = [
      CallStatItem(icon: Icons.phone_android, label: 'Phone Number', value: data.phoneNumber),
      CallStatItem(
        icon: Icons.calendar_today,
        label: 'Date',
        value: DateFormat('dd MMM yyyy').format(DateTime.parse(data.startedAt)),
      ),
      CallStatItem(
        icon: Icons.access_time,
        label: 'Call Time',
        value: DateFormat('hh:mm a').format(DateTime.parse(data.startedAt)),
      ),
      CallStatItem(
        icon: isIncoming ? Icons.call_received : Icons.call_made,
        label: 'Call Type',
        value: data.direction.toUpperCase(),
        iconColor: isIncoming ? const Color(0xFF8BC34A) : const Color(0xFFFFA726),
      ),
      CallStatItem(
        icon: Icons.timer,
        label: 'Duration',
        value: _formatDuration(data.durationSeconds),
        iconColor: const Color(0xFF42A5F5),
      ),
    ];

    switch (type) {
      case 'longest_call':
        return CallStatsModel(name: name, phoneNumber: data.phoneNumber, stats: baseStats);

      case 'highest_duration':
        final totalSec = highlightDuration ?? data.durationSeconds;
        final totalStats = [
          CallStatItem(icon: Icons.phone_android, label: 'Contact', value: highlightName ?? name),
          CallStatItem(
            icon: Icons.timer,
            label: 'Total Duration',
            value: _formatDuration(totalSec),
            iconColor: const Color(0xFFFFA726),
          ),
        ];
        return CallStatsModel(name: highlightName ?? name, phoneNumber: '', stats: totalStats);

      default: // top_caller
        return CallStatsModel(name: name, phoneNumber: data.phoneNumber, stats: baseStats);
    }
  }

  String _formatDuration(int seconds) {
    if (seconds == 0) return '0s';
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) return '${h}h ${m}m ${s}s';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  String _getTitle(String type) {
    return switch (type) {
      'longest_call' => 'Longest Call',
      'highest_duration' => 'Highest Total Call Duration',
      _ => 'Top Caller',
    };
  }
}