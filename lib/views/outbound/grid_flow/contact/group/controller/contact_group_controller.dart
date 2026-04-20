import '../../../../../../core/app-export.dart';
import '../../../../../../core/services/api_services.dart';
import '../../../../../../core/services/dio_client.dart';
import '../../../../../../core/services/role_provider.dart';
import '../../../../../more_flow/more_screen/controller/more_controller.dart';

class ContactGroupController extends GetxController {
  var groups = <Map<String, dynamic>>[].obs;
  var displayedGroups = <Map<String, dynamic>>[].obs;
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final RxBool isLoading = false.obs;
  MoreController? moreController;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    fetchAllGroups();
  }

  void searchGroups(String query) {
    if (query.isEmpty) {
      displayedGroups.assignAll(groups);
      return;
    }
    final lowercaseQuery = query.toLowerCase();
    final filtered = groups.where((group) {
      final name = (group['name'] ?? '').toString().toLowerCase();
      final category = (group['category'] ?? '').toString().toLowerCase();
      return name.contains(lowercaseQuery) || category.contains(lowercaseQuery);
    }).toList();
    displayedGroups.assignAll(filtered);
  }

  void _initializeDependencies() {
    try {
      // Ensure MoreController is available
      moreController = Get.find<MoreController>();
      // Ensure RoleProvider is available
      Get.find<RoleProvider>();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> fetchAllGroups() async {
    try {
      isLoading.value = true;

      // Call WhatsApp groups API
      final dioClient = DioClient().dio;
      final response = await dioClient.get('whatsai/contacts/groups');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          List<dynamic> groupsList = data['data']['groups'] ?? [];
          final mapped = groupsList
              .map((group) => {
                    '_id': group['_id'] ?? '',
                    'name': group['name'] ?? '',
                    'description': group['description'] ?? '',
                    'category': group['category'] ?? '',
                    'createdAt': group['createdAt'],
                    'contactCount': 0,
                  })
              .toList();
          groups.assignAll(mapped);
          displayedGroups.assignAll(mapped);
        } else {
          print("❌ Failed to fetch groups: ${data['message']}");
          groups.clear();
          displayedGroups.clear();
        }
      } else {
        print("❌ Failed to fetch groups. Status: ${response.statusCode}");
        groups.clear();
        displayedGroups.clear();
      }
    } catch (e) {
      print("🚨 Error fetching groups: $e");
      groups.clear();
      displayedGroups.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Create new WhatsApp group
  Future<void> createGroup(
      String name, String category, String description) async {
    try {
      isLoading.value = true;

      // Prepare request with only required fields for WhatsApp API
      final Map<String, dynamic> request = {
        'name': name,
        'description': description,
      };

      // Call the WhatsApp contacts groups API
      final dioClient = DioClient().dio;
      final response = await dioClient.post(
        'whatsai/contacts/groups',
        data: request,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final groupData = data['data']['group'];
          final newGroup = {
            '_id': groupData['_id'] ?? '',
            'name': groupData['name'] ?? name,
            'description': groupData['description'] ?? description,
            'category': category,
            'createdAt':
                groupData['createdAt'] ?? DateTime.now().toIso8601String(),
            'contactCount': 0,
          };
          groups.insert(0, newGroup);
          displayedGroups.insert(0, newGroup);

          // Get.snackbar(
          //   "Success",
          //   "Group created successfully",
          //   backgroundColor: Colors.green,
          //   colorText: Colors.white,
          //   duration: const Duration(seconds: 2),
          // );

          // Delay before closing dialog to allow snackbar to show
          // await Future.delayed(const Duration(milliseconds: 300));
          Get.back();
        } else {
          Get.snackbar(
            "Error",
            data['message'] ?? "Failed to create group",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Failed to create group. Status: ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("🚨 Error creating group: $e");
      Get.snackbar(
        "Error",
        "Failed to create group. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete a group
  Future<void> deleteGroup(String groupId) async {
    try {
      isLoading.value = true;

      // Call the WhatsApp contacts groups delete API
      final dioClient = DioClient().dio;
      final response =
          await dioClient.delete('whatsai/contacts/groups/$groupId');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          groups.removeWhere((group) => group['_id'] == groupId);
          displayedGroups.removeWhere((group) => group['_id'] == groupId);

          Get.snackbar(
            "Success",
            data['message'] ?? "Group deleted successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          await Future.delayed(const Duration(milliseconds: 300));
        } else {
          Get.snackbar(
            "Error",
            data['message'] ?? "Failed to delete group",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Failed to delete group. Status: ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("🚨 Error deleting group: $e");
      Get.snackbar(
        "Error",
        "Failed to delete group. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Update existing group
  Future<void> updateGroup(
      String groupId, String name, String category, String description) async {
    try {
      isLoading.value = true;

      final Map<String, dynamic> request = {
        'name': name,
        'category': category,
        'description': description,
      };

      final response = await apiService.updateOutboundGroups(groupId, request);
      if (response.success == true) {
        final index = groups.indexWhere((group) => group['_id'] == groupId);
        if (index != -1) {
          groups[index] = {
            '_id': groupId,
            'name': name,
            'category': category,
            'description': description,
            'createdAt': groups[index]['createdAt'],
            'contactCount': groups[index]['contactCount'],
          };
          groups.refresh();
        }
        Get.back();
        await fetchAllGroups();
      } else {
        throw Exception('Group update failed');
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
