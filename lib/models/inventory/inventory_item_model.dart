import 'package:shop_mate/models/base_model.dart';
import 'package:shop_mate/models/inventory/inventory_model.dart';

class InventoryItem extends BaseModel {
  final String productId;
  final String businessId;
  final int quantity; // Quantity in the base unit
  final InventoryStatus status;
  final String? location; // Optional: Location/Warehouse
  final double costPrice; // Cost price per base unit
  final double salesPrice; // Sales price per base unit
  final String baseUnit;

  set quantity(value) => quantity = value;
  set lastUpdated(value) => lastUpdated = value;
  set status(value) => status = value;
  set location(value) => location = value;

  InventoryItem({
    required this.productId,
    required this.businessId,
    required this.quantity,
    required this.status,
    required this.costPrice,
    required this.salesPrice,
    required this.location,
    required this.baseUnit,
    required super.id,
    required super.name,
    super.createdAt,
    super.updatedAt,
  });

  static InventoryStatus calculateStatus(int quantity) {
    if (quantity <= 0) {
      return InventoryStatus.outOfStock;
    } else if (quantity < 10) {
      return InventoryStatus.lowStock;
    }
    return InventoryStatus.inStock;
  }

  /// Validation
  void validate() {
    if (quantity < 0) throw Exception('Quantity must be non-negative.');
    if (costPrice < 0) throw Exception('Cost price must be non-negative.');
    if (salesPrice < 0) throw Exception('Sales price must be non-negative.');
  }

  factory InventoryItem.defaultItem() => InventoryItem(
        id: '',
        productId: '',
        location: '',
        quantity: 0,
        status: InventoryStatus.inStock,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        name: '',
        businessId: '',
        costPrice: 0,
        salesPrice: 0,
        baseUnit: 'unit',
      );

  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
        id: json['id'],
        productId: json['productId'],
        businessId: json['businessId'],
        name: json['name'],
        costPrice: json['costPrice'],
        salesPrice: json['salesPrice'],
        location: json['location'],
        quantity: json['quantity'],
        baseUnit: json['baseUnit'],
        status: InventoryStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => InventoryStatus.inStock,
        ),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  @override
  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'productId': productId,
      'location': location,
      'quantity': quantity,
      'baseUnit': baseUnit,
      'status': status.name,
      'costPrice': costPrice,
      'salesPrice': salesPrice,
      'businessId': businessId,
    });

  @override
  InventoryItem copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? productId,
    String? businessId,
    int? quantity,
    InventoryStatus? status,
    String? location,
    double? costPrice,
    double? salesPrice,
    String? baseUnit,
  }) {
    return InventoryItem(
      productId: productId ?? this.productId,
      businessId: businessId ?? this.businessId,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      costPrice: costPrice ?? this.costPrice,
      salesPrice: salesPrice ?? this.salesPrice,
      baseUnit: baseUnit ?? this.baseUnit,
      location: location,
      id: id ?? super.id,
      name: name ?? super.name,
      createdAt: createdAt ?? super.createdAt,
      updatedAt: updatedAt ?? super.updatedAt,
    );
  }
}
