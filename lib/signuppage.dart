import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseapp/LogInPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MySignUpPage extends StatefulWidget {
  const MySignUpPage({super.key});

  @override
  State<MySignUpPage> createState() => _MySignUpPageState();
}

class _MySignUpPageState extends State<MySignUpPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.8),
        child: Column(children: [
          Center(
            child: Text(
              "sign up page",
              style: TextStyle(fontSize: 40),
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Text("email"),
          TextField(controller: email),
          Text("password"),
          TextField(controller: password),
          Divider(height: 25),
          TextButton(
              onPressed: () async {
                try {
                  var authenticationobject = FirebaseAuth.instance;

                  UserCredential myUser =
                      await authenticationobject.createUserWithEmailAndPassword(
                          email: email.text, password: password.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("added successfully")));
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("sign up failed")));
                }
              },
              child: Text("sign up ")),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyLogInPage(),
                    ));
              },
              child: Text("Already have an account? Log in here"))
        ]),
      ),
    );
  }
}
