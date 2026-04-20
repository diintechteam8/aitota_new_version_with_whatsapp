import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/app-export.dart';
import '../../../../../data/model/outbound/icons/whatsapp/get_templates_model.dart';
import '../../../../core/utils/widgets/common_widgets/shimmer_loading.dart';
import '../../../../routes/app_routes.dart';
import '../controller/whatsapp_templates_controller.dart';

class WhatsAppTemplatesScreen extends GetView<WhatsAppTemplatesController> {
  const WhatsAppTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: ColorConstants.whatsappGradient,
          ),
        ),
        title: Text(
          'WhatsApp Templates',
          style: TextStyle(
            fontSize: 18.sp,
            fontFamily: AppFonts.playfair,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          gradient: ColorConstants.whatsappGradient,
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          onPressed: () => Get.toNamed(AppRoutes.createTemplateScreen),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.allTemplates.isEmpty) {
                return ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: 8,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) =>
                      BaseShimmer(child: TemplateCardShimmer()),
                );
              }
              if (controller.filteredTemplates.isEmpty) {
                return _buildEmptyState();
              }
              return RefreshIndicator(
                onRefresh: controller.fetchTemplates,
                child: ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: controller.filteredTemplates.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final template = controller.filteredTemplates[index];
                    return InkWell(
                      onTap: () => Get.toNamed(
                        AppRoutes.whatsappTemplateDetailsScreen,
                        arguments: template,
                      ),
                      child: _buildTemplateCard(template),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) => controller.searchQuery.value = value,
        decoration: InputDecoration(
          hintText: "Search templates...",
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.message_outlined, size: 64, color: Colors.grey.shade300),
          SizedBox(height: 16.h),
          Text(
            "No templates found",
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
              fontFamily: AppFonts.poppins,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(GetTemplateModelTemplates template) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  template.name ?? "Unnamed Template",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.poppins,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildStatusBadge(template.status ?? "pending"),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _buildInfoChip(template.category ?? "Utility", Icons.category_outlined),
              SizedBox(width: 8.w),
              _buildInfoChip(template.language ?? "en", Icons.language),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            _getTemplateBody(template),
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey.shade700,
              fontFamily: AppFonts.poppins,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'approved':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade600),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  String _getTemplateBody(GetTemplateModelTemplates template) {
    if (template.components == null) return "No content available";
    final bodyComponent = template.components!.firstWhere(
      (c) => c.type == "BODY",
      orElse: () => GetTemplateModelComponents(),
    );
    return bodyComponent.text ?? "No text content";
  }
}
