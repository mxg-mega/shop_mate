import 'package:shop_mate/data/models/businesses/business_model.dart';
import 'package:shop_mate/data/models/users/user_model.dart';

class AuthSessionState {
  final AuthStatus status;
  final UserModel? user;
  final Business? business;
  final String? errorMessage;
  final bool? changeScreen;

  static final AuthSessionState _instance = AuthSessionState._(
    status: AuthStatus.authenticated,
  );
  factory AuthSessionState() => _instance;

  const AuthSessionState._({
    required this.status,
    this.user,
    this.business,
    this.errorMessage,
    this.changeScreen,
  });

  factory AuthSessionState.initial() =>
      const AuthSessionState._(status: AuthStatus.initial);

  factory AuthSessionState.loading() =>
      const AuthSessionState._(status: AuthStatus.loading);

  factory AuthSessionState.authenticated(UserModel user, Business business) =>
      AuthSessionState._(
        status: AuthStatus.authenticated,
        user: user,
        business: business,
      );

  factory AuthSessionState.unauthenticated() =>
      const AuthSessionState._(status: AuthStatus.unauthenticated);

  factory AuthSessionState.error(String message, {bool changeScreen = true}) => AuthSessionState._(
        status: AuthStatus.error,
        errorMessage: message,
        changeScreen: changeScreen,
      );
}

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}
