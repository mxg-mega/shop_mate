import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/models/users/user_model.dart';
import 'package:shop_mate/services/firebase_services.dart';

class UserServices {
  final MyFirebaseService<UserModel> _firebaseService =
      MyFirebaseService<UserModel>(
    collectionName: Storage.users,
    fromJson: (data) => UserModel.fromJson(data),
  );

  Future<void> storeUser(UserModel user) async {
    try {
      logger.d("Saving .....");
      // await _firebaseService.create(user);
      await FirebaseFirestore.instance
          .collection(Storage.users)
          .doc(user.id)
          .set(user.toJson());
      logger.d("Saved!!!");
    } on FirebaseException catch (e) {
      throw Exception(
          "Failed to store user: ${e.toString()}\n by UserServices.");
    }
  }

  Future<UserModel> updateUserInfo(
      String userID, Map<String, dynamic> updates) async {
    try {
      await FirebaseFirestore.instance
          .collection(Storage.users)
          .doc(userID)
          .update(updates);
      final userModel = await _firebaseService.read(userID);
      if (userModel == null){
        throw Exception("Could not get the user");
      }
      return userModel;
    } on FirebaseException catch (e) {
      throw Exception("Failed to save user updates: ${e.toString()}");
    }
  }

  Future<UserModel?> getUserData(String id) async {
    return await _firebaseService.read(id);
  }

  Future<UserModel?> fetchUserModel(String id) async {
    try{
      final userDoc = await FirebaseFirestore.instance.collection(Storage.users).doc(id).get();
      if (userDoc.exists){
        final userJson = userDoc.data();
        return UserModel.fromJson(userJson!);
      }
    }
    catch (e){
      logger.e("Failed to get user...");
      return null;
    }
  }
}
