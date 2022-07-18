import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:payment_handler/models/user_model.dart';
import 'package:payment_handler/screens/add_cust.dart';
import 'package:payment_handler/screens/load_cust.dart';
import 'package:payment_handler/screens/profile.dart';
import 'package:payment_handler/services/auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // state changes
  final TextEditingController _searchController = TextEditingController();

  final AuthService auth = AuthService();
  final user =
      FirebaseAuth.instance.currentUser!; // current user(every info about him)

  // getting the user with its uid from firestore
  Future<UserModel?> readUser() async {
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return UserModel.fromJson(snapshot.data()!);
    } else {
      return null;
    }
  }





  // very important - https://www.youtube.com/watch?v=sqE-J8YJnpg&t=620s
  late final Stream<DocumentSnapshot> _reRenderCustomers = reRenderCustomers();    // https://stackoverflow.com/questions/57793479/flutter-futurebuilder-gets-constantly-called
  Stream<DocumentSnapshot> reRenderCustomers() {
    final customersStream = FirebaseFirestore.instance.collection('customers').doc(user.uid).snapshots();
    // myFunc2();
    return customersStream;
  }



  // total amount to be shown at the top
  num _totalHeader = 0;
  void myFunc2() async {
    final docCustomer = FirebaseFirestore.instance.collection('customers').doc(user.uid);
    final snapshot = await docCustomer.get();

    // sum up total amount here
    num totalHeader = 0;
    if (snapshot.exists) {
      final customers = snapshot.data();
      for (int i = 0; i < customers!['children'].length; i++) {
        totalHeader += customers['children'][i]['amountDue'];
      }
      _totalHeader = totalHeader;     // updates the UI only once
    }
    print(totalHeader);
  }


  void tryLogout() async {
    dynamic result = await auth.logoutFromHere();
    if (result == "Logged out") {
      print(result);
    }
  }


  @override
  void initState() {
    super.initState();

    myFunc2();       // only the very first time
  }

  // int _counter = 0;


  @override
  Widget build(BuildContext context) {

    String setGiveAmount = '';
    if(_totalHeader <= 0) {
      setGiveAmount = '${-1 * _totalHeader}';
    } else if (_totalHeader > 0) {
      setGiveAmount = '0';
    }

    String setGaveAmount = '';
    if(_totalHeader >= 0) {
      setGaveAmount = '$_totalHeader';
    } else if (_totalHeader < 0) {
      setGaveAmount = '0';
    }


    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.indigo,
            leading: const Icon(
              Icons.book,
            ),
            title: GestureDetector(
              onLongPress: () {
                tryLogout();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
              },
              child: FutureBuilder<UserModel?>(
                future: readUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final user = snapshot.data;
                    return Text(
                      user!.username, // uid of the logged-in user.
                    );
                  } else if (snapshot.hasError) {
                    print("this is the error ${snapshot.error}");
                    return const Text('Something went wrong');
                  } else {
                    // loading
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ProfilePage()));
                },
              ),
            ],
            elevation: 0.0,
          ),
          body: Column(
            children: [
              SizedBox(
                height: 270.0,
                // decoration: BoxDecoration(
                //   border: Border.all(),
                // ),
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0.0,
                      left: 0.0,
                      child: Container(
                        color: Colors.indigo,
                        height: 200.0,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    Positioned(
                      top: 200.0,
                      left: 0.0,
                      child: Container(
                        color: Colors.black12,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      stream: _reRenderCustomers,
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if(_totalHeader <= 0) {
                          setGiveAmount = '${-1 * _totalHeader}';
                        } else if (_totalHeader > 0) {
                          setGiveAmount = '0';
                        }

                        if(_totalHeader >= 0) {
                          setGaveAmount = '$_totalHeader';
                        } else if (_totalHeader < 0) {
                          setGaveAmount = '0';
                        }


                        return Positioned(
                          top: 100.0,
                          left: MediaQuery.of(context).size.width * 0.05,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 10.0),
                            color: Colors.white,
                            height: 150.0,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      setGiveAmount,
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 50.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15.0,
                                    ),
                                    const Text(
                                      'You will give',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const VerticalDivider(
                                  thickness: 1.5,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      setGaveAmount,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 50.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15.0,
                                    ),
                                    const Text(
                                      'You will get',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(30.0, 5.0, 0.0, 5.0),
                    height: 60.0,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search Customer',
                        // enabledBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(color: Colors.white, width: 2.0),
                        // ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.indigo, width: 2.0),
                        ),
                      ),
                      controller: _searchController,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                ],
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: _reRenderCustomers,
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return const LoadCust();
                }
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddCustomers()));
              // setState(() => _counter++);
            },
            label: const Text('Add Customers'),
            icon: const Icon(Icons.person_add_alt_1),
            backgroundColor: Colors.pink,
          )),
    );
  }



}
