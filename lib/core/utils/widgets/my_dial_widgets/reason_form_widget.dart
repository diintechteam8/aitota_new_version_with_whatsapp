import 'package:aitota_business/data/model/myDial/call_log_model.dart';
import '../../../../core/app-export.dart';
import '../../../../views/myDial/grid_flow/call_logs/calls/controller/calls_controller.dart';

class ReasonFormWidget extends StatelessWidget {
  final CallLog callLog;
  final CallsController controller;
  final VoidCallback onShowCalendar;
  final Function(bool, String) onShowOtherReason;

  const ReasonFormWidget({
    super.key,
    required this.callLog,
    required this.controller,
    required this.onShowCalendar,
    required this.onShowOtherReason,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SizedBox(
          height: Get.height * 0.85,
          child: Obx(() {
            if (controller.selectedCategory.value.isEmpty) {
              controller.selectedCategory.value = 'connected';
            }
            if (controller.selectedConnectedTab.value.isEmpty) {
              controller.selectedConnectedTab.value = 'interested';
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Drag Handle
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 8.h),
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: ColorConstants.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),

                /// Header: Dispositions + Phone Number
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.checklist_rounded,
                            color: Color(0xFF6366F1),
                            size: 22.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Dispositions',
                            style: TextStyle(
                              fontFamily: AppFonts.poppins,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Color(0xFF10B981).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: 14.sp,
                              color: Color(0xFF10B981),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              callLog.phoneNumber,
                              style: TextStyle(
                                fontFamily: AppFonts.poppins,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// Connected / Not Connected Tabs
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: ColorConstants.grey.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildMainTab(
                            'Connected',
                            'connected',
                            Icons.call_made_rounded,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: _buildMainTab(
                            'Not Connected',
                            'not_connected',
                            Icons.call_missed_rounded,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8.h),

                /// Dynamic Content
                Expanded(child: _buildContent()),

                /// Submit Buttons
                SafeArea(
                  top: false,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
                    decoration: BoxDecoration(
                      color: ColorConstants.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              controller.isSubmitting.value = false;
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstants.grey.withOpacity(0.1),
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.close_rounded,
                                  size: 18.sp,
                                  color: ColorConstants.grey,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontFamily: AppFonts.poppins,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: ColorConstants.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Obx(() {
                            final wordCount = controller.explanation.value
                                .trim()
                                .split(' ')
                                .where((word) => word.isNotEmpty)
                                .length;

                            final isFormValid =
                                controller.selectedDisposition.value.isNotEmpty &&
                                controller.selectedMiniDisposition.value.isNotEmpty &&
                                wordCount > 2;

                            return ElevatedButton(
                              onPressed: (isFormValid && !controller.isSubmitting.value)
                                  ? () => controller.submitReason(callLog)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF6366F1),
                                disabledBackgroundColor:
                                    ColorConstants.grey.withOpacity(0.3),
                                elevation: 0,
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: controller.isSubmitting.value
                                  ? SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline_rounded,
                                          size: 18.sp,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          'Submit',
                                          style: TextStyle(
                                            fontFamily: AppFonts.poppins,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildMainTab(String label, String value, IconData icon) {
    final bool isSelected = controller.selectedCategory.value == value;
    return GestureDetector(
      onTap: () {
        controller.selectedCategory.value = value;
        controller.selectedDisposition.value = '';
        controller.selectedMiniDisposition.value = '';
        controller.selectedReason.value = '';
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorConstants.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: isSelected
                  ? Color(0xFF6366F1)
                  : ColorConstants.grey,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Color(0xFF6366F1)
                    : ColorConstants.grey,
                fontFamily: AppFonts.poppins,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return controller.selectedCategory.value == 'not_connected'
        ? _buildNotConnectedContent()
        : _buildConnectedContent();
  }

  /// ============== NOT CONNECTED TAB ==============
/// ============== NOT CONNECTED TAB ==============
Widget _buildNotConnectedContent() {
  final grouped = controller.notConnectedDispositions;
  final List<Widget> widgets = [];

  grouped.forEach((disposition, miniDispositions) {
    widgets.add(
      Padding(
        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 4.h),
        child: Row(
          children: [
            Icon(
              Icons.label_outline_rounded,
              size: 16.sp,
              color: Color(0xFFEC4899),
            ),
            SizedBox(width: 6.w),
            Text(
              disposition,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: ColorConstants.grey,
                fontFamily: AppFonts.poppins,
              ),
            ),
          ],
        ),
      ),
    );

    for (var miniDisposition in miniDispositions) {
      final fullReason = '$disposition - $miniDisposition';
      widgets.add(
        Obx(() {
          final isSelected = controller.selectedReason.value == fullReason;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? Color(0xFF6366F1).withOpacity(0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10.r),
              border: isSelected
                  ? Border.all(color: Color(0xFF6366F1).withOpacity(0.3), width: 1.5)
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile<String>(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
                  title: Text(
                    miniDisposition,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: AppFonts.poppins,
                      color: isSelected ? Color(0xFF6366F1) : ColorConstants.grey,
                    ),
                  ),
                  value: fullReason,
                  groupValue: controller.selectedReason.value,
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedReason.value = value;
                      controller.selectedDisposition.value = disposition;
                      controller.selectedMiniDisposition.value = miniDisposition;
                      controller.needsFollowUp.value = false;
                      controller.explanation.value = '';
                      // Ye 5 fields clear kar do kyunki not connected mein use nahi honge
                      controller.genderController.clear();
                      controller.ageController.clear();
                      controller.professionController.clear();
                      controller.pincodeController.clear();
                      controller.cityController.clear();
                    }
                  },
                  activeColor: Color(0xFF6366F1),
                ),

                // Sirf Remarks field dikhao Not Connected mein
                if (isSelected)
                  Padding(
                    padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Explanation Field (Remarks)
                        Container(
                          decoration: BoxDecoration(
                            color: ColorConstants.white,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: Color(0xFF6366F1).withOpacity(0.3),
                            ),
                          ),
                          child: TextField(
                            controller: TextEditingController(
                              text: controller.explanation.value,
                            )..selection = TextSelection.fromPosition(
                                TextPosition(offset: controller.explanation.value.length),
                              ),
                            onChanged: (v) => controller.explanation.value = v,
                            maxLines: 3,
                            style: TextStyle(fontSize: 13.sp, fontFamily: AppFonts.poppins),
                            decoration: InputDecoration(
                              labelText: 'Remarks (min 2 words)',
                              labelStyle: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: AppFonts.poppins,
                                color: ColorConstants.grey,
                              ),
                              hintText: 'Explain briefly...',
                              prefixIcon: Icon(
                                Icons.edit_note_rounded,
                                size: 20.sp,
                                color: Color(0xFF8B5CF6),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                            ),
                          ),
                        ),
                        // Word count
                        Padding(
                          padding: EdgeInsets.only(top: 4.h, left: 4.w),
                          child: Obx(() {
                            final words = controller.explanation.value
                                .trim()
                                .split(' ')
                                .where((w) => w.isNotEmpty)
                                .length;
                            return Text(
                              '$words word${words == 1 ? '' : 's'}',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: words > 3 ? Color(0xFF10B981) : Color(0xFFEF4444),
                                fontFamily: AppFonts.poppins,
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 8.h),
                      ],
                    ),
                  ),
              ],
            ),
          );
        }),
      );
    }

    widgets.add(Divider(
      thickness: 0.5,
      height: 8.h,
      indent: 12.w,
      endIndent: 12.w,
      color: ColorConstants.lightGrey.withOpacity(0.5),
    ));
  });

  return ListView(
    padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
    children: widgets,
  );
}

  /// ============== CONNECTED TAB ==============
  Widget _buildConnectedContent() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: ColorConstants.grey.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildConnectedTab('interested', 'Interested', Icons.thumb_up_outlined),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: _buildConnectedTab('not_interested', 'Not Interested', Icons.thumb_down_outlined),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            children: _buildConnectedDispositions(),
          ),
        ),
      ],
    );
  }

  Widget _buildConnectedTab(String value, String label, IconData icon) {
    final bool isSelected = controller.selectedConnectedTab.value == value;
    return GestureDetector(
      onTap: () {
        controller.selectedConnectedTab.value = value;
        controller.selectedDisposition.value = '';
        controller.selectedMiniDisposition.value = '';
        controller.selectedReason.value = '';
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? ColorConstants.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: isSelected
                  ? (value == 'interested' ? Color(0xFF10B981) : Color(0xFFEF4444))
                  : ColorConstants.grey,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? (value == 'interested' ? Color(0xFF10B981) : Color(0xFFEF4444))
                    : ColorConstants.grey,
                fontFamily: AppFonts.poppins,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildConnectedDispositions() {
    final tab = controller.selectedConnectedTab.value;
    final dispositions = tab == 'interested'
        ? controller.interestedDispositions
        : controller.notInterestedDispositions;

    final List<Widget> widgets = [];

    dispositions.forEach((disposition, miniDispositions) {
      widgets.add(
        Padding(
          padding: EdgeInsets.fromLTRB(0, 8.h, 0, 4.h),
          child: Row(
            children: [
              Icon(
                Icons.label_outline_rounded,
                size: 16.sp,
                color: tab == 'interested' ? Color(0xFF10B981) : Color(0xFFEF4444),
              ),
              SizedBox(width: 6.w),
              Text(
                disposition,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.grey,
                  fontFamily: AppFonts.poppins,
                ),
              ),
            ],
          ),
        ),
      );

      for (var miniDisposition in miniDispositions) {
        final fullReason = '$disposition - $miniDisposition';
        final isFollowUp =
            disposition == 'Follow Up' || disposition == 'Warm Lead';

        widgets.add(
          Obx(() {
            final isSelected = controller.selectedReason.value == fullReason;
            return Container(
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? (tab == 'interested' 
                        ? Color(0xFF10B981).withOpacity(0.08)
                        : Color(0xFFEF4444).withOpacity(0.08))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10.r),
                border: isSelected
                    ? Border.all(
                        color: tab == 'interested' 
                            ? Color(0xFF10B981).withOpacity(0.3)
                            : Color(0xFFEF4444).withOpacity(0.3),
                        width: 1.5)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioListTile<String>(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            miniDisposition,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontFamily: AppFonts.poppins,
                              color: isSelected 
                                  ? (tab == 'interested' ? Color(0xFF10B981) : Color(0xFFEF4444))
                                  : ColorConstants.grey,
                            ),
                          ),
                        ),
                        if (isFollowUp)
                          Icon(
                            Icons.event_rounded,
                            size: 16.sp,
                            color: Color(0xFFF59E0B),
                          ),
                      ],
                    ),
                    value: fullReason,
                    groupValue: controller.selectedReason.value,
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedReason.value = value;
                        controller.selectedDisposition.value = disposition;
                        controller.selectedMiniDisposition.value = miniDisposition;
                        controller.needsFollowUp.value = isFollowUp;
                        controller.explanation.value = '';
                        controller.genderController.clear();
                        controller.ageController.clear();
                        controller.professionController.clear();
                        controller.pincodeController.clear();
                        controller.cityController.clear();
                        if (isFollowUp) {
                          Get.back();
                          onShowCalendar();
                        }
                      }
                    },
                    activeColor: tab == 'interested' ? Color(0xFF10B981) : Color(0xFFEF4444),
                  ),

                  /// Show explanation + 5 input fields
                  if (isSelected)
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Explanation Field
                          Container(
                            decoration: BoxDecoration(
                              color: ColorConstants.white,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: (tab == 'interested' 
                                    ? Color(0xFF10B981)
                                    : Color(0xFFEF4444)).withOpacity(0.3),
                              ),
                            ),
                            child: TextField(
                              controller: TextEditingController(
                                text: controller.explanation.value,
                              )..selection = TextSelection.fromPosition(
                                  TextPosition(offset: controller.explanation.value.length),
                                ),
                              onChanged: (v) => controller.explanation.value = v,
                              maxLines: 3,
                              style: TextStyle(fontSize: 13.sp, fontFamily: AppFonts.poppins),
                              decoration: InputDecoration(
                                labelText: 'Remarks (min 2 words)',
                                labelStyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: AppFonts.poppins,
                                  color: ColorConstants.grey,
                                ),
                                hintText: 'Explain briefly...',
                                prefixIcon: Icon(
                                  Icons.edit_note_rounded,
                                  size: 20.sp,
                                  color: Color(0xFF8B5CF6),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                              ),
                            ),
                          ),
                          // Live word count
                          Padding(
                            padding: EdgeInsets.only(top: 4.h, left: 4.w),
                            child: Obx(() {
                              final words = controller.explanation.value
                                  .trim()
                                  .split(' ')
                                  .where((w) => w.isNotEmpty)
                                  .length;
                              return Text(
                                '$words word${words == 1 ? '' : 's'}',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: words > 3 ? Color(0xFF10B981) : Color(0xFFEF4444),
                                  fontFamily: AppFonts.poppins,
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 12.h),

                          // === 5 NEW INPUT FIELDS ===
                                                 // === GENDER: Radio Buttons (Male / Female) ===
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person_outline_rounded,
                                      size: 20.sp,
                                      color: Color(0xFF3B82F6),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Gender',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppFonts.poppins,
                                        color: ColorConstants.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: ColorConstants.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: ColorConstants.appThemeColor.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Obx(() => Row(
                                    children: [
                                      Expanded(
                                        child: _buildGenderRadio(
                                          label: 'Male',
                                          value: 'Male',
                                          groupValue: controller.selectedGender.value,
                                          onChanged: (val) {
                                            controller.selectedGender.value = val!;
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: _buildGenderRadio(
                                          label: 'Female',
                                          value: 'Female',
                                          groupValue: controller.selectedGender.value,
                                          onChanged: (val) {
                                            controller.selectedGender.value = val!;
                                          },
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          _buildInputRow(
                            label: 'Age',
                            hint: 'e.g. 25',
                            controller: controller.ageController,
                            keyboardType: TextInputType.number,
                            icon: Icons.cake_outlined,
                            iconColor: Color(0xFFF59E0B),
                          ),
                          SizedBox(height: 8.h),
                          _buildInputRow(
                            label: 'Profession',
                            hint: 'e.g. Student, Engineer',
                            controller: controller.professionController,
                            icon: Icons.work_outline_rounded,
                            iconColor: Color(0xFF8B5CF6),
                          ),
                          SizedBox(height: 8.h),
                          _buildInputRow(
                            label: 'PinCode',
                            hint: 'e.g. 110001',
                            controller: controller.pincodeController,
                            keyboardType: TextInputType.number,
                            icon: Icons.location_on_outlined,
                            iconColor: Color(0xFFEF4444),
                          ),
                          SizedBox(height: 8.h),
                          _buildInputRow(
                            label: 'City',
                            hint: 'e.g. Delhi',
                            controller: controller.cityController,
                            icon: Icons.location_city_outlined,
                            iconColor: Color(0xFF10B981),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          }),
        );
      }

      widgets.add(Divider(
        thickness: 0.5,
        height: 8.h,
        color: ColorConstants.lightGrey.withOpacity(0.5),
      ));
    });

    return widgets;
  }

  // Helper: Reusable Input Row (Updated to support icon & iconColor)
Widget _buildInputRow({
  required String label,
  required String hint,
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  IconData? icon,                     // Optional icon
  Color? iconColor,                   // Optional icon color
}) {
  return Container(
    decoration: BoxDecoration(
      color: ColorConstants.white,
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(color: ColorConstants.appThemeColor.withOpacity(0.3)),
    ),
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 13.sp, fontFamily: AppFonts.poppins),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 12.sp,
          fontFamily: AppFonts.poppins,
          color: ColorConstants.grey,
        ),
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 12.sp,
          fontFamily: AppFonts.poppins,
          color: ColorConstants.grey.withOpacity(0.6),
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        // Prefix icon (only shown if icon is provided)
        prefixIcon: icon != null
            ? Icon(
                icon,
                color: iconColor ?? ColorConstants.appThemeColor, // fallback color
                size: 20.sp,
              )
            : null,
      ),
    ),
  );
}

  Widget _buildGenderRadio({
    required String label,
    required String value,
    required String groupValue,
    required Function(String?) onChanged,
  }) {
    final bool isSelected = groupValue == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xFF6366F1).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: Color(0xFF6366F1),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontFamily: AppFonts.poppins,
                color: isSelected ? Color(0xFF6366F1) : ColorConstants.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// OtherReasonInputWidget remains unchanged
class OtherReasonInputWidget extends StatelessWidget {
  final CallLog callLog;
  final CallsController controller;
  final bool isFollowUp;
  final String prefix;
  final VoidCallback onShowCalendar;

  const OtherReasonInputWidget({
    super.key,
    required this.callLog,
    required this.controller,
    required this.isFollowUp,
    required this.prefix,
    required this.onShowCalendar,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    return SafeArea(
      top: false,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: ColorConstants.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Drag Handle
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: ColorConstants.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),

              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: ColorConstants.appThemeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.rate_review_rounded,
                      color: ColorConstants.appThemeColor,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Enter Other Reason',
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  color: ColorConstants.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: ColorConstants.grey.withOpacity(0.2),
                  ),
                ),
                child: TextField(
                  controller: textController,
                  maxLines: 3,
                  style: TextStyle(fontSize: 13.sp, fontFamily: AppFonts.poppins),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type your reason here',
                    hintStyle: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: AppFonts.poppins,
                      color: ColorConstants.grey.withOpacity(0.6),
                    ),
                    contentPadding: EdgeInsets.all(12.w),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.selectedReason.value = '';
                        controller.selectedTimeSlot.value = '';
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.grey.withOpacity(0.1),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.close_rounded,
                            size: 18.sp,
                            color: ColorConstants.grey,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Cancel',
                            style: TextStyle(
                              fontFamily: AppFonts.poppins,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorConstants.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final text = textController.text.trim();
                        if (text.isNotEmpty) {
                          controller.selectedReason.value =
                              '${prefix}Other: $text';
                          controller.needsFollowUp.value = isFollowUp;
                          Get.back();
                          if (isFollowUp) {
                            onShowCalendar();
                          } else {
                            controller.submitReason(callLog);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.appThemeColor,
                        disabledBackgroundColor:
                            ColorConstants.grey.withOpacity(0.3),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            size: 18.sp,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Submit',
                            style: TextStyle(
                              fontFamily: AppFonts.poppins,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
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
    );
  }
}