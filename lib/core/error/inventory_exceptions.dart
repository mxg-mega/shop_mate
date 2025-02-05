
class InventoryException implements Exception {
  final String message;
  final String? code;

  InventoryException(this.message, {this.code});

  @override
  String toString() => 'InventoryException: $message${code != null ? ' (Code: $code)' : ''}';
}

// Add more specific exception types
class InsufficientStockException extends InventoryException {
  final String productId;
  final double requested;
  final double available;

  InsufficientStockException(this.productId, this.requested, this.available) : super(
    'Insufficient stock for product $productId: requested $requested, available $available',
    code: 'INSUFFICIENT_STOCK',
  );

  @override
  String toString() =>
      'Insufficient stock for product $productId: requested $requested, available $available';
}

