import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/updateCampaign/controller/update_outbound_campaign_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateOutboundCampaignScreen extends GetView<UpdateOutboundCampaignController> {
  const UpdateOutboundCampaignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackgroundColor,
      appBar: CustomAppBar(
        title: "Edit Details",
        titleStyle: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,fontFamily: AppFonts.poppins,color: ColorConstants.white),
        showBackButton: true,
        onTapBack: (){
          Get.back();
        },
      ),
      body: Obx(
            () => controller.isLoading.value
            ? const Center(
          child: CircularProgressIndicator(
            color: Colors.green,
            strokeWidth: 2,
          ),
        )
            : SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Campaign Details',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16.h),
                CustomTextFormField(
                  controller: controller.nameController,
                  hintText: 'Enter campaign name',
                  labelText: 'Campaign Name',
                  padding: TextFormFieldPadding.PaddingAll12,
                  variant: TextFormFieldVariant.OutlineGray30004_1,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a campaign name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                CustomTextFormField(
                  controller: controller.descriptionController,
                  hintText: 'Enter campaign description',
                  labelText: 'Description',
                  padding: TextFormFieldPadding.PaddingVertical20,
                  variant: TextFormFieldVariant.OutlineGray30004_1,
                  maxLines: 6,
                  minLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                CustomTextFormField(
                  controller: controller.categoryController,
                  hintText: 'Enter campaign category',
                  labelText: 'Category',
                  padding: TextFormFieldPadding.PaddingAll12,
                  variant: TextFormFieldVariant.OutlineGray30004_1,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.updateCampaign();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Update Campaign',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}