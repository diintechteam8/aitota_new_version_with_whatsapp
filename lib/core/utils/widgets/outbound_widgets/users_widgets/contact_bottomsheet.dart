import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/group/detail_screen/controller/outbound_group_detail_controller.dart';

class ContactBottomSheet {
  static void showAddContactBottomSheet(BuildContext context, OutboundGroupDetailController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorConstants.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Contact',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomSheetOption(
                    icon: Icons.edit,
                    label: 'Enter Details',
                    onTap: () {
                      Get.back();
                      showEnterDetailsBottomSheet(context, controller);
                    },
                  ),
                  _buildBottomSheetOption(
                    icon: Icons.contacts,
                    label: 'Open Contacts',
                    onTap: () {
                      Get.back();
                      controller.openPhonebook();
                    },
                  ),
                  _buildBottomSheetOption(
                    icon: Icons.upload_file,
                    label: 'Import File',
                    onTap: () {
                      Get.back();
                      controller.addFromFile();
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  static void showEnterDetailsBottomSheet(BuildContext context, OutboundGroupDetailController controller) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      backgroundColor: ColorConstants.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Contact Details',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    CustomTextFormField(
                      controller: nameController,
                      hintText: 'e.g., John Doe',
                      labelText: 'Name *',
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: ColorConstants.appThemeColor1,
                      ),
                      variant: TextFormFieldVariant.FillGray10001,
                      padding: TextFormFieldPadding.PaddingAll12,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),
                    CustomTextFormField(
                      controller: phoneController,
                      hintText: 'e.g., +1234567890',
                      labelText: 'Phone',
                      prefixIcon: const Icon(
                        Icons.phone_outlined,
                        color: ColorConstants.appThemeColor1,
                      ),
                      variant: TextFormFieldVariant.FillGray10001,
                      padding: TextFormFieldPadding.PaddingAll12,
                      textInputType: TextInputType.phone,
                    ),
                    SizedBox(height: 12.h),
                    CustomTextFormField(
                      controller: emailController,
                      hintText: 'e.g., example@domain.com',
                      labelText: 'Email (Optional)',
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: ColorConstants.appThemeColor1,
                      ),
                      variant: TextFormFieldVariant.FillGray10001,
                      padding: TextFormFieldPadding.PaddingAll12,
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Get.back(),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
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
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                controller.addContact(
                                  nameController.text.trim(),
                                  phoneController.text.trim(),
                                  emailController.text.trim(),
                                );
                                Get.back();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstants.appThemeColor1,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle_rounded, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'Add Contact',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
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
      },
    );
  }

  static Widget _buildBottomSheetOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey.shade100,
              child: Icon(icon, color: ColorConstants.appThemeColor1, size: 24),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}