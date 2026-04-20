import 'dart:io';
import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/contact/group/controller/contact_group_controller.dart';
import '../../../../../../../core/services/api_services.dart';
import '../../../../../../../core/services/role_provider.dart';
import '../../../../../../../data/team_models/outbound/users/group_contacts_model.dart';
import '../../../../../../../core/services/dio_client.dart';
import '../../../open_phonebook/controller/open_phonebook_controller.dart';
import '../../../open_phonebook/open_phonebook_screen.dart';
import 'package:csv/csv.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

class OutboundGroupDetailController extends GetxController {
  var group = <String, dynamic>{}.obs;
  var contacts = <Map<String, dynamic>>[].obs;
  var filteredContacts = <Map<String, dynamic>>[].obs;
  final RxString groupId = ''.obs;
  final ApiService apiService = ApiService(dio: DioClient().dio);
  final RxBool isLoading = false.obs;
  final showDeleteIcon = <String, bool>{}.obs;
  final RxBool isSearchActive = false.obs;
  final TextEditingController searchController = TextEditingController();
  final Uuid _uuid = const Uuid();

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      group.value = Map<String, dynamic>.from(arguments);
      groupId.value = arguments['_id']?.toString() ?? '';
      if (groupId.value.isNotEmpty) {
        fetchGroupContacts(groupId.value);
      }
    }
    searchController.addListener(() {
      searchContacts(searchController.text);
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void toggleSearch() {
    isSearchActive.value = !isSearchActive.value;
    if (!isSearchActive.value) {
      searchController.clear();
      searchContacts('');
    }
  }

  void searchContacts(String query) {
    final lowerQuery = query.toLowerCase().trim();

    if (lowerQuery.isEmpty) {
      filteredContacts.assignAll(contacts);
      isSearchActive.value = false;
    } else {
      isSearchActive.value = true;
      final filtered = contacts.where((contact) {
        final name = (contact['name']?.toString() ?? '').toLowerCase();
        final phone = (contact['phone']?.toString() ?? '').toLowerCase();
        return name.contains(lowerQuery) || phone.contains(lowerQuery);
      }).toList();
      filteredContacts.assignAll(filtered);
    }
  }

  Future<void> fetchGroupContacts(String groupId) async {
    if (groupId.isEmpty) return;

    try {
      isLoading.value = true;

      final role = Get.find<RoleProvider>().role;

      List<Map<String, dynamic>> fetchedContacts = [];

      if (role == UserRole.executive) {
        // final GetTeamGroupContactsModel teamResp =
        //     await apiService.getTeamGroupContacts(groupId);
        // if (teamResp.success == true && teamResp.data != null) {
        //   fetchedContacts = teamResp.data!.map((contact) {
        //     return {
        //       'id': contact.sId ?? '',
        //       'name': contact.name?.trim().isNotEmpty == true
        //           ? contact.name
        //           : 'Unnamed Contact',
        //       'phone': contact.phone?.trim() ?? 'N/A',
        //       'email': contact.email?.trim() ?? 'N/A',
        //       'color': Colors.blue,
        //     };
        //   }).toList();
        // }
      } else {
        final response = await apiService.getCampaignContactsByGroupId(groupId);
        if (response.success == true && response.data?.contacts != null) {
          fetchedContacts = response.data!.contacts!.map((contact) {
            return {
              'id': contact.sId ?? '',
              'name': contact.name?.trim().isNotEmpty == true
                  ? contact.name
                  : 'Unnamed Contact',
              'phone': contact.phone?.trim() ?? 'N/A',
              'email': contact.email?.trim() ?? 'N/A',
              'color': Colors.blue,
            };
          }).toList();
        }
      }

      // Update contacts
      contacts.assignAll(fetchedContacts);

      // Reset UI state
      showDeleteIcon.clear();
      for (var contact in contacts) {
        final id = contact['id']?.toString() ?? '';
        if (id.isNotEmpty) {
          showDeleteIcon[id] = false;
        }
      }

      // Sync filtered list
      searchContacts(searchController.text);

      // Update group count
      group['contactCount'] = contacts.length;
      group.refresh();
    } catch (e) {
      debugPrint('fetchGroupContacts error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleDeleteIcon(String contactId) {
    if (contactId.isEmpty) return;
    showDeleteIcon[contactId] = !(showDeleteIcon[contactId] ?? false);
    showDeleteIcon.refresh();
  }

  Future<void> addContact(String name, String phone, String email) async {
    if (groupId.value.isEmpty) return;

    try {
      isLoading.value = true;

      String normalizedPhone = phone.trim().replaceAll(RegExp(r"\s+"), "");
      if (normalizedPhone.startsWith("+91")) {
        normalizedPhone = normalizedPhone.substring(3);
      }

      String normalizedName = name.trim();
      if (RegExp(r'^[0-9+]+$').hasMatch(normalizedName)) {
        normalizedName = "Unnamed";
      }

      if (contacts.any((c) => c['phone']?.toString() == normalizedPhone)) {
        debugPrint('Contact already exists: $normalizedPhone');
        return;
      }

      final request = {
        'name': normalizedName,
        'phone': normalizedPhone,
        'email': email.trim(),
      };

      final response =
          await apiService.addContactInGroup(request, groupId.value);

      if (response.success == true && response.data != null) {
        await fetchGroupContacts(groupId.value); // Full refresh
        Get.find<ContactGroupController>().fetchAllGroups();
      }
    } catch (e) {
      debugPrint('addContact error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteContact(String contactId) async {
    if (groupId.value.isEmpty || contactId.isEmpty) return;

    try {
      isLoading.value = true;

      final response =
          await apiService.deleteContactInGroup(groupId.value, contactId);

      if (response.success == true) {
        contacts.removeWhere((c) => c['id'] == contactId);
        filteredContacts.removeWhere((c) => c['id'] == contactId);
        showDeleteIcon.remove(contactId);
        group['contactCount'] = contacts.length;
        group.refresh();
        Get.find<ContactGroupController>().fetchAllGroups();
      }
    } catch (e) {
      debugPrint('deleteContact error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openPhonebook() async {
    try {
      Get.put(OpenPhoneBookController());
      final selected = await Get.to(() => OpenPhonebookScreen());
      if (selected != null && selected is List<Map<String, dynamic>>) {
        int addedCount = 0;
        for (var contact in selected) {
          final phone = contact['phone']?.toString().trim() ?? '';
          if (phone.isNotEmpty && !contacts.any((c) => c['phone'] == phone)) {
            await addContact(
              contact['name']?.toString() ?? 'Unnamed',
              phone,
              contact['email']?.toString() ?? '',
            );
            addedCount++;
          }
        }
        if (addedCount > 0) {
          await fetchGroupContacts(groupId.value);
        }
      }
    } catch (e) {
      debugPrint('openPhonebook error: $e');
    }
  }

  Future<void> addFromFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      if (result == null || result.files.isEmpty) return;

      final file = File(result.files.first.path!);
      final csvString = await file.readAsString();
      final csvList = const CsvToListConverter().convert(csvString);

      if (csvList.isEmpty) return;

      int addedCount = 0;
      for (var row in csvList.skip(1)) {
        if (row.length >= 2) {
          final phone = row[1].toString().trim();
          if (phone.isNotEmpty && !contacts.any((c) => c['phone'] == phone)) {
            await addContact(
              row[0].toString(),
              phone,
              row.length > 2 ? row[2].toString() : '',
            );
            addedCount++;
          }
        }
      }
      if (addedCount > 0) {
        await fetchGroupContacts(groupId.value);
      }
    } catch (e) {
      debugPrint('addFromFile error: $e');
    }
  }
}
