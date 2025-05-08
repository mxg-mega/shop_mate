import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shop_mate/core/error/my_exceptions.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/data/datasource/local/business_storage.dart';
import 'package:shop_mate/data/models/base_model.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/services/business_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shop_mate/core/error/my_exceptions.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/data/datasource/local/business_storage.dart';
import 'package:shop_mate/data/models/base_model.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/services/business_service.dart';

/// A generic service class for performing CRUD operations in Firestore.
/// [T] must extend [BaseModel] and provide methods for JSON serialization and deserialization.
class FirebaseCRUDService<T extends BaseModel> {
  final String collectionName;
  final T Function(Map<String, dynamic>) fromJson;
  final bool isSubcollection;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // String? businessId;

  FirebaseCRUDService({
    required this.collectionName,
    required this.fromJson,
    this.isSubcollection = true,
  });

  // Get businessId dynamically each time
  String? get businessId => BusinessService.instance.businessId;

  /// Returns the appropriate collection reference depending on whether it's a subcollection.
  CollectionReference<Map<String, dynamic>> get collection {
    if (isSubcollection) {
      if (businessId == null) {
        throw FirebaseCRUDException("Collection", "BusinessID not available");
      }
      return _firestore
          .collection(Storage.businesses)
          .doc(businessId)
          .collection(collectionName);
    } else {
      return _firestore.collection(collectionName);
    }
  }

  Future<void> create(T model) async {
    try {
      await collection.doc(model.id).set({
        ...model.toJson(),
        'businessId': businessId,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } on FirebaseException catch (e) {
      throw FirebaseCRUDException("Create", e.message ?? "Unknown error");
    }
  }

  Future<T?> read(String id) async {
    try {
      final doc = await collection.doc(id).get();
      if (!doc.exists) return null;
      return fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw FirebaseCRUDException("Read", e.message ?? "Unknown error");
    }
  }

  Future<T?> readByName(String name) async {
    try {
      final querySnapshot =
          await collection.where('name', isEqualTo: name).get();
      if (querySnapshot.docs.isNotEmpty) {
        return fromJson(querySnapshot.docs.first.data());
      }
      return null;
    } on FirebaseException catch (e) {
      throw FirebaseCRUDException("ReadByName", e.message ?? "Unknown error");
    }
  }

  Future<List<T>?> readListById(String id) async {
    try {
      final filteredItems = <T>[];
      final filteredSnapshot =
          await collection.where('id', isEqualTo: id).get().then((snapshot) {
        for (int i = 0; i < snapshot.docs.length; i++) {
          if (snapshot.docs[i].data()['id'] == id) {
            filteredItems.add(fromJson(snapshot.docs[i].data()));
          }
        }
        return filteredItems;
      });
      return filteredSnapshot;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> update(String id,
      {Map<String, dynamic>? updates, T? model}) async {
    if (updates != null && model != null) {
      throw ArgumentError("Provide either updates or a model, not both.");
    }
    try {
      final updateData = updates ?? model!.toJson();
      await collection.doc(id).update({
        ...updateData,
        'updatedAt': DateTime.now().toIso8601String(),
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
    try {
      await _firestore.runTransaction((transaction) async {
        final docRef = collection.doc(id);
        final docSnapshot = await transaction.get(docRef);
        if (!docSnapshot.exists) {
          throw FirebaseCRUDException("Delete", "Document not found");
        }
        transaction.delete(docRef);
      });
    } on FirebaseException catch (e) {
      throw FirebaseCRUDException("SafeDelete", e.message ?? "Unknown error");
    }
  }

  DocumentReference<Map<String, dynamic>> getDocRef(String id) {
    try {
      return collection.doc(id);
    } catch (e) {
      throw FirebaseCRUDException("GetDocRef", "Doc Reference query failed");
    }
  }

  Stream<List<T>> streamAll() {
    return collection.orderBy('createdAt', descending: true).snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => fromJson(doc.data())).toList());
  }

  static Stream<List<T>> ensureMainThreadStream<T>(Stream<List<T>> stream) {
    return stream.asyncExpand((items) async* {
      if (kIsWeb) {
        yield items;
      } else {
        await Future(() {}); // Forces execution on main thread
        yield items;
      }
    }).handleError((e) {
      debugPrint("Stream error: $e");
      logger.e("Stream error: $e");
      return <T>[]; // Return empty list on error
    });
  }

  Stream<List<T>> list() => streamAll();

  Stream<List<T>> streamByField(String field, dynamic value) {
    return collection.where(field, isEqualTo: value).snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => fromJson(doc.data())).toList());
  }

  Future<List<T>> getPaginated({
    required int limit,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query<Map<String, dynamic>> query =
          collection.orderBy('createdAt', descending: true).limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) => fromJson(doc.data())).toList();
    } on FirebaseException catch (e) {
      throw FirebaseCRUDException("Pagination", e.message ?? "Unknown error");
    }
  }
}
