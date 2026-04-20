import 'package:intl/intl.dart';
import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/services/api_services.dart';
import 'package:aitota_business/core/services/dio_client.dart';
import '../../../../../data/model/myDial/sale_done_model.dart';

class MyDialSaleController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final salesData = Rxn<SaleDoneModel>();
  var isLoading = true.obs;

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

    fetchSales(filter: filter);
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

  void confirmCustomRange() {
    if (validateDateRange()) {
      isCustomRangeSelected.value = true;
      isYesterdaySelected.value = false;
      isTodaySelected.value = false;
      isLast7DaysSelected.value = false;

      final start = DateFormat('yyyy-MM-dd').format(selectedRange.value.start);
      final end = DateFormat('yyyy-MM-dd').format(selectedRange.value.end);

      fetchSales(startDate: start, endDate: end);
    }
  }

  Future<void> fetchSales({String? filter, String? startDate, String? endDate}) async {
    try {
      isLoading.value = true;
      final response = await apiService.getSaleDone(
        filter: filter,
        startDate: startDate,
        endDate: endDate,
      );

      if (response.success == true && response.data != null) {
        salesData.value = response;
      } else {
        salesData.value = SaleDoneModel(data: []);
      }
    } catch (e) {
      salesData.value = SaleDoneModel(data: []);
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshSales() async {
    if (isCustomRangeSelected.value) {
      confirmCustomRange();
    } else if (isYesterdaySelected.value) {
      selectFilter('Yesterday');
    } else if (isTodaySelected.value) {
      selectFilter('Today');
    } else if (isLast7DaysSelected.value) {
      selectFilter('Last 7 Days');
    } else {
      fetchSales();
    }
  }
}

extension DateTimeExtension on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
}