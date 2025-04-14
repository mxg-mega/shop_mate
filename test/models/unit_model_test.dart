import 'package:flutter_test/flutter_test.dart';
import 'package:shop_mate/data/models/unit_system/units_model.dart';

void main() {
  group('Unit Model Tests', () {
    test('Unit Initialization', () {
      final unit = Unit(name: 'kg', symbol: 'kg', conversionRate: 1);
      expect(unit.name, 'kg');
      expect(unit.symbol, 'kg');
      expect(unit.conversionRate, 1);
    });

    test('Unit CSV Serialization', () {
      final unit = Unit(name: 'kg', symbol: 'kg', conversionRate: 1);
      final csv = unit.toCSV();
      expect(csv, 'kg,kg,1.0');
    });

    test('Unit CSV Deserialization', () {
      final csv = 'kg,kg,1.0';
      final unit = Unit.fromCSV(csv);
      expect(unit.name, 'kg');
      expect(unit.symbol, 'kg');
      expect(unit.conversionRate, 1);
    });

    test('Unit JSON Serialization', () {
      final unit = Unit(name: 'kg', symbol: 'kg', conversionRate: 1);
      final json = unit.toJson();
      expect(json['name'], 'kg');
      expect(json['symbol'], 'kg');
      expect(json['conversionRate'], 1);
    });

    test('Unit JSON Deserialization', () {
      final json = {'name': 'kg', 'symbol': 'kg', 'conversionRate': 1};
      final unit = Unit.fromJson(json);
      expect(unit.name, 'kg');
      expect(unit.symbol, 'kg');
      expect(unit.conversionRate, 1);
    });
  });
}
