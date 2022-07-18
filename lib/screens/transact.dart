import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/database.dart';

class Transact extends StatefulWidget {
  const Transact({Key? key}) : super(key: key);

  @override
  State<Transact> createState() => _TransactState();
}

class _TransactState extends State<Transact> {

  final user = FirebaseAuth.instance.currentUser!;

  // state variables
  int transact = 0;
  late DateTime time;

  @override
  Widget build(BuildContext context) {

    Map data = ModalRoute.of(context)!.settings.arguments as Map;

    Color c = (data['what'] == 'gave') ? Colors.red : Colors.green;

    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            backgroundColor: Colors.grey,
            title: Text(
              data['what'] == 'gave' ? 'You gave $transact to ${data['childName']}' : 'You got $transact from ${data['childName']}',
              style: TextStyle(
                color: c,
                fontSize: 25.0,
              ),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() => transact = int.parse(value));
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter amount',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: c, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0,),
                TextField(
                  keyboardType: TextInputType.datetime,
                  onChanged: (value) {
                    setState(() => time = value as DateTime);
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter date',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: c, width: 2.0),
                    ),
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {

                  final docTransactor =  FirebaseFirestore.instance.collection('transactions').doc(user.uid + data['childId']);
                  final snapshot = await docTransactor.get();

                  String message = (data['what'] == 'gave') ? 'You gave' : 'You got';

                  Map<String, dynamic> transaction = {
                    'message': message,
                    'amount': transact
                  };

                  if(snapshot.exists) {
                    List<dynamic> currentTransactions = snapshot.data()!['trans'];
                    currentTransactions.add(transaction);
                    await docTransactor.update({
                      'trans': currentTransactions,
                    });

                  } else {
                    await DatabaseService(uid: user.uid).updateTransactions([transaction], data['childId']);
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: c,
                  minimumSize: const Size(100, 50),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}
