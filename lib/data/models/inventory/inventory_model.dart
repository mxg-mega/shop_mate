import 'package:shop_mate/data/models/inventory/inventory_item_model.dart';

enum InventoryStatus {
  inStock,
  lowStock,
  onOrder,
  outOfStock,
}

class Inventory {
  List<InventoryItem> items;

  Inventory({required this.items});

  double get averageValue {
    return items.fold(0.0, (sum, item) => sum + item.salesPrice) / items.length;
  }

  double get totalInventoryValue {
    return items.fold(
        0.0, (sum, item) => sum + (item.quantity * item.costPrice));
  }

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        items: (json['items'] as List<dynamic>)
            .map((item) => InventoryItem.fromJson(item))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'items': items.map((item) => item.toJson()).toList(),
      };

  // Method to update inventory item quantity
  // void updateQuantity(String productId, String location, int quantity) {
  //   final item = items.firstWhere(
  //     (item) => item.productId == productId && item.location == location,
  //     orElse: () => InventoryItem.defaultItem(),
  //   );
  //   if (item != InventoryItem.defaultItem()) {
  //     item.quantity = quantity;
  //     item.lastUpdated = DateTime.now();
  //     item.status = _calculateStatus(quantity);
  //   }
  // }

  // Method to update inventory item quantity
  void updateQuantity(String productId, String location, double quantity) {
    try {
      final item = items.firstWhere(
        (item) => item.productId == productId && item.location == location,
      );
      item.quantity = quantity;
      item.lastUpdated = DateTime.now();
      item.status = _calculateStatus(quantity.toInt());
    } catch (e) {
      throw Exception(
          'The inventory item you are trying to update does not exists');
    }
  }

  // Method to add a new inventory item
  void addItem(InventoryItem item) {
    items.add(item);
  }

  // Method to remove an inventory item
  void removeItem(String productId, String location) {
    items.removeWhere(
      (item) => item.productId == productId && item.location == location,
    );
  }

  // Method to calculate the inventory status based on quantity
  static InventoryStatus _calculateStatus(int quantity) {
    if (quantity <= 0) {
      return InventoryStatus.outOfStock;
    } else if (quantity < 10) {
      return InventoryStatus.lowStock;
    } else {
      return InventoryStatus.inStock;
    }
  }
}
