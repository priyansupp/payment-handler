import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:payment_handler/screens/first_page.dart';
import 'package:payment_handler/screens/transaction.dart';
import 'package:payment_handler/screens/transact.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const Wrapper(),
      home: const FirstPage(),
      routes: {
        '/transactions': (context) => const Transactions(),
        '/transact': (context) => const Transact(),
      },
    );
  }
}

