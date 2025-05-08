// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Business _$BusinessFromJson(Map<String, dynamic> json) => Business(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String,
      businessType:
          $enumDecode(_$BusinessCategoriesEnumMap, json['businessType']),
      ownerId: json['ownerId'] as String,
      token: json['token'] as String?,
      subscription: json['subscription'] == null
          ? null
          : Subscription.fromJson(json['subscription'] as Map<String, dynamic>),
      businessAbbrev: json['businessAbbrev'] as String?,
      locations: (json['locations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      businessSettings: json['businessSettings'] == null
          ? null
          : BusinessSettings.fromJson(
              json['businessSettings'] as Map<String, dynamic>),
    )
      ..createdAt = json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String)
      ..updatedAt = json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String);

Map<String, dynamic> _$BusinessToJson(Business instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'email': instance.email,
      'address': instance.address,
      'phone': instance.phone,
      'ownerId': instance.ownerId,
      'businessType': _$BusinessCategoriesEnumMap[instance.businessType]!,
      'token': instance.token,
      'subscription': instance.subscription.toJson(),
      'businessAbbrev': instance.businessAbbrev,
      'locations': instance.locations,
      'businessSettings': instance.businessSettings?.toJson(),
    };

const _$BusinessCategoriesEnumMap = {
  BusinessCategories.none: 'none',
  BusinessCategories.retail: 'retail',
  BusinessCategories.pharmacy: 'pharmacy',
  BusinessCategories.provision: 'provision',
  BusinessCategories.electronics: 'electronics',
  BusinessCategories.supplies: 'supplies',
  BusinessCategories.other: 'other',
};
