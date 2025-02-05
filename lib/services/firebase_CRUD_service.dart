import "package:cloud_firestore/cloud_firestore.dart";
import 'package:shop_mate/core/error/my_exceptions.dart';
import 'package:shop_mate/models/base_model.dart';
import '../core/utils/constants.dart';

/// A generic service class for performing CRUD operations in Firestore.
///
/// [T] must extend `BaseModel` and provide methods for JSON serialization
/// and deserialization.
class FirebaseCRUDService<T extends BaseModel> {
  /// The Firestore collection name for this service.
  final String collectionName;

  /// A function to convert a Firestore document's data into an object of type [T].
  final T Function(Map<String, dynamic>) fromJson;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String businessId;

  // property to indicate whether the one used on is a sub collection or not
  final bool isSubcollection;

  /// Creates an instance of [MyFirebaseService].
  FirebaseCRUDService({
    required this.collectionName,
    required this.fromJson,
    required this.businessId,
    this.isSubcollection = true,
  });

  CollectionReference<Map<String, dynamic>> get collection {
    if (isSubcollection == false){
      return _firestore.collection(collectionName);
    }

    return _firestore
        .collection(Storage.businesses)
        .doc(businessId)
        .collection(collectionName);
  }

  /// Create function to post new information to the database
  Future<void> create(T model) async {
    try {
      await collection.doc(model.id).set({
        ...model.toJson(),
        'businessId': businessId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw FirebaseCRUDException("Create", e.message ?? "Unknown error");
    }
  }

  Future<T?> read(String id) async {
    try {
      final doc = await collection.doc(id).get();
      if (!doc.exists) {
        return null;
      }

      return fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw FirebaseCRUDException("Read", e.message ?? "Unknown error");
    }
  }

  Future<void> update(String id,
      {Map<String, dynamic>? updates, T? model}) async {
    assert(!(updates != null && model != null), "Use either updates or model");
    try {
      final update = updates ?? model!.toJson();
      await collection.doc(id).update({
        ...update,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw FirebaseCRUDException("Update", e.message ?? "Unknown error");
    }
  }

  Future<void> delete(String id) async {
    try {
      await collection.doc(id).delete();
    } on FirebaseException catch (e) {
      throw FirebaseCRUDException("Delete", e.message ?? "Unknown error");
    }
  }

  Future<void> safeDelete(String id) async {
    return _firestore.runTransaction((transaction) async {
      final docRef = collection.doc(id);
      final doc = await transaction.get(docRef);
      if (!doc.exists) throw FirebaseCRUDException("Delete", "Document not found");
      transaction.delete(docRef);
    });
  }

  Stream<List<T>> streamAll() {
    return collection.orderBy('createdAt', descending: true).snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => fromJson(doc.data())).toList());
  }

  Stream<List<T>> streamByField(String field, dynamic value) {
    return collection
        .where(field, isEqualTo: value)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => fromJson(doc.data())).toList());
  }

  Future<List<T>> getPaginated({
    required int limit,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      var query =
          collection.orderBy('createdAt', descending: true).limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) => fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception("Pagination failed: $e");
    }
  }
}


