import 'package:freezed_annotation/freezed_annotation.dart';
part 'base_model.g.dart';

/// A base class representing common properties shared across models.
@JsonSerializable(explicitToJson: true)
class BaseModel {
  String name;
  final String id;
  DateTime? createdAt;
  DateTime? updatedAt;

  /// Creates a [BaseModel] with the given parameters.
  BaseModel({
    required this.name,
    required this.id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    _validateFields();
    this.createdAt = createdAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? createdAt;
  }

  void _validateFields() {
    if (id.isEmpty) {
      throw ArgumentError('ID cannot be empty.');
    }
    if (name.isEmpty) {
      throw ArgumentError('Name cannot be empty.');
    }
  }

  /// Parses a [BaseModel] object from a JSON map.
  factory BaseModel.fromJson(Map<String, dynamic> json) =>
      _$BaseModelFromJson(json);
  // factory BaseModel.fromJson(Map<String, dynamic> json) {
  //   return BaseModel(
  //     name: json["name"] as String,
  //     id: json["id"] as String,
  //     createdAt: DateTime.parse(json["createdAt"] as String),
  //     updatedAt: DateTime.parse(json["updatedAt"] as String),
  //   );
  // }

  /// Converts the object to a JSON map.
  @override
  Map<String, dynamic> toJson() => _$BaseModelToJson(this);
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'createdAt': createdAt?.toIso8601String(),
  //     'updatedAt': updatedAt?.toIso8601String(),
  //   };
  // }

  /// Converts the object to a CSV-formatted string.
  String toCSV() {
    return '$id , $name , ${createdAt?.toIso8601String()} , ${updatedAt?.toIso8601String()}';
  }

  static void validateCSVParts(List<String> parts, int expectedCount) {
    if (parts.length != expectedCount) {
      throw FormatException(
          "Invalid CSV: expected $expectedCount fields but found ${parts.length}.");
    }
  }

  /// Parses a [BaseModel] object from a CSV-formatted string.
  factory BaseModel.fromCSV(String csv) {
    final parts = csv.split(',').map((part) => part.trim()).toList();
    validateCSVParts(parts, 4);

    return BaseModel(
      id: parts[0],
      name: parts[1],
      createdAt: DateTime.tryParse(parts[2]),
      updatedAt: DateTime.tryParse(parts[3]),
    );
  }

  /// Creates a new instance with updated fields while retaining unchanged ones.
  BaseModel copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BaseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
