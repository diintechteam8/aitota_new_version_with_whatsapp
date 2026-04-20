import 'dart:io';
import 'package:aitota_business/core/app-export.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import '../../../../core/services/dio_client.dart';
import '../../controller/my_business_controller.dart';
import '../../../../core/services/api_services.dart';

class UpdateMyBusinessController extends GetxController {
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final RxBool isLoading = false.obs;

  // Form controllers
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final typeController = TextEditingController(); // For form validation
  final RxString businessType = ''.obs; // For reactive updates
  final videoLinkController = TextEditingController();
  final linkController = TextEditingController();
  final descriptionController = TextEditingController();
  final mrpController = TextEditingController();
  final offerPriceController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // File fields
  final Rx<File?> imageFile = Rx<File?>(null);
  final Rx<File?> documentFile = Rx<File?>(null);
  final RxString imageKey = ''.obs;
  final RxString imageUrl = ''.obs;
  String? id;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null || args['id'] == null) {
      return;
    }
    id = args['id'];
    titleController.text = args['title'] ?? '';
    categoryController.text = args['category'] ?? '';
    businessType.value = args['type'] ?? '';
    typeController.text = args['type'] ?? ''; // Sync with form controller
    descriptionController.text = args['description'] ?? '';
    videoLinkController.text = args['videoLink'] ?? '';
    linkController.text = args['link'] ?? '';
    mrpController.text = args['mrp']?.toString() ?? '';
    offerPriceController.text = args['offerPrice']?.toString() ?? '';
    imageUrl.value = args['imageUrl'] ?? '';
  }

  @override
  void onClose() {
    titleController.dispose();
    categoryController.dispose();
    typeController.dispose();
    videoLinkController.dispose();
    linkController.dispose();
    descriptionController.dispose();
    mrpController.dispose();
    offerPriceController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty) {
        imageFile.value = File(result.files.first.path!);
        print('Image picked: ${imageFile.value?.path}');
        await uploadImageToS3();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> uploadImageToS3() async {
    if (imageFile.value == null) return;

    try {
      isLoading.value = true;

      final fileName = imageFile.value!.path.split('/').last;
      final fileType = 'image/${fileName.split('.').last}';

      final uploadResponse = await apiService.uploadUrlInMyBusiness(
        fileName: fileName,
        fileType: fileType,
      );

      if (uploadResponse.success == true && uploadResponse.url != null) {
        final response = await http.put(
          Uri.parse(uploadResponse.url!),
          body: await imageFile.value!.readAsBytes(),
          headers: {
            'Content-Type': fileType,
          },
        );

        if (response.statusCode == 200) {
          imageKey.value = uploadResponse.key ?? '';
          // Replace with actual S3 bucket URL or logic from uploadResponse
          imageUrl.value =
          'https://your-actual-s3-bucket.s3.amazonaws.com/${imageKey.value}';
          print('Image URL set to: ${imageUrl.value}');
          Get.snackbar(
            'Success',
            'Image uploaded successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade600,
            colorText: Colors.white,
          );
        } else {
          throw Exception('Failed to upload image to S3: ${response.statusCode}');
        }
      } else {
        throw Exception('Failed to get upload URL');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty) {
        documentFile.value = File(result.files.first.path!);
        print('Document picked: ${documentFile.value?.path}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick document: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> updateBusiness() async {
    if (!formKey.currentState!.validate()) return;

    final urlPattern = RegExp(
        r'^(https?:\/\/)?([\w\-])+\.{1}([a-zA-Z]{2,63})([\/\w-]*)*\/?\??([^#\n\r]*)?#?([^\n\r]*)$');
    if (videoLinkController.text.trim().isNotEmpty &&
        !urlPattern.hasMatch(videoLinkController.text.trim())) {
      Get.snackbar('Error', 'Invalid Video Link format',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (linkController.text.trim().isNotEmpty &&
        !urlPattern.hasMatch(linkController.text.trim())) {
      Get.snackbar('Error', 'Invalid Link format',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (mrpController.text.trim().isNotEmpty &&
        (double.tryParse(mrpController.text.trim()) == null ||
            double.parse(mrpController.text.trim()) <= 0)) {
      Get.snackbar('Error', 'MRP must be a valid positive number',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (offerPriceController.text.trim().isNotEmpty &&
        (double.tryParse(offerPriceController.text.trim()) == null ||
            double.parse(offerPriceController.text.trim()) <= 0)) {
      Get.snackbar('Error', 'Offer Price must be a valid positive number',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (id == null) {
      Get.snackbar('Error', 'Business ID not found',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;

      final request = dio.FormData.fromMap({
        'title': titleController.text.trim(),
        'category': categoryController.text.trim(),
        'type': businessType.value,
        if (videoLinkController.text.trim().isNotEmpty)
          'videoLink': videoLinkController.text.trim(),
        if (linkController.text.trim().isNotEmpty)
          'link': linkController.text.trim(),
        if (descriptionController.text.trim().isNotEmpty)
          'description': descriptionController.text.trim(),
        if (mrpController.text.trim().isNotEmpty)
          'mrp': double.parse(mrpController.text.trim()),
        if (offerPriceController.text.trim().isNotEmpty)
          'offerPrice': double.parse(offerPriceController.text.trim()),
        if (imageKey.value.isNotEmpty) 'imageKey': imageKey.value,
        if (documentFile.value != null)
          'documents': await dio.MultipartFile.fromFile(
            documentFile.value!.path,
            filename: documentFile.value!.path.split('/').last,
          ),
      });

      print("📝 FormData Fields for Update:");
      for (var field in request.fields) {
        print("  ${field.key}: ${field.value}");
      }
      final response = await apiService.updateMyBusiness(request, id!);
      print("UpdateBusiness Response: ${response.toJson()}");

      if (response.success == true) {
        Get.back();
        final myBusinessController = Get.find<MyBusinessController>();
        // await myBusinessController.fetchMyBusinesses();
        Get.snackbar(
          'Success',
          'Business "${titleController.text.trim()}" updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Business update failed');
      }
    } catch (e) {
      print("UpdateBusinessError: $e");
      Get.snackbar('Error', 'Failed to update business: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}