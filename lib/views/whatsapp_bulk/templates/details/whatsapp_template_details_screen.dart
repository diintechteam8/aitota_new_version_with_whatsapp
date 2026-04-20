import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/app-export.dart';
import '../../../../../data/model/outbound/icons/whatsapp/get_templates_model.dart';
import '../../../../../data/model/outbound/icons/whatsapp/get_templates_model.dart';
import '../../../../routes/app_routes.dart';
import 'controller/whatsapp_template_details_controller.dart';

class WhatsAppTemplateDetailsScreen
    extends GetView<WhatsAppTemplateDetailsController> {
  const WhatsAppTemplateDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xffECE5DD), // Classic WhatsApp background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: ColorConstants.whatsappGradient,
          ),
        ),
        title: Text(
          'Template Details',
          style: TextStyle(
            fontSize: 18.sp,
            fontFamily: AppFonts.playfair,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              final template = controller.template;
              Get.toNamed(
                AppRoutes.createTemplateScreen,
                arguments: {
                  'templateId': template.sId,
                  'name': template.name,
                  'bodyPreview': _getComponent("BODY")?.text ?? "",
                  'languageCode': template.languageCode,
                  'category': template.category,
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              Get.defaultDialog(
                title: "Delete Template",
                middleText: "Are you sure you want to delete this template?",
                textCancel: "Cancel",
                textConfirm: "Delete",
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                cancelTextColor: Colors.black,
                onConfirm: () {
                  Get.back(); // close dialog
                  controller.deleteTemplate();
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Template Info Section
                  _buildLabel("Template Information"),
                  SizedBox(height: 12.h),
                  _buildInfoCard(),
                  SizedBox(height: 32.h),

                  _buildLabel("Message Preview"),
                  SizedBox(height: 12.h),
                  _buildWhatsAppPreview(),
                  SizedBox(height: 32.h),
                  _buildLabel("Send To"),
                  SizedBox(height: 12.h),
                  _buildAudienceSection(),
                ],
              ),
            ),
          ),
          _buildLaunchButton(context),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade800,
        fontFamily: AppFonts.poppins,
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Template Name", controller.template.name ?? "N/A"),
          Divider(color: Colors.grey.shade200),
          _buildInfoRow("WhatsApp Template",
              controller.template.whatsappTemplateName ?? "N/A"),
          Divider(color: Colors.grey.shade200),
          _buildInfoRow("Language", controller.template.languageCode ?? "N/A"),
          Divider(color: Colors.grey.shade200),
          _buildInfoRow("Format", controller.template.parameterFormat ?? "N/A"),
          Divider(color: Colors.grey.shade200),
          _buildInfoRow("Status", controller.template.status ?? "N/A"),
          Divider(color: Colors.grey.shade200),
          _buildInfoRow(
              "Created", _formatDate(controller.template.createdAt ?? "")),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
              fontFamily: AppFonts.poppins,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                fontFamily: AppFonts.poppins,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return "N/A";
    try {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (_) {
      return dateString;
    }
  }

  Widget _buildWhatsAppPreview() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (if any)
          if (_getComponent("HEADER") != null)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text(
                _getComponent("HEADER")!.text ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
              ),
            ),

          // Body
          Text(
            _getComponent("BODY")?.text ?? "No content",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
              height: 1.4,
            ),
          ),

          // Footer (if any)
          if (_getComponent("FOOTER") != null)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                _getComponent("FOOTER")!.text ?? "",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
            ),

          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "12:00 PM",
                style: TextStyle(fontSize: 10.sp, color: Colors.grey),
              ),
              SizedBox(width: 4.w),
              const Icon(Icons.done_all, size: 14, color: Colors.blue),
            ],
          ),

          // Buttons (if any)
          if (_getComponent("BODY")?.buttons != null) ...[
            const Divider(),
            ..._getComponent("BODY")!
                .buttons!
                .map((btn) => _buildPreviewButton(btn.text ?? "")),
          ]
        ],
      ),
    );
  }

  Widget _buildPreviewButton(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.open_in_new, size: 14, color: Colors.blue),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildAudienceSection() {
    return Obx(() => InkWell(
          onTap: controller.navigateToAudienceSelection,
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: controller.selectedAudience.isEmpty
                      ? Colors.grey.shade300
                      : ColorConstants.whatsappGradientDark,
                  width: 1.5),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05), blurRadius: 10),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  controller.selectedAudience.isEmpty
                      ? Icons.group_add_outlined
                      : Icons.check_circle,
                  color: controller.selectedAudience.isEmpty
                      ? Colors.grey
                      : Colors.green,
                  size: 28,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.selectedAudience.isEmpty
                            ? "Select Audience"
                            : controller.selectedAudience["name"],
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.poppins),
                      ),
                      Text(
                        controller.selectedAudience.isEmpty
                            ? "Import CSV or select from history"
                            : "${controller.selectedAudience["count"]} Contacts selected",
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ));
  }

  Widget _buildLaunchButton(context) {
    final padding = MediaQuery.of(context).padding;
    return Padding(
      padding: EdgeInsets.only(
          bottom: padding.bottom 
         ),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Obx(() => ElevatedButton(
              onPressed: (controller.isSending.value ||
                      controller.selectedAudience.isEmpty)
                  ? null
                  : controller.sendTemplate,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40.h),
                backgroundColor: ColorConstants.whatsappGradientDark,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: controller.isSending.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "Launch Bulk Campaign",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            )),
      ),
    );
  }

  GetTemplateModelComponents? _getComponent(String type) {
    try {
      return controller.template.components!.firstWhere((c) => c.type == type);
    } catch (_) {
      return null;
    }
  }
}
