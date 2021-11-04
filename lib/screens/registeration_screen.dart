import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber_clone/components/progress_dialogue.dart';
import 'package:uber_clone/main.dart';
import 'package:uber_clone/utils/app.dart';
import 'package:uber_clone/screens/home_screen.dart';

import 'login_screen.dart';

class RegisterationScreen extends StatelessWidget {
  static const String id = 'register';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  RegisterationScreen({Key? key}) : super(key: key);

  buildShowToast({required String message, required BuildContext context}) {
    Fluttertoast.showToast(msg: message);
  }

  void registerNewUSer(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const ProgressDialogue(
            message: 'Registering user, please wait...',
          );
        });

    final User? firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
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

      Map userDataMap = {
        'name': nameTextEditingController.text.trim(),
        'email': emailTextEditingController.text.trim(),
        'phone': phoneTextEditingController.text.trim(),
      };

      usersRef.child(firebaseUser.uid).set(userDataMap);
      buildShowToast(message: 'Account has been created', context: context);
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.id, (route) => false);
    } else {
      // error
      Navigator.pop(context);
      buildShowToast(
          message: 'New user has not been created', context: context);
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
              const SizedBox(
                height: 20.0,
              ),
              Image.asset(
                'assets/images/logo.png',
                height: 350.0,
                width: 350.0,
                alignment: Alignment.center,
              ),
              const SizedBox(
                height: 15.0,
              ),
              const Text(
                'Register as a Rider',
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
                    const SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      obscuringCharacter: '*',
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.yellow),
                        textStyle: MaterialStateProperty.all(
                            const TextStyle(color: Colors.white)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (nameTextEditingController.text.length < 3) {
                          buildShowToast(
                              message: 'Name must be at least 3 characters',
                              context: context);
                        } else if (!emailTextEditingController.text
                            .contains('@')) {
                          buildShowToast(
                              message: 'Email is invalid', context: context);
                        } else if (phoneTextEditingController.text.isEmpty) {
                          buildShowToast(
                              message: 'Phone Number is empty',
                              context: context);
                        } else if (passwordTextEditingController.text.length <
                            6) {
                          buildShowToast(
                              message: 'Password must be at least 6 characters',
                              context: context);
                        } else {
                          registerNewUSer(context);
                        }
                      },
                      child: const SizedBox(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            'Register',
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
                      context, LoginScreen.id, (route) => false);
                },
                child: const Text(
                  'Already have an account? Login here',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
