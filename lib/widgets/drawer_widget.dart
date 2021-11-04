import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uber_clone/components/divider.dart';
import 'package:uber_clone/screens/home_screen.dart';
import 'package:uber_clone/screens/login_screen.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late User loggedInUser;

  final _auth = FirebaseAuth.instance;

  buildShowToast({required String message, required BuildContext context}) {
    Fluttertoast.showToast(msg: message);
  }

  void getUserDetails() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      buildShowToast(message: '$e', context: context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // drawer header
        children: [
          SizedBox(
            height: 165.0,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/user_icon.png',
                    height: 65.0,
                    width: 65.0,
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${loggedInUser.displayName}',
                        style: const TextStyle(
                          fontFamily: 'bolt-semibold',
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(
                        height: 6.0,
                      ),
                      const Text('Visit Profile'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const DividerWidget(),
          const SizedBox(
            height: 12.0,
          ),
          // header controller
          const ListTile(
            leading: Icon(Icons.history),
            title: Text(
              'History',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Visit Profile',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text(
              'About',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _auth.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.id, (route) => false);
            },
            child: const ListTile(
              leading: Icon(FontAwesomeIcons.signOutAlt),
              title: Text(
                'Log out',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
