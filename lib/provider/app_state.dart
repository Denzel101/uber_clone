import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone/services/methods.dart';

class AppState extends ChangeNotifier {
  late Position currentPosition;

  double bottomPaddingOfMap = 0;
  static double rideDetailsContainerHeight = 0;
  static double searchContainerHeight = 300.0;
  static double requestRideContainerHeight = 0;
  bool drawerOpen = true;

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markers = {};
  Set<Circle> circles = {};

  late GoogleMapController _newGoogleMapController;
  GoogleMapController get newGoogleMapController => _newGoogleMapController;

  AppState(BuildContext context) {
    // locatePosition(context);
  }

  void locatePosition(BuildContext context) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14.0);

    _newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await Methods.searchCoordinateAddress(position, context);
  }

  resetApp(BuildContext context) {
    drawerOpen = true;

    searchContainerHeight = 300;
    rideDetailsContainerHeight = 0;
    requestRideContainerHeight = 0;
    bottomPaddingOfMap = 300.0;
    polylineSet.clear();
    markers.clear();
    circles.clear();
    pLineCoordinates.clear();

    locatePosition(context);
  }
}
