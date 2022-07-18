import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:payment_handler/screens/load_transactions.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {


  late String customerId;
  final user = FirebaseAuth.instance.currentUser!;


  void updateAmountDue(num total) async {

    final docCustomer = FirebaseFirestore.instance.collection('customers').doc(user.uid);
    final snapshot = await docCustomer.get();

    for(int i = 0; i < snapshot.data()!['children'].length; i++){
      if(snapshot.data()!['children'][i]['childId'] == customerId) {
        Map<String, dynamic>? customer = snapshot.data();
        customer!['children'][i]['amountDue'] = total;
        docCustomer.set(customer);
      }
    }
  }


  // total amount to be shown at the top
  num _totalAmount = 0;
  void setTotalAmount(num total){
    setState(() => _totalAmount = total);
    updateAmountDue(total);
  }



  void myFunc() async {

    final docCustomer = FirebaseFirestore.instance.collection('transactions').doc(user.uid + customerId);
    final snapshot = await docCustomer.get();

    // sum up total amount here
    num total = 0;
    if (snapshot.exists) {
      final transactions = snapshot.data();
      for (int i = 0; i < transactions!['trans'].length; i++) {
        total += (transactions['trans'][i]['message'] == 'You gave') ? transactions['trans'][i]['amount'] : -transactions['trans'][i]['amount'];
      }
      setTotalAmount(total);     // updates the UI only once
    }
  }


  @override
  void initState() {
    super.initState();

    myFunc();       // only called once

  }




  late final Stream<DocumentSnapshot> _reRenderTransactions = reRenderTransactions();
  Stream<DocumentSnapshot> reRenderTransactions() {
    final transactionsStream = FirebaseFirestore.instance.collection('transactions').doc(user.uid + customerId).snapshots();
    myFunc();
    return transactionsStream;
  }



  @override
  Widget build(BuildContext context) {

    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    customerId = data['customerId'];

    String headerMessage;
    if(_totalAmount > 0) {
      headerMessage = 'You will get';
    } else if (_totalAmount < 0) {
      headerMessage = 'You will give';
    } else {
      headerMessage = 'Settled up';
    }

    String headerAmount;
    if(_totalAmount > 0) {
      headerAmount = _totalAmount.toString();
    } else if (_totalAmount < 0) {
      headerAmount = (-1 * _totalAmount).toString();
    } else {
      headerAmount = '0';
    }

    Color c;
    if(_totalAmount > 0) {
      c = Colors.red;
    } else if (_totalAmount < 0) {
      c = Colors.green;
    } else {
      c = Colors.black;
    }
    IconData? i = _totalAmount == 0 ? Icons.check : null;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.indigo,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.yellowAccent,
                radius: 20.0,
              ),
              const SizedBox(width: 15.0,),
              Text(
                data['customerName'],
              )
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.call),
              onPressed: () {},
            ),
          ],
          elevation: 0.0,
        ),
        body: Column(
          children: [
            const SizedBox(height: 10.0,),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  children: [
                    Icon(
                      i,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 20.0,),
                    Text(
                      headerMessage,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: c,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 80.0,),
                    Text(
                      headerAmount,
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0,),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                color: Colors.white60,
                child: Column(
                  children: [
                    const SizedBox(height: 20.0,),
                    StreamBuilder<DocumentSnapshot>(
                      stream: _reRenderTransactions,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return LoadTrans(childId: data['customerId']);
                      }
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        persistentFooterButtons: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/transact', arguments: {
                'childName': data['customerName'],
                'childId': data['customerId'],
                'what': 'gave'
              });
            },
            child: const Text(
              'YOU GAVE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0
              ),
            ),
          ),
          const SizedBox(width: 10.0,),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/transact', arguments: {
                'childName': data['customerName'],
                'childId': data['customerId'],
                'what': 'got'
              });
            },
            child: const Text(
              'YOU GOT',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0
              ),
            ),
          ),
          const SizedBox(width: 20.0,),
        ]
      ),
    );
  }
}
