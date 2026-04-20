import 'package:intl/intl.dart';
import '../../../../../core/app-export.dart';
import '../../../../../core/services/api_services.dart';
import '../../../../../core/services/dio_client.dart';
import '../../../../../data/model/inbound/inbound_lead_conversations_model.dart';
import '../../../../../routes/app_routes.dart';

class InboundLeadsController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final leadData = Rxn<InboundLeadData>();
  final isLoading = false.obs;

  final isYesterdaySelected = false.obs;
  final isTodaySelected = false.obs;
  final isLast7DaysSelected = false.obs;
  final isCustomRangeSelected = false.obs;

  final selectedRange = Rx<DateTimeRange>(
    DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 6)),
      end: DateTime.now(),
    ),
  );

  final dateError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    selectFilter('Today');
  }

  void selectFilter(String label) {
    isYesterdaySelected.value = label == 'Yesterday';
    isTodaySelected.value = label == 'Today';
    isLast7DaysSelected.value = label == 'Last 7 Days';
    isCustomRangeSelected.value = false;

    String? filter;
    if (label == 'Yesterday') filter = 'yesterday';
    if (label == 'Today') filter = 'today';
    if (label == 'Last 7 Days') filter = 'last7days';

    fetchLeads(filter: filter);
  }

  void selectStartDate(DateTime date) {
    selectedRange.value = DateTimeRange(
      start: date,
      end: selectedRange.value.end,
    );
  }

  void selectEndDate(DateTime date) {
    selectedRange.value = DateTimeRange(
      start: selectedRange.value.start,
      end: date,
    );
  }

  void confirmCustomRange() {
    isCustomRangeSelected.value = true;
    isYesterdaySelected.value = false;
    isTodaySelected.value = false;
    isLast7DaysSelected.value = false;

    final start = selectedRange.value.start.toIso8601String();
    final end = selectedRange.value.end
        .add(const Duration(hours: 23, minutes: 59, seconds: 59, milliseconds: 999))
        .toIso8601String();

    fetchLeads(startDate: start, endDate: end);
  }

  bool validateDateRange() {
    if (selectedRange.value.end.isBefore(selectedRange.value.start)) {
      dateError.value = 'End date must be after start date';
      return false;
    }
    dateError.value = '';
    return true;
  }

  String formattedDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void initializeCalendarRange() {
    selectedRange.value = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 6)),
      end: DateTime.now(),
    );
    dateError.value = '';
  }

  Future<void> fetchLeads({String? filter, String? startDate, String? endDate}) async {
    try {
      isLoading.value = true;
      final response = await apiService.getInboundLeads(
        filter: filter,
        startDate: startDate,
        endDate: endDate,
      );

      if (response.success == true && response.data != null) {
        leadData.value = response.data;
      } else {
        leadData.value = InboundLeadData(
          veryInterested: LeadCategory(data: [], count: 0),
          maybe: LeadCategory(data: [], count: 0),
          enrolled: LeadCategory(data: [], count: 0),
        );
      }
    } catch (e) {
      leadData.value = InboundLeadData(
        veryInterested: LeadCategory(data: [], count: 0),
        maybe: LeadCategory(data: [], count: 0),
        enrolled: LeadCategory(data: [], count: 0),
      );
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshLeads() async {
    // Reapply the last filter on refresh
    if (isCustomRangeSelected.value) {
      confirmCustomRange();
    } else if (isYesterdaySelected.value) {
      selectFilter('Yesterday');
    } else if (isTodaySelected.value) {
      selectFilter('Today');
    } else if (isLast7DaysSelected.value) {
      selectFilter('Last 7 Days');
    } else {
      fetchLeads(); // default
    }
  }

  void onVVITap() {
    Get.toNamed(
      AppRoutes.inboundLeadsDetailScreen,
      arguments: {'status': 'Very Interested', 'leads': leadData.value?.veryInterested?.data ?? []},
    );
  }

  void onMayBeTap() {
    Get.toNamed(
      AppRoutes.inboundLeadsDetailScreen,
      arguments: {'status': 'May Be', 'leads': leadData.value?.maybe?.data ?? []},
    );
  }

  void onEnrolledTap() {
    Get.toNamed(
      AppRoutes.inboundLeadsDetailScreen,
      arguments: {'status': 'Enrolled', 'leads': leadData.value?.enrolled?.data ?? []},
    );
  }
}