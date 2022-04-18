import 'package:firebase_auth/firebase_auth.dart';
import '../services/store_service.dart';
import 'package:onl/services/store_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?>? get user =>
      _firebaseAuth.authStateChanges().map((User? user) => user);

// Email and password signUP
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name, bool isTeacher) async {
    final currentUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    //update the name
    await _firebaseAuth.currentUser!.updateDisplayName(name);
    await currentUser.user!.reload();
    await StoreService(uid: currentUser.user!.uid)
        .updateUserData(name, email, isTeacher);
    return currentUser.user!.uid;
  }

  String uID() {
    final User? user = _firebaseAuth.currentUser;
    final uid = user!.uid;
    return uid;
  }

// SignIn
  Future<String> signIn(String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user!
        .uid;
  }

  signOut() {
    _firebaseAuth.signOut();
  }

  Future sendPasswordResetEmail(String email) async {
    return await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<String?> username() async {
    try {
      User? user = _firebaseAuth.currentUser;
      String? name = user!.displayName;
      return name;
    } catch (e) {
      return null;
    }
  }
}
