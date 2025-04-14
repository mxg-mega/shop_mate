import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_mate/core/error/error_toaster.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/data/datasource/local/business_storage.dart';
import 'package:shop_mate/data/models/inventory/inventory_item_model.dart';
import 'package:shop_mate/data/models/inventory/inventory_model.dart';
import 'package:shop_mate/data/models/products/product_model.dart';
import 'package:shop_mate/services/business_service.dart';
import 'package:shop_mate/services/firebase_CRUD_service.dart';
import 'package:shop_mate/services/inventory_service.dart';
import 'package:shop_mate/services/product_services.dart';

class InventoryProvider extends ChangeNotifier {
  bool isLoading = false;
  String errorMessage = '';
  Inventory _inventory = Inventory(items: []);
  List<InventoryItem> get inventoryItems => _inventory.items;
  final services = InventoryService();
  final productServices = ProductServices();
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

  void _createStream() {
    _inventoryStream = FirebaseCRUDService.ensureMainThreadStream(
        services.streamInventoryItems());

    _streamSub = _inventoryStream!.listen((items) {
      _inventory.items = items;
      notifyListeners();
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

  void updateItem(InventoryItem update) async {
    isLoading = true;
    notifyListeners();
    try {
      await Future(
          () => services.updateInventoryItem(update.id, update.toJson()));
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

  Future<void> createInventoryItem(InventoryItem item) async {
    isLoading = true;
    notifyListeners();
    try {
      await Future(() => services.createInventoryItem(item));
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

  Future<void> saveProduct(Product product) async {
    isLoading = true;
    notifyListeners();
    try {
      await productServices.saveProduct(product);
      ErrorNotificationService.showErrorToaster(
        message: 'Successfully saved Product',
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

  void deleteInventoryItem(InventoryItem item) {
    _inventory.removeItem(item.id, item.location!);
    notifyListeners();
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
      //   BusinessStorage.getBusinessProfile()!.id,
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
}
