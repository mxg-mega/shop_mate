import 'package:shop_mate/data/models/base_model.dart';

class ExpenseCategory extends BaseModel {
  final String description;
  final bool isFixed;
  final bool affectsInventory;
  final bool affectsCogs; // Cost of Goods Sold
  final String? parentCategoryId; // For hierarchical categories

  ExpenseCategory({
    required super.id,
    required super.name,
    required this.description,
    required this.isFixed,
    required this.affectsInventory,
    required bool? affectsCogs,
    this.parentCategoryId,
    required super.createdAt,
    required super.updatedAt,
  }) : affectsCogs = affectsCogs ?? false;

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) =>
      ExpenseCategory(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        isFixed: json['isFixed'],
        affectsInventory: json['affectsInventory'],
        affectsCogs: json['affectsCogs'],
        parentCategoryId: json['parentCategoryId'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  @override
  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'description': description,
      'isFixed': isFixed,
      'affectsInventory': affectsInventory,
      'affectsCogs': affectsCogs,
      'parentCategoryId': parentCategoryId,
    });
}