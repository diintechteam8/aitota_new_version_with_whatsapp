import 'package:aitota_business/core/app-export.dart';
import '../../../../../../../core/services/api_services.dart';
import '../../../../../../../core/services/role_provider.dart';
import '../../../../../../../core/services/dio_client.dart';
import '../../../../../../../data/team_models/outbound/users/group_contacts_model.dart';

class MyAssignGroupDetailController extends GetxController {
  var group = <String, dynamic>{}.obs;
  final RxString groupId = ''.obs;

  // All contacts
  var allTouchedContacts = <Contact>[].obs;
  var allUntouchedContacts = <Contact>[].obs;

  // Filtered lists
  var filteredTouched = <Contact>[].obs;
  var filteredUntouched = <Contact>[].obs;

  // New: Touched Breakdown Counts
  var touchedBreakdown = <String, int>{
    'hotLeads': 0,
    'warmLeads': 0,
    'followUp': 0,
    'convertedWon': 0,
  }.obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;
  final int limit = 10;

  final ApiService apiService = ApiService(dio: DioClient().dio);
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isSearchActive = false.obs;
  final TextEditingController searchController = TextEditingController();

  final RxInt selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      group.value = Map<String, dynamic>.from(arguments);
      groupId.value = arguments['_id']?.toString() ?? '';
      if (groupId.value.isNotEmpty) {
        fetchGroupContacts(reset: true);
      }
    }

    searchController.addListener(() {
      performSearch(searchController.text);
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
      performSearch('');
    }
  }

  void performSearch(String query) {
    final lowerQuery = query.toLowerCase().trim();

    if (lowerQuery.isEmpty) {
      filteredTouched.assignAll(allTouchedContacts);
      filteredUntouched.assignAll(allUntouchedContacts);
    } else {
      filteredTouched.assignAll(allTouchedContacts.where((c) {
        final name = (c.name ?? '').toLowerCase();
        final phone = (c.phone ?? '').toLowerCase();
        return name.contains(lowerQuery) || phone.contains(lowerQuery);
      }).toList());

      filteredUntouched.assignAll(allUntouchedContacts.where((c) {
        final name = (c.name ?? '').toLowerCase();
        final phone = (c.phone ?? '').toLowerCase();
        return name.contains(lowerQuery) || phone.contains(lowerQuery);
      }).toList());
    }
  }

  Future<void> fetchGroupContacts({bool reset = false}) async {
    if (groupId.value.isEmpty) return;

    if (reset) {
      currentPage.value = 1;
      hasMore.value = true;
      allTouchedContacts.clear();
      allUntouchedContacts.clear();
      filteredTouched.clear();
      filteredUntouched.clear();
    }

    if (!hasMore.value || isLoading.value || isLoadingMore.value) return;

    try {
      isLoading.value = reset;
      isLoadingMore.value = !reset;

      final role = Get.find<RoleProvider>().role;
      GetTeamGroupContactsModel? response;

      if (role == UserRole.executive) {
        response =await apiService.getTeamGroupContacts(
          groupId.value,
          page: currentPage.value,
          limit: limit,
        );
      } else {
        return;
      }

      if (response?.success == true && response?.data != null) {
        final data = response!.data!;
        final contacts = data.contacts ?? [];

        final touched = contacts.where((c) => c.dispositionStatus == 'disposed').toList();
        final untouched = contacts.where((c) => c.dispositionStatus != 'disposed').toList();

        if (reset) {
          allTouchedContacts.assignAll(touched);
          allUntouchedContacts.assignAll(untouched);
        } else {
          allTouchedContacts.addAll(touched);
          allUntouchedContacts.addAll(untouched);
        }

        // Update touchedBreakdown from API
        if (data.touchedBreakdown != null) {
          touchedBreakdown.value = {
            'hotLeads': data.touchedBreakdown!.hotLeads ?? 0,
            'warmLeads': data.touchedBreakdown!.warmLeads ?? 0,
            'followUp': data.touchedBreakdown!.followUp ?? 0,
            'convertedWon': data.touchedBreakdown!.convertedWon ?? 0,
          };
        }

        _formatAllPhoneNumbers();
        performSearch(searchController.text);

        // Update group counts
        group['touchedCount'] = data.touchedCount ?? allTouchedContacts.length;
        group['untouchedCount'] = data.untouchedCount ?? allUntouchedContacts.length;
        group.refresh();

        hasMore.value = (data.pagination?.totalPages ?? 1) > currentPage.value;
        if (hasMore.value) currentPage.value++;
      }
    } catch (e, s) {
      debugPrint('fetchGroupContacts error: $e\n$s');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void _formatAllPhoneNumbers() {
    final format = (Contact c) {
      final raw = c.phone ?? '';
      c.phone = _formatIndianPhoneNumber(raw);
    };
    allTouchedContacts.forEach(format);
    allUntouchedContacts.forEach(format);
    filteredTouched.forEach(format);
    filteredUntouched.forEach(format);
  }

  String _formatIndianPhoneNumber(String phone) {
    if (phone.isEmpty) return 'N/A';
    String digits = phone.replaceAll(RegExp(r'\D'), '');
    if (phone.startsWith('+91')) return phone;
    if (digits.startsWith('91') && digits.length == 12) return '+91${digits.substring(2)}';
    if (digits.length == 10 && '6789'.contains(digits[0])) return '+91$digits';
    if (digits.length == 11 && digits.startsWith('0')) return '+91${digits.substring(1)}';
    if (digits.length == 12 && digits.startsWith('91')) return '+91${digits.substring(2)}';
    return phone;
  }

  List<Contact> get currentList =>
      selectedTabIndex.value == 0 ? filteredUntouched : filteredTouched;

  int get currentCount => currentList.length;
}