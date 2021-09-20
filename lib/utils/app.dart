import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/models/app_data.dart';
import 'package:uber_clone/screens/home_screen.dart';
import 'package:uber_clone/screens/login_screen.dart';
import 'package:uber_clone/screens/registeration_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Uber Clone',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'bolt-regular',
        ),
        initialRoute: HomeScreen.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          RegisterationScreen.id: (context) => RegisterationScreen(),
          HomeScreen.id: (context) => HomeScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
