
class InventoryItem {
  final double productId;
  final String productName;
  final int productQuantity;

  const InventoryItem({
    required this.productId,
    required this.productName,
    required this.productQuantity,
  });

  void convertToJson(InventoryItem item) {
    print("${item.toString()}");
  }
}
