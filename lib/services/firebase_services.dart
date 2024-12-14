import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/models/base_model.dart';

/// A generic service class for performing CRUD operations in Firestore.
/// 
/// [T] must extend `BaseModel` and provide methods for JSON serialization
/// and deserialization.
class FirebaseService<T extends BaseModel> {
  /// The Firestore collection name for this service.
  final String collectionName;

  /// A function to convert a Firestore document's data into an object of type [T].
  final T Function(Map<String, dynamic>) fromJson;

  /// Creates an instance of [FirebaseService].
  FirebaseService({
    required this.collectionName,
    required this.fromJson,
  });

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Creates a new document in Firestore.
  Future<void> create(T model) async {
    try {
      await _firestore.collection(collectionName).doc(model.id).set(model.toJson());
    } catch (e) {
      print("Error creating document: $e");
      throw Exception("Create operation failed");
    }
  }

  /// Reads a document by its ID from Firestore.
  Future<T?> read(String id) async {
    try {
      final doc = await _firestore.collection(collectionName).doc(id).get();
      return doc.exists ? fromJson(doc.data()!) : null;
    } catch (e) {
      print("Error reading document: $e");
      throw Exception("Read operation failed");
    }
  }

  /// Updates a document with the given ID in Firestore.
  Future<void> update(String id, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(collectionName).doc(id).update(updates);
    } catch (e) {
      print("Error updating document: $e");
      throw Exception("Update operation failed");
    }
  }

  /// Deletes a document with the given ID from Firestore.
  Future<void> delete(String id) async {
    try {
      await _firestore.collection(collectionName).doc(id).delete();
    } catch (e) {
      print("Error deleting document: $e");
      throw Exception("Delete operation failed");
    }
  }

  /// Streams a list of documents in real-time.
  Stream<List<T>> list() {
    return _firestore.collection(collectionName).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => fromJson(doc.data()!)).toList());
  }

  /// Retrieves a paginated list of documents from Firestore.
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
      return querySnapshot.docs.map((doc) => fromJson(doc.data()!)).toList();
    } catch (e) {
      print("Error fetching paginated list: $e");
      throw Exception("Pagination failed");
    }
  }
}
