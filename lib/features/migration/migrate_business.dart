import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/core/utils/constants.dart';

Future<void> migrateBusiness() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference businessCollection = firestore.collection(Storage.businesses);

  // Retrieve all documents in the business collection
  QuerySnapshot querySnapshot = await businessCollection.get();

  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    // Update each document to include the new field
    await businessCollection.doc(doc.id).update({
      'locations': ["Store", "Warehouse"], // Set default value for the new field
    });
  }

  print('Migration completed: New field added to all business.');
}

void main() async {
  await migrateBusiness();
}