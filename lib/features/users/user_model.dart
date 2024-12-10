import 'package:shop_mate/features/users/roles_enum.dart';

class User {
  final int id;
  final String name;
  final RoleTypes role;

  const User({
    required this.id,
    required this.name,
    required this.role,
  });
}
