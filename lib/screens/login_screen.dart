import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber_clone/components/progress_dialogue.dart';
import 'package:uber_clone/screens/registeration_screen.dart';

import '../main.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'login';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  buildShowToast({required String message, required BuildContext context}) {
    Fluttertoast.showToast(msg: '$message');
  }

  void loginUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialogue(
            message: 'Authenticating user, please wait...',
          );
        });

    final User? firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text,
      password: passwordTextEditingController.text,
    )
            .catchError((errMsg) {
      Navigator.pop(context);
      buildShowToast(message: 'Error:' + errMsg.toString(), context: context);
    }))
        .user;

    if (firebaseUser != null) // create user
    {
      // save data

      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.id, (route) => false);
          buildShowToast(message: 'You are now logged in', context: context);
        } else {
          // error
          Navigator.pop(context);
          _firebaseAuth.signOut();
          buildShowToast(message: 'No account found', context: context);
        }
      });
    } else {
      Navigator.pop(context);
      buildShowToast(message: 'An error has occured', context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 45.0,
              ),
              Image.asset(
                'assets/images/logo.png',
                height: 350.0,
                width: 350.0,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                'Login as a Rider',
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'bolt-semibold',
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      obscuringCharacter: '*',
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.yellow),
                        textStyle: MaterialStateProperty.all(
                            TextStyle(color: Colors.white)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (!emailTextEditingController.text.contains('@')) {
                          buildShowToast(
                              message: 'Email is invalid', context: context);
                        } else if (passwordTextEditingController.text.length <
                            6) {
                          buildShowToast(
                              message: 'Password is not valid',
                              context: context);
                        } else {
                          loginUser(context);
                        }
                      },
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontFamily: 'bolt-semibold',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RegisterationScreen.id, (route) => false);
                },
                child: Text(
                  'Do not have an account? Register here',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
