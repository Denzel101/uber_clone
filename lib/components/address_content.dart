import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressContent extends StatelessWidget {
  final IconData icon;
  final String locationAddress;
  final String locationDescripton;

  const AddressContent(
      {required this.icon,
      required this.locationAddress,
      required this.locationDescripton});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.yellow,
        ),
        const SizedBox(
          width: 12.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locationAddress,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 4.0,
            ),
            Text(
              locationDescripton,
              style: const TextStyle(
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
