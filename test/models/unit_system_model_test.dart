import 'package:flutter_test/flutter_test.dart';
import 'package:shop_mate/data/models/unit_system/unit_sytem.dart';
import 'package:shop_mate/data/models/unit_system/units_model.dart';
import 'package:shop_mate/data/models/unit_system/unit_conversion.dart';

void main() {
  group('UnitSystem Model Tests', () {
    test('UnitSystem Initialization', () {
      final unitSystem = UnitSystem(
        name: 'Test System',
        units: {
          'unit': Unit(name: 'unit', symbol: 'unit', conversionRate: 1),
        },
        conversions: {
          'unit-box': UnitConversion(
            fromUnit: Unit(name: 'unit', symbol: 'unit', conversionRate: 1),
            toUnit: Unit(name: 'box', symbol: 'box', conversionRate: 10),
            conversionRate: 10,
          ),
        },
      );

      expect(unitSystem.name, 'Test System');
      expect(unitSystem.units.length, 1);
      expect(unitSystem.conversions.length, 1);
    });

    test('UnitSystem Default System', () {
      final unitSystem = UnitSystem.defaultSystem();
      expect(unitSystem.name, 'Default Unit System');
      expect(unitSystem.units.length, 5);
      expect(unitSystem.conversions.length, 3);
    });

    test('UnitSystem Add or Update Unit', () {
      final unitSystem = UnitSystem.defaultSystem();
      final newUnit = Unit(name: 'newUnit', symbol: 'newUnit', conversionRate: 1);
      unitSystem.addOrUpdateUnit(newUnit);
      expect(unitSystem.units['newUnit'], newUnit);
    });

    test('UnitSystem Add or Update Conversion', () {
      final unitSystem = UnitSystem.defaultSystem();
      final newConversion = UnitConversion(
        fromUnit: Unit(name: 'unit', symbol: 'unit', conversionRate: 1),
        toUnit: Unit(name: 'newUnit', symbol: 'newUnit', conversionRate: 1),
        conversionRate: 1,
      );
      unitSystem.addOrUpdateConversion(newConversion);
      expect(unitSystem.conversions['unit-newUnit'], newConversion);
    });

    test('UnitSystem Get Conversion', () {
      final unitSystem = UnitSystem.defaultSystem();
      final conversion = unitSystem.getConversion('kg', 'g');
      expect(conversion, isNotNull);
      expect(conversion!.conversionRate, 1000);
    });

    test('UnitSystem JSON Serialization', () {
      final unitSystem = UnitSystem.defaultSystem();
      final json = unitSystem.toJson();
      expect(json['name'], 'Default Unit System');
      expect(json['units'].length, 5);
      expect(json['conversions'].length, 3);
    });

    test('UnitSystem JSON Deserialization', () {
      final json = {
        'name': 'Test System',
        'units': {
          'unit': {'name': 'unit', 'symbol': 'unit', 'conversionRate': 1},
        },
        'conversions': {
          'unit-box': {
            'fromUnit': {'name': 'unit', 'symbol': 'unit', 'conversionRate': 1},
            'toUnit': {'name': 'box', 'symbol': 'box', 'conversionRate': 10},
            'conversionRate': 10,
          },
        },
      };

      final unitSystem = UnitSystem.fromJson(json);
      expect(unitSystem.name, 'Test System');
      expect(unitSystem.units.length, 1);
      expect(unitSystem.conversions.length, 1);
    });
  });
}
