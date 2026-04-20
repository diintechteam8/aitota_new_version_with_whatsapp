// controller/incoming_calls_controller.dart
import '../../../../../../../core/app-export.dart';
import '../../../../../../../core/services/api_services.dart';
import '../../../../../../../core/services/dio_client.dart';
import '../../../../../../../data/model/myDial/analysis_models/call_analytics_analysis_model.dart';
import '../../controller/call_analytics_controller.dart';

class IncomingCallsController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);

  final isLoading = false.obs;
  final filteredCalls = <CallLogDetailData>[].obs;
  final errorMessage = ''.obs;

  // No timer any more
  // Timer? _pollingTimer;

  late final List<String> callLogIds;
  late final String direction;
  late final String? status;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as AnalyticsNavigationData;

    callLogIds = List<String>.from(args.extra['callLogIds'] ?? []);
    direction = args.extra['direction'] as String? ?? 'incoming';
    status = args.extra['status'] as String?;

    // Load once on screen open
    fetchCallLogs();
  }

  @override
  void onClose() {
    // No timer to cancel
    super.onClose();
  }

  // -----------------------------------------------------------------
  // Public method – call this whenever you *actually* want fresh data
  // -----------------------------------------------------------------
  Future<void> refreshCalls({bool showLoader = true}) async {
    await fetchCallLogs(showLoader: showLoader);
  }

  // -----------------------------------------------------------------
  // Core fetch logic (kept private, used by refreshCalls & onInit)
  // -----------------------------------------------------------------
  Future<void> fetchCallLogs({bool showLoader = true}) async {
    if (callLogIds.isEmpty) {
  
      filteredCalls.clear();
      return;
    }

    if (showLoader) isLoading.value = true;
    final List<CallLogDetailData> fetched = [];

    try {
      // Parallelise the API calls – far faster than sequential loop
      final futures = callLogIds.map((id) => apiService.getCallLogDetail(id));

      final responses = await Future.wait(futures, eagerError: false);

      for (final model in responses) {
        if (model?.success == true && model?.data != null) {
          fetched.add(model!.data!);
        }
      }

      filteredCalls.assignAll(fetched);
      errorMessage.value = '';
    } catch (e) {
      debugPrint('IncomingCallsController – fetch error: $e');
    } finally {
      if (showLoader) isLoading.value = false;
    }
  }
}