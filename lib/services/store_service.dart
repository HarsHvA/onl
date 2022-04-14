import 'package:cloud_firestore/cloud_firestore.dart';

class StoreService {
  final String uid;
  StoreService({required this.uid});

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, String email, bool premiumUser) async {
    return users.doc(uid).set({
      'Name': name,
      'Email': email,
      'PremiumUsers': premiumUser,
      'uid': uid,
    });
  }

  Future<bool> checkIfUserExists() async {
    final userDocRef = users.doc(uid);
    final doc = await userDocRef.get();
    if (doc.exists) {
      return true;
    }
    return false;
  }
}
