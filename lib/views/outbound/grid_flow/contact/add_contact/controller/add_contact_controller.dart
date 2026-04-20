import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../../../../../../core/app-export.dart';
import '../../../../../../core/services/api_services.dart';
import '../../../../../../core/services/dio_client.dart';
import 'dart:developer' as developer;
import '../../../../../../core/utils/snack_bar.dart';
import 'dart:async';

class AddContactController extends GetxController {
  var contacts = <Map<String, dynamic>>[].obs;
  var displayedContacts = <Map<String, dynamic>>[].obs;
  var importedContactCount = 0.obs;
  var isSyncing = false.obs;
  var isSynced = false.obs;
  var hasMoreContacts = false.obs;
  var isSearchActive = false.obs;
  var isLoadingMore = false.obs;
  final searchController = TextEditingController();
  final secureStorage = const FlutterSecureStorage();
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final ScrollController scrollController = ScrollController();
  static const int batchSize = 200;
  static const int pageSize = 20;
  var currentPage = 1.obs;
  var totalContacts = 0.obs;
  var apiContacts = <Map<String, dynamic>>[].obs;
  var localContacts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() async {
    super.onInit();
    scrollController.addListener(_onScroll);
    await fetchPhoneContactsOnly(); // Load local first
    await fetchWhatsAiContacts(); // Then load API
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadMoreContacts();
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void toggleSearch() {
    isSearchActive.value = !isSearchActive.value;
    if (!isSearchActive.value) {
      searchController.clear();
      currentPage.value = 0; // Reset to first page
      updateDisplayedContacts(); // Restore original paginated list
    }
    print('🔍 Search active: ${isSearchActive.value}');
  }

  void searchContacts(String query) {
    print('🔍 Searching for: $query');
    searchController.text = query; // Update the controller text
    currentPage.value = 1;

    // Always trigger local filter immediately
    _combineAndDisplay();

    // Also fetch from API for broader search
    fetchWhatsAiContacts(search: query);
  }

  void updateDisplayedContacts() {
    final startIndex = currentPage.value * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, contacts.length);
    displayedContacts.value = contacts.sublist(0, endIndex).toList();
    hasMoreContacts.value = endIndex < contacts.length;
  }

  Future<void> loadMoreContacts() async {
    if (isLoadingMore.value || !hasMoreContacts.value) return;
    isLoadingMore.value = true;
    currentPage.value++;
    await fetchWhatsAiContacts(search: searchController.text, isLoadMore: true);
    isLoadingMore.value = false;
  }

  Future<void> fetchWhatsAiContacts(
      {String search = "", bool isLoadMore = false}) async {
    if (!isLoadMore) {
      isSyncing.value = true;
      currentPage.value = 1;
    }

    try {
      final response = await apiService.getWhatsAiContacts(
        page: currentPage.value,
        limit: pageSize,
        search: search,
      );

      if (response.success == true && response.data != null) {
        final List<Map<String, dynamic>> fetchedApiContacts =
            response.data!.contacts!
                .map((c) => {
                      'id': c.sId,
                      'name': c.name ?? '',
                      'phone': c.phone ?? '',
                      'email': c.email ?? '',
                      'tags': c.tags ?? [],
                      'group': c.group ?? [],
                      'createdAt': c.createdAt ?? '',
                      'isSynced': true,
                    })
                .toList();

        if (isLoadMore) {
          apiContacts.addAll(fetchedApiContacts);
        } else {
          apiContacts.assignAll(fetchedApiContacts);
        }

        totalContacts.value = response.data!.pagination?.total ?? 0;
        hasMoreContacts.value = apiContacts.length < totalContacts.value;

        _combineAndDisplay();
      }
    } catch (e) {
      print('❌ Error fetching WhatsAi contacts: $e');
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> refreshContacts() async {
    await fetchPhoneContactsOnly();
    await fetchWhatsAiContacts();
  }

  Future<void> updateContact(Map<String, dynamic> contact, String name,
      String email, List<String> tags, bool optedOut) async {
    final String? id = contact['id'];
    final String phone = contact['phone'];

    if (id != null) {
      try {
        final response = await apiService.updateWhatsAiContact(id, {
          "name": name,
          "email": email,
          "tags": tags,
          "optedOut": optedOut,
        });

        if (response.success == true && response.data?.contact != null) {
          final updatedContact = response.data!.contact!;

          // Update apiContacts list instantly
          final index = apiContacts.indexWhere((c) => c['id'] == id);
          if (index != -1) {
            apiContacts[index] = {
              ...apiContacts[index],
              'name': updatedContact.name ?? name,
              'email': updatedContact.email ?? email,
              'tags': updatedContact.tags?.cast<String>() ?? tags,
              'optedOut': updatedContact.optedOut ?? optedOut,
            };
          }
        }
      } catch (e) {
        print('❌ Error updating API contact: $e');
        customSnackBar(
            message: 'Failed to update contact on server', type: 'E');
      }
    }

    // Always update local list if found
    final localIndex = localContacts.indexWhere(
        (c) => _normalizePhone(c['phone']) == _normalizePhone(phone));
    if (localIndex != -1) {
      localContacts[localIndex] = {
        ...localContacts[localIndex],
        'name': name,
        'email': email,
      };
    }

    _combineAndDisplay();
  }

  Future<bool> deleteContact(Map<String, dynamic> contact) async {
    final String? id = contact['id'];

    try {
      if (id != null) {
        final response = await apiService.deleteWhatsAiContact(id);

        if (response.success == true) {
          apiContacts.removeWhere((c) => c['id'] == id);
          _combineAndDisplay();
          customSnackBar(message: 'Contact removed', type: 'S');
          return true; // ✅ success
        }
      }
    } catch (e) {
      customSnackBar(message: 'Failed to delete contact', type: 'E');
    }

    return false; // ❌ fail
  }

  // Future<void> deleteContact(Map<String, dynamic> contact) async {
  //   final String? id = contact['id'];
  //   final String phone = contact['phone'];

  //   if (id != null) {
  //     try {
  //       final response = await apiService.deleteWhatsAiContact(id);
  //       if (response.success == true) {
  //         apiContacts.removeWhere((c) => c['id'] == id);
  //       }
  //     } catch (e) {
  //       print('❌ Error deleting API contact: $e');
  //       customSnackBar(
  //           message: 'Failed to delete contact from server', type: 'E');
  //     }
  //   }

  //   // Always remove from local list if found
  //   localContacts.removeWhere(
  //       (c) => _normalizePhone(c['phone']) == _normalizePhone(phone));

  //   _combineAndDisplay();
  //   customSnackBar(message: 'Contact removed', type: 'S');
  // }

  void _combineAndDisplay() {
    final Map<String, Map<String, dynamic>> combinedMap = {};
    final String query = searchController.text.toLowerCase();

    // Add local contacts (filter if searching)
    for (var contact in localContacts) {
      final name = (contact['name'] ?? '').toString().toLowerCase();
      final phoneStr = (contact['phone'] ?? '').toString().toLowerCase();

      if (query.isEmpty || name.contains(query) || phoneStr.contains(query)) {
        final phone = _normalizePhone(contact['phone']);
        if (phone.isNotEmpty) {
          combinedMap[phone] = contact;
        }
      }
    }

    // Add/overwrite with API contacts (API takes precedence)
    for (var contact in apiContacts) {
      final name = (contact['name'] ?? '').toString().toLowerCase();
      final phoneStr = (contact['phone'] ?? '').toString().toLowerCase();

      if (query.isEmpty || name.contains(query) || phoneStr.contains(query)) {
        final phone = _normalizePhone(contact['phone']);
        if (phone.isNotEmpty) {
          combinedMap[phone] = contact;
        }
      }
    }

    contacts.assignAll(combinedMap.values.toList());
    displayedContacts.assignAll(contacts);
    isSynced.value = true; // Mark loading as complete

    print('📄 Combined ${contacts.length} contacts (Search query: "$query")');
  }

  String _normalizePhone(dynamic phone) {
    if (phone == null) return "";
    String p = phone.toString().replaceAll(RegExp(r'\D'), '');
    if (p.length > 10) {
      p = p.substring(p.length - 10);
    }
    return p;
  }

  Future<void> fetchPhoneContactsInternal() async {
    print('🔄 Requesting contact permission...');
    bool permissionGranted = await FlutterContacts.requestPermission();
    print('🔍 Permission granted: $permissionGranted');

    if (!permissionGranted) {
      _showPermissionDialog();
      return;
    }

    try {
      final fetchedContacts =
          await FlutterContacts.getContacts(withProperties: true);
      print('📞 Contacts fetched: ${fetchedContacts.length}');

      contacts.clear();
      contacts.addAll(fetchedContacts.map((c) {
        return {
          'name': c.displayName ?? '',
          'phone': c.phones.isNotEmpty ? c.phones.first.number : '',
          'email': c.emails.isNotEmpty ? c.emails.first.address : '',
          'createdAt': DateTime.now().toIso8601String(),
          'isImported': true,
        };
      }).toList());

      importedContactCount.value = contacts.length;
      print('📥 Imported ${importedContactCount.value} contacts');
      updateDisplayedContacts();
    } catch (e) {
      print('❌ Error fetching contacts: $e');
      isSynced.value = true; // Allow UI to show empty state
      updateDisplayedContacts();
    }
  }

  Future<void> syncContacts() async {
    if (isSyncing.value) {
      print('🔄 Sync already in progress, skipping...');
      return;
    }
    isSyncing.value = true;

    try {
      String? token = await secureStorage.read(key: Constants.token);
      if (token == null || token.isEmpty) {
        isSynced.value = true;
        isSyncing.value = false;
        updateDisplayedContacts();
        return;
      }

      await fetchPhoneContactsInternal();

      final totalContacts = contacts.length;
      if (totalContacts == 0) {
        isSynced.value = true;
        isSyncing.value = false;
        updateDisplayedContacts();
        return;
      }

      final List<Map<String, String>> contactList = contacts
          .where((contact) =>
              contact['phone'] != null &&
              contact['phone'].toString().trim().isNotEmpty)
          .map((contact) {
        return {
          'name': (contact['name'] ?? '').toString(),
          'phone': contact['phone'].toString(),
        };
      }).toList();

      if (contactList.isEmpty) {
        isSynced.value = true; // Allow UI to show empty state
        isSyncing.value = false;
        updateDisplayedContacts();
        return;
      }

      print('📤 Syncing ${contactList.length} valid contacts to backend...');
      developer.log('📤 All contacts: $contactList');

      final response = await apiService.syncUserContacts(contactList);

      print('📥 Response: ${response.toString()}');

      if (response.status == true) {
        customSnackBar(message: 'Contacts synced successfully', type: 'S');
        await fetchWhatsAiContacts(); // Refresh list from backend after sync
      } else {
        isSynced.value = true; // Allow UI to show empty state
        displayedContacts.assignAll(contacts);
      }
    } catch (e) {
      print('❌ Error syncing contacts: $e');
      isSynced.value = true; // Allow UI to show empty state
      updateDisplayedContacts();
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> fetchPhoneContactsOnly() async {
    bool permissionGranted = await FlutterContacts.requestPermission();
    if (!permissionGranted) return;

    try {
      final fetchedContacts =
          await FlutterContacts.getContacts(withProperties: true);
      localContacts.assignAll(fetchedContacts.map((c) {
        return {
          'name': c.displayName ?? '',
          'phone': c.phones.isNotEmpty ? c.phones.first.number : '',
          'email': c.emails.isNotEmpty ? c.emails.first.address : '',
          'createdAt': DateTime.now().toIso8601String(),
          'isImported': true,
          'isSynced': false,
        };
      }).toList());
      _combineAndDisplay();
    } catch (e) {
      print('❌ Error fetching local contacts: $e');
    }
  }

  Future<void> fetchPhoneContacts() async {
    print('🔄 Requesting contact permission...');
    bool permissionGranted = await FlutterContacts.requestPermission();
    print('🔍 Permission granted: $permissionGranted');

    if (!permissionGranted) {
      _showPermissionDialog();
      return;
    }

    try {
      final fetchedContacts =
          await FlutterContacts.getContacts(withProperties: true);
      print('📞 Contacts fetched: ${fetchedContacts.length}');
      if (fetchedContacts.isEmpty && await _isRealmeOrColorOS()) {
        _showPermissionDialog();
        return;
      }
      final List<Map<String, dynamic>> imported = fetchedContacts.map((c) {
        return {
          'name': c.displayName ?? '',
          'phone': c.phones.isNotEmpty ? c.phones.first.number : '',
          'email': c.emails.isNotEmpty ? c.emails.first.address : '',
          'createdAt': DateTime.now().toIso8601String(),
          'isImported': true,
          'isSynced': false,
        };
      }).toList();

      localContacts.assignAll(imported);
      _combineAndDisplay();
      await syncContacts();
    } catch (e) {
      print('❌ Error fetching contacts: $e');
      customSnackBar(message: 'Failed to fetch contacts.', type: 'E');
      isSynced.value = true; // Allow UI to show empty state
    }
  }

  void addImportedContacts(List<Map<String, dynamic>> importedContacts) {
    final updated = importedContacts.map((contact) {
      return {
        ...contact,
        'isImported': true,
      };
    }).toList();

    contacts.addAll(updated);
    importedContactCount.value += updated.length;
    currentPage.value = 0;
    updateDisplayedContacts();
  }

  Future<bool> _isRealmeOrColorOS() async {
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      final manufacturer = info.manufacturer.toLowerCase() ?? '';
      final brand = info.brand.toLowerCase() ?? '';
      final model = info.model.toLowerCase() ?? '';
      final os = info.version.release;

      print(
          '📱 Device: manufacturer=$manufacturer, brand=$brand, model=$model, os=$os');
      return manufacturer.contains('realme') ||
          brand.contains('realme') ||
          model.contains('rmx') ||
          manufacturer.contains('oppo') ||
          brand.contains('oppo') ||
          os.contains('color');
    } catch (e) {
      print('❌ Error checking device info: $e');
      return false;
    }
  }

  void _showPermissionDialog() {
    isSyncing.value = false;
    Get.dialog(
      AlertDialog(
        title: const Text(
          "Contacts Permission Required",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text(
          "This device may be blocking contact access even after granting permission.\n\n"
          "To enable contacts:\n"
          "• Go to Settings → App Management → Aitota Business → Permissions\n"
          "• Tap 'Contacts' → Select 'Allow'\n\n"
          "Then return and try again.",
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              isSynced.value =
                  true; // Show "No contacts available" if user cancels
              displayedContacts.clear();
              updateDisplayedContacts();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await openAppSettings();
              await fetchPhoneContacts(); // Retry after opening settings
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }
}
