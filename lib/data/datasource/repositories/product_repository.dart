import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_mate/core/error/product_exceptions.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/data/models/products/product_model.dart';
import 'package:shop_mate/services/business_service.dart';
import 'package:shop_mate/services/firebase_CRUD_service.dart';

class ProductRepository {
  static final ProductRepository _instance = ProductRepository._internal();
  factory ProductRepository() => _instance;

  final FirebaseCRUDService<Product> _crudService;
  final BusinessService _businessService = BusinessService.instance;

  ProductRepository._internal()
      : _crudService = FirebaseCRUDService<Product>(
          collectionName: Storage.products,
          fromJson: (data) => Product.fromJson(data),
        ) {
    final businessId = BusinessService.instance.businessId;
    if (businessId == null) {
      throw ProductException('No business selected', code: 'no-business');
    }
  }

  CollectionReference getCollection() {
    return _crudService.collection;
  }

  Future<List<Product>> getAllProducts() async {
    try {
      // TODO: you can change this later to get all product
      // or implement the pagination in UI
      final response = _crudService.getPaginated(limit: 100);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createProduct(Product product) async {
    try {
      await _crudService.create(product);
    } catch (e) {
      logger.e('Error creating product: $e');
      rethrow;
    }
  }

  Future<void> updateProduct(
      String productId, Map<String, dynamic> updates) async {
    try {
      await _crudService.update(productId, updates: updates);
    } catch (e) {
      logger.e('Error updating product: $e');
      rethrow;
    }
  }

  Future<Product?> fetchProduct(String productId) async {
    try {
      final response = await _crudService.read(productId);
      return response;
    } catch (e) {
      logger.e('Error fetching Product: $e');
      rethrow;
    }
  }

  Future<Product?> fetchProductByName(String name) async {
    try {
      final querySnapshot = await _crudService.collection
          .where('name', isEqualTo: name)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return Product.fromJson(querySnapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      logger.e('Error fetching Product by name: $e');
      rethrow;
    }
  }

  Future<List<Product>> fetchProductsPaginated({
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _crudService.collection.orderBy('name').limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) {
        debugPrint('Product: ${doc.data()}');
        return Product.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      logger.e('Error fetching paginated products: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _crudService.delete(productId);
    } catch (e) {
      logger.e('Error deleting Product: $e');
      rethrow;
    }
  }
}
