import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:payment_handler/screens/loading.dart';
import '../services/auth.dart';
import 'home.dart';
import 'login.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  // handle input states
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool loading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() :  Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            alignment: AlignmentDirectional.centerStart,
            child: IconButton(
              icon: const Icon(
                Icons.chevron_left,
                size: 50,
              ),
              onPressed: (){Navigator.of(context).pop();},
            ),
          ),
          Container(
              alignment: AlignmentDirectional.center,
              height: 200,
              child: const FlutterLogo(size: 150,)
          ),
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
          Container(
            width: 350,
            height: 60,
            padding: const EdgeInsets.all(5),
            child: TextFormField(
              keyboardType: TextInputType.text,
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
              controller: _nameController,
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              setState(() => loading = true);
              final AuthService auth = AuthService();
              dynamic result = await auth.registerWithEmailAndPassword(_emailController.text, _passwordController.text, _nameController.text);
              if(result == "Registered userrrrrr") {
                print(result);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
              } else {
                setState(() {
                  error = 'Could not sign up with those credentials';
                  loading = false;
                });
              }
            },
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(340,50),
                padding: const EdgeInsets.all(10)
            ),
            child: const Text('Sign up'),
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
                const Text('Have an account?'),
                TextButton(
                  child: const Text('Log in'),
                  onPressed: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
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