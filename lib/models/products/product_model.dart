import 'package:shop_mate/models/base_model.dart';
import 'package:shop_mate/models/businesses/business_settings.dart';
import 'package:shop_mate/models/inventory/inventory_item_model.dart';
import 'package:shop_mate/models/inventory/inventory_model.dart';
import 'package:shop_mate/models/products/product_unit.dart';
import 'package:shop_mate/models/unit_system/units_model.dart';

enum ProductCategory {
  electronics,
  clothing,
  homeGoods,
}

enum ProductStatus {
  available,
  lowStock,
  outOfStock,
}

class Product extends BaseModel {
  final String businessId;
  final ProductCategory category;
  final String? description;
  final double salesPrice;
  final double costPrice;
  final List<ProductUnit> productUnits;
  final String baseUnit;
  double stockQuantity;
  final String? imageUrl;
  final bool isActive;
  final String sku;

  Product({
    required super.id,
    required super.name,
    required this.businessId,
    required this.category,
    this.description,
    required this.salesPrice,
    required this.costPrice,
    List<ProductUnit>? productUnits,
    required this.baseUnit,
    required this.stockQuantity,
    this.imageUrl,
    this.isActive = true,
    required this.sku,
    super.createdAt,
    super.updatedAt,
  }) : productUnits = productUnits ?? defaultProductUnits;

  static final List<ProductUnit> defaultProductUnits = [
    ProductUnit(
        unit: Unit(name: 'unit', symbol: 'unit', conversionRate: 1),
        price: 0.0,
        isBaseUnit: true,
        costPrice: 0.0),
  ];

  ProductStatus get status {
    if (stockQuantity <= 0) {
      return ProductStatus.outOfStock;
    } else if (stockQuantity < 10) {
      return ProductStatus.lowStock;
    } else {
      return ProductStatus.available;
    }
  }

  void validate() {
    if (costPrice < 0) throw Exception('Cost price must be non-negative.');
    if (salesPrice < 0) throw Exception('Sales price must be non-negative.');
    if (!productUnits.any((unit) => unit.unit.name == baseUnit)) {
      throw Exception('Base unit "$baseUnit" is not defined in product units.');
    }
    if (stockQuantity < 0) {
      throw Exception('Stock quantity must be non-negative.');
    }
    if (productUnits.isEmpty) {
      throw Exception('Product units cannot be empty.');
    }
  }

  // Method to update inventory when a sale is made
  /*void updateInventoryOnSale(int quantitySold, String location) {
    final inventoryItem = inventoryItems.firstWhere(
      (item) => item.location == location,
      orElse: () => InventoryItem.defaultItem(),
    );
    if (inventoryItem != InventoryItem.defaultItem()) {
      inventoryItem.quantity -= quantitySold;
      inventoryItem.lastUpdated = DateTime.now();
      inventoryItem.status = _calculateStatus(inventoryItem.quantity);
    }
  }*/

  // Method to calculate the inventory status based on quantity
  InventoryStatus _calculateStatus(int quantity) {
    if (quantity <= 0) {
      return InventoryStatus.outOfStock;
    } else if (quantity < 10) {
      return InventoryStatus.lowStock;
    } else {
      return InventoryStatus.inStock;
    }
  }

  void addStock(double amount) {
    assert(amount > 0, 'Amount to add must be greater than zero.');
    stockQuantity += amount;
  }

  void reduceStock(double amount) {
    assert(amount > 0, 'Amount to reduce must be greater than zero.');
    if (amount > stockQuantity) {
      throw Exception('Insufficient stock to reduce.');
    }
    stockQuantity -= amount;
  }

  double getPriceForUnit(String unitName) {
    final unit = productUnits.firstWhere(
      (u) => u.unit.name == unitName,
      orElse: () => throw Exception('Unit not found: $unitName'),
    );
    return unit.price;
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'businessId': businessId,
        'category': category.name,
        'description': description,
        'salesPrice': salesPrice,
        'costPrice': costPrice,
        'productUnits': productUnits.map((u) => u.toJson()).toList(),
        'baseUnit': baseUnit,
        'stockQuantity': stockQuantity,
        'imageUrl': imageUrl,
        'isActive': isActive,
        'sku': sku,
        'status': status.name,
        // 'inventoryItems': inventoryItems.map((i) => i.toJson()).toList(),
      });
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      businessId: json['businessId'] as String,
      category: ProductCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ProductCategory.homeGoods,
      ),
      description: json['description'] as String?,
      salesPrice: json['salesPrice'] as double,
      costPrice: json['costPrice'] as double,
      productUnits: (json['productUnits'] as List<dynamic>)
          .map((u) => ProductUnit.fromJson(u as Map<String, dynamic>))
          .toList(),
      baseUnit: json['baseUnit'] as String,
      stockQuantity: (json['stockQuantity'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      sku: json['sku'] as String,
      // inventoryItems: (json['inventoryItems'] as List<dynamic>)
      //     .map(
            // (itemJson) =>
            //     InventoryItem.fromJson(itemJson as Map<String, dynamic>),
          // )
          // .toList(),
    );
  }
}
