import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoadTrans extends StatefulWidget {

  final String childId;
  const LoadTrans({Key? key, required this.childId}) : super(key: key);

  @override
  State<LoadTrans> createState() => _LoadTransState();
}

class _LoadTransState extends State<LoadTrans> {


  final user = FirebaseAuth.instance.currentUser!;



  // late final Future<Map<String, dynamic>?> _readTrans = readTrans();    // https://stackoverflow.com/questions/57793479/flutter-futurebuilder-gets-constantly-called

  Future<Map<String, dynamic>?> readTrans() async {
    final docCustomer =
    FirebaseFirestore.instance.collection('transactions').doc(user.uid + widget.childId);
    final snapshot = await docCustomer.get();

    // print("this is snapshot");
    // print(snapshot.data());

    if (snapshot.exists) {
      return snapshot.data();
    } else {
      return null;
    }
  }




  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<Map<String, dynamic>?>(
        future: readTrans(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.data == null){
            return const Expanded(
              child: Text(
                'No transactions here to show',
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            );
          }
          if(snapshot.hasData && snapshot.data != null) {
            final transactions = snapshot.data;

            return (transactions!['trans'] != null) ? ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              itemCount: transactions['trans'].length,
              itemBuilder: (BuildContext context, int index) {
                Color c = (transactions['trans'][index]['message'] == 'You gave') ? Colors.red : Colors.green;
                return transactions['trans'][index] != null ? Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                  child: ListTile(
                    tileColor: Colors.white,
                    title: const Text(
                      '12:28PM',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 10.0,
                      ),
                    ),
                    subtitle: Text(
                      transactions['trans'][index]['message'],
                      style: TextStyle(
                        color: c,
                      ),
                    ),
                    trailing: Text(
                      '${transactions['trans'][index]['amount']}',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: c,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                ) : const Text('.');
              },
            ) : const Text('No transactions');
          } else {
            return const Text('Add transactions');
          }
        },
      ),
    );
  }

}
