import '../../../../app-export.dart';
import '../../../../../views/outbound/grid_flow/contact/group/controller/contact_group_controller.dart';

class AddGroupDialog {
  static void show(BuildContext context, ContactGroupController controller) {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final isCreating = false.obs;
    // final padding = MediaQuery.of(context).padding;

    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 20.h,
          bottom: bottomInset + 25.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Title
                Text(
                  'Create New Group',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10.h),

                // Group Name Field
                CustomTextFormField(
                  controller: nameController,
                  hintText: 'e.g., Sales Team',
                  labelText: 'Group Name*',
                  prefixIcon: const Icon(
                    Icons.group_add_outlined,
                    color: ColorConstants.appThemeColor1,
                  ),
                  variant: TextFormFieldVariant.FillGray10001,
                  padding: TextFormFieldPadding.PaddingAll12,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a group name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),

                // Category Field
                CustomTextFormField(
                  controller: categoryController,
                  hintText: 'e.g., Work, Personal',
                  labelText: 'Category',
                  prefixIcon: const Icon(
                    Icons.category_outlined,
                    color: ColorConstants.appThemeColor1,
                  ),
                  variant: TextFormFieldVariant.FillGray10001,
                  padding: TextFormFieldPadding.PaddingAll12,
                ),
                SizedBox(height: 12.h),

                // Description Field
                CustomTextFormField(
                  controller: descriptionController,
                  // minLines: 3,
                  // maxLines: 4,
                  hintText: 'Brief description of the group',
                  labelText: 'Description',
                  prefixIcon: Icon(
                    Icons.description_outlined,
                    color: ColorConstants.appThemeColor1,
                  ),
                  variant: TextFormFieldVariant.FillGray10001,
                  padding: TextFormFieldPadding.PaddingVertical20,
                ),
                SizedBox(height: 12.h),

                // Action Buttons
                Padding(
                  padding: EdgeInsets.only(bottom: bottomInset + 12.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Get.back(),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        flex: 2,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: isCreating.value
                                ? null
                                : () async {
                                    if (formKey.currentState!.validate()) {
                                      isCreating.value = true;
                                      try {
                                        await controller.createGroup(
                                          nameController.text.trim(),
                                          categoryController.text.trim(),
                                          descriptionController.text.trim(),
                                        );
                                      } catch (e) {
                                        isCreating.value = false;
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstants.appThemeColor1,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              elevation: 0,
                            ),
                            child: isCreating.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.check_circle_rounded,
                                          size: 16),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Create Group',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
  }
}

class EditGroupDialog {
  static void show(BuildContext context, ContactGroupController controller,
      Map<String, dynamic> group) {
    final nameController = TextEditingController(text: group['name']);
    final categoryController = TextEditingController(text: group['category']);
    final descriptionController =
        TextEditingController(text: group['description']);
    final formKey = GlobalKey<FormState>();
    final isUpdating = false.obs;
    final padding = MediaQuery.of(context).padding;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 20.h,
          bottom: padding.bottom + 20.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Title
                Text(
                  'Edit Group',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10.h),

                // Group Name Field
                CustomTextFormField(
                  controller: nameController,
                  hintText: 'e.g., Sales Team',
                  labelText: 'Group Name*',
                  prefixIcon: const Icon(
                    Icons.group_add_outlined,
                    color: ColorConstants.appThemeColor1,
                  ),
                  variant: TextFormFieldVariant.FillGray10001,
                  padding: TextFormFieldPadding.PaddingAll12,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a group name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),

                // Category Field
                CustomTextFormField(
                  controller: categoryController,
                  hintText: 'e.g., Work, Personal',
                  labelText: 'Category',
                  prefixIcon: const Icon(
                    Icons.category_outlined,
                    color: ColorConstants.appThemeColor1,
                  ),
                  variant: TextFormFieldVariant.FillGray10001,
                  padding: TextFormFieldPadding.PaddingAll12,
                ),
                SizedBox(height: 12.h),

                // Description Field
                CustomTextFormField(
                  controller: descriptionController,
                  minLines: 3,
                  maxLines: 4,
                  hintText: 'Brief description of the group',
                  labelText: 'Description',
                  prefixIcon: const Icon(
                    Icons.description_outlined,
                    color: ColorConstants.appThemeColor1,
                  ),
                  variant: TextFormFieldVariant.FillGray10001,
                  padding: TextFormFieldPadding.PaddingVertical20,
                ),
                SizedBox(height: 24.h),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      flex: 2,
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: isUpdating.value
                              ? null
                              : () async {
                                  if (formKey.currentState!.validate()) {
                                    isUpdating.value = true;
                                    try {
                                      await controller.updateGroup(
                                        group['_id'],
                                        nameController.text.trim(),
                                        categoryController.text.trim(),
                                        descriptionController.text.trim(),
                                      );
                                    } catch (e) {
                                      isUpdating.value = false;
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstants.appThemeColor1,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            elevation: 0,
                            disabledBackgroundColor: Colors.grey.shade300,
                          ),
                          child: isUpdating.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check_circle_rounded,
                                        size: 16),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Save Changes',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
  }
}

class DeleteGroupDialog {
  static void show(BuildContext context, ContactGroupController controller,
      String groupId, String groupName) {
    final isDeleting = false.obs;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 40.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Warning Icon
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_rounded,
                size: 32.w,
                color: Colors.red.shade600,
              ),
            ),
            SizedBox(height: 16.h),

            // Title
            Text(
              'Delete Group?',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 12.h),

            // Message
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black54,
                  height: 1.5,
                  fontFamily: 'Poppins',
                ),
                children: [
                  const TextSpan(text: 'Are you sure you want to delete '),
                  TextSpan(
                    text: '"$groupName"',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const TextSpan(text: '? This action cannot be undone.'),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: isDeleting.value
                          ? null
                          : () async {
                              isDeleting.value = true;
                              try {
                                await controller.deleteGroup(groupId);
                                // Delay before closing to allow snackbar to show
                                await Future.delayed(
                                    const Duration(milliseconds: 300));
                                Get.back();
                              } catch (e) {
                                isDeleting.value = false;
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        elevation: 0,
                      ),
                      child: isDeleting.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delete_rounded, size: 16.sp),
                                SizedBox(width: 6.w),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
  }
}
