// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      businessID: json['businessID'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      profilePicture: json['profilePicture'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'email': instance.email,
      'password': instance.password,
      'phoneNumber': instance.phoneNumber,
      'profilePicture': instance.profilePicture,
      'role': _$UserRoleEnumMap[instance.role]!,
      'businessID': instance.businessID,
      'isActive': instance.isActive,
    };

const _$UserRoleEnumMap = {
  UserRole.none: 'none',
  UserRole.admin: 'admin',
  UserRole.staff: 'staff',
  UserRole.manager: 'manager',
  UserRole.employee: 'employee',
  UserRole.accountant: 'accountant',
  UserRole.customer: 'customer',
};
