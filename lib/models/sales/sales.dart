import 'package:shop_mate/models/base_model.dart';
import 'package:shop_mate/models/sales/sale_item_model.dart';

enum SaleStatus {
  pending,
  confirmed,
  cancelled,
}

class Sale extends BaseModel {
  final String businessId;
  final String employeeId;
  final String? customerId; // Optional: can be null for walk-in customers
  final String? customerName;
  final List<SaleItem> items;
  final double subtotal;
  final double? taxRate;
  final double? taxAmount;
  final double discount;
  final double total;
  final SaleStatus status;
  final String? notes;
  final String createdBy; // Reference to user who created the sale

  Sale({
    required super.id,
    required this.businessId,
    required this.employeeId,
    this.customerId,
    this.customerName,
    required this.items,
    required this.subtotal,
    this.taxRate,
    this.taxAmount,
    required this.discount,
    required this.total,
    required this.status,
    this.notes,
    required this.createdBy,
    required super.createdAt,
    required super.updatedAt,
  }) : super(name: ''); // Pass an empty string for name

  /// Calculate the total sales price of the items
  double get totalSalesPrice => items.fold(0.0, (sum, item) => sum + item.total);

  /// Calculate the total cost price of the items
  double get totalCostPrice => items.fold(0.0, (sum, item) => sum + (item.costPrice ?? 0.0));

  /// Calculate the total profit from this sale
  double get totalProfit => totalSalesPrice - totalCostPrice;


  @override
  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
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
      'status': status.name,
      'notes': notes,
      'createdBy': createdBy,
    });

  factory Sale.fromJson(Map<String, dynamic> json) => Sale(
        id: json['id'],
        businessId: json['businessId'],
        customerId: json['customerId'],
        employeeId: json['employeeId'],
        customerName: json['customerName'],
        items: List<SaleItem>.from(
          json['items'].map((x) => SaleItem.fromJson(x)),
        ),
        subtotal: json['subtotal'].toDouble(),
        taxRate: json['taxRate']?.toDouble(),
        taxAmount: json['taxAmount']?.toDouble(),
        discount: json['discount'].toDouble(),
        total: json['total'].toDouble(),
        status: SaleStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => SaleStatus.pending,
        ),
        notes: json['notes'],
        createdBy: json['createdBy'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}
