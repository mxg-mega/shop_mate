import 'package:flutter_test/flutter_test.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';
import 'package:shop_mate/data/models/businesses/business_model.dart';
import 'package:shop_mate/data/models/businesses/subscription_model.dart';
import 'package:shop_mate/data/models/businesses/business_settings.dart';
import 'package:shop_mate/data/models/users/employee_model.dart';

void main() {
  group('Business Model Tests', () {
    test('Business Initialization', () {
      final business = Business(
        id: '1',
        name: 'Test Business',
        email: 'test@example.com',
        phone: '1234567890',
        address: '123 Test St',
        businessType: BusinessCategories.retail,
        ownerId: 'owner1',
        employees: [
          Employee(
            id: 'emp1',
            name: 'Employee 1',
            email: 'emp1@example.com',
            role: UserRole.staff,
            businessId: '123456778',
            password: 'password',
              businessAbbrev: "TST"
          ),
        ],
        subscription: Subscription.defaultSubscription(),
        businessSettings: BusinessSettings.defaultSettings('owner1'),
      );

      expect(business.id, '1');
      expect(business.name, 'Test Business');
      expect(business.email, 'test@example.com');
      expect(business.phone, '1234567890');
      expect(business.address, '123 Test St');
      expect(business.businessType, BusinessCategories.retail);
      expect(business.ownerId, 'owner1');
      expect(business.employees.length, 1);
      expect(business.subscription, isNotNull);
      expect(business.businessSettings, isNotNull);
    });

    test('Business JSON Serialization', () {
      final business = Business(
        id: '1',
        name: 'Test Business',
        email: 'test@example.com',
        phone: '1234567890',
        address: '123 Test St',
        businessType: BusinessCategories.retail,
        ownerId: 'owner1',
        employees: [
          Employee(
              id: 'emp1',
              name: 'Employee 1',
              email: 'emp1@example.com',
              role: UserRole.staff,
              businessId: '123456778',
              password: 'password',
              businessAbbrev: "TST"
          ),
        ],
        subscription: Subscription.defaultSubscription(),
        businessSettings: BusinessSettings.defaultSettings('owner1'),
      );

      final json = business.toJson();
      expect(json['id'], '1');
      expect(json['name'], 'Test Business');
      expect(json['email'], 'test@example.com');
      expect(json['phone'], '1234567890');
      expect(json['address'], '123 Test St');
      expect(json['businessType'], 'retail');
      expect(json['ownerId'], 'owner1');
      expect(json['employees'].length, 1);
      expect(json['subscription'], isNotNull);
      expect(json['businessSettings'], isNotNull);
    });

    test('Business JSON Deserialization', () {
      final json = {
        'id': '1',
        'name': 'Test Business',
        'email': 'test@example.com',
        'phone': '1234567890',
        'address': '123 Test St',
        'businessType': 'retail',
        'ownerId': 'owner1',
        'employees': [
          {'id': 'emp1', 'name': 'Employee 1', 'email': 'emp1@example.com'},
        ],
        'subscription': Subscription.defaultSubscription().toJson(),
        'businessSettings': BusinessSettings.defaultSettings('owner1').toJson(),
      };

      final business = Business.fromJson(json);
      expect(business.id, '1');
      expect(business.name, 'Test Business');
      expect(business.email, 'test@example.com');
      expect(business.phone, '1234567890');
      expect(business.address, '123 Test St');
      expect(business.businessType, BusinessCategories.retail);
      expect(business.ownerId, 'owner1');
      expect(business.employees.length, 1);
      expect(business.subscription, isNotNull);
      expect(business.businessSettings, isNotNull);
    });
  });
}
