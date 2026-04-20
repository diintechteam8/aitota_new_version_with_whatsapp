import '../../../../core/app-export.dart';
import '../../../../views/myDial/grid_flow/call_logs/calls/controller/calls_controller.dart';

class TabWidget extends StatelessWidget {
  final String label;
  final String value;
  final CallsController controller;

  const TabWidget({
    super.key,
    required this.label,
    required this.value,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = controller.selectedCategory.value == value;
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          controller.selectedCategory.value = value;
          controller.selectedDisposition.value = '';
          controller.selectedMiniDisposition.value = '';
          controller.selectedReason.value = '';
          controller.needsFollowUp.value = false;
          controller.selectedTimeSlot.value = '';
          if (value == 'connected') {
            controller.selectedConnectedTab.value = 'interested';
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
          backgroundColor: isSelected
              ? ColorConstants.appThemeColor
              : ColorConstants.white.withAlpha(80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : ColorConstants.grey,
            fontFamily: AppFonts.poppins,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            height: 1.1,
          ),
        ),
      ),
    );
  }
}
