import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/provider/app_data.dart';
import 'package:uber_clone/provider/app_state.dart';
import 'package:uber_clone/screens/home_screen.dart';
import 'package:uber_clone/screens/login_screen.dart';
import 'package:uber_clone/screens/registeration_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppData>(
          create: (context) => AppData(),
        ),
        ChangeNotifierProvider<AppState>(
          create: (context) => AppState(context),
        ),
      ],
      child: MaterialApp(
        title: 'Uber Clone',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
          fontFamily: 'bolt-regular',
        ),
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? LoginScreen.id
            : HomeScreen.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          RegisterationScreen.id: (context) => RegisterationScreen(),
          HomeScreen.id: (context) => const HomeScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

DatabaseReference usersRef =
    FirebaseDatabase.instance.reference().child('users');
