import '../../../../../../../../core/app-export.dart';
import '../../../../../../../../core/services/api_services.dart';
import '../../../../../../../../core/services/dio_client.dart';
import '../../../../../../../../data/model/myDial/analysis_models/call_analytics_analysis_model.dart';
import '../../../controller/call_analytics_controller.dart';

class ContactCall {
  final String name;
  final String phoneNumber;
  final int callCount;
  final int totalSeconds;

  ContactCall({
    required this.name,
    required this.phoneNumber,
    required this.callCount,
    required this.totalSeconds,
  });

  String get totalDuration {
    if (totalSeconds == 0) return '0s';
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;
    if (h > 0) return '${h}h ${m}m ${s}s';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }
}

class TopTalkedController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);

  final isLoading = false.obs;
  final selectedTab = 0.obs;
  final type = 'frequency'.obs;

  final allCalls = <ContactCall>[].obs;
  final incomingCalls = <ContactCall>[].obs;
  final outgoingCalls = <ContactCall>[].obs;

  late final List<String> callLogIds;
  late final String rankingType; // 'frequency' or 'duration'

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as AnalyticsNavigationData;
    callLogIds = List<String>.from(args.extra['callLogIds'] ?? []);
    rankingType = args.extra['type'] as String? ?? 'frequency';
    type.value = rankingType == 'duration' ? 'duration' : 'frequency';

    if (callLogIds.isNotEmpty) {
      fetchAndGroupCalls();
    }
  }

  Future<void> fetchAndGroupCalls() async {
    if (callLogIds.isEmpty) {
      allCalls.clear();
      incomingCalls.clear();
      outgoingCalls.clear();
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

      _groupAndSort(details);
    } catch (e) {
      debugPrint('TopTalked error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _groupAndSort(List<CallLogDetailData> details) {
    final Map<String, _ContactStats> stats = {};

    for (final call in details) {
      final key = call.phoneNumber;
      final name = call.contact?.name ?? 'Unknown';

      final stat = stats.putIfAbsent(key, () => _ContactStats(name: name, phone: key));

      stat.callCount++;
      stat.totalSeconds += call.durationSeconds;

      if (call.direction.toLowerCase() == 'incoming') {
        stat.incomingCount++;
        stat.incomingSeconds += call.durationSeconds;
      } else {
        stat.outgoingCount++;
        stat.outgoingSeconds += call.durationSeconds;
      }
    }

    final sorted = stats.values.toList();

    // Sort All
    sorted.sort((a, b) => rankingType == 'duration'
        ? b.totalSeconds.compareTo(a.totalSeconds)
        : b.callCount.compareTo(a.callCount));

    allCalls.assignAll(sorted.map((s) => ContactCall(
          name: s.name,
          phoneNumber: s.phone,
          callCount: s.callCount,
          totalSeconds: s.totalSeconds,
        )));

    // Incoming
    final inc = sorted.where((s) => s.incomingCount > 0).toList()
      ..sort((a, b) => rankingType == 'duration'
          ? b.incomingSeconds.compareTo(a.incomingSeconds)
          : b.incomingCount.compareTo(a.incomingCount));

    incomingCalls.assignAll(inc.map((s) => ContactCall(
          name: s.name,
          phoneNumber: s.phone,
          callCount: s.incomingCount,
          totalSeconds: s.incomingSeconds,
        )));

    // Outgoing
    final out = sorted.where((s) => s.outgoingCount > 0).toList()
      ..sort((a, b) => rankingType == 'duration'
          ? b.outgoingSeconds.compareTo(a.outgoingSeconds)
          : b.outgoingCount.compareTo(a.outgoingCount));

    outgoingCalls.assignAll(out.map((s) => ContactCall(
          name: s.name,
          phoneNumber: s.phone,
          callCount: s.outgoingCount,
          totalSeconds: s.outgoingSeconds,
        )));
  }

  void changeTab(int index) => selectedTab.value = index;

  List<ContactCall> getCurrentTabData() {
    return selectedTab.value == 1
        ? incomingCalls
        : selectedTab.value == 2
            ? outgoingCalls
            : allCalls;
  }
}

class _ContactStats {
  final String name;
  final String phone;
  int callCount = 0;
  int totalSeconds = 0;
  int incomingCount = 0;
  int incomingSeconds = 0;
  int outgoingCount = 0;
  int outgoingSeconds = 0;

  _ContactStats({required this.name, required this.phone});
}