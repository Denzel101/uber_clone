import 'package:flutter/material.dart';
import 'package:uber_clone/models/address.dart';

class AppData extends ChangeNotifier {
  Address? pickUpLocation, dropOffLocation;

  Future updateUserPickUpLocationAddress(Address pickUpAddress) async {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  Future updateDropOffLocationAddress(Address dropOffAddress) async {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}
