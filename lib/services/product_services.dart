import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/data/datasource/repositories/product_repository.dart';
import 'package:shop_mate/data/models/products/product_model.dart';
import 'package:shop_mate/services/business_service.dart';
import 'package:shop_mate/services/transaction_service.dart';

class ProductServices {
  static final ProductServices _instance = ProductServices._internal();

  final ProductRepository _repo;

  ProductServices._internal() : _repo = ProductRepository();

  factory ProductServices() {
    return _instance;
  }

  Future<List<Product>> fetchAllProducts() async {
    try {
      final response = await _repo.getAllProducts();
      return response;
    } catch (e) {
      throw Exception('Could not fetch Products');
    }
  }
  Future<Product?> fetchProductById(String productId) async {
    try {
      return await _repo.fetchProduct(productId);
    } catch (e) {
      throw Exception('Could not fetch Product');
    }
  }

  Future<Product?> fetchProductByName(String productName) async {
    try {
      return await _repo.fetchProductByName(productName);
    } catch (e) {
      throw Exception('Could not fetch Product');
    }
  }

  Future<void> saveProduct(Product product) async {
    try {
      await _repo.createProduct(product);
      // Create transaction for product creation
      final transactionService = TransactionService();
      await transactionService.createTransactionForProductCreation(
        productId: product.id,
        businessId: BusinessService.instance.currentBusiness?.id ?? '',
        productName: product.name,
        quantity: product.stockQuantity,
      );
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
