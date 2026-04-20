import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/app-export.dart';
import 'controller/create_template_controller.dart';

class CreateTemplateScreen extends GetView<CreateTemplateController> {
  const CreateTemplateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: ColorConstants.whatsappGradient,
          ),
        ),
        title: Text(
          controller.templateId != null ? 'Edit Template' : 'Create Template',
          style: TextStyle(
            fontSize: 18.sp,
            fontFamily: AppFonts.playfair,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  _buildGeneralInfoSection(),
                  SizedBox(height: 20.h),
                  _buildContentSection(),
                  SizedBox(height: 20.h),
                  _buildButtonsSection(),
                ],
              ),
            ),
          ),
          _buildSaveButton(context),
        ],
      ),
    );
  }

  Widget _buildGeneralInfoSection() {
    return _buildCard(
      title: "General Information",
      child: Column(
        children: [
          _buildTextField("Template Name", controller.nameController,
              hint: "e.g. order_alert"),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                  child: _buildDropdown("Category", controller.selectedCategory,
                      controller.categories)),
              SizedBox(width: 12.w),
              Expanded(
                  child: _buildDropdown("Language", controller.selectedLanguage,
                      controller.languages)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return _buildCard(
      title: "Message Content",
      child: Column(
        children: [
          _buildTextField("Header (Optional)", controller.headerController,
              hint: "Text header"),
          SizedBox(height: 16.h),
          _buildTextField("Body Text", controller.bodyController,
              hint: "Write your message here. Use {{1}} for variables.",
              maxLines: 4),
          SizedBox(height: 16.h),
          _buildTextField("Footer (Optional)", controller.footerController,
              hint: "Small text at bottom"),
        ],
      ),
    );
  }

  Widget _buildButtonsSection() {
    return _buildCard(
      title: "Interactive Buttons",
      child: Column(
        children: [
          Obx(() => Column(
                children: controller.buttons.asMap().entries.map((entry) {
                  int idx = entry.key;
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.smart_button, size: 20),
                        SizedBox(width: 12.w),
                        Expanded(child: Text(entry.value["text"] ?? "")),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red, size: 20),
                          onPressed: () => controller.removeButton(idx),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              )),
          TextButton.icon(
            onPressed: controller.addButton,
            icon: const Icon(Icons.add),
            label: const Text("Add Button"),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: ColorConstants.whatsappGradientDark,
              fontFamily: AppFonts.poppins,
            ),
          ),
          SizedBox(height: 20.h),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl,
      {String? hint, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600)),
        SizedBox(height: 8.h),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, RxString selected, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600)),
        SizedBox(height: 8.h),
        Obx(() => Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selected.value,
                  isExpanded: true,
                  items: items
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => selected.value = val!,
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildSaveButton(context) {
    final padding = MediaQuery.of(context).padding;

    return Padding(
      padding: EdgeInsets.only(bottom: padding.bottom),
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
              onPressed:
                  controller.isSaving.value ? null : controller.saveTemplate,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 45.h),
                backgroundColor: ColorConstants.whatsappGradientDark,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: controller.isSaving.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      controller.templateId != null ? "Update Template" : "Save Template",
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
}
