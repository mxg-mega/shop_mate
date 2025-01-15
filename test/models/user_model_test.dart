import 'package:test/test.dart';
import 'package:shop_mate/models/users/user_model.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';

void main() {
  group('User Model', () {
    test('should create a UserModel with valid parameters', () {
      final user = UserModel(
        id: '1',
        name: 'John Doe',
        email: 'john.doe@example.com',
        password: 'password123',
        role: UserRole.admin,
        phoneNumber: '1234567890',
        businessID: null,
        profilePicture: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: true,
      );

      expect(user.id, '1');
      expect(user.name, 'John Doe');
      expect(user.email, 'john.doe@example.com');
      expect(user.password, 'password123');
      expect(user.role, UserRole.admin);
      expect(user.phoneNumber, '1234567890');
      expect(user.businessID, null);
      expect(user.profilePicture, null);
      expect(user.isActive, true);
    });

    test('should throw an error if password is empty', () {
      expect(() {
        UserModel(
          id: '1',
          name: 'John Doe',
          email: 'john.doe@example.com',
          password: '',
          role: UserRole.admin,
          phoneNumber: '1234567890',
          businessID: null,
          profilePicture: null,
        );
      }, throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'Password cannot be empty if provided.')));
    });

    test('should throw an error if phone number is empty', () {
      expect(() {
        UserModel(
          id: '1',
          name: 'John Doe',
          email: 'john.doe@example.com',
          password: 'password123',
          role: UserRole.admin,
          phoneNumber: '',
          businessID: null,
          profilePicture: null,
        );
      }, throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'Phone number cannot be empty if provided.')));
    });

    test('should throw an error if customer has a businessID', () {
      expect(() {
        UserModel(
          id: '1',
          name: 'John Doe',
          email: 'john.doe@example.com',
          password: 'password123',
          role: UserRole.customer,
          phoneNumber: '1234567890',
          businessID: 'business123',
          profilePicture: null,
        );
      }, throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'Customers cannot have a businessID.')));
    });

    test('should serialize to JSON correctly', () {
      final user = UserModel(
        id: '1',
        name: 'John Doe',
        email: 'john.doe@example.com',
        password: 'password123',
        role: UserRole.admin,
        phoneNumber: '1234567890',
        businessID: null,
        profilePicture: null,
        createdAt: DateTime.parse('2023-10-01T12:00:00.000Z'),
        updatedAt: DateTime.parse('2023-10-01T12:00:00.000Z'),
        isActive: true,
      );

      final json = user.toJson();
      expect(json['id'], '1');
      expect(json['name'], 'John Doe');
      expect(json['email'], 'john.doe@example.com');
      expect(json['role'], 'admin');
      expect(json['phoneNumber'], '1234567890');
      expect(json['businessID'], null);
      expect(json['isActive'], true);
      expect(json['createdAt'], '2023-10-01T12:00:00.000Z');
      expect(json['updatedAt'], '2023-10-01T12:00:00.000Z');
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': '1',
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'password': 'password123',
        'role': 'admin',
        'phone Number': '1234567890',
        'businessID': null,
        'profilePicture': null,
        'createdAt': '2023-10-01T12:00:00.000Z',
        'updatedAt': '2023-10-01T12:00:00.000Z',
        'isActive': true,
      };

      final user = UserModel.fromJson(json);
      expect(user.id, '1');
      expect(user.name, 'John Doe');
      expect(user.email, 'john.doe@example.com');
      expect(user.password, 'password123');
      expect(user.role, UserRole.admin);
      expect(user.phoneNumber, '1234567890');
      expect(user.businessID, null);
      expect(user.isActive, true);
    });

    test('should serialize to CSV correctly', () {
      final user = UserModel(
        id: '1',
        name: 'John Doe',
        email: 'john.doe@example.com',
        password: 'password123',
        role: UserRole.admin,
        phoneNumber: '1234567890',
        businessID: null,
        profilePicture: null,
        createdAt: DateTime.parse('2023-10-01T12:00:00.000Z'),
        updatedAt: DateTime.parse('2023-10-01T12:00:00.000Z'),
        isActive: true,
      );

      final csv = user.toCSV();
      expect(csv, '1, John Doe, john.doe@example.com, password123, null, admin, null, true');
    });

    test('should deserialize from CSV correctly', () {
      final csv = '1, John Doe, john.doe@example.com, password123, null, admin, null, true, 2023-10-01T12:00:00.000Z, 2023-10-01T12:00:00.000Z, null';
      final user = UserModel.fromCSV(csv);

      expect(user.id, '1');
      expect(user.name, 'John Doe');
      expect(user.email, 'john.doe@example.com');
      expect(user.password, 'password123');
      expect(user.role, UserRole.admin);
      expect(user.phoneNumber, '1234567890');
      expect(user.businessID, null);
      expect(user.isActive, true);
    });

    test('should throw an error if CSV does not have the correct number of fields', () {
      final csv = '1, John Doe, john.doe@example.com, password123, null, admin, null, true';
      expect(() => UserModel.fromCSV(csv), throwsA(isA<FormatException>()));
    });
  });
}