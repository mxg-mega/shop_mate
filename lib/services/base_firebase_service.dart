import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_mate/core/utils/constants.dart';
import '../models/base_model.dart';

abstract class BaseFirebaseService<T extends BaseModel> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String businessId;
  final bool isSubCollection;

  BaseFirebaseService({required this.businessId,this.isSubCollection = true,});

  // Abstract methods that must be implemented
  String get collectionName;
  T fromJson(Map<String, dynamic> json);

  // Get the appropriate collection reference based on pattern
  CollectionReference<Map<String, dynamic>> get collection {
    if (isSubCollection) {
      return _firestore
          .collection(Storage.businesses)
          .doc(businessId)
          .collection(collectionName);
    } else {
      return _firestore.collection(collectionName);
    }
  }

  // Enable offline persistence for subscribed businesses
  Future<void> enableOfflinePersistence(bool enabled) async {
    FirebaseFirestore.instance.settings = Settings(
      persistenceEnabled: enabled,
      cacheSizeBytes: enabled ? Settings.CACHE_SIZE_UNLIMITED : 0,
    );
  }

  // CRUD Operations
  Future<void> create(T model) async {
    try {
      final data = {
        ...model.toJson(),
        'businessId': businessId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      await collection.doc(model.id).set(data);
      // Cache the data locally if persistence is enabled
      if (await _isPersistenceEnabled()) {
        await _cacheItem(model.id, data);
      }
    } catch (e) {
      throw Exception("Create operation failed: $e");
    }
  }

  Future<bool> _isPersistenceEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('persistence_enabled_$businessId') ?? false;
  }

  Future<void> _cacheItem(String id, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cache_${collectionName}_${businessId}_$id',
        jsonEncode(data));
  }

  Future<Map<String, dynamic>?> _getCachedItem(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('cache_${collectionName}_${businessId}_$id');
    return cached != null ? jsonDecode(cached) : null;
  }

  Future<T?> read(String id) async {
    try {
      // if (!await _hasConnectivity() && await _isPersistenceEnabled()){
      if (await _isPersistenceEnabled()){
        final cachedData = _getCachedItem(id);

        return fromJson(cachedData as Map<String, dynamic>);
      }
      final doc = await collection.doc(id).get();
      if (!doc.exists){
        return null;
      }
      if (await _isPersistenceEnabled()) {
        await _cacheItem(id, doc.data()!);
      }

      return fromJson(doc.data()!);
    } catch (e) {
      throw Exception("Read operation failed: $e");
    }
  }

  Future<void> update(String id, Map<String, dynamic> updates) async {
    try {
      await collection.doc(id).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Update operation failed: $e");
    }
  }

  Future<void> delete(String id) async {
    try {
      await collection.doc(id).delete();
    } catch (e) {
      throw Exception("Delete operation failed: $e");
    }
  }

  Stream<List<T>> streamAll() {
    return collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => fromJson(doc.data())).toList());
  }

  Future<List<T>> getPaginated({
    required int limit,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      var query = collection
          .orderBy('createdAt', descending: true)
          .limit(limit);

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