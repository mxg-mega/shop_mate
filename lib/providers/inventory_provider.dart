import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shop_mate/core/error/error_toaster.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/data/models/inventory/inventory_item_model.dart';
import 'package:shop_mate/data/models/inventory/inventory_model.dart';
import 'package:shop_mate/services/business_service.dart';
import 'package:shop_mate/services/firebase_CRUD_service.dart';
import 'package:shop_mate/services/inventory_service.dart';
import 'package:shop_mate/services/product_services.dart';
import 'package:shop_mate/services/transaction_service.dart';

class InventoryProvider extends ChangeNotifier {
  bool isLoading = false;
  String errorMessage = '';
  Inventory _inventory = Inventory(items: []);
  List<InventoryItem> get inventoryItems => _inventory.items;
  final services = InventoryService();
  StreamSubscription? _streamSub;
  StreamSubscription? get streamSub => _streamSub;
  Stream<List<InventoryItem>>? _inventoryStream;

  // Add this to track the current business ID
  String? _currentBusinessId;

  Stream<List<InventoryItem>> get inventoryStream {
    final businessId = BusinessService.instance.businessId;

    // If business ID changed or stream is null, recreate the stream
    if (_inventoryStream == null || businessId != _currentBusinessId) {
      _currentBusinessId = businessId;
      _disposeStream();
      _createStream();
    }

    return _inventoryStream!;
  }

  Timer? _debounceTimer;
  final Set<String> _pendingProductStockUpdates = {};

  void _createStream() {
    _inventoryStream = FirebaseCRUDService.ensureMainThreadStream(
        services.streamInventoryItems());

    _streamSub = _inventoryStream!.listen((items) {
      _inventory.items = items;
      notifyListeners();

      // Collect productIds that need stock quantity update
      for (var item in items) {
        _pendingProductStockUpdates.add(item.productId);
      }

      // Debounce the stock quantity updates to batch them
      _debounceTimer?.cancel();
      _debounceTimer = Timer(Duration(milliseconds: 500), () async {
        final productIdsToUpdate =
            Set<String>.from(_pendingProductStockUpdates);
        _pendingProductStockUpdates.clear();

        for (var productId in productIdsToUpdate) {
          await _updateProductStockQuantity(productId);
        }
      });
    }, onError: (error) {
      print('Inventory stream error: $error');
      _inventory.items = [];
      notifyListeners();
    });
  }

  void _disposeStream() {
    _streamSub?.cancel();
    _streamSub = null;
    _inventoryStream = null;
  }

  void initStream() {
    if (_inventoryStream != null) return;
    _createStream();
  }

  // Reset the provider state when logging out
  void reset() {
    _disposeStream();
    _inventory.items = [];
    _currentBusinessId = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposeStream();
    _inventory.items = [];
    print('disposed provider');
    notifyListeners();
    super.dispose();
  }

  set inventory(Inventory inventory) {
    _inventory = inventory;
  }

  Inventory get inventory => _inventory;

//   void addInventory(InventoryItem item) {
//   _inventory = _inventory.copyWith(items: [..._inventory.items, item]);
//   notifyListeners();
// }

  void removeInventory({required InventoryItem item, String? location}) {
    _inventory.removeItem(item.productId, location ?? item.location!);
    notifyListeners();
  }

  Future<void> updateItem(InventoryItem update) async {
    isLoading = true;
    notifyListeners();
    try {
      await Future(
          () => services.updateInventoryItem(update.id, update.toJson()));

      // After updating inventory item, update product stock quantity
      await _updateProductStockQuantity(update.productId);

      // Create transaction for inventory item update
      await _createTransactionForInventoryChange(
        inventoryItemId: update.id,
        productId: update.productId,
        quantity: update.quantity,
        notes: 'Inventory item updated',
      );

      ErrorNotificationService.showErrorToaster(
        message: 'Successfully Updated Product',
      );
    } catch (e) {
      ErrorNotificationService.showErrorToaster(
          message: e.toString(), isDestructive: true);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createInventoryItem(
    InventoryItem item, {
    bool isProductCreation = false,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      logger.d('ITem Being Created:\n ${item.toJson()}');
      await Future(() => services.createInventoryItem(item));

      if (isProductCreation == false) {
        // After creating inventory item, update product stock quantity
        await _updateProductStockQuantity(item.productId);
      }

      // Create transaction for inventory item creation
      // await _createTransactionForInventoryChange(
      //   inventoryItemId: item.id,
      //   productId: item.productId,
      //   quantity: item.quantity,
      //   notes: 'Inventory item created',
      // );

      ErrorNotificationService.showErrorToaster(
        message: 'Successfully registered Product',
      );
    } catch (e) {
      ErrorNotificationService.showErrorToaster(
          message: e.toString(), isDestructive: true);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  InventoryItem getInventoryItemById(String productId) {
    return _inventory.items.firstWhere(
      (item) => item.productId == productId,
      orElse: () => throw Exception('Item not found'),
    );
  }

  Future<void> deleteInventoryItem(InventoryItem item) async {
    isLoading = true;
    notifyListeners();
    try {
      await services.deleteInventoryItem(item.id);

      // After deleting inventory item, update product stock quantity
      await _updateProductStockQuantity(item.productId);

      final inventoryItemIndex =
          _inventory.items.indexWhere((i) => i.id == item.id);
      if (inventoryItemIndex != -1) {
        _inventory.items.removeAt(inventoryItemIndex);
      }
      ErrorNotificationService.showErrorToaster(
        message: 'Successfully deleted Inventory Item',
      );
    } catch (e) {
      ErrorNotificationService.showErrorToaster(
          message: e.toString(), isDestructive: true);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Saves the Current State of the inventory to firebase
  void saveInventory() {
    // TODO: Implement this
  }

  Future<void> fetchInventoryItems() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await services.getInventoryItemsPaginated(
        limit: 20,
        startAfter: null,
      );
      print('${response.map(
            (e) => e.toJson(),
          ).toList()}');
      _inventory.items = response;
      // final response = await services.getInventoryTransactions(
      //   BusinessService.instance.businessId,
      //   DateTime.now(),
      // );
      // _inventory = response;
      ErrorNotificationService.showErrorToaster(
          message: 'Successfully Fetched Inventory Items');
    } catch (e) {
      print(e);
      ErrorNotificationService.showErrorToaster(
          message: e.toString(), isDestructive: true);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  double getLocationStock(String location) {
    final itemsAtLocation =
        _inventory.items.where((item) => item.location == location);
    final totalQuantity =
        itemsAtLocation.fold<double>(0, (sum, item) => sum + item.quantity);
    return totalQuantity;
  }

  Future<void> _updateProductStockQuantity(String productId) async {
    try {
      final productService = ProductServices();
      final product = await productService.fetchProduct(productId);
      if (product == null) {
        throw Exception('Product not found');
      }

      final totalQuantity = _inventory.items
          .where((item) => item.productId == productId)
          .fold<double>(0, (sum, item) => sum + item.quantity);

      logger.d('${inventoryItems.length}');

      // Update product stock quantity
      // is it possible to get the inventory items with the same product id of the product using the stream ?
      // inventoryStream.listen((items) async {});
      // inventoryStream.first.then((items) async {
      //   final totalQuantity = items
      //       .where((item) => item.productId == productId)
      //       .fold<double>(0, (sum, item) => sum + item.quantity);
      //   await productService
      //       .updateProduct(productId, {'stockQuantity': totalQuantity});
      //   ErrorNotificationService.showErrorToaster(
      //     message: 'Successfully updated Product Stock Quantity',
      //   );
      // }).catchError((error) {
      //   print('Error fetching inventory items: $error');
      // }).whenComplete(() {
      //   print('Stream completed');
      // });

      //       final totalQuantity = items
      //     .where((item) => item.productId == productId)
      //     .fold<double>(0, (sum, item) => sum + item.quantity);
      await productService
          .updateProduct(productId, {'stockQuantity': totalQuantity});
      ErrorNotificationService.showErrorToaster(
        message: 'Successfully updated Product Stock Quantity',
      );

      // await productService
      //     .updateProduct(productId, {'stockQuantity': totalQuantity});
    } catch (e) {
      print('Error updating product stock quantity: $e');
    }
  }

  Future<void> _createTransactionForInventoryChange({
    required String inventoryItemId,
    required String productId,
    required double quantity,
    required String notes,
  }) async {
    try {
      final transactionService = TransactionService();
      await transactionService.createTransactionForInventoryItemCreation(
        businessId: BusinessService.instance.businessId!,
        inventoryItemId: inventoryItemId,
        productId: productId,
        quantity: quantity,
        notes: notes,
      );
    } catch (e) {
      print('Error creating transaction: $e');
    }
  }

  // double getLocationStock(String location) {
  //   // Filter inventory items by location and sum their quantities
  //   final itemsAtLocation =
  //       _inventory.items.where((item) => item.location == location);
  //   final totalQuantity =
  //       itemsAtLocation.fold<double>(0, (sum, item) => sum + item.quantity);
  //   return totalQuantity;
  // }

  // Future<void> _updateProductStockQuantity(String productId) async {
  //   try {
  //     final productService = ProductServices();
  //     final product = await productService.fetchProduct(productId);
  //     if (product == null) {
  //       throw Exception('Product not found');
  //     }
  //     // Calculate total quantity from inventory items
  //     final totalQuantity = _inventory.items
  //         .where((item) => item.productId == productId)
  //         .fold<double>(0, (sum, item) => sum + item.quantity);
  //     // Update product stock quantity
  //     await productService.updateProduct(productId, {'stockQuantity': totalQuantity});
  //   } catch (e) {
  //     print('Error updating product stock quantity: $e');
  //   }
  // }

  // Future<void> _createTransactionForInventoryChange({
  //   required String inventoryItemId,
  //   required String productId,
  //   required double quantity,
  //   required String notes,
  // }) async {
  //   try {
  //     // Import TransactionService at the top of the file
  //     // import 'package:shop_mate/services/transaction_service.dart';
  //     final transactionService = TransactionService();
  //     await transactionService.createTransactionForInventoryItemChange(
  //       inventoryItemId: inventoryItemId,
  //       productId: productId,
  //       quantity: quantity,
  //       notes: notes,
  //     );
  //   } catch (e) {
  //     print('Error creating transaction: $e');
  //   }
  // }

//   Future<void> _updateProductStockQuantity(String productId) async {
//     try {
//       final productService = ProductServices();
//       final product = await productService.fetchProduct(productId);
//       if (product == null) {
//         throw Exception('Product not found');
//       }
//       // Calculate total quantity from inventory items
//       final totalQuantity = _inventory.items
//           .where((item) => item.productId == productId)
//           .fold<double>(0, (sum, item) => sum + item.quantity);
//       // Update product stock quantity
//       await productService.updateProduct(productId, {'stockQuantity': totalQuantity});
//     } catch (e) {
//       print('Error updating product stock quantity: $e');
//     }
//   }

  // Future<void> _createTransactionForInventoryChange({
  //   required String inventoryItemId,
  //   required String productId,
  //   required double quantity,
  //   required String notes,
  // }) async {
  //   try {
  //     final transactionService = TransactionService();
  //     await transactionService.createTransactionForInventoryItemChange(
  //       inventoryItemId: inventoryItemId,
  //       productId: productId,
  //       quantity: quantity,
  //       notes: notes,
  //     );
  //   } catch (e) {
  //     print('Error creating transaction: $e');
  //   }
  // }
}
