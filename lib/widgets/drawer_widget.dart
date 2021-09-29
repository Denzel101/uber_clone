import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uber_clone/components/divider.dart';
import 'package:uber_clone/screens/home_screen.dart';
import 'package:uber_clone/screens/login_screen.dart';

class DrawerWidget extends StatefulWidget {
  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late User loggedInUser;

  final _auth = FirebaseAuth.instance;

  void getUserDetails() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
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
          Container(
            height: 165.0,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/user_icon.png',
                    height: 65.0,
                    width: 65.0,
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${loggedInUser.displayName}',
                        style: TextStyle(
                          fontFamily: 'bolt-semibold',
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      Text('Visit Profile'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          DividerWidget(),
          SizedBox(
            height: 12.0,
          ),
          // header controller
          ListTile(
            leading: Icon(Icons.history),
            title: Text(
              'History',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Visit Profile',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ),
          ListTile(
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
            child: ListTile(
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
