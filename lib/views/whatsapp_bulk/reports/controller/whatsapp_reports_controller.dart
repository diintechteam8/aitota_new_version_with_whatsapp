import 'package:get/get.dart';

class WhatsAppReportsController extends GetxController {
  RxList<Map<String, dynamic>> campaigns = <Map<String, dynamic>>[
    {
      "id": "CAM001",
      "name": "Diwali Special Offer",
      "template": "festival_offer",
      "status": "Completed",
      "total": 1250,
      "sent": 1250,
      "delivered": 1210,
      "read": 980,
      "replied": 150,
      "date": "10 Oct 2023",
    },
    {
      "id": "CAM002",
      "name": "January Signup Reminder",
      "template": "signup_reminder",
      "status": "Completed",
      "total": 3200,
      "sent": 3200,
      "delivered": 3150,
      "read": 2800,
      "replied": 420,
      "date": "05 Jan 2024",
    },
    {
      "id": "CAM003",
      "name": "Abandoned Cart Alert",
      "template": "abandoned_cart",
      "status": "Processing",
      "total": 450,
      "sent": 210,
      "delivered": 195,
      "read": 120,
      "replied": 12,
      "date": "Today",
    },
  ].obs;

  RxBool isLoading = false.obs;

  Future<void> refreshReports() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
  }
}
