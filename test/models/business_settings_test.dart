import 'package:flutter_test/flutter_test.dart';
import 'package:shop_mate/models/businesses/business_settings.dart';
import 'package:shop_mate/models/unit_system/unit_sytem.dart';

void main() {
  group('BusinessSettings Model Tests', () {
    test('BusinessSettings Initialization', () {
      final businessSettings = BusinessSettings(
        businessId: 'business1',
        currency: 'USD',
        timezone: 'UTC',
        defaultUnitSystem: UnitSystem.defaultSystem(),
        additionalUnitSystems: [],
        unitSystem: UnitSystem.defaultSystem(),
      );

      expect(businessSettings.businessId, 'business1');
      expect(businessSettings.currency, 'USD');
      expect(businessSettings.timezone, 'UTC');
      expect(businessSettings.defaultUnitSystem, isNotNull);
      expect(businessSettings.additionalUnitSystems.length, 0);
      expect(businessSettings.unitSystem, isNotNull);
    });

    test('BusinessSettings Default Settings', () {
      final businessSettings = BusinessSettings.defaultSettings('business1');
      expect(businessSettings.businessId, 'business1');
      expect(businessSettings.currency, 'USD');
      expect(businessSettings.timezone, 'UTC');
      expect(businessSettings.defaultUnitSystem, isNotNull);
      expect(businessSettings.additionalUnitSystems.length, 0);
      expect(businessSettings.unitSystem, isNotNull);
    });

    test('BusinessSettings JSON Serialization', () {
      final businessSettings = BusinessSettings.defaultSettings('business1');
      final json = businessSettings.toJson();
      expect(json['businessId'], 'business1');
      expect(json['currency'], 'USD');
      expect(json['timezone'], 'UTC');
      expect(json['defaultUnitSystem'], isNotNull);
      expect(json['additionalUnitSystems'].length, 0);
      expect(json['unitSystem'], isNotNull);
    });

    test('BusinessSettings JSON Deserialization', () {
      final json = {
        'businessId': 'business1',
        'currency': 'USD',
        'timezone': 'UTC',
        'defaultUnitSystem': UnitSystem.defaultSystem().toJson(),
        'additionalUnitSystems': [],
        'unitSystem': UnitSystem.defaultSystem().toJson(),
      };

      final businessSettings = BusinessSettings.fromJson(json);
      expect(businessSettings.businessId, 'business1');
      expect(businessSettings.currency, 'USD');
      expect(businessSettings.timezone, 'UTC');
      expect(businessSettings.defaultUnitSystem, isNotNull);
      expect(businessSettings.additionalUnitSystems.length, 0);
      expect(businessSettings.unitSystem, isNotNull);
    });
  });
}
