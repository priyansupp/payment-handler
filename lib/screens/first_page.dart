import 'package:flutter/material.dart';
import 'package:payment_handler/screens/login.dart';
import 'package:payment_handler/screens/signup.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(
              size: 150,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(320, 0),
                  padding: const EdgeInsets.all(10)),
              child: const Text('Log in'),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUpPage()));
              },
              style: OutlinedButton.styleFrom(
                  primary: Colors.blueAccent,
                  minimumSize: const Size(320, 0),
                  padding: const EdgeInsets.all(10),
                  side: const BorderSide(
                    color: Colors.blueAccent,
                  )),
              child: const Text('Sign up'),
            )
          ],
        ),
      ),
    );
  }
}

