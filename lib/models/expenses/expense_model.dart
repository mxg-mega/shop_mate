import 'package:shop_mate/models/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/models/expenses/expense_category.dart';

enum ExpenseType {
  fixed, // Rent, salaries
  variable, // Utilities, supplies
  oneTime, // Equipment purchase
  recurring // Subscriptions
}

enum ExpenseStatus {
  pending,
  approved,
  paid,
  rejected,
  cancelled
}

class Expense extends BaseModel {
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

  Expense({
    required super.id,
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
    required super.createdAt,
    required super.updatedAt,
  }) : super(name: '');

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json['id'] as String,
        businessId: json['businessId'] as String,
        category: ExpenseCategory.fromJson(json['category'] as Map<String, dynamic>),
        employeeId: json['employeeId'] as String,
        amount: json['amount'].toDouble(),
        date: DateTime.parse(json['date']),
        description: json['description'] as String,
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
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  factory Expense.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Expense(
      id: doc.id,
      businessId: data['businessId'],
      category: data['category'],
      employeeId: data['employeeId'],
      amount: data['amount'].toDouble(),
      date: DateTime.parse(data['date']),
      description: data['description'],
      type: ExpenseType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => ExpenseType.fixed,
      ),
      status: ExpenseStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => ExpenseStatus.pending,
      ),
      recurringId: data['recurringId'],
      attachmentUrls: List<String>.from(data['attachmentUrls']),
      customFields: Map<String, dynamic>.from(data['customFields']),
      supplierId: data['supplierId'],
      orderId: data['orderId'],
      productId: data['productId'],
      departmentAllocation:
          Map<String, double>.from(data['departmentAllocation'] ?? {}),
      projectAllocation:
          Map<String, double>.from(data['projectAllocation'] ?? {}),
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
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
    });
}




class RecurringExpense extends BaseModel {
  final String businessId;
  final ExpenseTemplate template;
  final RecurrenceSchedule schedule;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;

  RecurringExpense({
    required super.id,
    required this.businessId,
    required this.template,
    required this.schedule,
    required this.startDate,
    this.endDate,
    required this.isActive,
    required super.createdAt,
    required super.updatedAt,
  }) : super(name: ''); // Pass an empty string for name

  factory RecurringExpense.fromJson(Map<String, dynamic> json) =>
      RecurringExpense(
        id: json['id'],
        businessId: json['businessId'],
        template: ExpenseTemplate.fromJson(json['template']),
        schedule: RecurrenceSchedule.fromJson(json['schedule']),
        startDate: DateTime.parse(json['startDate']),
        endDate:
            json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
        isActive: json['isActive'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  @override
  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'businessId': businessId,
      'template': template.toJson(),
      'schedule': schedule.toJson(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
    });
}

class RecurrenceSchedule extends BaseModel {
  final String frequency;
  final int interval;
  final List<String> daysOfWeek;
  final int dayOfMonth;
  final int monthOfYear;
  final int year;
  final int? occurrenceCount;
  final int? occurrenceLimit;
  final String? recurrenceType;
  final String? recurrencePattern;

  RecurrenceSchedule({
    required super.name,
    required super.id,
    required this.frequency,
    required this.interval,
    required List<String>? daysOfWeek,
    required this.dayOfMonth,
    required this.monthOfYear,
    required this.year,
    required this.occurrenceCount,
    required this.occurrenceLimit,
    required this.recurrenceType,
    required this.recurrencePattern,
  }) : daysOfWeek = daysOfWeek ?? [];

  @override
  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'frequency': frequency,
      'interval': interval,
      'daysOfWeek': daysOfWeek,
      'dayOfMonth': dayOfMonth,
      'monthOfYear': monthOfYear,
      'year': year,
      'occurrenceCount': occurrenceCount,
      'occurrenceLimit': occurrenceLimit,
      'recurrenceType': recurrenceType,
      'recurrencePattern': recurrencePattern,
    });

  @override
  factory RecurrenceSchedule.fromJson(Map<String, dynamic> json) =>
      RecurrenceSchedule(
        name: json['name'],
        id: json['id'],
        frequency: json['frequency'],
        interval: json['interval'],
        daysOfWeek: List<String>.from(json['daysOfWeek']),
        dayOfMonth: json['dayOfMonth'],
        monthOfYear: json['monthOfYear'],
        year: json['year'],
        occurrenceCount: json['occurrenceCount'],
        occurrenceLimit: json['occurrenceLimit'],
        recurrenceType: json['recurrenceType'],
        recurrencePattern: json['recurrencePattern'],
      );
}

class ExpenseTemplate extends BaseModel {
  final String? description;
  final String? categoryId;
  final String? supplierId;
  final String? orderId;
  final String? productId;
  final Map<String, dynamic>? customFields;

  ExpenseTemplate({
    required super.name,
    required super.id,
    required this.description,
    required this.categoryId,
    required this.supplierId,
    required this.orderId,
    required this.productId,
    required Map<String, dynamic> this.customFields,
  });

  @override
  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'description': description,
      'categoryId': categoryId,
      'supplierId': supplierId,
      'orderId': orderId,
      'productId': productId,
      'customFields': customFields,
    });

  @override
  factory ExpenseTemplate.fromJson(Map<String, dynamic> json) =>
      ExpenseTemplate(
        name: json['name'],
        id: json['id'],
        description: json['description'],
        categoryId: json['categoryId'],
        supplierId: json['supplierId'],
        orderId: json['orderId'],
        productId: json['productId'],
        customFields: Map<String, dynamic>.from(json['customFields']),
      );
}


