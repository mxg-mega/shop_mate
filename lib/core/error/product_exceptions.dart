class ProductException implements Exception {
  final String message;
  final String code;

  ProductException(this.message, {required this.code});

  @override
  String toString() => 'ProductException: $message (code: $code)';
}
