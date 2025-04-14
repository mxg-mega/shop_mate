import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shop_mate/data/models/base_model.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';
import 'package:bcrypt/bcrypt.dart';
part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel extends BaseModel {
  String email;
  String password;
  String? phoneNumber;
  String? profilePicture;
  UserRole role;
  String? businessID;
  final bool isActive;

  UserModel({
    required super.id,
    required super.name,
    required this.email,
    required this.password,
    required this.role,
    required this.businessID,
    required this.phoneNumber,
    this.profilePicture,
    super.createdAt,
    super.updatedAt,
    this.isActive = true,
  }) : assert(role != UserRole.customer || businessID == null,
            'Customers cannot have a businessID') {
    _validateFields();
  }

  /// Hashes the password using bcrypt.
  static String hashPassword(String plainPassword) {
    return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
  }

  /// Verifies the password against the hashed password.
  static bool verifyPassword(String plainPassword, String hashedPassword) {
    return BCrypt.checkpw(plainPassword, hashedPassword);
  }

  /// Validates the fields for logical correctness
  void _validateFields() {
    if (password != null && password!.isEmpty) {
      throw ArgumentError('Password cannot be empty if provided.');
    }
    if (phoneNumber != null && phoneNumber!.isEmpty) {
      throw ArgumentError('Phone number cannot be empty if provided.');
    }
    if (role == UserRole.customer && businessID != null) {
      throw ArgumentError('Customers cannot have a businessID.');
    }
  }

  // Change factory to use generated code
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // Change toJson to use generated code
  @override
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // factory UserModel.fromJson(Map<String, dynamic> json) {
  //   return UserModel(
  //     id: json['id'] as String,
  //     name: json['name'] as String,
  //     email: json['email'] as String,
  //     password: json['password'] as String,
  //     role: UserRole.values.firstWhere(
  //       (r) => r.name == json['role'] as String,
  //       orElse: () => UserRole.admin,
  //     ),
  //     phoneNumber: json['phoneNumber'] as String?,
  //     isActive: json['isActive'] as bool? ?? false,
  //     createdAt: DateTime.parse(json['createdAt'] as String),
  //     updatedAt: DateTime.parse(json['updatedAt'] as String),
  //     businessID: json['businessID'] as String?,
  //     profilePicture: json['profilePicture'] as String?,
  //   );
  // }

  // @override
  // Map<String, dynamic> toJson() {
  //   return super.toJson()
  //     ..addAll({
  //       'email': email,
  //       'password': password,
  //       'phoneNumber': phoneNumber,
  //       'role': role.name,
  //       'businessID': businessID,
  //       'profilePicture': profilePicture,
  //       'isActive': isActive,
  //     });
  // }

  // @override
  // String toCSV() {
  //   return '${super.toCSV()} , $email , $phoneNumber, $password , $profilePicture , ${role.name}, '
  //       '$businessID , $isActive';
  // }

  // @override
  // factory UserModel.fromCSV(String csv) {
  //   final parts = csv.split(',').map((part) => part.trim()).toList();
  //   BaseModel.validateCSVParts(parts, 11);

  //   return UserModel(
  //     id: parts[0],
  //     name: parts[1],
  //     email: parts[2],
  //     password: parts[3],
  //     role: UserRole.values.firstWhere(
  //       (r) => r.name == parts[4],
  //       orElse: () => UserRole.admin,
  //     ),
  //     phoneNumber: parts[5],
  //     isActive: parts[6] == 'true',
  //     createdAt: DateTime.tryParse(parts[7]),
  //     updatedAt: DateTime.tryParse(parts[8]),
  //     businessID: parts[9],
  //     profilePicture: parts[10],
  //   );
  // }

  /// Creates a new instance with updated fields while retaining unchanged ones.
  @override
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? phoneNumber,
    String? profilePicture,
    UserRole? role,
    String? businessID,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? updates,
  }) {
    // Handle enum conversion from string if needed
    final roleFromMap = updates?['role'] is String
        ? UserRole.values.firstWhere(
            (e) => e.name == updates!['role'],
            orElse: () => this.role,
          )
        : updates?['role'];

    return UserModel(
      id: updates?['id'] ?? id ?? this.id,
      name: updates?['name'] ?? name ?? this.name,
      email: updates?['email'] ?? email ?? this.email,
      password: updates?['password'] ?? password ?? this.password,
      role: roleFromMap ?? role ?? this.role,
      businessID: updates?['businessID'] ?? businessID ?? this.businessID,
      phoneNumber: updates?['phoneNumber'] ?? phoneNumber ?? this.phoneNumber,
      profilePicture:
          updates?['profilePicture'] ?? profilePicture ?? this.profilePicture,
      isActive: updates?['isActive'] ?? isActive ?? this.isActive,
      createdAt: updates?['createdAt'] != null
          ? DateTime.tryParse(updates?['createdAt'] as String)
          : createdAt ?? this.createdAt,
      updatedAt: updates?['updatedAt'] != null
          ? DateTime.tryParse(updates?['updatedAt'] as String)
          : updatedAt ?? this.updatedAt,
    );
  }

  /// Creates a copy of this user with updates from a map
  UserModel copyWithMap(Map<String, dynamic> updates) {
    return copyWith(updates: updates);
  }
}
