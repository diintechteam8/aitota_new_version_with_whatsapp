import '../app-export.dart';
import 'role_provider.dart';
import 'api_endpoints_contract.dart';
import 'endpoints_client.dart';
import 'endpoints_executive.dart';

class AppConfig extends GetxService {
  static AppConfig get instance => Get.find<AppConfig>();

  final RoleProvider roleProvider;

  AppConfig(this.roleProvider) {
    // Initial fallback
    _setEndpointsForRole(roleProvider.role);
  }

  final Rx<ApiEndpointsContract> _endpoints =
      Rx<ApiEndpointsContract>(ApiEndpointsExecutive());

  ApiEndpointsContract get endpoints => _endpoints.value;
  String get baseUrl => endpoints.baseUrl;
  String get newBaseUrl => endpoints.newBaseUrl;
  // String get baseUrl1 => endpoints.baseUrl1;

  void onRoleUpdated(UserRole role) {
    _setEndpointsForRole(role);
    debugPrint('[AppConfig] Role → $role | baseUrl → ${endpoints.baseUrl}');
  }

  // void _setEndpointsForRole(UserRole role) {
  //   _endpoints.value = switch (role) {
  //     UserRole.executive => ApiEndpointsExecutive(),
  //     UserRole.client => ApiEndpointsClient(),
  //     UserRole.admin => ApiEndpointsClient(),        // Admin uses same endpoints as Client
  //     UserRole.manager => ApiEndpointsExecutive(),   // Example: manager = executive-like
  //     UserRole.teamlead => ApiEndpointsExecutive(),  // teamlead = executive-like
  //     UserRole.unknown => ApiEndpointsExecutive(),   // fallback
  //     // Add more roles above as needed
  //   };
  // }

  void _setEndpointsForRole(UserRole role) {
    _endpoints.value = switch (role) {
      UserRole.client || UserRole.admin => ApiEndpointsClient(),
      _ =>
        ApiEndpointsExecutive(), // Covers: executive, manager, teamlead, unknown, etc.
    };
  }
}
