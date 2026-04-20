import 'package:aitota_business/core/constants/constants.dart';
import 'package:aitota_business/core/services/api_services.dart';
import 'package:aitota_business/core/services/dio_client.dart';
import 'package:aitota_business/core/services/role_provider.dart';
import 'package:aitota_business/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import '../../../../data/model/auth_models/admin_clients_model.dart';

class AdminClientsController extends GetxController
    with GetTickerProviderStateMixin {
  final ApiService apiService = ApiService(dio: DioClient().dio);

  final RxList<ClientData> clients = <ClientData>[].obs;
  final RxList<ClientData> filteredClients = <ClientData>[].obs;
  final Rx<ClientData?> selectedClient = Rx<ClientData?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxInt selectedTabIndex = 0.obs;
  final RxBool isAscending = true.obs;

  final TextEditingController searchController = TextEditingController();
  late final TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    loadAdminClients();

    ever(searchQuery, (_) => filterAndSortClients());
    ever(selectedTabIndex, (_) => filterAndSortClients());
    ever(isAscending, (_) => filterAndSortClients());

    tabController.addListener(() {
      if (!tabController.indexIsChanging)
        selectedTabIndex.value = tabController.index;
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    tabController.dispose();
    super.onClose();
  }

  Future<void> loadAdminClients() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      // Prefer admin token header override if available
      final gs = GetStorage();
      final String? adminToken = gs.read(Constants.adminToken);
      final response = adminToken != null && adminToken.isNotEmpty
          ? await apiService.getAdminClientsAsAdmin(adminToken)
          : await apiService.getAdminClients();
      if (response.success == true && response.data != null) {
        clients.assignAll(response.data!);
        filterAndSortClients();
      } else {
        throw Exception('Failed to load clients');
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void selectClient(ClientData client) => selectedClient.value = client;

  void updateSearchQuery(String q) => searchQuery.value = q.trim();

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  void toggleSortOrder() => isAscending.value = !isAscending.value;

  void filterAndSortClients() {
    var list = clients.toList();

    // Tab filter
    final type = selectedTabIndex.value == 0 ? 'Prime' : 'owned';
    list = list.where((c) => c.clientType == type).toList();

    // Search filter
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list.where((c) {
        return (c.name?.toLowerCase() ?? '').contains(q) ||
            (c.email?.toLowerCase() ?? '').contains(q) ||
            (c.businessName?.toLowerCase() ?? '').contains(q);
      }).toList();
    }

    // Sort
    list.sort((a, b) {
      final aName = (a.businessName ?? a.name ?? '').trim();
      final bName = (b.businessName ?? b.name ?? '').trim();
      return isAscending.value
          ? aName.compareTo(bName)
          : bName.compareTo(aName);
    });

    filteredClients.assignAll(list);
  }

  Future<void> switchToClient() async {
    if (selectedClient.value == null) {
      return;
    }
    try {
      isLoading.value = true;
      final client = selectedClient.value!;
      // Build tokens payload using stored admin token
      final sec = const FlutterSecureStorage();
      final gs = GetStorage();
      final adminToken = gs.read(Constants.adminToken) as String?;
      if (adminToken == null || adminToken.isEmpty) {
        throw Exception('Admin token not found');
      }
      final tokensBody = {
        'tokens': {
          'adminToken': adminToken,
          'clientToken': null,
          'humanAgentToken': null,
        }
      };

      print("Switching to Client ID: ${client.id}");
      final tokenResp = await apiService.getClientTokenPost(
        client.id!,
        tokensBody,
        adminTokenOverride: adminToken,
      );
      if (tokenResp.token == null || tokenResp.token!.isEmpty)
        throw Exception('No token');

      await sec.write(key: Constants.token, value: tokenResp.token!);
      if (tokenResp.profileId != null)
        await sec.write(key: Constants.profileId, value: tokenResp.profileId!);
      await sec.write(key: Constants.id, value: client.id!);
      await sec.write(key: 'isLoggedIn', value: 'true');

      // Update More screen admin section flag based on response tokens
      final String? adminTokenResp = tokenResp.tokens?.adminToken;
      final hasAdminToken = adminTokenResp != null && adminTokenResp.isNotEmpty;
      final gs2 = GetStorage();
      gs2.write(Constants.hasAdminToken, hasAdminToken);
      if (hasAdminToken) {
        gs2.write(Constants.adminToken, adminTokenResp);
      }

      Get.find<RoleProvider>().setRole(tokenResp.userType ?? 'client');
      GetStorage().write(
          Constants.isProfileCompleted, client.isProfileCompleted ?? false);
      Get.offAllNamed(AppRoutes.bottomBarScreen);
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
