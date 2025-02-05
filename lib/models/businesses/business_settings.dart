import 'package:shop_mate/models/unit_system/unit_sytem.dart';

class BusinessSettings {
  final String businessId;
  final String currency;
  final String timezone;
  final UnitSystem defaultUnitSystem;
  final List<UnitSystem> additionalUnitSystems;
  final UnitSystem unitSystem;

  BusinessSettings({
    required this.businessId,
    required this.currency,
    required this.timezone,
    UnitSystem? defaultUnitSystem,
    List<UnitSystem>? additionalUnitSystems,
    UnitSystem? unitSystem,
  })  : defaultUnitSystem = defaultUnitSystem ?? UnitSystem.defaultSystem(),
        additionalUnitSystems = additionalUnitSystems ?? [],
        unitSystem = unitSystem ?? UnitSystem.defaultSystem();

  factory BusinessSettings.defaultSettings(String businessId) {
    return BusinessSettings(
      businessId: businessId,
      currency: 'NGN',
      timezone: 'UTC',
      defaultUnitSystem: UnitSystem.defaultSystem(),
      additionalUnitSystems: [],
      unitSystem: UnitSystem.defaultSystem(),
    );
  }

  factory BusinessSettings.fromJson(Map<String, dynamic> json) {
    return BusinessSettings(
      businessId: json['businessId'] as String,
      currency: json['currency'] as String,
      timezone: json['timezone'] as String,
      defaultUnitSystem: UnitSystem.fromJson(
          json['defaultUnitSystem'] as Map<String, dynamic>),
      additionalUnitSystems: (json['additionalUnitSystems'] as List<dynamic>)
          .map((system) => UnitSystem.fromJson(system as Map<String, dynamic>))
          .toList(),
      unitSystem: UnitSystem.fromJson(json['unitSystem']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessId': businessId,
      'currency': currency,
      'timezone': timezone,
      'defaultUnitSystem': defaultUnitSystem.toJson(),
      'additionalUnitSystems':
          additionalUnitSystems.map((system) => system.toJson()).toList(),
      'unitSystem': unitSystem.toJson(),
    };
  }

  BusinessSettings copyWith({
    String? businessId,
    String? currency,
    String? timezone,
    UnitSystem? defaultUnitSystem,
    List<UnitSystem>? additionalUnitSystems,
    UnitSystem? unitSystem,
  }) {
    return BusinessSettings(
      businessId: businessId ?? this.businessId,
      currency: currency ?? this.currency,
      timezone: timezone ?? this.timezone,
      defaultUnitSystem: defaultUnitSystem ?? this.defaultUnitSystem,
      additionalUnitSystems: additionalUnitSystems ?? this.additionalUnitSystems,
      unitSystem: unitSystem ?? this.unitSystem,
    );
  }

}
