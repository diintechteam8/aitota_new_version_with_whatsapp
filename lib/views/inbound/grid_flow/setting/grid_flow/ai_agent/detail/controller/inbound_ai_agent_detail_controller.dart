import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/utils/snack_bar.dart';
import 'package:aitota_business/data/model/inbound/settings/ai_agent/ai_agent_model.dart';
import '../../../../../../../../core/services/api_services.dart';
import '../../../../../../../../core/services/dio_client.dart';

class InboundAiAgentDetailController extends GetxController {
  final agentData = Rx<AgentData?>(null);
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final isLoading = false.obs;
  final errorMessage = "".obs;
  final firstMessageController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();
  final phoneNumberController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null && arguments is AgentData) {
      agentData.value = arguments;
      firstMessageController.text = agentData.value?.firstMessage ?? '';
    } else {
      errorMessage.value = "No agent data provided";
    }
  }

  Future<void> saveGreeting() async {
    final newMessage = firstMessageController.text.trim();
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final request = {
        'firstMessage': newMessage,
        'startingMessages': [
          {'text': newMessage}
        ],
      };

      final response = await apiService.updateInboundAiAgent(
        request,
        agentData.value?.id ?? '',
      );

      if (response.id != null) {
        agentData.value = AgentData(
          id: response.id,
          agentName: agentData.value?.agentName ?? '',
          language: agentData.value?.language ?? '',
          category: agentData.value?.category ?? '',
          personality: agentData.value?.personality ?? '',
          firstMessage: newMessage,
          callingNumber: agentData.value?.callingNumber ?? '',
          callingType: agentData.value?.callingType ?? '',
        );
        firstMessageController.text = newMessage;
        customSnackBar(message: "Agent updated successfully", type: "S");
      } else {
        throw Exception("Invalid response from server");
      }
    } catch (e) {
      firstMessageController.text = agentData.value?.firstMessage ?? '';
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> makePhoneCall() async {
    final phoneNumber = agentData.value?.callingNumber?.toString();
    if (phoneNumber == null || phoneNumber.isEmpty) {
      customSnackBar(message: "No phone number available for this agent", type: "E");
      return;
    }

    var status = await Permission.phone.request();
    if (status.isGranted) {
      bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
      if (res == false) {
        customSnackBar(message: "Could not initiate call", type: "E");
      }
    } else if (status.isDenied) {
      customSnackBar(message: "Phone call permission is required to make calls", type: "E");
    } else if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 30.sp,
                color: Colors.red,
              ),
              SizedBox(height: 8.h),
              Text(
                'Permission Denied',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.poppins,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Please enable phone call permission in app settings to make calls.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: AppFonts.poppins,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: AppFonts.poppins,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  ElevatedButton(
                    onPressed: () {
                      openAppSettings();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.appThemeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Open Settings',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: AppFonts.poppins,
                        color: Colors.white,
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

  @override
  void onClose() {
    firstMessageController.dispose();
    textFieldFocusNode.dispose();
    phoneNumberController.dispose();
    super.onClose();
  }
}