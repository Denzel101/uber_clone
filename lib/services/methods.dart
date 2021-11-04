import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/models/address.dart';
import 'package:uber_clone/provider/app_data.dart';
import 'package:uber_clone/models/direction_details.dart';
import 'package:uber_clone/models/users.dart';
import 'package:uber_clone/utils/config_map.dart';
import 'package:uber_clone/services/network_helper.dart';

class Methods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = '';
    String st1, st2, st3;
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey');

    var response = await NetworkHelper.getRequest(url);

    if (response != 'Failed') {
      st1 = response['results'][0]['address_components'][0]['long_name'];
      st2 = response['results'][0]['address_components'][1]['long_name'];
      st3 = response['results'][0]['address_components'][2]['long_name'];
      // st4 = response['results'][0]['address_components'][3]['long_name'];

      placeAddress = st1 + ',' + st2 + ',' + st3;

      Address userPickupAddress = Address();
      userPickupAddress.longitude = position.longitude;
      userPickupAddress.latitude = position.latitude;
      userPickupAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updateUserPickUpLocationAddress(userPickupAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetails?> getPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    var directionUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$apiKey');
    var res = await NetworkHelper.getRequest(directionUrl);

    if (res == 'Failed') {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.encodedPoints =
        res['routes'][0]['overview_polyline']['points'];
    directionDetails.distanceText =
        res['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue =
        res['routes'][0]['legs'][0]['distance']['value'];
    directionDetails.durationText =
        res['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue =
        res['routes'][0]['legs'][0]['duration']['value'];

    return directionDetails;
  }

  static int calculateFares(DirectionDetails directionDetails) {
    //usd
    double timeTravelledFare = (directionDetails.durationValue / 60) * 0.20;
    double distanceTravelledFare =
        (directionDetails.distanceValue / 1000) * 0.20;
    double totalFareAmount = timeTravelledFare + distanceTravelledFare;
    //1$ = 110kes
    double totalLocalAmount = totalFareAmount * 110;
    return totalLocalAmount.truncate();
  }

  static void getOnlineUserInformation() async {
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String userId = firebaseUser!.uid;
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('users').child(userId);
    databaseReference.once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        userCurrentInfo = Users.fromSnapshot(dataSnapshot);
      }
    });
  }
}
