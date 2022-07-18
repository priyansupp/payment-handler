import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoadCust extends StatefulWidget {

  const LoadCust({Key? key}) : super(key: key);

  @override
  State<LoadCust> createState() => _LoadCustState();
}

class _LoadCustState extends State<LoadCust> {
  final user = FirebaseAuth.instance.currentUser!;


  Future<Map<String, dynamic>?> readCustomers() async {
    final docCustomer =
        FirebaseFirestore.instance.collection('customers').doc(user.uid);
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
      child: Container(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: readCustomers(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final customers = snapshot.data;
              var type = customers!['children'].runtimeType;
              print(type);
              print(customers['children']);
              // return Text('Customers here');
              return (customers['children'] != null) ? ListView.builder(
                itemCount: customers['children'].length,
                itemBuilder: (BuildContext context, int index) {

                  Color c;
                  if(customers['children'][index]['amountDue'] > 0) {
                    c = Colors.red;
                  } else if (customers['children'][index]['amountDue'] < 0) {
                    c = Colors.green;
                  } else {
                    c = Colors.black;
                  }

                  String customerAmount;
                  if(customers['children'][index]['amountDue'] > 0) {
                    customerAmount = customers['children'][index]['amountDue'].toString();
                  } else if (customers['children'][index]['amountDue'] < 0) {
                    customerAmount = (-1 * customers['children'][index]['amountDue']).toString();
                  } else {
                    customerAmount = '0';
                  }

                  return customers['children'][index] != null ? GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/transactions', arguments: {
                        'customerId': customers['children'][index]['childId'],
                        'customerName': customers['children'][index]['childName'],
                        'amountDue': customers['children'][index]['amountDue']
                      });
                    },
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.yellowAccent,
                        radius: 20.0,
                      ),
                      title: Text(
                        customers['children'][index]['childName'],
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      trailing: Text(
                        customerAmount,
                        style: TextStyle(
                          color: c, fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ) : const Text('.');

                },
              ) : const Text('No customers');
            } else {
              return const Text('Add Customers');
            }
          },
        ),
      ),
    );
  }
}