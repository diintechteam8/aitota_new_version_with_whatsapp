import 'package:get/get.dart';
import '../../../../core/app-export.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../data/model/outbound/icons/whatsapp/get_templates_model.dart';

class WhatsAppTemplatesController extends GetxController {
  final DioClient _dioClient = DioClient();

  RxBool isLoading = false.obs;
  RxList<GetTemplateModelTemplates> allTemplates =
      <GetTemplateModelTemplates>[].obs;
  RxList<GetTemplateModelTemplates> filteredTemplates =
      <GetTemplateModelTemplates>[].obs;

  var searchQuery = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchTemplates();

    // Listen to search query changes
    debounce(searchQuery, (_) => filterTemplates(),
        time: const Duration(milliseconds: 300));
  }

  Future<void> fetchTemplates() async {
    isLoading.value = true;
    try {
      final res = await _dioClient.dio.get('whatsai/templates');

      if (res.statusCode == 200) {
        if (res.data is Map<String, dynamic>) {
          final responseData = res.data as Map<String, dynamic>;

          // Handle nested data.templates structure
          if (responseData.containsKey('data') && responseData['data'] is Map) {
            final dataMap = responseData['data'] as Map<String, dynamic>;

            if (dataMap.containsKey('templates') &&
                dataMap['templates'] is List) {
              final templatesList = (dataMap['templates'] as List)
                  .map((v) => GetTemplateModelTemplates.fromJson(
                      v as Map<String, dynamic>))
                  .toList();

              allTemplates.assignAll(templatesList);
              filteredTemplates.assignAll(templatesList);
            }
          }
        }
      } else {
        print("Failed to fetch templates: ${res.statusCode}");
      }
    } catch (e) {
      print("Error fetching templates: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterTemplates() {
    if (searchQuery.isEmpty) {
      filteredTemplates.assignAll(allTemplates);
    } else {
      filteredTemplates.assignAll(allTemplates
          .where((template) =>
              (template.name ?? "")
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              (template.category ?? "")
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
          .toList());
    }
  }
}
