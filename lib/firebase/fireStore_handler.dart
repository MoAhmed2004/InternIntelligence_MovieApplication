
import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/user.dart';

class FireStoreHandler{
  static CollectionReference<User> getUserCollection() {
    return FirebaseFirestore.instance
        .collection('users')
        .withConverter<User>(
      fromFirestore: (snapshot, _) => User.fromFireStore(snapshot.data()!),
      toFirestore: (user, _) => user.tofireStore(),
    );
  }
  static Future<void> createUser(User user) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(user.id)
        .set(user.tofireStore());
  }

  static Future<User?> getUser(String uid) async {
    var docSnap = await getUserCollection().doc(uid).get();
    return docSnap.data();
  }
  static Future<void> updateUserName(String uid, String name) async {
    return FirebaseFirestore.instance.collection("users").doc(uid).update({
      "name": name,
    });
  }

}