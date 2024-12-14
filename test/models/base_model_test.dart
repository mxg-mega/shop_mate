import 'package:test/test.dart';
import 'package:shop_mate/models/base_model.dart';

void main() {
  group('BaseModel', () {
    test('should create a BaseModel with valid parameters', () {
      final model = BaseModel(name: 'Test Model', id: '123');

      expect(model.name, 'Test Model');
      expect(model.id, '123');
      expect(model.createdAt, isNotNull);
      expect(model.updatedAt, model.createdAt);
    });

    test('should throw an error when id is empty', () {
      expect(
          () => BaseModel(name: 'Test Model', id: ''),
          throwsA(isA<ArgumentError>()
              .having((e) => e.message, 'message', 'ID cannot be empty.')));
    });

    test('should throw an error when name is empty', () {
      expect(
          () => BaseModel(name: '', id: '123'),
          throwsA(isA<ArgumentError>()
              .having((e) => e.message, 'message', 'Name cannot be empty.')));
    });

    test('should parse from JSON correctly', () {
      final json = {
        'name': 'Test Model',
        'id': '123',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      final model = BaseModel.fromJson(json);

      expect(model.name, 'Test Model');
      expect(model.id, '123');
      expect(model.createdAt, isNotNull);
      expect(model.updatedAt, isNotNull);
    });

    test('should convert to JSON correctly', () {
      final model = BaseModel(name: 'Test Model', id: '123');

      final json = model.toJson();

      expect(json['name'], 'Test Model');
      expect(json['id'], '123');
      expect(json['createdAt'], isNotNull);
      expect(json['updatedAt'], isNotNull);
    });

    test('should convert to CSV correctly', () {
      final model = BaseModel(name: 'Test Model', id: '123');

      final csv = model.toCSV();

      expect(csv, contains('123'));
      expect(csv, contains('Test Model'));
      expect(csv, contains(model.createdAt!.toIso8601String()));
      expect(csv, contains(model.updatedAt!.toIso8601String()));
    });

    test('should create a copy with updated fields', () {
      final model = BaseModel(name: 'Test Model', id: '123');
      final updatedModel = model.copyWith(name: 'Updated Model');

      expect(updatedModel.name, 'Updated Model');
      expect(updatedModel.id, model.id);
      expect(updatedModel.createdAt, model.createdAt);
      expect(updatedModel.updatedAt, model.updatedAt);
    });

    test('should retain unchanged fields when copying', () {
      final model = BaseModel(name: 'Test Model', id: '123');
      final updatedModel = model.copyWith();

      expect(updatedModel.name, model.name);
      expect(updatedModel.id, model.id);
      expect(updatedModel.createdAt, model.createdAt);
      expect(updatedModel.updatedAt, model.updatedAt);
    });

    test('should throw exception for invalid CSV format', () {
      final csv = '1, John Doe, 2023-01-01T00:00:00.000'; // Missing a field
      expect(() => BaseModel.fromCSV(csv), throwsFormatException);
    });
  });
}
