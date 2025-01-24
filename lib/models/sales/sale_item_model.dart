class SaleItem {
  final String productId;
  final String productName;
  final String? unit;
  final int quantity;
  final double unitPrice;
  final double? costPrice; // Cost price of the item
  final double total;
  final Map<String, dynamic>? customFields;

  SaleItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.total,
    this.unit,
    this.costPrice,
    this.customFields,
  });

  /// Calculate the profit for this sale item
  double get profit => (total - (costPrice ?? 0.0));

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        'unit': unit,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'costPrice': costPrice,
        'total': total,
        'customFields': customFields,
      };

  factory SaleItem.fromJson(Map<String, dynamic> map) => SaleItem(
        productId: map['productId'],
        productName: map['productName'],
        quantity: map['quantity'],
        unitPrice: map['unitPrice'].toDouble(),
        costPrice: map['costPrice']?.toDouble(),
        total: map['total'].toDouble(),
        unit: map['unit'],
        customFields: map['customFields'],
      );

  get location => null;
}
