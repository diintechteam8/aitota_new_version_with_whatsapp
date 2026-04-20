import '../../../../../core/app-export.dart';
import 'controller/enter_details_controller.dart';

class EnterDetailsScreen extends GetView<EnterDetailsController> {
  const EnterDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title:  Text(
          "Add New Contact",
          style: TextStyle(
            color: ColorConstants.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phone Number Field with India Icon
              CustomTextFormField(
                controller: controller.phoneController,
                labelText: "Phone Number",
                textInputType: TextInputType.phone,
                validator: AppValidators.validateIndianPhone,
                inputFormatters: controller.phoneInputFormatters,
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "+91",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        width: 1,
                        height: 24.h,
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),
                ),
                prefixIconConstraints: BoxConstraints(maxHeight: 48.h),
                variant: TextFormFieldVariant.OutlineGray30004_1,
                padding: TextFormFieldPadding.PaddingT15,
              ),
              SizedBox(height: 16.h),

              // Name Field
              CustomTextFormField(
                controller: controller.nameController,
                labelText: "Full Name",
                validator: (value) => AppValidators.validateRequired(value, fieldName: "Name"),
                variant: TextFormFieldVariant.OutlineGray30004_1,
                padding: TextFormFieldPadding.PaddingT15,
              ),
              SizedBox(height: 16.h),

              // Company Name Field
              CustomTextFormField(
                controller: controller.companyController,
                labelText: "Company Name",
                variant: TextFormFieldVariant.OutlineGray30004_1,
                padding: TextFormFieldPadding.PaddingT15,
              ),
              SizedBox(height: 16.h),

              // Email Field
              CustomTextFormField(
                controller: controller.emailController,
                labelText: "Email",
                textInputType: TextInputType.emailAddress,
                validator: (value) {
                  final requiredError = AppValidators.validateRequired(value, fieldName: "Email");
                  if (requiredError != null) return requiredError;
                  return AppValidators.validateEmail(value);
                },
                variant: TextFormFieldVariant.OutlineGray30004_1,
                padding: TextFormFieldPadding.PaddingT15,
              ),
              SizedBox(height: 16.h),

              // Address Field
              CustomTextFormField(
                controller: controller.addressController,
                labelText: "Address",
                maxLines: 3,
                variant: TextFormFieldVariant.OutlineGray30004_1,
                padding: TextFormFieldPadding.PaddingT15,
              ),
              SizedBox(height: 16.h),

              // DOB Field
              CustomTextFormField(
                controller: controller.dobController,
                labelText: "Date of Birth",
                readOnly: true,
                onTap: () => controller.selectDate(context),
                variant: TextFormFieldVariant.OutlineGray30004_1,
                padding: TextFormFieldPadding.PaddingT15,
                prefixIcon: Icon(
                  Icons.calendar_today,
                  color: Colors.green.shade600,
                  size: 20,
                ),
              ),
              SizedBox(height: 24.h),

              // Submit Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    shape: const StadiumBorder(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 12.h,
                    ),
                    elevation: 4,
                  ),
                  onPressed: controller.submitForm,
                  child: const Text(
                    "Save Contact",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
}