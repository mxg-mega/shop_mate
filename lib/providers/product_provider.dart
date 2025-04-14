import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/core/error/error_toaster.dart';
import 'package:shop_mate/core/error/product_exceptions.dart';
import 'package:shop_mate/data/models/products/product_model.dart';
import 'package:shop_mate/services/product_services.dart';

class ProductProvider extends ChangeNotifier {
  final ProductServices _productService = ProductServices();
  
  List<Product> _allProducts = [];
  List<Product> _currentPageProducts = [];
  bool _isLoadingMore = false;
  bool _hasMoreProducts = true;
  DocumentSnapshot? _lastDocument;
  int _currentPage = 1;

  List<Product> get products => _searchQuery.isEmpty ? _currentPageProducts : _searchResults;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMoreProducts => _hasMoreProducts;
  String get searchQuery => _searchQuery;

  List<Product> _searchResults = [];
  String _searchQuery = '';


  Future<void> searchProducts(String query) async {
    _searchQuery = query;
    if (query.isEmpty) {
      _searchResults = [];
    } else {
      _searchResults = _allProducts.where((product) =>
        product.name.toLowerCase().contains(query.toLowerCase()) ||
        (product.description?.toLowerCase().contains(query.toLowerCase()) ?? false)
      ).toList();
    }
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }

  Future<void> fetchInitialProducts() async {

    try {
      _resetPagination();
      final products = await _productService.fetchProductsPaginated(limit: 20);
      
      if (products.isNotEmpty) {
        _allProducts = products;
        _currentPageProducts = products;
        notifyListeners();
      }
    } catch (e) {
      ErrorNotificationService.showErrorToaster(message: e.toString());
      rethrow;
    }
  }

  Future<void> loadMoreProducts() async {
    if (_isLoadingMore || !_hasMoreProducts) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final newProducts = await _productService.fetchProductsPaginated(
        limit: 20,
        lastDocument: _lastDocument,
      );

      if (newProducts.isEmpty) {
        _hasMoreProducts = false;
      } else {
        _allProducts.addAll(newProducts);
        _currentPageProducts = _allProducts;
        _currentPage++;
        notifyListeners();
      }
    } catch (e) {
      ErrorNotificationService.showErrorToaster(message: e.toString());
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void _resetPagination() {
    _allProducts = [];
    _currentPageProducts = [];
    _isLoadingMore = false;
    _hasMoreProducts = true;
    _lastDocument = null;
    _currentPage = 1;
  }

  Future<Product> fetchProduct(String id) async {
    try {
      if (id.isEmpty) {
        throw ProductException('Failed to Fetch Product', code: 'Fetching-Failed');
      }
      final product = await _productService.fetchProduct(id);
      if (product == null) {
        throw ProductException('Error Occurred During fetching Product', code: 'Fetching-Failed');
      }
      return product;
    } catch (e) {
      ErrorNotificationService.showErrorToaster(message: e.toString());
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await _productService.saveProduct(product);
      _allProducts.insert(0, product);
      _currentPageProducts = _allProducts;
      notifyListeners();
    } catch (error) {
      ErrorNotificationService.showErrorToaster(message: error.toString());
    }
  }

  Future<void> updateProduct(String productId, Product product) async {
    try {
      await _productService.updateProduct(productId, product.toJson());
      final index = _allProducts.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _allProducts[index] = product;
        _currentPageProducts = _allProducts;
        notifyListeners();
      }
    } catch (error) {
      ErrorNotificationService.showErrorToaster(message: error.toString());
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _productService.deleteProduct(productId);
      _allProducts.removeWhere((p) => p.id == productId);
      _currentPageProducts = _allProducts;
      notifyListeners();
    } catch (error) {
      ErrorNotificationService.showErrorToaster(message: error.toString());
    }
  }
}
