import 'package:aitota_business/core/app-export.dart';
import 'package:intl/intl.dart';
import '../../../../../../data/model/myDial/my_dial_leads_model.dart';
import 'controller/my_dial_lead_status_detail_controller.dart';

class MyDialLeadStatusDetailScreen
    extends GetView<MyDialLeadStatusDetailController> {
  const MyDialLeadStatusDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Lead Details",
        titleStyle: TextStyle(
          fontFamily: AppFonts.poppins,
          color: ColorConstants.white,
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
        ),
        showBackButton: true,
      ),
      body: SafeArea(
        top: false,
        child: Obx(() {
          final lead = controller.lead.value;
          if (lead == null) return _noData();
  
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              children: [
                _buildHeaderCard(lead),
                SizedBox(height: 12.h),
                   /// 🔹 NEW: Client Details Card added here
               _buildClientDetailsCard(lead),
                _buildExplanationCard(lead),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // No Data
  // ─────────────────────────────────────────────────────────────────────
  Widget _noData() => Center(
        child: Container(
          padding: EdgeInsets.all(14.w),
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
          child: Text(
            'No lead details available',
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: ColorConstants.grey,
            ),
          ),
        ),
      );

  // ─────────────────────────────────────────────────────────────────────
  // Header: Mobile, Name, Call Time, Lead Date + Status Badge
  // ─────────────────────────────────────────────────────────────────────
  Widget _buildHeaderCard(LeadData lead) {
    return Container(
      padding: EdgeInsets.all(14.w),
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
            children: [
              _iconRow(icon: Icons.phone, value: lead.phoneNumber ?? 'N/A'),
                 SizedBox(height: 8.h),
              _iconRow(icon: Icons.person, value: _getContactName(lead.contactName)),
              SizedBox(height: 8.h),
              // _iconRow(icon: Icons.access_time, value: _formatDateTime(lead.createdAt)),
              if (lead.date != null && lead.date != lead.createdAt)
                Padding(
                  padding: EdgeInsets.only(),
                  child: _iconRow(icon: Icons.calendar_today, value: _formatDate(lead.date!)),
                ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: _getStatusColor(controller.actualStatus.value),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(6.r),
                  topRight: Radius.circular(6.r),
                ),
              ),
              child: Text(
                controller.actualStatus.value,
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
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // Explanation Card – Always shown in start row
  // ─────────────────────────────────────────────────────────────────────
  Widget _buildExplanationCard(LeadData lead) {
    final explanation = lead.explanation?.trim();
    final hasExplanation = explanation != null && explanation.isNotEmpty;

    return _card(
      title: 'Explanation',
      titleColor: ColorConstants.black,
      titleWeight: FontWeight.w500,
      children: [
        _iconRow(
          icon: Icons.description,
          value: hasExplanation ? explanation! : 'No reason',
          valueColor: hasExplanation ? ColorConstants.black : ColorConstants.grey,
        ),
      ],
    );
  }


// ─────────────────────────────────────────────────────────────
// Client Details Card
// ─────────────────────────────────────────────────────────────
Widget _buildClientDetailsCard(LeadData lead) {
  return _card(
    title: "Client Details",
    children: [
      _iconRow(
        icon: Icons.person_outline,
        value: lead.gender ?? 'N/A',
      ),
      SizedBox(height: 10.h),
      _iconRow(
        icon: Icons.badge_outlined,
        value: lead.profession ?? 'N/A',
      ),
      SizedBox(height: 10.h),
      _iconRow(
        icon: Icons.cake_outlined,
        value: lead.age?.toString() ?? 'N/A',
      ),
      SizedBox(height: 10.h),
      _iconRow(
        icon: Icons.location_on_outlined,
        value: lead.city ?? 'N/A',
      ),
      SizedBox(height: 10.h),
      _iconRow(
        icon: Icons.pin_drop_outlined,
        value: lead.pincode ?? 'N/A',
      ),
    ],
  );
}


  // ─────────────────────────────────────────────────────────────────────
  // Reusable Card
  // ─────────────────────────────────────────────────────────────────────
  Widget _card({
    required String title,
    Color? titleColor,
    FontWeight? titleWeight,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      margin: EdgeInsets.only(bottom: 12.h),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 15.sp,
              fontWeight: titleWeight ?? FontWeight.w600,
              color: titleColor ?? ColorConstants.lightTextColor,
            ),
          ),
          SizedBox(height: 8.h),
          ...children,
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // Icon + Value Row (Grey icons)
  // ─────────────────────────────────────────────────────────────────────
  Widget _iconRow({
    required IconData icon,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18.sp,
          color: ColorConstants.grey,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: valueColor ?? ColorConstants.black,
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // Smart Contact Name: "Unknown" if null or empty
  // ─────────────────────────────────────────────────────────────────────
  String _getContactName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Unknown';
    }
    return name.trim();
  }

  // ─────────────────────────────────────────────────────────────────────
  // Status Color
  // ─────────────────────────────────────────────────────────────────────
  Color _getStatusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('hot') || s.contains('payment') || s.contains('document')) {
      return const Color(0xFFE53935); // red
    }
    if (s.contains('warm') || s.contains('follow') || s.contains('schedule')) {
      return const Color(0xFFFB8C00); // orange
    }
    if (s.contains('converted') || s.contains('admission') || s.contains('payment_recieved')) {
      return const Color(0xFF43A047); // green
    }
    if (s.contains('not') || s.contains('wrong') || s.contains('dnd')) {
      return const Color(0xFF757575); // grey
    }
    return ColorConstants.grey;
  }

  // ─────────────────────────────────────────────────────────────────────
  // Date Formatters
  // ─────────────────────────────────────────────────────────────────────
  String _formatDateTime(String? dateTime) {
    if (dateTime == null) return 'N/A';
    try {
      final d = DateTime.parse(dateTime);
      return DateFormat('MMM dd, yyyy – hh:mm a').format(d);
    } catch (_) {
      return 'N/A';
    }
  }

  String _formatDate(String date) {
    try {
      final d = DateTime.parse(date);
      return DateFormat('MMM dd, yyyy').format(d);
    } catch (_) {
      return date;
    }
  }
}