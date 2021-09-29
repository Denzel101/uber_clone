// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:uber_clone/components/progress_dialogue.dart';
// import 'package:uber_clone/models/address.dart';
// import 'package:uber_clone/models/direction_details.dart';
// import 'package:uber_clone/services/methods.dart';
// import 'package:uber_clone/utils/config_map.dart';
//
// import 'app_data.dart';
//
// class AppState extends ChangeNotifier {
//   late GoogleMapController _newGoogleMapController;
//
//   set newGoogleMapController(GoogleMapController value) {
//     _newGoogleMapController = value;
//   }
//
//   List<LatLng> _pLineCoordinates = [];
//   Set<Polyline> _polylineSet = {};
//   Set<Marker> _markers = {};
//   Set<Circle> _circles = {};
//   Set<Polyline> get polylineSet => _polylineSet;
//   late Address initialPos;
//   late Address finalPos;
//
//   Set<Marker> get markers => _markers;
//
//   Set<Circle> get circles => _circles;
//
//   List<LatLng> get pLineCoordinates => _pLineCoordinates;
//   double bottomPaddingOfMap = 0;
//   static double rideDetailsContainerHeight = 0;
//   static double searchContainerHeight = 300.0;
//   static double requestRideContainerHeight = 0;
//   bool drawerOpen = true;
//   DirectionDetails? _tripDirectionDetails;
//
//   DirectionDetails? get tripDirectionDetails => _tripDirectionDetails;
//   DatabaseReference? _rideRequestRef;
//
//   DatabaseReference? get rideRequestRef => _rideRequestRef;
//   late Position _currentPosition;
//
//   Position get currentPosition => _currentPosition;
//
//   AppState(BuildContext context) {
//     // getPlaceDirection(context);
//     //saveRideRequest(context);
//     //displayRideDetailsContainer(context);
//     //displayRequestDetailsContainer(context);
//     locatePosition(context);
//     // resetApp(context);
//     cancelRideRequest(context);
//   }
//
//   // Future<void> getPlaceDirection(BuildContext context) async {
//   //   initialPos = Provider.of<AppData>(context, listen: false).pickUpLocation!;
//   //   finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation!;
//   //
//   //   var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
//   //   var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);
//   //
//   //   showDialog(
//   //     context: context,
//   //     builder: (BuildContext context) =>
//   //         ProgressDialogue(message: 'Please wait...'),
//   //   );
//   //
//   //   var details =
//   //       await Methods.getPlaceDirectionDetails(pickUpLatLng, dropOffLatLng);
//   //   _tripDirectionDetails = details!;
//   //
//   //   Navigator.pop(context);
//   //   // print('This is the Encoded points ::');
//   //   // print(details!.encodedPoints);
//   //
//   //   PolylinePoints polylinePoints = PolylinePoints();
//   //   List<PointLatLng> decodePolylinePointResult =
//   //       polylinePoints.decodePolyline(details.encodedPoints);
//   //
//   //   _pLineCoordinates.clear();
//   //   if (decodePolylinePointResult.isNotEmpty) {
//   //     decodePolylinePointResult.forEach((PointLatLng pointLatLng) {
//   //       _pLineCoordinates
//   //           .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
//   //     });
//   //   }
//   //
//   //   _polylineSet.clear();
//   //
//   //   Polyline polyline = Polyline(
//   //     polylineId: PolylineId('PolylineID'),
//   //     color: Colors.red,
//   //     jointType: JointType.round,
//   //     points: pLineCoordinates,
//   //     width: 5,
//   //     startCap: Cap.roundCap,
//   //     endCap: Cap.roundCap,
//   //     geodesic: true,
//   //   );
//   //
//   //   _polylineSet.add(polyline);
//   //
//   //   late LatLngBounds latLngBounds;
//   //   if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
//   //       pickUpLatLng.longitude > dropOffLatLng.longitude) {
//   //     latLngBounds =
//   //         LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
//   //   } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
//   //     latLngBounds = LatLngBounds(
//   //       southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
//   //       northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
//   //     );
//   //   } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
//   //     latLngBounds = LatLngBounds(
//   //       southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
//   //       northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
//   //     );
//   //   } else {
//   //     latLngBounds =
//   //         LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
//   //   }
//   //   _newGoogleMapController
//   //       .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
//   //
//   //   Marker pickUpLocMarker = Marker(
//   //     markerId: MarkerId('pickUpId'),
//   //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
//   //     infoWindow:
//   //         InfoWindow(title: initialPos.placeName, snippet: 'My location'),
//   //     position: pickUpLatLng,
//   //   );
//   //   Marker dropOffLocMarker = Marker(
//   //     markerId: MarkerId('dropOffId'),
//   //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
//   //     infoWindow:
//   //         InfoWindow(title: finalPos.placeName, snippet: 'Drop off location'),
//   //     position: dropOffLatLng,
//   //   );
//   //
//   //   _markers.add(pickUpLocMarker);
//   //   _markers.add(dropOffLocMarker);
//   //
//   //   Circle pickUpLocCircle = Circle(
//   //     circleId: CircleId('pickUpId'),
//   //     fillColor: Colors.red,
//   //     center: pickUpLatLng,
//   //     radius: 12,
//   //     strokeWidth: 4,
//   //     strokeColor: Colors.redAccent,
//   //   );
//   //   Circle dropOffLocCircle = Circle(
//   //     circleId: CircleId('dropOffId'),
//   //     fillColor: Colors.red,
//   //     center: dropOffLatLng,
//   //     radius: 12,
//   //     strokeWidth: 4,
//   //     strokeColor: Colors.redAccent,
//   //   );
//   //
//   //   _circles.add(pickUpLocCircle);
//   //   _circles.add(dropOffLocCircle);
//   //
//   //   notifyListeners();
//   // }
//   //
//   // void displayRideDetailsContainer(BuildContext context) async {
//   //   await getPlaceDirection(context);
//   //
//   //   searchContainerHeight = 0;
//   //   rideDetailsContainerHeight = 300.0;
//   //   bottomPaddingOfMap = 300.0;
//   //   drawerOpen = false;
//   //
//   //   notifyListeners();
//   // }
//
//   // void saveRideRequest(BuildContext context) {
//   //   rideRequestRef =
//   //       FirebaseDatabase.instance.reference().child('Ride Requests').push();
//   //   var pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;
//   //   var dropOff = Provider.of<AppData>(context, listen: false).dropOffLocation;
//   //
//   //   Map pickUpLocMap = {
//   //     'latitude': pickUp!.latitude.toString(),
//   //     'longitude': pickUp.longitude.toString(),
//   //   };
//   //
//   //   Map dropOffLocMap = {
//   //     'latitude': dropOff!.latitude.toString(),
//   //     'longitude': dropOff.longitude.toString(),
//   //   };
//   //   Map rideInfoMap = {
//   //     'driver_id': 'waiting',
//   //     'payment_method': 'cash',
//   //     'pickup': pickUpLocMap,
//   //     'drop off': dropOffLocMap,
//   //     'created_at': DateTime.now().toString(),
//   //     'rider_name': userCurrentInfo!.name,
//   //     'rider_phone': userCurrentInfo!.phone,
//   //     'pickup_address': pickUp.placeName,
//   //     'dropoff_address': dropOff.placeName,
//   //   };
//   //
//   //   rideRequestRef!.set(rideInfoMap);
//   //   notifyListeners();
//   // }
//   //
//   // displayRequestDetailsContainer(BuildContext context) {
//   //   requestRideContainerHeight = 300;
//   //   rideDetailsContainerHeight = 0;
//   //   bottomPaddingOfMap = 300.0;
//   //   drawerOpen = true;
//   //
//   //   saveRideRequest(context);
//   //   notifyListeners();
//   // }
//
//   void locatePosition(BuildContext context) async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     _currentPosition = position;
//
//     LatLng latLngPosition = LatLng(position.latitude, position.longitude);
//
//     CameraPosition cameraPosition =
//         CameraPosition(target: latLngPosition, zoom: 14.0);
//
//     _newGoogleMapController
//         .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
//
//     String address = await Methods.searchCoordinateAddress(position, context);
//     print('This is your address :: ' + address);
//     notifyListeners();
//   }
//
//   resetApp(BuildContext context) {
//     drawerOpen = true;
//
//     searchContainerHeight = 300;
//     rideDetailsContainerHeight = 0;
//     requestRideContainerHeight = 0;
//     bottomPaddingOfMap = 300.0;
//     _polylineSet.clear();
//     _markers.clear();
//     _circles.clear();
//     _pLineCoordinates.clear();
//
//     locatePosition(context);
//     notifyListeners();
//   }
//
//   cancelRideRequest(BuildContext context) {
//     if (_rideRequestRef != null) {
//       _rideRequestRef!.remove();
//       notifyListeners();
//     }
//   }
// }
