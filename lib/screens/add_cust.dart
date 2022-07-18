import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:payment_handler/models/user_model.dart';

import '../services/database.dart';


class AddCustomers extends StatelessWidget {
  AddCustomers({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;        // this one is the user who's logged in


  @override
  Widget build(BuildContext context) {


    Stream<List<UserModel>> readUsers() =>
      FirebaseFirestore.instance.collection('users').snapshots()      // getting all the snapshots
          .map((snapshot) =>                                          // mapping each snapshot, to read all the docs in the snapshot
      snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());   // mapping all the docs to get UserModel out of each doc


    void clickedCustomer(UserModel customer) async {
      print('tapped ${customer.username}');

      Map<String, dynamic> child = {
        'childId': customer.id,
        'childName': customer.username,
        'amountDue': 0,
      };

      final docCustomer = FirebaseFirestore.instance.collection('customers').doc(user.uid);
      final snapshot = await docCustomer.get();

      // if there exists such a document in customers collection then update the List of children
      if(snapshot.exists) {
        // List<dynamic> currentCustomers = snapshot.data()!['childrenUid'];
        // var type = snapshot.data()!['children'].runtimeType;
        // print(type);
        List<dynamic> currentCustomers = snapshot.data()!['children'];
        currentCustomers.add(child);
        docCustomer.update({
          'children': currentCustomers,
        });
        // print(snapshot.data()!['childrenUid']);
        // print(currentCustomers);
      } else {        // else create the document first with the clicked child.
        await DatabaseService(uid: user.uid).updateUserCustomers(child);
      }
    }


    Widget buildUser(UserModel customer) =>
      GestureDetector(
        onTap: () async {

          // clickedCustomer(customer);
          print('tapped ${customer.username}');

          Map<String, dynamic> child = {
            'childId': customer.id,
            'childName': customer.username,
            'amountDue': 0,
          };

          final docCustomer = FirebaseFirestore.instance.collection('customers').doc(user.uid);
          final snapshot = await docCustomer.get();

          // if there exists such a document in customers collection then update the List of children
          if(snapshot.exists) {
            // List<dynamic> currentCustomers = snapshot.data()!['childrenUid'];
            // var type = snapshot.data()!['children'].runtimeType;
            // print(type);
            List<dynamic> currentCustomers = snapshot.data()!['children'];
            currentCustomers.add(child);
            await docCustomer.update({
              'children': currentCustomers,
            });
            // print(snapshot.data()!['childrenUid']);
            // print(currentCustomers);
          } else {        // else create the document first with the clicked child.
            await DatabaseService(uid: user.uid).updateUserCustomers(child);
          }
          Navigator.pop(context);

        },
        child: ListTile(
          tileColor: Colors.white,
          leading: const CircleAvatar(
            backgroundColor: Colors.yellowAccent,
          ),
          title: Text(
            customer.username,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 20.0,
            ),
          ),
        ),
      );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Text(
            'Add Customers',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
            ),
          ),
        ),
        body: StreamBuilder<List<UserModel>>(
          stream: readUsers(),
          builder: (context, snapshot) {
            if(snapshot.hasError) {
              return const Text("Some error in fetching data");
            } else if (snapshot.hasData) {
              final users = snapshot.data;

              return ListView(
                children: users!.where((U) => U.id != user.uid).map(buildUser).toList(),
              );
            } else {
              return const Center(child: CircularProgressIndicator(),);
            }
          },
        ),
      ),
    );
  }



}
