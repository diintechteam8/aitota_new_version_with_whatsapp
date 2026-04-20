import 'package:aitota_business/core/app-export.dart';
import 'package:dio/dio.dart';

import '../../../../../core/services/api_services.dart';
import '../../../../../core/services/dio_client.dart';

class OutboundCampaignController extends GetxController {
  // Use .obs directly (type is inferred as RxList)
  final campaignItems = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final ApiService apiService = ApiService(dio: DioClient().dio);

  // Filter states
  final selectedCategory = ''.obs;
  final searchQuery = ''.obs;

  // Unique categories (non-reactive, computed)
  List<String> get uniqueCategories {
    final categories = campaignItems
        .map((e) => e['category'] as String? ?? '')
        .toSet()
        .toList();
    categories.removeWhere((c) => c.isEmpty);
    categories.sort();
    return categories;
  }

  // Filtered items — returns RxList for reactivity
  RxList<Map<String, dynamic>> get filteredCampaignItems {
    List<Map<String, dynamic>> list = campaignItems.toList();

    // Apply category filter
    if (selectedCategory.value.isNotEmpty) {
      list = list
          .where((item) => item['category'] == selectedCategory.value)
          .toList();
    }

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      list = list.where((item) {
        final name = (item['name'] as String? ?? '').toLowerCase();
        final description =
            (item['description'] as String? ?? '').toLowerCase();
        final category = (item['category'] as String? ?? '').toLowerCase();
        return name.contains(query) ||
            description.contains(query) ||
            category.contains(query);
      }).toList();
    }

    return list.obs; // This makes it reactive
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllOutboundCampaigns();
  }

  Future<void> fetchAllOutboundCampaigns() async {
    try {
      isLoading.value = true;

      final response = await apiService.getAllOutboundCampaigns();
      print("Fetched Campaigns: ${response.toJson()}");

      if (response.success == true && response.data != null) {
        // Use assignAll() — safe for RxList
        campaignItems.assignAll(
          response.data!
              .map((campaign) => {
                    'id': campaign.id,
                    'name': campaign.name,
                    'description': campaign.description,
                    'category': campaign.category,
                    'createdAt': campaign.createdAt,
                    'updatedAt': campaign.updatedAt,
                    'clientId': campaign.clientId,
                    'groupIds': campaign.groupIds
                        ?.map((group) => group.toJson())
                        .toList(),
                    'contacts': campaign.contacts
                        ?.map((contact) => contact.toJson())
                        .toList(),
                  })
              .toList(),
        );
      } else {
        campaignItems.clear();
        print('No campaigns found or API returned unsuccessful response');
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteOutboundCampaign(String campaignId) async {
    try {
      isLoading.value = true;
      final response = await apiService.deleteOutboundCampaign(campaignId);

      if (response.success == true) {
        campaignItems.removeWhere((item) => item['id'] == campaignId);
      } else {
        throw Exception();
      }
    } on DioException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
