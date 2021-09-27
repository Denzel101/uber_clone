import 'package:flutter/material.dart';
import 'package:uber_clone/components/divider.dart';

class DrawerWidget extends StatelessWidget {
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
                        'Profile name',
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
        ],
      ),
    );
  }
}
