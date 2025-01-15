import 'package:shop_mate/models/unit_system/units_model.dart';

class ProductUnit {
  final Unit unit;
  final double price;
  final double costPrice;
  final bool isBaseUnit;

  ProductUnit({
    required this.unit,
    required this.price,
    required this.costPrice,
    required this.isBaseUnit,
  });

  String toCSV() {
    return '${unit.toCSV()}:$price:$costPrice:$isBaseUnit';
  }

  factory ProductUnit.fromCSV(String csv) {
    final parts = csv.split(':');
    if (parts.length != 4) {
      throw const FormatException('Invalid CSV format for ProductUnit');
    }
    return ProductUnit(
      unit: Unit.fromCSV(parts[0]),
      price: double.tryParse(parts[1]) ?? 0.0,
      costPrice: double.tryParse(parts[2]) ?? 0.0,
      isBaseUnit: parts[3] == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unit': unit.toJson(),
      'price': price,
      'costPrice': costPrice,
      'isBaseUnit': isBaseUnit,
    };
  }

  factory ProductUnit.fromJson(Map<String, dynamic> json) {
    return ProductUnit(
      unit: Unit.fromJson(json['unit']),
      price: (json['price'] as num).toDouble(),
      costPrice: (json['costPrice'] as num).toDouble(),
      isBaseUnit: json['isBaseUnit'] as bool,
    );
  }
}
