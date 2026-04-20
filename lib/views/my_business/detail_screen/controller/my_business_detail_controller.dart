import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MyBusinessDetailsController extends GetxController {
  final Map<String, dynamic> businessItem = Get.arguments ?? {};
  final RxBool isLoading = false.obs;

  RxBool isDescriptionExpanded = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Optional: Add any initialization logic here, e.g., fetching additional data if needed
  }

  Future<void> launchVideoLink() async {
    final String videoLink = businessItem['videoLink'] ?? '';
    if (videoLink.isNotEmpty) {
      try {
        if (await canLaunchUrl(Uri.parse(videoLink))) {
          await launchUrl(Uri.parse(videoLink), mode: LaunchMode.externalApplication);
        } else {
          Get.snackbar('Error', 'Could not launch video link');
        }
      } catch (e) {
       throw Exception(e.toString());
      }
    }
  }

  Future<void> launchLink() async {
    final String link = businessItem['link'] ?? '';
    if (link.isNotEmpty) {
      try {
        if (await canLaunchUrl(Uri.parse(link))) {
          await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
        } else {
          Get.snackbar('Error', 'Could not launch link');
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to launch link: $e');
      }
    }
  }

  Future<void> launchShareLink() async {
    final String sharelink = businessItem['sharelink'] ?? '';
    if (sharelink.isNotEmpty) {
      try {
        if (await canLaunchUrl(Uri.parse(sharelink))) {
          await launchUrl(Uri.parse(sharelink), mode: LaunchMode.externalApplication);
        } else {
          Get.snackbar('Error', 'Could not launch share link');
        }
      } catch (e) {
        throw Exception(e.toString());
      }
    }
  }
}
