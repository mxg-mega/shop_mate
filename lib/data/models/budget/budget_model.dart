// budget_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/data/models/base_model.dart';

class Budget extends BaseModel {
  final String businessId;
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, double> plannedExpenses;

  Budget({
    required super.id,
    required super.name,
    required this.businessId,
    required this.startDate,
    required this.endDate,
    required this.plannedExpenses,
    super.createdAt,
    super.updatedAt,
  });

  factory Budget.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Budget(
      id: doc.id,
      businessId: data['businessId'],
      name: data['name'],
      startDate: DateTime.parse(data['startDate']),
      endDate: DateTime.parse(data['endDate']),
      plannedExpenses: Map<String, double>.from(data['plannedExpenses']),
    );
  }

  @override
  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'businessId': businessId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'plannedExpenses': plannedExpenses,
    });
}