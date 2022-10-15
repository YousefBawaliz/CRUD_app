import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseapp/CRUD.dart';
import 'package:firebaseapp/signuppage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyLogInPage extends StatefulWidget {
  const MyLogInPage({super.key});

  @override
  State<MyLogInPage> createState() => _MyLogInPageState();
}

class _MyLogInPageState extends State<MyLogInPage> {
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
              "Log In page",
              style: TextStyle(fontSize: 30),
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
                      await authenticationobject.signInWithEmailAndPassword(
                          email: email.text, password: password.text);

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Log In Succesful")));

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductsPage(),
                      ));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("incorrect username or password")));
                }
              },
              child: Text("Log In ")),
          SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MySignUpPage(),
                    ));
              },
              child: Text("Dont have an account ? sign up instead"))
        ]),
      ),
    );
  }
}
