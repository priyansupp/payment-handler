import 'package:flutter/material.dart';
import 'package:payment_handler/screens/home.dart';
import 'package:payment_handler/screens/signup.dart';
import '../services/auth.dart';
import 'loading.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final AuthService auth = AuthService();


  // state changes
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  bool loading = false;
  String error = '';


  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            alignment: AlignmentDirectional.centerStart,
            child: IconButton(
              icon: const Icon(
                Icons.chevron_left,
                size: 50,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Container(
            height: 100,
          ),
          Container(
              alignment: AlignmentDirectional.center,
              height: 200,
              child: const FlutterLogo(
                size: 150,
              )),
          Container(
            width: 350,
            height: 60,
            padding: const EdgeInsets.all(5),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
              controller: _emailController,
            ),
          ),
          Container(
            width: 350,
            height: 60,
            padding: const EdgeInsets.all(5),
            child: TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              controller: _passwordController,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() => loading = true);
              dynamic result = await auth.loginWithEmailAndPassword(_emailController.text, _passwordController.text);
              if(result == "Logged in") {
                print(result);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
              } else {
                setState(() {
                  error = 'Could not sign in with those credentials';
                  loading = false;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(340, 50),
              padding: const EdgeInsets.all(10)),
            child: const Text('Log in'),
          ),
          const SizedBox(height: 20.0,),
          Text(error),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: const Text('Or'),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account?'),
                TextButton(
                  child: const Text('Sign Up'),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignUpPage()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
