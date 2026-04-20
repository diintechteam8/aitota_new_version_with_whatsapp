// core/services/role_provider.dart
import 'package:get/get.dart';
import 'app_config.dart';

enum UserRole {
  client,
  executive,
  admin,
  unknown,
  manager,
  teamlead
}

class RoleProvider extends GetxService {
  final Rx<UserRole> _role = UserRole.unknown.obs;

  UserRole get role => _role.value;
  bool get isExecutive => _role.value == UserRole.executive;

  // REMOVED: isMyAssignVisible → no longer needed

  void setRole(String? rawRole) {
    final newRole = switch (rawRole?.toLowerCase()) {
      'client' => UserRole.client,
      'executive' => UserRole.executive,
      'admin' => UserRole.admin,
      'manager' => UserRole.manager,
      'teamlead' => UserRole.teamlead,
      _ => UserRole.unknown,
    };

    if (_role.value != newRole) {
      _role.value = newRole;
      if (Get.isRegistered<AppConfig>()) {
        Get.find<AppConfig>().onRoleUpdated(newRole);
      }
    }
  }
}

// Optional: Keep this extension if used elsewhere
extension _OneOf on UserRole {
  bool isOneOf(List<UserRole> roles) => roles.contains(this);
}