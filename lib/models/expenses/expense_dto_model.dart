import 'package:shop_mate/models/expenses/expense_category.dart';
import 'package:shop_mate/models/expenses/expense_model.dart';

class ExpenseDto {
  final String businessId;
  final ExpenseCategory category;
  final String? employeeId; // Who recorded the expense
  final double amount;
  final DateTime date;
  final String description;
  final ExpenseType type;
  final ExpenseStatus status;
  final String? recurringId; // For recurring expenses
  final List<String> attachmentUrls; // Receipts etc.
  final Map<String, dynamic> customFields; // For business-specific data

  // Optional fields for specific expense types
  final String? supplierId;
  final String? orderId;
  final String? productId;

  // For expense allocation
  final Map<String, double>? departmentAllocation;
  final Map<String, double>? projectAllocation;

  ExpenseDto({
    required this.businessId,
    required this.category,
    this.employeeId,
    required this.amount,
    required this.date,
    required this.description,
    required this.type,
    required this.status,
    this.recurringId,
    required this.attachmentUrls,
    required this.customFields,
    this.supplierId,
    this.orderId,
    this.productId,
    this.departmentAllocation,
    this.projectAllocation,
  });

  factory ExpenseDto.fromJson(Map<String, dynamic> json) => ExpenseDto(
        businessId: json['businessId'],
        category: ExpenseCategory.fromJson(json['categoryId'] as Map<String, dynamic>),
        employeeId: json['employeeId'],
        amount: json['amount'].toDouble(),
        date: DateTime.parse(json['date']),
        description: json['description'],
        type: ExpenseType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => ExpenseType.fixed,
        ),
        status: ExpenseStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => ExpenseStatus.pending,
        ),
        recurringId: json['recurringId'],
        attachmentUrls: List<String>.from(json['attachmentUrls']),
        customFields: Map<String, dynamic>.from(json['customFields']),
        supplierId: json['supplierId'],
        orderId: json['orderId'],
        productId: json['productId'],
        departmentAllocation:
            Map<String, double>.from(json['departmentAllocation'] ?? {}),
        projectAllocation:
            Map<String, double>.from(json['projectAllocation'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'businessId': businessId,
        'categoryId': category.toJson(),
        'employeeId': employeeId,
        'amount': amount,
        'date': date.toIso8601String(),
        'description': description,
        'type': type.name,
        'status': status.name,
        'recurringId': recurringId,
        'attachmentUrls': attachmentUrls,
        'customFields': customFields,
        'supplierId': supplierId,
        'orderId': orderId,
        'productId': productId,
        'departmentAllocation': departmentAllocation,
        'projectAllocation': projectAllocation,
      };
}
