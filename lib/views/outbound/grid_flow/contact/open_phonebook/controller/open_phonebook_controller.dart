import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import '../../../../../../core/app-export.dart';

class OpenPhoneBookController extends GetxController {
  var contacts = <Contact>[].obs;
  var allContacts = <Contact>[];
  var filteredContacts = <Contact>[].obs;

  // REPLACE index-based selection with ID-based selection
  final selectedContactIds = <String>{}.obs;

  var importedContacts = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMoreContacts = true.obs;
  var searchQuery = ''.obs;
  final int batchSize = 100;
  int currentPage = 0;

  @override
  void onInit() {
    super.onInit();
    fetchContacts();
  }

  Future<void> fetchContacts({bool loadMore = false}) async {
    if (loadMore && (!hasMoreContacts.value || isLoadingMore.value)) return;

    try {
      if (!loadMore) {
        isLoading.value = true;
        if (await FlutterContacts.requestPermission()) {
          allContacts = await FlutterContacts.getContacts(withProperties: true);
          allContacts.sort((a, b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));
          if (allContacts.isEmpty) {
            hasMoreContacts.value = false;
            contacts.clear();
            filteredContacts.clear();
          } else {
            filteredContacts.assignAll(allContacts);
            _applyFilterAndPagination();
          }
        } else {
          // Permission denied: optionally handle UI here
        }
      } else {
        isLoadingMore.value = true;
        _applyFilterAndPagination(loadMore: true);
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void filterContacts(String query) {
    searchQuery.value = query;
    currentPage = 0;
    _applyFilterAndPagination();
  }

  void loadMoreContacts() {
    if (!hasMoreContacts.value || isLoadingMore.value) return;
    _applyFilterAndPagination(loadMore: true);
  }

  void _applyFilterAndPagination({bool loadMore = false}) {
    if (!loadMore) {
      currentPage = 0;
      contacts.clear();
      // DO NOT clear selections here; keep user choices persistent
    }

    final query = searchQuery.value.toLowerCase();
    List<Contact> currentList;

    if (query.isEmpty) {
      currentList = allContacts.toList();
    } else {
      if (RegExp(r'^\d+$').hasMatch(query)) {
        currentList = allContacts.where((contact) {
          return contact.phones.any((phone) =>
              phone.number.replaceAll(RegExp(r'[^0-9]'), '').contains(query));
        }).toList();
        currentList.sort((a, b) => (a.phones.isNotEmpty ? a.phones.first.number : '')
            .compareTo(b.phones.isNotEmpty ? b.phones.first.number : ''));
      } else {
        currentList = allContacts.where((contact) {
          return contact.displayName.toLowerCase().contains(query);
        }).toList();
        currentList.sort((a, b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));
      }
    }

    filteredContacts.assignAll(currentList);

    final startIndex = currentPage * batchSize;
    final endIndex = startIndex + batchSize;

    if (startIndex >= currentList.length) {
      hasMoreContacts.value = false;
      isLoadingMore.value = false;
      return;
    }

    final batch = currentList.sublist(startIndex, endIndex > currentList.length ? currentList.length : endIndex);
    contacts.addAll(batch);
    currentPage++;
    hasMoreContacts.value = endIndex < currentList.length;
    isLoadingMore.value = false;
  }

  // Selection helpers
  bool isSelected(String id) => selectedContactIds.contains(id);

  void toggleSelectionById(String id, bool value) {
    if (value) {
      selectedContactIds.add(id);
    } else {
      selectedContactIds.remove(id);
    }
    selectedContactIds.refresh();
  }

  void importSelectedContacts() {
    final selected = <Map<String, dynamic>>[];

    for (final contact in allContacts) {
      if (selectedContactIds.contains(contact.id)) {
        selected.add({
          'name': contact.displayName,
          'phone': contact.phones.isNotEmpty ? contact.phones.first.number : '',
          'email': contact.emails.isNotEmpty ? contact.emails.first.address : '',
          'createdAt': DateTime.now().toIso8601String(),
          'contactCount': 1,
        });
      }
    }

    Get.back(result: selected);
  }

  void clearImportedContacts() {
    importedContacts.clear();
    selectedContactIds.clear();
  }
}