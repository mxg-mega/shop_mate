import 'package:shop_mate/models/base_model.dart';
import 'package:shop_mate/models/users/roles_enum.dart';

class UserModel extends BaseModel {
  final String email;
  final String? password;
  final String? phoneNumber;
  final String? profilePicture;
  final RoleTypes role;
  late final String? businessID;
  final bool isActive;

  UserModel({
    required super.id,
    required super.name,
    required this.email,
    required this.password,
    required this.role,
    this.businessID,
    required this.phoneNumber,
    this.profilePicture,
    super.createdAt,
    super.updatedAt,
    this.isActive = true,
  }) : assert(role != RoleTypes.customer || businessID == null,
            'Customers cannot have a businessID') {
    _validateFields();
  }

  /// Validates the fields for logical correctness
  void _validateFields() {
    if (password != null && password!.isEmpty) {
      throw ArgumentError('Password cannot be empty if provided.');
    }
    if (phoneNumber != null && phoneNumber!.isEmpty) {
      throw ArgumentError('Phone number cannot be empty if provided.');
    }
    if (role == RoleTypes.customer && businessID != null) {
      throw ArgumentError('Customers cannot have a businessID.');
    }
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: RoleTypes.values.firstWhere(
        (r) => r.name == json['role'] as String,
        orElse: () => RoleTypes.customer,
      ),
      phoneNumber: json['phoneNumber'] as String?,
      isActive: json['isActive'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      businessID: json['businessID'] as String?,
      profilePicture: json['profilePicture'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
        'role': role.name,
        'businessID': businessID,
        'profilePicture': profilePicture,
        'isActive': isActive,
      });
  }

  @override
  String toCSV() {
    return '${super.toCSV()} , $email , $phoneNumber, $password , $profilePicture , ${role.name}, '
           '$businessID , $isActive';
  }
}
