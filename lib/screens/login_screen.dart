import 'package:flutter/material.dart';
import 'package:uber_clone/screens/registeration_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'login';

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
                      onPressed: () {},
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
