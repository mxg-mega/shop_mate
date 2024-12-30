import 'package:shop_mate/models/base_model.dart';
import 'package:shop_mate/models/users/constants_enums.dart';

class Employee extends BaseModel {
  final RoleTypes role;
  final String businessId;
  final String password;

  Employee({
    required this.role,
    required this.businessId,
    required this.password,
    required super.name,
    required super.id,
  });

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'role': role.name,
        'password': password,
        'businessId': businessId,
      });
  }

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String,
      name: json['name'] as String,
      password: json['password'] as String,
      role: RoleTypes.values.firstWhere(
        (r) => r.name == json['role'] as String,
        orElse: () => RoleTypes.staff,
      ),
      businessId: json['businessId'] as String,
    );
  }
}
