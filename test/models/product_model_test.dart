import 'package:flutter_test/flutter_test.dart';
import 'package:shop_mate/models/products/product_model.dart';
import 'package:shop_mate/models/products/product_unit.dart';
import 'package:shop_mate/models/unit_system/units_model.dart';

void main() {
  group('Product Model Tests', () {
    test('Product Initialization', () {
      final product = Product(
        id: '1',
        name: 'Test Product',
        businessId: 'business1',
        category: ProductCategory.electronics,
        salesPrice: 100.0,
        costPrice: 50.0,
        productUnits: [
          ProductUnit(
            unit: Unit(name: 'unit', symbol: 'unit', conversionRate: 1),
            price: 100.0,
            costPrice: 50.0,
            isBaseUnit: true,
          ),
        ],
        baseUnit: 'unit',
        stockQuantity: 10.0,
        sku: 'SKU123',
      );

      expect(product.id, '1');
      expect(product.name, 'Test Product');
      expect(product.businessId, 'business1');
      expect(product.category, ProductCategory.electronics);
      expect(product.salesPrice, 100.0);
      expect(product.costPrice, 50.0);
      expect(product.productUnits.length, 1);
      expect(product.baseUnit, 'unit');
      expect(product.stockQuantity, 10.0);
      expect(product.sku, 'SKU123');
    });

    test('Product Validation', () {
      final product = Product(
        id: '1',
        name: 'Test Product',
        businessId: 'business1',
        category: ProductCategory.electronics,
        salesPrice: 100.0,
        costPrice: 50.0,
        productUnits: [
          ProductUnit(
            unit: Unit(name: 'unit', symbol: 'unit', conversionRate: 1),
            price: 100.0,
            costPrice: 50.0,
            isBaseUnit: true,
          ),
        ],
        baseUnit: 'unit',
        stockQuantity: 10.0,
        sku: 'SKU123',
      );

      expect(() => product.validate(), returnsNormally);
    });

    test('Product Status', () {
      final product = Product(
        id: '1',
        name: 'Test Product',
        businessId: 'business1',
        category: ProductCategory.electronics,
        salesPrice: 100.0,
        costPrice: 50.0,
        productUnits: [
          ProductUnit(
            unit: Unit(name: 'unit', symbol: 'unit', conversionRate: 1),
            price: 100.0,
            costPrice: 50.0,
            isBaseUnit: true,
          ),
        ],
        baseUnit: 'unit',
        stockQuantity: 10.0,
        sku: 'SKU123',
      );

      expect(product.status, ProductStatus.available);

      product.stockQuantity = 5.0;
      expect(product.status, ProductStatus.lowStock);

      product.stockQuantity = 0.0;
      expect(product.status, ProductStatus.outOfStock);
    });

    test('Product Add Stock', () {
      final product = Product(
        id: '1',
        name: 'Test Product',
        businessId: 'business1',
        category: ProductCategory.electronics,
        salesPrice: 100.0,
        costPrice: 50.0,
        productUnits: [
          ProductUnit(
            unit: Unit(name: 'unit', symbol: 'unit', conversionRate: 1),
            price: 100.0,
            costPrice: 50.0,
            isBaseUnit: true,
          ),
        ],
        baseUnit: 'unit',
        stockQuantity: 10.0,
        sku: 'SKU123',
      );

      product.addStock(5.0);
      expect(product.stockQuantity, 15.0);
    });

    test('Product Reduce Stock', () {
      final product = Product(
        id: '1',
        name: 'Test Product',
        businessId: 'business1',
        category: ProductCategory.electronics,
        salesPrice: 100.0,
        costPrice: 50.0,
        productUnits: [
          ProductUnit(
            unit: Unit(name: 'unit', symbol: 'unit', conversionRate: 1),
            price: 100.0,
            costPrice: 50.0,
            isBaseUnit: true,
          ),
        ],
        baseUnit: 'unit',
        stockQuantity: 10.0,
        sku: 'SKU123',
      );

      product.reduceStock(5.0);
      expect(product.stockQuantity, 5.0);

      expect(() => product.reduceStock(10.0), throwsException);
    });

    test('Product Get Price For Unit', () {
      final product = Product(
        id: '1',
        name: 'Test Product',
        businessId: 'business1',
        category: ProductCategory.electronics,
        salesPrice: 100.0,
        costPrice: 50.0,
        productUnits: [
          ProductUnit(
            unit: Unit(name: 'unit', symbol: 'unit', conversionRate: 1),
            price: 100.0,
            costPrice: 50.0,
            isBaseUnit: true,
          ),
        ],
        baseUnit: 'unit',
        stockQuantity: 10.0,
        sku: 'SKU123',
      );

      expect(product.getPriceForUnit('unit'), 100.0);
      expect(() => product.getPriceForUnit('invalidUnit'), throwsException);
    });

    test('Product JSON Serialization', () {
      final product = Product(
        id: '1',
        name: 'Test Product',
        businessId: 'business1',
        category: ProductCategory.electronics,
        salesPrice: 100.0,
        costPrice: 50.0,
        productUnits: [
          ProductUnit(
            unit: Unit(name: 'unit', symbol: 'unit', conversionRate: 1),
            price: 100.0,
            costPrice: 50.0,
            isBaseUnit: true,
          ),
        ],
        baseUnit: 'unit',
        stockQuantity: 10.0,
        sku: 'SKU123',
      );

      final json = product.toJson();
      expect(json['id'], '1');
      expect(json['name'], 'Test Product');
      expect(json['businessId'], 'business1');
      expect(json['category'], 'electronics');
      expect(json['salesPrice'], 100.0);
      expect(json['costPrice'], 50.0);
      expect(json['productUnits'].length, 1);
      expect(json['baseUnit'], 'unit');
      expect(json['stockQuantity'], 10.0);
      expect(json['sku'], 'SKU123');
    });

    test('Product JSON Deserialization', () {
      final json = {
        'id': '1',
        'name': 'Test Product',
        'businessId': 'business1',
        'category': 'electronics',
        'salesPrice': 100.0,
        'costPrice': 50.0,
        'productUnits': [
          {
            'unit': {'name': 'unit', 'symbol': 'unit', 'conversionRate': 1},
            'price': 100.0,
            'costPrice': 50.0,
            'isBaseUnit': true,
          },
        ],
        'baseUnit': 'unit',
        'stockQuantity': 10.0,
        'sku': 'SKU123',
      };

      final product = Product.fromJson(json);
      expect(product.id, '1');
      expect(product.name, 'Test Product');
      expect(product.businessId, 'business1');
      expect(product.category, ProductCategory.electronics);
      expect(product.salesPrice, 100.0);
      expect(product.costPrice, 50.0);
      expect(product.productUnits.length, 1);
      expect(product.baseUnit, 'unit');
      expect(product.stockQuantity, 10.0);
      expect(product.sku, 'SKU123');
    });
  });
}
