import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/data/datasource/repositories/product_repository.dart';
import 'package:shop_mate/data/models/products/product_model.dart';

class ProductServices {
  static final ProductServices _instance = ProductServices._internal();

  final ProductRepository _repo;

  ProductServices._internal() : _repo = ProductRepository();

  factory ProductServices() {
    return _instance;
  }

  Future<void> saveProduct(Product product) async {
    try {
      await _repo.createProduct(product);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  Future<void> updateProduct(
      String productId, Map<String, dynamic> updates) async {
    try {
      await _repo.updateProduct(productId, updates);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  Future<Product?> fetchProduct(String productId) async {
    try {
      return await _repo.fetchProduct(productId);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  Future<List<Product>> fetchProductsPaginated({
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      return await _repo.fetchProductsPaginated(
        limit: limit,
        lastDocument: lastDocument,
      );
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {

    try {
      await _repo.deleteProduct(productId);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }
}
