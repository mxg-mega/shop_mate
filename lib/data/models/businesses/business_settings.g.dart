// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessSettings _$BusinessSettingsFromJson(Map<String, dynamic> json) =>
    BusinessSettings(
      businessId: json['businessId'] as String,
      currency: json['currency'] as String,
      timezone: json['timezone'] as String,
      defaultUnitSystem: json['defaultUnitSystem'] == null
          ? null
          : UnitSystem.fromJson(
              json['defaultUnitSystem'] as Map<String, dynamic>),
      additionalUnitSystems: (json['additionalUnitSystems'] as List<dynamic>?)
          ?.map((e) => UnitSystem.fromJson(e as Map<String, dynamic>))
          .toList(),
      unitSystem: json['unitSystem'] == null
          ? null
          : UnitSystem.fromJson(json['unitSystem'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BusinessSettingsToJson(BusinessSettings instance) =>
    <String, dynamic>{
      'businessId': instance.businessId,
      'currency': instance.currency,
      'timezone': instance.timezone,
      'defaultUnitSystem': instance.defaultUnitSystem.toJson(),
      'additionalUnitSystems':
          instance.additionalUnitSystems.map((e) => e.toJson()).toList(),
      'unitSystem': instance.unitSystem.toJson(),
    };
