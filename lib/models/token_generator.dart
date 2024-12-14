import 'dart:math';

String generateToken() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  return List.generate(32, (index) => chars[Random().nextInt(chars.length)]).join();
}