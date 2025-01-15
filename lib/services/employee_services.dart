import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/models/users/employee_model.dart';
import 'package:shop_mate/services/firebase_services.dart';

import '../core/utils/constants.dart';

class EmployeeServices {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final MyFirebaseService _firebaseService = MyFirebaseService<Employee>(
    collectionName: Storage.employees,
    fromJson: (data) => Employee.fromJson(data),
  );



}
