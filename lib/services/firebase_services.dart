import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_mate/data/datasource/local/business_storage.dart';
import 'package:shop_mate/data/models/base_model.dart';

import '../core/utils/constants.dart';

/// A generic service class for performing CRUD operations in _Firestore.
///
/// [T] must extend `BaseModel` and provide methods for JSON serialization
/// and deserialization.
class MyFirebaseService<T extends BaseModel> {
  /// The _Firestore collection name for this service.
  final String collectionName;

  /// A function to convert a _Firestore document's data into an object of type [T].
  final T Function(Map<String, dynamic>) fromJson;

  /// Creates an instance of [MyFirebaseService].
  MyFirebaseService({
    required this.collectionName,
    required this.fromJson,
  });

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final businessId = BusinessStorage.getBusinessProfile()?.id ?? '';

  // Get collection reference with business scope
  // CollectionReference<Map<String, dynamic>> get collection =>
  //     _firestore.collection(collectionName).doc(businessId).collection('items');

  /// Creates a new document in Firestore.
  Future<void> create(T model) async {
    try {
      print(
          'My Firebase CRUD Service creating document:\n ${model.toJson()}\n.......');
      await _firestore
          .collection(collectionName)
          .doc(model.id)
          .set(model.toJson());
    } on FirebaseException catch (e) {
      print("Error creating document: ${e.toString()}");
      throw Exception("Create operation failed");
    }
  }

  // TODO: Write a save function

  /// Reads a document by its ID from Firestore.
  Future<T?> read(String id) async {
    try {
      final doc = await _firestore.collection(collectionName).doc(id).get();
      return doc.exists ? fromJson(doc.data()!) : null;
    } catch (e) {
      debugPrint("Error reading document: $e");
      throw Exception("Read operation failed");
    }
  }

  /// Reads a document by its name from Firestore.
  Future<T?> readByName(String name) async {
    try {
      final doc = await _firestore
          .collection(collectionName)
          .where('name', isEqualTo: name)
          .get();
      logger.d("Gotten ${doc.docs.first.data()} by name");
      return doc.docs.isEmpty ? fromJson(doc.docs.first.data()) : null;
    } catch (e) {
      print("Error reading document: $e");
      throw Exception("Read operation failed: Failed to get info by name");
    }
  }

  /// Updates a document with the given ID in _Firestore.
  Future<void> update(String id, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(collectionName).doc(id).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error updating document: $e");
      throw Exception("Update operation failed");
    }
  }

  /// Deletes a document with the given ID from _Firestore.
  Future<void> delete(String id) async {
    try {
      await _firestore.collection(collectionName).doc(id).delete();
    } catch (e) {
      print("Error deleting document: $e");
      throw Exception("Delete operation failed");
    }
  }

  /// Gets the Doc Reference of the class
  DocumentReference getDocRef(String id) {
    try {
      final docRef = _firestore.collection(collectionName).doc(id);
      return docRef;
    } catch (e) {
      throw Exception("Doc Reference query failed");
    }
  }

  /// Streams a list of documents in real-time.
  Stream<List<T>> list() {
    return _firestore
        .collection(collectionName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => fromJson(doc.data())).toList());
  }

  /// Retrieves a paginated list of documents from Fire store.
  Future<List<T>> paginatedList({
    required int limit,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      var query = _firestore.collection(collectionName).limit(limit);
      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }
      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) => fromJson(doc.data())).toList();
    } catch (e) {
      print("Error fetching paginated list: $e");
      throw Exception("Pagination failed");
    }
  }
}
