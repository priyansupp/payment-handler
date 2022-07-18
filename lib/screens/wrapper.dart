import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:payment_handler/screens/first_page.dart';
import 'home.dart';


class Wrapper extends StatelessWidget {

  const Wrapper({Key? key}) : super(key: key); // instance of _auth class from auth.dart into this class


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),);
            } else if(snapshot.hasError) {
              return const Center(child: Text('Error occurred'),);
            } else if (snapshot.hasData) {
              print(snapshot.data);
              return const Home();
            } else {
              return const FirstPage();
            }
          }
      ),
    );
  }
}
