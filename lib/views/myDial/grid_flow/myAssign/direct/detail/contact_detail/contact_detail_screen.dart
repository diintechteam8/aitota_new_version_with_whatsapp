import 'package:aitota_business/core/app-export.dart';
import 'package:intl/intl.dart';
import 'controller/contact_detail_controller.dart';

class ContactDetailScreen extends GetView<ContactDetailController> {
  const ContactDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: CustomAppBar(
        title: "Contact Details",
        showBackButton: true,
        titleStyle: TextStyle(
          fontSize: 16.sp,
          color: ColorConstants.white,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.poppins,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
                color: ColorConstants.appThemeColor1),
          );
        }

        final contact = controller.contact;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ────── BASIC INFO CARD ──────
              _buildSectionCard(
                title: "Basic Information",
                children: [
                  _infoRow("Name", contact['name'] ?? '—'),
                  _infoRow("Phone", contact['phone'] ?? '—'),
                ],
              ),

              const SizedBox(height: 8),

              // ────── DISPOSITION (UPDATED) ──────
              _buildDispositionSection(contact),

              const SizedBox(height: 12),
            ],
          ),
        );
      }),
    );
  }

  // ─────────────────────────────────────────────
  //  SECTION CARD: DEFAULT WHITE CARD
  // ─────────────────────────────────────────────
  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
        side: BorderSide(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontFamily: AppFonts.poppins,
              ),
            ),
            Divider(
              height: 20.h,
              thickness: 1,
              color: Colors.grey.shade300,
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  📌 UPDATED DISPOSITION SECTION
  // ─────────────────────────────────────────────
  Widget _buildDispositionSection(Map contact) {
    final lastTime = _formatDate(contact['lastDispositionAt'] as String?);

    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
        side: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 TITLE + TIME IN SAME ROW
            Row(
              children: [
                Text(
                  "Disposition",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: AppFonts.poppins,
                  ),
                ),
                Spacer(),
                Text(
                  lastTime,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                    fontFamily: AppFonts.poppins,
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            Divider(
              height: 20.h,
              thickness: 1,
              color: Colors.grey.shade300,
            ),

   _infoRow("Last Lead Status", contact['lastLeadStatus'] ?? '—'),
_infoRow("Sub Disposition", contact['lastDispositionCategory'] ?? '—'),
_infoRow("Mini Disposition", contact['lastDispositionSubCategory'] ?? '—'),
_infoRow("Count", (contact['dispositionCount'] ?? 0).toString()),

          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  INFO ROW
  // ─────────────────────────────────────────────
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140.w,
            child: Text(
              "$label:",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
                fontFamily: AppFonts.poppins,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                fontFamily: AppFonts.poppins,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  AGENT TILE WITH BORDER
  // ─────────────────────────────────────────────
  Widget _agentTile(Map<String, dynamic> agent) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow("Agent ID", agent['humanAgentId'] ?? '—'),
          _infoRow("Assigned At", _formatDate(agent['assignedAt'] as String?)),
          _infoRow("Assigned By", agent['assignedBy'] ?? '—'),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  DATE FORMATTER (dd-MM-yyyy, hh:mm a)
  // ─────────────────────────────────────────────
  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '—';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return DateFormat('dd-MM-yyyy, hh:mm a').format(dt);
    } catch (_) {
      return iso;
    }
  }
}
