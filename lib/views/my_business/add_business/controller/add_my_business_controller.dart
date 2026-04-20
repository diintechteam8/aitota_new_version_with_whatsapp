import 'dart:io';
import 'dart:convert';
import 'package:aitota_business/core/app-export.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import '../../../../core/services/dio_client.dart';
import '../../controller/my_business_controller.dart';
import '../../../../core/services/api_services.dart';

class AddMyBusinessController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final RxBool isLoading = false.obs;

  // Form controllers
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final selectedType = ''.obs;
  final videoLinkController = TextEditingController();
  final linkController = TextEditingController();
  final sharelinkController = TextEditingController();
  final descriptionController = TextEditingController();
  final mrpController = TextEditingController();
  final offerPriceController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // File fields
  final Rx<File?> imageFile = Rx<File?>(null);
  final Rx<File?> documentFile = Rx<File?>(null);

  // S3 values
  final RxString s3Key = ''.obs;
  final RxString s3ImageUrl = ''.obs;

  @override
  void onClose() {
    titleController.dispose();
    categoryController.dispose();
    videoLinkController.dispose();
    linkController.dispose();
    sharelinkController.dispose();
    descriptionController.dispose();
    mrpController.dispose();
    offerPriceController.dispose();
    super.onClose();
  }

  /// Pick image and upload to S3
  Future<void> pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty) {
        imageFile.value = File(result.files.first.path!);
        await uploadImageToS3();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Upload selected image to S3
  Future<void> uploadImageToS3() async {
    if (imageFile.value == null) return;

    try {
      isLoading.value = true;

      final fileName = imageFile.value!.path.split('/').last;
      final fileType = 'image/${fileName.split('.').last}';

      // Step 1: Get pre-signed URL from backend
      final uploadResponse = await apiService.uploadUrlInMyBusiness(
        fileName: fileName,
        fileType: fileType,
      );

      if (uploadResponse.success == true &&
          uploadResponse.url != null &&
          uploadResponse.key != null) {
        // Step 2: Upload to S3 directly
        final s3Response = await http.put(
          Uri.parse(uploadResponse.url!),
          body: await imageFile.value!.readAsBytes(),
          headers: {
            'Content-Type': fileType,
          },
        );

        if (s3Response.statusCode == 200) {
          s3Key.value = uploadResponse.key!;
          s3ImageUrl.value = uploadResponse.url!.split('?').first;
        } else {
          throw Exception(
              'Failed to upload image to S3: ${s3Response.statusCode}');
        }
      } else {
        throw Exception('Failed to get upload URL from backend');
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Pick a document (for JSON request we will Base64 encode it)
  Future<void> pickDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty) {
        documentFile.value = File(result.files.first.path!);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Create business with pure JSON request
  Future<void> createBusiness() async {
    if (!formKey.currentState!.validate()) return;

    if (imageFile.value == null || s3Key.value.isEmpty) {
      return;
    }

    if (selectedType.value.isEmpty) {
      return;
    }

    final urlPattern = RegExp(
        r'^(https?:\/\/)?([\w\-])+\.{1}([a-zA-Z]{2,63})([\/\w-]*)*\/?\??([^#\n\r]*)?#?([^\n\r]*)$');
    if (!urlPattern.hasMatch(videoLinkController.text.trim())) {
      return;
    }

    if (int.tryParse(mrpController.text.trim()) == null ||
        int.parse(mrpController.text.trim()) <= 0) {
      return;
    }
    if (int.tryParse(offerPriceController.text.trim()) == null ||
        int.parse(offerPriceController.text.trim()) <= 0) {
      return;
    }

    try {
      isLoading.value = true;

      final requestBody = {
        "title": titleController.text.trim(),
        "category": categoryController.text.trim(),
        "type": selectedType.value,
        "image": {
          "url": s3ImageUrl.value,
          "key": s3Key.value
        },
        "videoLink": videoLinkController.text.trim(),
        "description": descriptionController.text.trim(),
        "mrp": int.parse(mrpController.text.trim()),
        "offerPrice": int.parse(offerPriceController.text.trim())
      };

      print("SendReq: ${jsonEncode(requestBody)}");

      final response = await apiService.addMyBusiness(requestBody);

      if (response.success == true) {
        Get.back();
        final myBusinessController = Get.find<MyBusinessController>();
        // await myBusinessController.fetchMyBusinesses();
      } else {
        throw Exception('Business creation failed');
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

}