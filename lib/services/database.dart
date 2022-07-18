import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;

  DatabaseService({ required this.uid });

  // collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String email, String username) async {
    return await userCollection.doc(uid).set({
      'id': uid,
      'email': email,
      'username': username,
    });       // if present then gets the document with the uid passed else creates the document with uid passed.
  }

  final CollectionReference customerCollection = FirebaseFirestore.instance.collection('customers');

  Future updateUserCustomers(Map<String, dynamic> child) async {
    return await customerCollection.doc(uid).set({
      'parentUid': uid,
      'children': [child],          // creating the children filed with list of Map<String, dynamic> child
    });
  }

  final CollectionReference transactionCollection = FirebaseFirestore.instance.collection('transactions');

  Future updateTransactions(List<Map<String, dynamic>> transaction, String childUid) async {  // supplying the child itself as List<Map<String, dynamic>>
    return await transactionCollection.doc(uid + childUid).set({
      'parNchildUid': uid + childUid,
      'trans': transaction,
    });
  }


}