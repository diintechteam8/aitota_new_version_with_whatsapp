import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/core/utils/snack_bar.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class DialerPadController extends GetxController {
  final TextEditingController numberController = TextEditingController();
  final RxString phoneNumber = ''.obs;

  void addDigit(String digit) {
    phoneNumber.value += digit;
    numberController.text = phoneNumber.value;
  }

  void removeDigit() {
    if (phoneNumber.value.isNotEmpty) {
      phoneNumber.value =
          phoneNumber.value.substring(0, phoneNumber.value.length - 1);
      numberController.text = phoneNumber.value;
    }
  }

  void clearNumber() {
    phoneNumber.value = '';
    numberController.clear();
  }

  Future<void> makePhoneCall() async {
    var status = await Permission.phone.request();
    if (status.isGranted) {
      bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber.value);
      if (res == false) {
        customSnackBar(message: "Could not initiate call", type: "I");
      }
    } else if (status.isDenied) {
      customSnackBar(
          message: "Phone call permission is required to make calls",
          type: "I");
    } else if (status.isPermanentlyDenied) {
      customSnackBar(
          message: "Please enable phone call permission in app settings",
          type: "I",
          onTap: () {
            openAppSettings();
          });
    }
  }

  @override
  void onClose() {
    numberController.dispose();
    super.onClose();
  }
}
