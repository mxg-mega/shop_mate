import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/data/datasource/repositories/product_repository.dart';
import 'package:shop_mate/data/models/inventory/inventory_item_model.dart';
import 'package:shop_mate/data/models/products/product_model.dart';
import 'package:shop_mate/services/business_service.dart';
import 'package:shop_mate/services/inventory_service.dart';
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
      // reference the inventory repo
      // call the get inventory items aanf filter those with the same product id
      // loop through the filtered list and make necessaru changes

      //==================================
      // if there are alternatives for looping throught the inventory sub collection in the firebase directly
      // to make those necessary changes
      // =================================
      // first get the updates that are related to the inventory from the product
      // the updates to the product are the ones that are related to the inventory
      // they are name, salesPrice, baseUnit and costPrice
      Map<String, dynamic> inventoryUpdates = {};
      if (updates['name'] != null) {
        inventoryUpdates.addAll({'name': updates['name']});
      }
      if (!updates['salesPrice']) {
        inventoryUpdates.addAll({'salesPrice': updates['salesPrice']});
      }
      if (!updates['baseUnit']) {
        inventoryUpdates.addAll({'baseUnit': updates['baseUnit']});
      }
      if (!updates['costPrice']) {
        inventoryUpdates.addAll({'costPrice': updates['costPrice']});
      }
      // =================================
      // okay get the collection reference for the inventory
      // then get the document reference for the product in the inventory
      // then update the inventory items from the updates done to the product
      // =================================
      final inventoryService = InventoryService();
      // get the collection reference for the inventory
      final inventoryItems = await inventoryService.collection
          .where('productId', isEqualTo: productId)
          .get()
          .then((snapshot) => snapshot.docs
              .map((doc) =>
                  InventoryItem.fromJson(doc.data() as Map<String, dynamic>))
              .toList());
      final filteredItems =
          inventoryItems.where((item) => item.productId == productId).toList();
      for (var item in filteredItems) {
        await inventoryService.updateInventoryItem(item.id, inventoryUpdates);
      }
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
      final inventoryService = InventoryService();

      // Check if any inventory items are associated with the product
      final inventoryItemsQuery = await inventoryService.collection
          .where('productId', isEqualTo: productId)
          .limit(1)
          .get();

      if (inventoryItemsQuery.docs.isNotEmpty) {
        throw Exception(
            'User cannot delete product that has a sales record or an inventory item associated to it');
      }

      // Check if any transactions are associated with the product
      // final transactions = await transactionService.fetchTransactionsByProductId(productId, limit: 1);
      // if (transactions.isNotEmpty) {
      //   throw Exception(
      //       'User cannot delete product that has a sales record or an inventory item associated to it');
      // }

      await _repo.deleteProduct(productId);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }
}
