import 'package:flutter_test/flutter_test.dart';
import 'package:shop_mate/models/products/product_unit.dart';
import 'package:shop_mate/models/unit_system/units_model.dart';

void main() {
  group('ProductUnit Model Tests', () {
    test('ProductUnit Initialization', () {
      final productUnit = ProductUnit(
        unit: Unit(name: 'unit', symbol: 'unit', conversionRate: 1),
        price: 100.0,
        costPrice: 50.0,
        isBaseUnit: true,
      );

      expect(productUnit.unit.name, 'unit');
      expect(productUnit.price, 100.0);
      expect(productUnit.costPrice, 50.0);
      expect(productUnit.isBaseUnit, true);
    });

    test('ProductUnit CSV Serialization', () {
      final productUnit = ProductUnit(
        unit: Unit(name: 'unit', symbol: 'unit', conversionRate: 1),
        price: 100.0,
        costPrice: 50.0,
        isBaseUnit: true,
      );

      final csv = productUnit.toCSV();
      expect(csv, 'unit,unit,1.0:100.0:50.0:true');
    });

    test('ProductUnit CSV Deserialization', () {
      final csv = 'unit,unit,1.0:100.0:50.0:true';
      final productUnit = ProductUnit.fromCSV(csv);

      expect(productUnit.unit.name, 'unit');
      expect(productUnit.price, 100.0);
      expect(productUnit.costPrice, 50.0);
      expect(productUnit.isBaseUnit, true);
    });

    test('ProductUnit JSON Serialization', () {
      final productUnit = ProductUnit(
        unit: Unit(name: 'unit', symbol: 'unit', conversionRate: 1),
        price: 100.0,
        costPrice: 50.0,
        isBaseUnit: true,
      );

      final json = productUnit.toJson();
      expect(json['unit']['name'], 'unit');
      expect(json['price'], 100.0);
      expect(json['costPrice'], 50.0);
      expect(json['isBaseUnit'], true);
    });

    test('ProductUnit JSON Deserialization', () {
      final json = {
        'unit': {'name': 'unit', 'symbol': 'unit', 'conversionRate': 1},
        'price': 100.0,
        'costPrice': 50.0,
        'isBaseUnit': true,
      };

      final productUnit = ProductUnit.fromJson(json);
      expect(productUnit.unit.name, 'unit');
      expect(productUnit.price, 100.0);
      expect(productUnit.costPrice, 50.0);
      expect(productUnit.isBaseUnit, true);
    });
  });
}
