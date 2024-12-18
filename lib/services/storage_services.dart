import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageServices {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a file to Firebase Storage and returns its URL.
  Future<String> uploadProfilePicture(File file, String userID) async {
    try {
      final ref = _storage.ref().child('profilePictures/$userID.jpg');
      await ref.putFile(file);
      return ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }

  /// Gets the default profile picture URL.
  Future<String> getDefaultProfilePicture() async {
    try {
      final ref = _storage.ref().child('profilePictures/default.jpg');
      return ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to fetch default profile picture: $e');
    }
  }
}
