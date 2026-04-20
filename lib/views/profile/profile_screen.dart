import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/profile/controller/profile_controller.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  // Edit-mode toggle – **static** so it survives navigation
  static final RxBool isEditMode = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: CustomAppBar(
        title: "Profile",
        titleStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.poppins,
          color: ColorConstants.white,
        ),
        showBackButton: true,
        onTapBack: () => Get.back(),
        actions: [
          Obx(() {
            // ---- any field changed? ----
            final bool anyChanged =
                controller.isNameChanged.value ||
                controller.isEmailChanged.value ||
                controller.isMobileNumberChanged.value ||
                controller.isCityChanged.value ||
                controller.isBusinessNameChanged.value ||
                controller.isPincodeChanged.value ||
                controller.isAddressChanged.value ||
                controller.isPanChanged.value ||
                controller.isGstChanged.value ||
                (controller.isRoleChanged.value && controller.isClientRole.value);

            if (!isEditMode.value) {
              return IconButton(
                onPressed: () => isEditMode.value = true,
                icon: const Icon(Icons.edit, color: ColorConstants.white),
                tooltip: 'Edit',
              );
            }

            return IconButton(
              onPressed: anyChanged
                  ? () async {
                      await controller.saveAllChanges();
                      isEditMode.value = false;
                    }
                  : null,
              icon: Icon(
                Icons.check,
                color: anyChanged
                    ? ColorConstants.white
                    : ColorConstants.white.withOpacity(0.6),
              ),
              tooltip: 'Save',
            );
          }),
        ],
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () async => await controller.loadProfileData(),
          child: Obx(
            () => controller.isLoading.value
                ? _buildShimmer()
                : _buildProfileForm(),
          ),
        ),
      ),
    );
  }

  /* --------------------------------------------------------------------- */
  /*                              SHIMMER                                  */
  /* --------------------------------------------------------------------- */
  Widget _buildShimmer() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: List.generate(
          10,
          (_) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Shimmer.fromColors(
              baseColor: ColorConstants.lightGrey,
              highlightColor: ColorConstants.lightGrey.withAlpha(60),
              child: Container(
                height: 56.h,
                decoration: BoxDecoration(
                  color: ColorConstants.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /* --------------------------------------------------------------------- */
  /*                              FORM                                     */
  /* --------------------------------------------------------------------- */
  Widget _buildProfileForm() {
    return Obx(() {
      // ---- role check (executive → false, client → true) ----
      final bool showRoleField = controller.isClientRole.value;

      return SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildEditableTextField(
              label: "Name",
              controller: controller.nameController,
              isChanged: controller.isNameChanged.value,
              updateFunction: controller.updateName,
              readOnly: !isEditMode.value,
            ),
            _buildEditableTextField(
              label: "Email",
              controller: controller.emailController,
              isChanged: controller.isEmailChanged.value,
              updateFunction: null,
              readOnly: true,
            ),
            _buildEditableTextField(
              label: "Mobile Number",
              controller: controller.mobileNumberController,
              isChanged: controller.isMobileNumberChanged.value,
              updateFunction: controller.updateMobile,
              readOnly: !isEditMode.value,
            ),
            _buildEditableTextField(
              label: "City",
              controller: controller.cityController,
              isChanged: controller.isCityChanged.value,
              updateFunction: controller.updateCity,
              readOnly: !isEditMode.value,
            ),
            _buildEditableTextField(
              label: "Business Name",
              controller: controller.businessNameController,
              isChanged: controller.isBusinessNameChanged.value,
              updateFunction: controller.updateBusinessName,
              readOnly: !isEditMode.value,
            ),
            _buildEditableTextField(
              label: "Pincode",
              controller: controller.pincodeController,
              isChanged: controller.isPincodeChanged.value,
              updateFunction: controller.updatePincode,
              readOnly: !isEditMode.value,
            ),
            _buildEditableTextField(
              label: "Address",
              controller: controller.addressController,
              isChanged: controller.isAddressChanged.value,
              updateFunction: controller.updateAddress,
              readOnly: !isEditMode.value,
            ),
            _buildEditableTextField(
              label: "PAN",
              controller: controller.panController,
              isChanged: controller.isPanChanged.value,
              updateFunction: null,
              readOnly: !isEditMode.value,
            ),
            _buildEditableTextField(
              label: "GST",
              controller: controller.gstController,
              isChanged: controller.isGstChanged.value,
              updateFunction: null,
              readOnly: !isEditMode.value,
            ),

            // ---------- ROLE FIELD – ONLY FOR CLIENT ----------
            if (showRoleField)
              _buildEditableTextField(
                label: "Role",
                controller: controller.roleController,
                isChanged: controller.isRoleChanged.value,
                updateFunction: controller.updateRole,
                readOnly: !isEditMode.value,
              ),
          ],
        ),
      );
    });
  }

  /* --------------------------------------------------------------------- */
  /*                         EDITABLE TEXT FIELD                           */
  /* --------------------------------------------------------------------- */
  Widget _buildEditableTextField({
    required String label,
    required TextEditingController controller,
    required bool isChanged,
    required Function(String)? updateFunction,
    required bool readOnly,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          labelStyle: TextStyle(
            color: ColorConstants.grey,
            fontFamily: AppFonts.poppins,
            fontSize: 14.sp,
          ),
          enabledBorder:  OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.lightGrey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.appThemeColor),
          ),
        ),
        style: TextStyle(
          color: ColorConstants.black,
          fontFamily: AppFonts.poppins,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}