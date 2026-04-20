import 'package:aitota_business/core/app-export.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/utils/widgets/common_widgets/shimmer_loading.dart';
import 'controller/outbound_conversations_controller.dart';
import 'package:intl/intl.dart';

class OutboundConversationsScreen
    extends GetView<OutboundConversationsController> {
  const OutboundConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      body: SafeArea(
        top: true,
        child: RefreshIndicator(
          onRefresh: controller.refreshConversations,
          color: ColorConstants.appThemeColor,
          child: Obx(
            () => Stack(
              children: [
                CustomScrollView(
                  controller: controller.scrollController,
                  slivers: [
                    // Header with Filters, Title, Calendar
                    SliverToBoxAdapter(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Filter Buttons
                            Wrap(
                              spacing: 12.w,
                              runSpacing: 8.h,
                              children: [
                                _buildFilterButton(
                                    'Yesterday', controller.isYesterdaySelected),
                                _buildFilterButton(
                                    'Today', controller.isTodaySelected),
                                _buildFilterButton('Last 7 Days',
                                    controller.isLast7DaysSelected),
                              ],
                            ),
    
                            SizedBox(height: 8.h),
    
                            // Title + Calendar Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Conversations',
                                  style: TextStyle(
                                    fontFamily: AppFonts.poppins,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Get.isDarkMode
                                        ? ColorConstants.white
                                        : ColorConstants.blackText,
                                  ),
                                ),
                                _buildCalendarButton(context),
                              ],
                            ),
    
                            // Custom Date Range Display
                            if (controller.isCustomRangeSelected.value) ...[
                              SizedBox(height: 8.h),
                              _buildSelectedDateRange(),
                            ],
    
                            SizedBox(height: 8.h),
                          ],
                        ),
                      ),
                    ),
    
                    // Empty State
                    controller.isLoading.value && controller.conversations.isEmpty
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) =>
                                  BaseShimmer(child: ConversationCardShimmer()),
                              childCount: 10,
                            ),
                          )
                        : controller.conversations.isEmpty &&
                                !controller.isLoading.value
                            ? SliverFillRemaining(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'No conversations available',
                                        style: TextStyle(
                                          fontFamily: AppFonts.poppins,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: ColorConstants.grey,
                                        ),
                                      ),
                                      SizedBox(height: 12.h),
                                      ElevatedButton(
                                        onPressed: controller.refreshConversations,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorConstants.appThemeColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 10.h),
                                        ),
                                        child: Text(
                                          'Refresh',
                                          style: TextStyle(
                                            fontFamily: AppFonts.poppins,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: ColorConstants.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    if (index == controller.conversations.length &&
                                        controller.hasNextPage.value &&
                                        !controller.isLoading.value) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8.h),
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                                ColorConstants.appThemeColor),
                                          ),
                                        ),
                                      );
                                    }
                                    final conversation = controller.conversations[index];
                                    final clientName = controller.outboundConversationModel
                                            ?.clientName?.name ??
                                        'Unknown';

                                    return _buildConversationCard(
                                      userName: conversation.clientId ==
                                              controller.outboundConversationModel
                                                  ?.clientName?.id
                                          ? clientName
                                          : 'Unknown',
                                      userNumber: conversation.mobile ?? 'N/A',
                                      status: conversation.leadStatus ?? 'Unknown',
                                      date: _formatDate(conversation.time),
                                      duration: _formatDuration(conversation.duration),
                                      onTap: () {
                                        Get.toNamed(
                                          AppRoutes.outboundConversationsDetailScreen,
                                          arguments: {
                                            'conversation': conversation,
                                            'clientName': controller
                                                .outboundConversationModel?.clientName,
                                          },
                                        );
                                      },
                                    );
                                  },
                                  childCount: controller.conversations.length +
                                      (controller.hasNextPage.value &&
                                              !controller.isLoading.value
                                          ? 1
                                          : 0),
                                ),
                              ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Conversation Card
  Widget _buildConversationCard({
    required String userName,
    required String userNumber,
    required String status,
    required String date,
    required String duration,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 8.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: ColorConstants.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: ColorConstants.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          userName,
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Get.isDarkMode
                                ? ColorConstants.white
                                : ColorConstants.blackText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: ColorConstants.appThemeColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.phone,
                            size: 16.sp, color: ColorConstants.appThemeColor),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          userNumber,
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: ColorConstants.grey.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.calendar_today,
                                size: 14.sp, color: ColorConstants.grey),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            date,
                            style: TextStyle(
                              fontFamily: AppFonts.poppins,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: ColorConstants.grey.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.timer,
                                size: 14.sp, color: ColorConstants.grey),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            duration,
                            style: TextStyle(
                              fontFamily: AppFonts.poppins,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(6.r),
                      topRight: Radius.circular(6.r),
                    ),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Filter Button
  Widget _buildFilterButton(String label, RxBool isSelected) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.selectFilter(label),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected.value
                ? ColorConstants.appThemeColor
                : ColorConstants.white,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: ColorConstants.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color:
                  isSelected.value ? ColorConstants.white : ColorConstants.grey,
            ),
          ),
        ),
      ),
    );
  }

  // Calendar Button - EXACTLY like Inbound
  Widget _buildCalendarButton(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () => _showDateRangePicker(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: controller.isCustomRangeSelected.value
                ? ColorConstants.appThemeColor
                : ColorConstants.white,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: controller.isCustomRangeSelected.value
                    ? ColorConstants.appThemeColor.withOpacity(0.3)
                    : ColorConstants.grey.withOpacity(0.15),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.calendar_month,
            size: 22.sp,
            color: controller.isCustomRangeSelected.value
                ? ColorConstants.white
                : ColorConstants.appThemeColor.withOpacity(0.85),
          ),
        ),
      ),
    );
  }

  // Selected Date Range
  Widget _buildSelectedDateRange() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: ColorConstants.grey.withOpacity(0.3)),
        ),
        child: Text(
          'Selected: ${controller.formattedDate(controller.selectedRange.value.start)} - ${controller.formattedDate(controller.selectedRange.value.end)}',
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: ColorConstants.appThemeColor,
          ),
        ),
      ),
    );
  }

  // Date Range Picker Dialog
  void _showDateRangePicker(BuildContext context) {
    controller.initializeCalendarRange();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Date Range',
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  labelStyle: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 14.sp,
                    color: ColorConstants.grey,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                  suffixIcon: Icon(Icons.calendar_today, size: 16.sp),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                ),
                controller: TextEditingController(
                  text: controller
                      .formattedDate(controller.selectedRange.value.start),
                ),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: controller.selectedRange.value.start,
                    firstDate: DateTime.utc(2020, 1, 1),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) controller.selectStartDate(picked);
                },
              ),
              SizedBox(height: 12.h),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'End Date',
                  labelStyle: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 14.sp,
                    color: ColorConstants.grey,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                  suffixIcon: Icon(Icons.calendar_today, size: 16.sp),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  errorText: controller.dateError.value.isEmpty
                      ? null
                      : controller.dateError.value,
                ),
                controller: TextEditingController(
                  text: controller
                      .formattedDate(controller.selectedRange.value.end),
                ),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: controller.selectedRange.value.end,
                    firstDate: DateTime.utc(2020, 1, 1),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) controller.selectEndDate(picked);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.validateDateRange()) {
                controller.confirmCustomRange();
                Get.back();
              }
            },
            child: Text(
              'OK',
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 14.sp,
                color: ColorConstants.appThemeColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 14.sp,
                color: ColorConstants.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Status Color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'very interested':
      case 'v interested':
        return Colors.red;
      case 'maybe':
        return Colors.orange;
      case 'enrolled':
        return Colors.green;
      case 'junk lead':
        return Colors.grey;
      case 'not required':
        return Colors.blueGrey;
      case 'enroll other':
        return Colors.purple;
      case 'declined':
        return Colors.redAccent;
      case 'not eligible':
        return Colors.black54;
      case 'wrong number':
        return Colors.brown;
      case 'hot followup':
        return Colors.red;
      case 'cold followup':
        return Colors.blue;
      case 'scheduled':
        return Colors.green;
      default:
        return ColorConstants.grey;
    }
  }

  // Format Duration
  String _formatDuration(int? duration) {
    if (duration == null || duration <= 0) return '0 sec';
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    if (minutes == 0) return '$seconds sec';
    return '$minutes min $seconds sec';
  }

  // Format Date
  String _formatDate(String? time) {
    if (time == null || time.isEmpty) return 'N/A';
    try {
      DateTime dateTime = DateTime.parse(time).toLocal();
      return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
    } catch (e) {
      return 'Invalid time';
    }
  }
}
