// controller/never_attended_calls_controller.dart
import 'dart:async';
import 'package:intl/intl.dart';
import '../../../../../../../core/app-export.dart';
import '../../../../../../../core/services/api_services.dart';
import '../../../../../../../core/services/dio_client.dart';
import '../../../../../../../data/model/myDial/analysis_models/call_analytics_analysis_model.dart';
import '../../controller/call_analytics_controller.dart';

class NeverAttendedCallsController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);

  // UI
  final isLoading = false.obs;
  final calls = <CallGroupItem>[].obs;
  final errorMessage = ''.obs;

  // Navigation data
  late final List<String> callLogIds;
  late final String direction;
  late final String status;
  late final String screenTitle;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as AnalyticsNavigationData;

    callLogIds = List<String>.from(args.extra['callLogIds'] ?? []);
    direction = args.extra['direction'] as String? ?? 'incoming';
    status = args.extra['status'] as String? ?? 'never_attended';

    screenTitle = _getScreenTitle(direction, status);

    fetchAndGroupCalls();
  }

  String _getScreenTitle(String dir, String stat) {
    if (dir == 'incoming' && stat == 'never_attended') return 'Never Attended Calls';
    if (dir == 'outgoing' && stat == 'not_picked_by_client') return 'Not Picked by Client';
    return 'Call History';
  }

  // ── FETCH + GROUP ──
  Future<void> fetchAndGroupCalls() async {
    if (callLogIds.isEmpty) {
      errorMessage.value = 'No calls for this filter.';
      calls.clear();
      return;
    }

    try {
      isLoading.value = true;
      final List<CallLogDetailData> details = [];

      for (final id in callLogIds) {
        try {
          final model = await apiService.getCallLogDetail(id);
          if (model.success && model.data != null) {
            final d = model.data!;
            // Only include if duration is 0 (missed / not picked)
            if (d.durationSeconds == 0) {
              details.add(d);
            }
          }
        } catch (e) {
          debugPrint('Error loading detail $id: $e');
        }
      }

      final grouped = <String, _Group>{};

      for (final call in details) {
        final key = call.phoneNumber;
        final group = grouped.putIfAbsent(key, () => _Group(
          name: call.contact?.name ?? 'Unknown',
          phone: call.phoneNumber,
          calls: [],
        ));

        group.calls.add(call);
      }

      final result = grouped.values.map((g) {
        final latest = g.calls.reduce((a, b) =>
            a.startedAt.compareTo(b.startedAt) > 0 ? a : b);

        return CallGroupItem(
          name: g.name,
          phoneNumber: g.phone,
          callCount: g.calls.length.toString(),
          date: _formatDate(latest.startedAt),
          time: _formatTime(latest.startedAt),
        );
      }).toList();

      // Sort: newest first
      result.sort((a, b) {
        final da = DateTime.parse('${a.date} ${a.time}');
        final db = DateTime.parse('${b.date} ${b.time}');
        return db.compareTo(da);
      });

      calls.assignAll(result);
    } catch (e) {
      errorMessage.value = 'Failed to load calls';
    } finally {
      isLoading.value = false;
    }
  }

  String _formatDate(String iso) => DateFormat('dd MMM yyyy').format(DateTime.parse(iso));
  String _formatTime(String iso) => DateFormat('hh:mm a').format(DateTime.parse(iso));
}

// Helper classes
class _Group {
  final String name;
  final String phone;
  final List<CallLogDetailData> calls;
  _Group({required this.name, required this.phone, required this.calls});
}

class CallGroupItem {
  final String name;
  final String phoneNumber;
  final String callCount;
  final String date;
  final String time;

  CallGroupItem({
    required this.name,
    required this.phoneNumber,
    required this.callCount,
    required this.date,
    required this.time,
  });
}