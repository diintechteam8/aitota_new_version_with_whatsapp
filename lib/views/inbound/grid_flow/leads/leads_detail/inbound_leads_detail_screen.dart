import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/inbound/grid_flow/leads/leads_detail/controller/inbound_leads_detail_controller.dart';
import 'package:intl/intl.dart';
import '../../../../../data/model/inbound/inbound_lead_conversations_model.dart';
import '../../../../../routes/app_routes.dart';

class InboundLeadsDetailScreen extends GetView<InboundLeadsDetailController> {
  const InboundLeadsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Leads",
        titleStyle: TextStyle(
          fontFamily: AppFonts.poppins,
          fontWeight: FontWeight.w500,
          color: ColorConstants.white,
          fontSize: 16.sp,
        ),
        showBackButton: true,
        onTapBack: () {
          Get.back();
        },
      ),
      body: SafeArea(
        top: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Obx(
                () => controller.isLoading.value
                ? const Center(
                child: CircularProgressIndicator(
                    color: ColorConstants.appThemeColor))
                : controller.leads.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No ${controller.status} leads available',
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorConstants.grey,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: controller.leads.length,
              itemBuilder: (context, index) {
                final lead = controller.leads[index];
                return _buildLeadCard(
                  lead: lead,
                  status: controller.status,
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.inboundLeadsStatusDetailScreen,
                      arguments: {
                        'lead': lead,
                        'status': controller.status,
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadCard({
    required LeadItem lead,
    required String status,
    required VoidCallback onTap,
  }) {
    final inputFormat = DateFormat('MMM d, yyyy HH:mm');
    String formattedDate = 'N/A';
    try {
      final parsedDate = inputFormat.parse(_formatDateTime(lead.time));
      final outputFormat = DateFormat('dd/MM/yyyy');
      formattedDate = outputFormat.format(parsedDate);
    } catch (e) {
      formattedDate = 'N/A';
    }

    // Dynamically build actionIcons based on whatsappRequested
    final actionIcons = <Map<String, dynamic>>[];
    if (lead.metadata?.whatsappRequested ?? false) {
      actionIcons.add({
        'imagePath': ImageConstant.whatsapp,
        'tooltip': 'WhatsApp',
        'badgeCount': 0, // Badge count set to 0 as requested
      });
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: ColorConstants.grey.withOpacity(0.12),
              spreadRadius: 2,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: ColorConstants.grey.withOpacity(0.15)),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top: Call icon + number
                Row(
                  children: [
                    Icon(Icons.call, size: 16.sp, color: ColorConstants.grey),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        lead.mobile ?? 'Unknown',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                // Row 1: Calendar + Date (black)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.calendar_month,
                        size: 16.sp, color: ColorConstants.grey),
                    SizedBox(width: 6.w),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // Row 2: Duration (left) + LeadActionBar (right)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 16.sp, color: ColorConstants.grey),
                        SizedBox(width: 6.w),
                        Text(
                          _formatDuration(lead.duration),
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: ColorConstants.grey,
                          ),
                        ),
                      ],
                    ),
                    LeadActionBar(actionIcons: actionIcons),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(status),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r),
                  ),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Very Interested':
        return Colors.red;
      case 'May Be':
        return Colors.orange;
      case 'Enrolled':
        return Colors.green;
      default:
        return ColorConstants.grey;
    }
  }

  String _formatDuration(int? duration) {
    if (duration == null || duration == 0) return '0 sec';
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    if (minutes == 0) return '$seconds sec';
    return '$minutes min $seconds sec';
  }

  String _formatDateTime(String? dateTime) {
    if (dateTime == null || dateTime == 'N/A') return 'N/A';
    try {
      final parsedDate = DateTime.parse(dateTime);
      return DateFormat('MMM dd, yyyy HH:mm').format(parsedDate);
    } catch (e) {
      return 'N/A';
    }
  }
}