import '../../../../../../core/app-export.dart';
import '../../../../../../core/services/api_services.dart';
import '../../../../../../core/services/dio_client.dart';
import '../../../../../../core/services/role_provider.dart';
import '../../../../../more_flow/more_screen/controller/more_controller.dart';

class DirectGroupController extends GetxController {
  var groups = <Map<String, dynamic>>[].obs;

  final ApiService apiService = ApiService(dio: DioClient().dio);
  final RxBool isLoading = false.obs;

  /// 🔥 NEW → For first-time loading only
  final RxBool isInitialLoading = true.obs;

  MoreController? moreController;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    fetchAllGroups();
  }

  void _initializeDependencies() {
    try {
      moreController = Get.find<MoreController>();
      Get.find<RoleProvider>();
    } catch (e) {
      debugPrint('Dependency init error: $e');
    }
  }

  /// -----------------------------------------------------------------
  /// Fetch groups using the endpoint
  /// GET /teams/groups?owner=assign
  /// -----------------------------------------------------------------
  Future<void> fetchAllGroups() async {
    if (isLoading.value) return; // avoid parallel API calls

    try {
      if (groups.isEmpty) {
        isInitialLoading.value = true; // Only shows loader on FIRST load
      }

      isLoading.value = true;
      groups.clear();

      final response = await apiService.getAllTeamsGroups(owner: 'assign');

      if (response.success == true && response.data != null) {
        final mapped = response.data!
            .map((group) => {
                  '_id': group.sId,
                  'name': group.name ?? '',
                  'category': group.category ?? '',
                  'description': group.description ?? '',
                  'createdAt': group.createdAt,
                  'contactCount': group.contactsCount ?? 0,
                  // ADD THESE TWO LINES
                   'touchedCount': group.touchedCount ?? 0,
                  'untouchedCount': group.untouchedCount ?? 0,
                })
            .toList();

        _sortGroupsByLatest(mapped);

        groups.assignAll(mapped);
      } else {
        groups.clear();
      }
    } catch (e, s) {
      debugPrint('fetchAllGroups error: $e\n$s');
      groups.clear();
    } finally {
      isLoading.value = false;
      isInitialLoading.value = false;
    }
  }

  void _sortGroupsByLatest(List<Map<String, dynamic>> list) {
    list.sort((a, b) {
      try {
        final DateTime dateA = _safeParse(a['createdAt'] as String?);
        final DateTime dateB = _safeParse(b['createdAt'] as String?);
        return dateB.compareTo(dateA);
      } catch (e) {
        return 0;
      }
    });
  }

  DateTime _safeParse(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return DateTime(1970);
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return DateTime(1970);
    }
  }
}
