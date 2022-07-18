import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment_handler/models/user_model.dart';

import 'database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> _userFromUser(User userHere) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(userHere.uid);
    final snapshot = await docUser.get();
    return UserModel( id: snapshot.data()!['id'], email: snapshot.data()!['email'], username: snapshot.data()!['username']);
  }


  // register with email and password
  Future<String> registerWithEmailAndPassword(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      // create a new document for the user in firestore with his uid
      await DatabaseService(uid: user!.uid).updateUserData(user.email!, username);
      // await DatabaseService(uid: user.uid).updateUserCustomers();

      // return user;
      _userFromUser(user);
      return "Registered userrrrrr";
    } catch(e) {
      return e.toString();
    }
  }


  // sign in with email & password
  Future<String> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      // return user;
      _userFromUser(user!);
      return "Logged in";
    } catch(e) {
      return e.toString();
    }
  }

  // auth change user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // GET UID
  // Future<String> getCurrentUID() async {
  //   return _auth.currentUser!.uid;
  // }

  // logout
  Future<String> logoutFromHere() async {
    try {
      await _auth.signOut();
      return "Logged out";
    } catch(e) {
      return 'Couldn\'t log out';
    }
  }

}