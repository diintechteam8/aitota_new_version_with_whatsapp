import 'package:intl/intl.dart';
import 'package:aitota_business/core/app-export.dart';
import '../../../../../core/services/api_services.dart';
import '../../../../../core/services/dio_client.dart';
import '../../../../../data/model/myDial/my_dial_leads_model.dart';
import '../../../../../routes/app_routes.dart';

class MyDialLeadsController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final leadData = Rxn<DialLeadData>();
  final isLoading = false.obs;

  final isTodaySelected = true.obs;
  final isYesterdaySelected = false.obs;
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
    isTodaySelected.value = label == 'Today';
    isYesterdaySelected.value = label == 'Yesterday';
    isLast7DaysSelected.value = label == 'Last 7 Days';
    isCustomRangeSelected.value = false;

    String? filter;
    if (label == 'Today') filter = 'today';
    if (label == 'Yesterday') filter = 'yesterday';
    if (label == 'Last 7 Days') filter = 'last7days';

    fetchLeads(filter: filter);
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
      isCustomRangeSelected.value = true;
      isTodaySelected.value = false;
      isYesterdaySelected.value = false;
      isLast7DaysSelected.value = false;

      final start = DateFormat('yyyy-MM-dd').format(selectedRange.value.start);
      final end = DateFormat('yyyy-MM-dd').format(selectedRange.value.end);

      fetchLeads(startDate: start, endDate: end);
    }
  }

  String formattedDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void initializeCalendarRange() {
    selectedRange.value = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 6)).startOfDay,
      end: DateTime.now().endOfDay,
    );
    dateError.value = '';
  }

  Future<void> fetchLeads({String? filter, String? startDate, String? endDate}) async {
    try {
      isLoading.value = true;
      final response = await apiService.getDialLeads(
        filter: filter,
        startDate: startDate,
        endDate: endDate,
      );

      if (response.success == true && response.data != null) {
        leadData.value = response.data;
      } else {
        leadData.value = DialLeadData(
          veryInterested: LeadCategoryData(data: [], count: 0),
          maybe: LeadCategoryData(data: [], count: 0),
          enrolled: LeadCategoryData(data: [], count: 0),
          junkLead: LeadCategoryData(data: [], count: 0),
          notRequired: LeadCategoryData(data: [], count: 0),
          enrolledOther: LeadCategoryData(data: [], count: 0),
          decline: LeadCategoryData(data: [], count: 0),
          notEligible: LeadCategoryData(data: [], count: 0),
          wrongNumber: LeadCategoryData(data: [], count: 0),
          hotFollowup: LeadCategoryData(data: [], count: 0),
          coldFollowup: LeadCategoryData(data: [], count: 0),
          schedule: LeadCategoryData(data: [], count: 0),
          notConnected: LeadCategoryData(data: [], count: 0),
          other: LeadCategoryData(data: [], count: 0),
        );
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshLeads() async {
    if (isCustomRangeSelected.value) {
      confirmCustomRange();
    } else if (isTodaySelected.value) {
      selectFilter('Today');
    } else if (isYesterdaySelected.value) {
      selectFilter('Yesterday');
    } else if (isLast7DaysSelected.value) {
      selectFilter('Last 7 Days');
    } else {
      fetchLeads();
    }
  }

  void onVVITap() {
    Get.toNamed(
      AppRoutes.myDialLeadsDetailScreen,
      arguments: {'status': 'V Interested', 'leads': leadData.value?.veryInterested?.data ?? []},
    );
  }

  void onMayBeTap() {
    Get.toNamed(
      AppRoutes.myDialLeadsDetailScreen,
      arguments: {'status': 'May Be', 'leads': leadData.value?.maybe?.data ?? []},
    );
  }

  void onEnrolledTap() {
    Get.toNamed(
      AppRoutes.myDialLeadsDetailScreen,
      arguments: {'status': 'Enrolled', 'leads': leadData.value?.enrolled?.data ?? []},
    );
  }

}

extension DateTimeExtension on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
}