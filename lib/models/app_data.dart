import 'package:flutter/material.dart';
import 'package:uber_clone/models/address.dart';

class AppData extends ChangeNotifier {
  Address? pickUpLocation;

  Future updateUserPickUpLocationAddress(Address pickUpAddress) async {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }
}
