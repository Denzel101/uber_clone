import 'package:flutter/material.dart';

class AddressContent extends StatelessWidget {
  final IconData icon;
  final locationAddress;
  final locationDescripton;

  AddressContent(
      {required this.icon, this.locationAddress, this.locationDescripton});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey,
        ),
        SizedBox(
          width: 12.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locationAddress,
            ),
            SizedBox(
              height: 4.0,
            ),
            Text(
              locationDescripton,
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
          ],
        )
      ],
    );
  }
}
