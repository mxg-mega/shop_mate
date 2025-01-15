enum SaleStatus {
  pending,
  confirmed,
  cancelled
}

class Sale {
  final String id;
  final String businessId;
  final String employeeId;
  final String customerId; // Optional: can be null for walk-in customers
  final String customerName;
  final List<SaleItem> items;
  final double subtotal;
  // TODO: add a total of sales price, cost price of the items, and the total profit from this sale
  final double taxRate;
  final double taxAmount;
  final double discount;
  final double total;
  final SaleStatus status;
  final String? notes;
  final String createdBy; // Reference to user who created the sale
  final DateTime createdAt;
  final DateTime updatedAt;

  Sale({
    required this.id,
    required this.businessId,
    required this.employeeId,
    required this.customerId,
    required this.customerName,
    required this.items,
    required this.subtotal,
    required this.taxRate,
    required this.taxAmount,
    required this.discount,
    required this.total,
    required this.status,
    this.notes,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'businessId': businessId,
        'customerId': customerId,
        'employeeId': employeeId,
        'customerName': customerName,
        'items': items.map((item) => item.toJson()).toList(),
        'subtotal': subtotal,
        'taxRate': taxRate,
        'taxAmount': taxAmount,
        'discount': discount,
        'total': total,
        'status': status.toString(),
        'notes': notes,
        'createdBy': createdBy,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Sale.fromJson(Map<String, dynamic> json) =>
      Sale(
        id: json['id'],
        businessId: json['businessId'],
        customerId: json['customerId'],
        employeeId: json['employeeId'],
        customerName: json['customerName'],
        items: List<SaleItem>.from(
          json['items'].map((x) => SaleItem.fromJson(x)),
        ),
        subtotal: json['subtotal'].toDouble(),
        taxRate: json['taxRate'].toDouble(),
        taxAmount: json['taxAmount'].toDouble(),
        discount: json['discount'].toDouble(),
        total: json['total'].toDouble(),
        status: SaleStatus.values.firstWhere(
              (e) => e.toString() == json['status'],
        ),
        notes: json['notes'],
        createdBy: json['createdBy'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}

class SaleItem {
  final String productId;
  final String productName;
  final String? unit;
  final int quantity;
  final double unitPrice;
  // TODO: update to have sales price and cost price
  final double total;
  final Map<String, dynamic>? customFields;

  SaleItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.total,
    this.unit, this.customFields,
  });

  Map<String, dynamic> toJson() =>
      {
        'productId': productId,
        'productName': productName,
        'unit': unit,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'total': total,
        'customFields': customFields,
      };

  factory SaleItem.fromJson(Map<String, dynamic> map) =>
      SaleItem(
        productId: map['productId'],
        productName: map['productName'],
        quantity: map['quantity'],
        unitPrice: map['unitPrice'].toDouble(),
        total: map['total'].toDouble(),
        unit: map['unit'],
        customFields: map['customFields'],
      );
}
