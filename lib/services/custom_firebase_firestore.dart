import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../configs/app_configs.dart';


class CustomFirebaseFireStore {
  static FirebaseFirestore get database {
    if(!AppConfigs.demoDatabase) {
      return FirebaseFirestore.instance;
    }
    return FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: "demo");
  }

  // static Future<void> copyCollectionFromDefaultToOtherDatabase(String collectionPath) async {
  //   FirebaseFirestore defaultFirestore = FirebaseFirestore.instance;
  //   FirebaseFirestore demoFirestore = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'demo');
  //   QuerySnapshot querySnapshot = await defaultFirestore.collection(collectionPath).get();
  //
  //   print(querySnapshot.docs.length);
  //   int i = 1;
  //   for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
  //
  //     Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
  //     print('percent: ${i++ * 100~/ querySnapshot.docs.length}%');
  //     await demoFirestore.collection(collectionPath).doc(documentSnapshot.id).set(data, SetOptions(merge: true));
  //   }
  //   print('Sao chép collection thành công!');
  // }
}