import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../core/services/api_services.dart';
import '../../../../../core/services/dio_client.dart';
import '../../../../../data/model/outbound/outbound_conversations_model.dart';

class OutboundConversationsController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final conversations = <ConversationData>[].obs;
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
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final hasNextPage = false.obs;
  OutboundConversationsModel? outboundConversationModel;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    selectFilter('Today'); // Initialize with "Today" filter
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent &&
          !isLoading.value &&
          hasNextPage.value) {
        fetchMoreConversations();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
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

    currentPage.value = 1;
    conversations.clear();
    fetchConversations(filter: filter);
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

    currentPage.value = 1;
    conversations.clear();
    fetchConversations(startDate: start, endDate: end);
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

  Future<void> fetchConversations({
    String? filter,
    String? startDate,
    String? endDate,
  }) async {
    try {
      isLoading.value = true;
      final response = await apiService.getOutboundConversations(
        filter: filter,
        startDate: startDate,
        endDate: endDate,
        page: currentPage.value,
      );
      outboundConversationModel = response;
      if (response.success == true && response.data != null) {
        conversations.assignAll(response.data!);
        currentPage.value = response.pagination?.currentPage ?? 1;
        totalPages.value = response.pagination?.totalPages ?? 1;
        hasNextPage.value = response.pagination?.hasNextPage ?? (response.data!.length >= 20);
      } else {
        conversations.clear();
      }
    } catch (e) {
      conversations.clear();
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMoreConversations() async {
    if (!hasNextPage.value || isLoading.value) {
      return;
    }
    try {
      isLoading.value = true;
      final response = await apiService.getOutboundConversations(
        filter: isTodaySelected.value
            ? 'today'
            : isYesterdaySelected.value
            ? 'yesterday'
            : isLast7DaysSelected.value
            ? 'last7days'
            : null,
        startDate: isCustomRangeSelected.value
            ? selectedRange.value.start.toIso8601String()
            : null,
        endDate: isCustomRangeSelected.value
            ? selectedRange.value.end
            .add(const Duration(
            hours: 23, minutes: 59, seconds: 59, milliseconds: 999))
            .toIso8601String()
            : null,
        page: currentPage.value + 1,
      );
      if (response.success == true && response.data != null) {
        conversations.addAll(response.data!);
        currentPage.value = response.pagination?.currentPage ?? currentPage.value;
        totalPages.value = response.pagination?.totalPages ?? totalPages.value;
        hasNextPage.value = response.pagination?.hasNextPage ?? (response.data!.length >= 20);
      }
    } catch (e) {
       throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshConversations() async {
    currentPage.value = 1;
    conversations.clear();
    if (isCustomRangeSelected.value) {
      confirmCustomRange();
    } else if (isYesterdaySelected.value) {
      selectFilter('Yesterday');
    } else if (isTodaySelected.value) {
      selectFilter('Today');
    } else if (isLast7DaysSelected.value) {
      selectFilter('Last 7 Days');
    } else {
      fetchConversations();
    }
  }
}