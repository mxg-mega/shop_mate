/// A base class representing common properties shared across models.
class BaseModel {
  final String name;
  final String id;
  late final DateTime? createdAt;
  late DateTime? updatedAt;

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
  factory BaseModel.fromJson(Map<String, dynamic> json) {
    return BaseModel(
      name: json["name"] as String,
      id: json["id"] as String,
      createdAt: DateTime.parse(json["createdAt"] as String),
      updatedAt: DateTime.parse(json["updatedAt"] as String),
    );
  }

  /// Converts the object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt':updatedAt?.toIso8601String(),
    };
  }

  /// Converts the object to a CSV-formatted string.
  String toCSV() {
    return '$id , $name , ${createdAt?.toIso8601String()} , ${updatedAt?.toIso8601String()}';
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
