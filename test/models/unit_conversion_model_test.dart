import 'package:flutter_test/flutter_test.dart';
import 'package:shop_mate/data/models/unit_system/unit_conversion.dart';
import 'package:shop_mate/data/models/unit_system/units_model.dart';

void main() {
  group('UnitConversion Model Tests', () {
    test('UnitConversion Initialization', () {
      final fromUnit = Unit(name: 'kg', symbol: 'kg', conversionRate: 1);
      final toUnit = Unit(name: 'g', symbol: 'g', conversionRate: 1000);
      final conversion = UnitConversion(
        fromUnit: fromUnit,
        toUnit: toUnit,
        conversionRate: 1000,
      );

      expect(conversion.fromUnit.name, 'kg');
      expect(conversion.toUnit.name, 'g');
      expect(conversion.conversionRate, 1000);
    });

    test('UnitConversion CSV Serialization', () {
      final fromUnit = Unit(name: 'kg', symbol: 'kg', conversionRate: 1);
      final toUnit = Unit(name: 'g', symbol: 'g', conversionRate: 1000);
      final conversion = UnitConversion(
        fromUnit: fromUnit,
        toUnit: toUnit,
        conversionRate: 1000,
      );

      final csv = conversion.toCSV();
      expect(csv, 'kg,kg,1.0,g,g,1000.0,1000');
    });

    test('UnitConversion CSV Deserialization', () {
      final csv = 'kg,kg,1.0,g,g,1000.0,1000';
      final conversion = UnitConversion.fromCSV(csv);

      expect(conversion.fromUnit.name, 'kg');
      expect(conversion.toUnit.name, 'g');
      expect(conversion.conversionRate, 1000);
    });

    test('UnitConversion JSON Serialization', () {
      final fromUnit = Unit(name: 'kg', symbol: 'kg', conversionRate: 1);
      final toUnit = Unit(name: 'g', symbol: 'g', conversionRate: 1000);
      final conversion = UnitConversion(
        fromUnit: fromUnit,
        toUnit: toUnit,
        conversionRate: 1000,
      );

      final json = conversion.toJson();
      expect(json['fromUnit']['name'], 'kg');
      expect(json['toUnit']['name'], 'g');
      expect(json['conversionRate'], 1000);
    });

    test('UnitConversion JSON Deserialization', () {
      final json = {
        'fromUnit': {'name': 'kg', 'symbol': 'kg', 'conversionRate': 1},
        'toUnit': {'name': 'g', 'symbol': 'g', 'conversionRate': 1000},
        'conversionRate': 1000,
      };

      final conversion = UnitConversion.fromJson(json);
      expect(conversion.fromUnit.name, 'kg');
      expect(conversion.toUnit.name, 'g');
      expect(conversion.conversionRate, 1000);
    });
  });
}
