class FirebaseCRUDException implements Exception {
  final String operation;
  final String message;

  FirebaseCRUDException(this.operation, this.message);

  @override
  String toString() => "FirebaseCRUD: $operation failed: $message";
}

class AuthException implements Exception{
  final String operation;
  final String message;

  AuthException(this.operation, this.message);

  @override
  String toString() => "Authentication Service: $operation failed: $message";
}

class SessionException implements Exception{
  final String operation;
  final String message;

  SessionException(this.operation, this.message);

  @override
  String toString() => "Session Provider: $operation failed: $message";
}
