import 'package:aitota_business/core/app-export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../../data/model/myDial/call_log_model.dart';
import '../../../../../views/myDial/grid_flow/call_logs/calls/controller/calls_controller.dart';
import '../../my_dial_widgets/calendar_widget.dart';
import '../../my_dial_widgets/reason_form_widget.dart';
import '../../my_dial_widgets/time_selection_widget.dart';

class CustomContactCard extends StatelessWidget {
  final Map<String, dynamic> contact;
  final ThemeData theme;

  const CustomContactCard({
    super.key,
    required this.contact,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final phone = contact['phone'] ?? 'Unknown';
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: ColorConstants.appThemeColor.withOpacity(0.15),
          child: Text(
            (contact['name'] ?? 'U')[0].toUpperCase(),
            style: TextStyle(
              color: ColorConstants.appThemeColor,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.poppins,
              fontSize: 14.sp,
            ),
          ),
        ),
        title: Text(
          contact['name'] ?? 'Unknown',
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontWeight: FontWeight.w500,
            fontSize: 13.sp,
            color: theme.colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          phone,
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            color: Colors.grey.shade600,
            fontSize: 11.sp,
          ),
        ),
        trailing: phone != 'Unknown'
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                try {
                  final whatsappUrl = 'whatsapp://send?phone=$phone';
                  if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
                    await launchUrl(Uri.parse(whatsappUrl));
                  } else {
                    throw Exception();
                  }
                } catch (e) {
                  throw Exception(e.toString());
                }
              },
              child: SvgPicture.asset(
                ImageConstant.whatsappIcon,
                width: 30.w,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.phone,
                color: ColorConstants.appThemeColor,
                size: 20.sp,
              ),
              onPressed: () async {
                try {
                  await FlutterPhoneDirectCaller.callNumber(phone);
                } catch (e) {
                  throw Exception(e.toString());
                }
              },
            ),
          ],
        )
            : null,
      ),
    );
  }
}

class CustomAssignContactCard extends StatelessWidget {
  final Map<String, dynamic> contact;
  final ThemeData theme;

  const CustomAssignContactCard({
    super.key,
    required this.contact,
    required this.theme,
  });

  // Proper date format: 05-05-2025, 10:05 AM
  String _formatFullDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(isoString).toLocal();
      return DateFormat('dd-MM-yyyy, hh:mm a').format(date);
    } catch (e) {
      return 'N/A';
    }
  }

  // Status details (color, icon, label)
  ({Color color, IconData icon, String label}) _getStatusInfo(String? statusKey) {
    final key = (statusKey ?? '').toLowerCase().trim();

    switch (key) {
      case 'admission_confirmed':
      case 'payment_recieved':
      case 'course_started':
        return (color: Colors.green, icon: Icons.check_circle, label: 'Admission Done');

      case 'interested_waiting_confimation':
        return (color: Colors.green, icon: Icons.thumb_up, label: 'Interested');

      case 'call_back_schedule':
      case 'call_back_due':
      case 'follow_up_required':
      case 'call_later':
        return (color: Colors.blue, icon: Icons.schedule, label: 'Callback Scheduled');

      case 'information_shared':
      case 'whatsapp_sent':
        return (color: Colors.teal, icon: Icons.message, label: 'Info Shared');

      case 'payment_pending':
        return (color: Colors.orange, icon: Icons.payments, label: 'Payment Pending');

      case 'document_pending':
        return (color: Colors.deepOrange, icon: Icons.folder_open, label: 'Docs Pending');

      case 'call_busy':
      case 'call_bussy':
        return (color: Colors.orange, icon: Icons.call_end, label: 'Busy');

      case 'not_reachable':
      case 'switched_off':
      case 'out_of_coverage':
        return (color: Colors.grey, icon: Icons.phone_disabled, label: 'Not Reachable');

      case 'call_disconnected':
      case 'no_response':
        return (color: Colors.purple, icon: Icons.phone_missed, label: 'No Response');

      case 'not_interested':
      case 'joined_another_institute':
      case 'dropped_the_plan':
        return (color: Colors.red, icon: Icons.cancel, label: 'Not Interested');

      case 'dnd':
      case 'wrong_number':
      case 'invalid_number':
        return (color: Colors.red, icon: Icons.block, label: 'Invalid/DND');

      case 'unqualified_lead':
      case 'postpone':
      case 'other':
        return (color: Colors.grey, icon: Icons.info_outline, label: 'Other');

      default:
        return (color: Colors.grey, icon: Icons.info_outline, label: 'No Status');
    }
  }

  // Show Reason Form (Same flow as in Calls Tab)
  void _showReasonForm(BuildContext context, CallLog callLog) {
    final controller = Get.find<CallsController>();
    controller.loadStoredCallStatus(callLog.phoneNumber);
    controller.currentCallLog = callLog;

    Get.bottomSheet(
      ReasonFormWidget(
        callLog: callLog,
        controller: controller,
        onShowCalendar: () => _showCalendar(context, callLog),
        onShowOtherReason: (isFollowUp, prefix) =>
            _showOtherReasonInput(context, callLog, isFollowUp, prefix),
      ),
      isScrollControlled: true,
      enableDrag: false,
    );
  }

  void _showOtherReasonInput(
      BuildContext context, CallLog callLog, bool isFollowUp, String prefix) {
    Get.bottomSheet(
      OtherReasonInputWidget(
        callLog: callLog,
        controller: Get.find<CallsController>(),
        isFollowUp: isFollowUp,
        prefix: prefix,
        onShowCalendar: () => _showCalendar(context, callLog),
      ),
      isScrollControlled: true,
    );
  }

  void _showCalendar(BuildContext context, CallLog callLog) {
    Get.bottomSheet(
      CalendarWidget(
        callLog: callLog,
        controller: Get.find<CallsController>(),
        onShowTimeSelection: () => _showTimeSelection(context, callLog),
        onShowReasonForm: () => _showReasonForm(context, callLog),
      ),
      isScrollControlled: true,
    );
  }

  void _showTimeSelection(BuildContext context, CallLog callLog) {
    Get.bottomSheet(
      TimeSelectionWidget(
        callLog: callLog,
        controller: Get.find<CallsController>(),
        onShowCalendar: () => _showCalendar(context, callLog),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final phone = contact['phone']?.toString().replaceAll('+91', '').trim() ?? 'N/A';
    final rawPhone = contact['phone']?.toString() ?? 'N/A';
    final name = contact['name']?.toString().isNotEmpty == true
        ? contact['name'].toString().trim()
        : 'Unknown';
    final lastStatus = contact['lastLeadStatus']?.toString();
    final lastSubCategory = contact['lastDispositionSubCategory']?.toString();
    final lastTime = contact['lastDispositionAt']?.toString();

    final statusInfo = _getStatusInfo(lastStatus);

    // Create a temporary CallLog object for disposition
    final tempCallLog = CallLog(
      id: 'temp-${contact['id']}',
      contactName: name,
      phoneNumber: rawPhone.replaceAll(RegExp(r'\D'), ''),
      isIncoming: false,
      dateTime: DateTime.now(),
      duration: const Duration(seconds: 0),
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.lightGrey,
            offset: const Offset(0, 2),
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //---------------- TOP ROW ----------------//
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: ColorConstants.appThemeColor.withOpacity(0.12),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                    color: ColorConstants.appThemeColor,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      rawPhone,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Only show buttons if phone is valid
              if (phone != 'N/A' && phone.isNotEmpty && phone.length >= 10) ...[
                // + Button (Add Disposition) - Now in place of old Call button
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: ColorConstants.appThemeColor,
                    size: 28.sp,
                  ),
                  onPressed: () {
                    _showReasonForm(context, tempCallLog);
                  },
                ),
                SizedBox(width: 4.w),

                // Call Button - Now moved to WhatsApp's old position
                IconButton(
                  icon: Icon(
                    Icons.phone,
                    color: ColorConstants.appThemeColor,
                    size: 24.sp,
                  ),
                  onPressed: () async {
                    await FlutterPhoneDirectCaller.callNumber(rawPhone);
                  },
                ),
              ],
            ],
          ),

          SizedBox(height: 8.h),
          Divider(color: Colors.grey.shade300, height: .5),
          SizedBox(height: 8.h),

          //---------------- STATUS + SUBCATEGORY + TIME ROW ----------------//
          Row(
            children: [
              Icon(statusInfo.icon, size: 16.sp, color: statusInfo.color),
              SizedBox(width: 4.w),
              Text(
                statusInfo.label,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: statusInfo.color,
                ),
              ),

              if (lastSubCategory != null && lastSubCategory.isNotEmpty) ...[
                SizedBox(width: 20.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    lastSubCategory.toUpperCase(),
                    style: TextStyle(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],

              const Spacer(),

              Row(
                children: [
                  Icon(Icons.access_time, size: 16.sp, color: Colors.grey.shade600),
                  SizedBox(width: 4.w),
                  Text(
                    _formatFullDate(lastTime),
                    style: TextStyle(
                      fontSize: 8.sp,
                      fontFamily: AppFonts.poppins,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}