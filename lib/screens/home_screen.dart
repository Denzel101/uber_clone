import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/components/address_content.dart';
import 'package:uber_clone/components/divider.dart';
import 'package:uber_clone/components/progress_dialogue.dart';
import 'package:uber_clone/models/direction_details.dart';
import 'package:uber_clone/provider/app_data.dart';
import 'package:uber_clone/screens/search_screen.dart';
import 'package:uber_clone/services/methods.dart';
import 'package:uber_clone/utils/config_map.dart';
import 'package:uber_clone/utils/constants.dart';
import 'package:uber_clone/widgets/drawer_widget.dart';
import 'package:uber_clone/widgets/ride_details.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:uber_clone/widgets/ride_request.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home';
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  double bottomPaddingOfMap = 0;
  static double rideDetailsContainerHeight = 0;
  static double searchContainerHeight = 300.0;
  static double requestRideContainerHeight = 0;
  bool drawerOpen = true;

  Completer<GoogleMapController> _googleMapController = Completer();

  late GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DirectionDetails? tripDirectionDetails;
  DatabaseReference? rideRequestRef;

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markers = {};
  Set<Circle> circles = {};

  late Position currentPosition;

  void displayRideDetailsContainer() async {
    await getPlaceDirection();
    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 300.0;
      bottomPaddingOfMap = 300.0;
      drawerOpen = false;
    });
  }

  void displayRequestDetailsContainer() {
    setState(() {
      requestRideContainerHeight = 300;
      rideDetailsContainerHeight = 0;
      bottomPaddingOfMap = 300.0;
      drawerOpen = true;
    });

    saveRideRequest();
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14.0);

    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await Methods.searchCoordinateAddress(position, context);
    print('This is your address :: ' + address);
  }

  Future<void> getPlaceDirection() async {
    var initialPos =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatLng = LatLng(initialPos!.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos!.latitude, finalPos.longitude);

    showDialog(
      context: context,
      builder: (BuildContext context) =>
          ProgressDialogue(message: 'Please wait...'),
    );

    var details =
        await Methods.getPlaceDirectionDetails(pickUpLatLng, dropOffLatLng);
    setState(() {
      tripDirectionDetails = details!;
    });

    Navigator.pop(context);
    print('This is the Encoded points ::');
    print(details!.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodePolylinePointResult =
        polylinePoints.decodePolyline(details.encodedPoints);

    pLineCoordinates.clear();
    if (decodePolylinePointResult.isNotEmpty) {
      decodePolylinePointResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('PolylineID'),
        color: Colors.red,
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylineSet.add(polyline);
    });

    late LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
        northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
      );
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
        northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
      );
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }
    newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      markerId: MarkerId('pickUpId'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow:
          InfoWindow(title: initialPos.placeName, snippet: 'My location'),
      position: pickUpLatLng,
    );
    Marker dropOffLocMarker = Marker(
      markerId: MarkerId('dropOffId'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow:
          InfoWindow(title: finalPos.placeName, snippet: 'Drop off location'),
      position: dropOffLatLng,
    );
    setState(() {
      markers.add(pickUpLocMarker);
      markers.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
      circleId: CircleId('pickUpId'),
      fillColor: Colors.red,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.redAccent,
    );
    Circle dropOffLocCircle = Circle(
      circleId: CircleId('dropOffId'),
      fillColor: Colors.red,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.redAccent,
    );
    setState(() {
      circles.add(pickUpLocCircle);
      circles.add(dropOffLocCircle);
    });
  }

  resetApp() {
    setState(() {
      drawerOpen = true;

      searchContainerHeight = 300;
      rideDetailsContainerHeight = 0;
      requestRideContainerHeight = 0;
      bottomPaddingOfMap = 300.0;
      polylineSet.clear();
      markers.clear();
      circles.clear();
      pLineCoordinates.clear();
    });
    locatePosition();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Methods.getOnlineUserInformation();
  }

  void saveRideRequest() {
    rideRequestRef =
        FirebaseDatabase.instance.reference().child('Ride Requests').push();
    var pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var dropOff = Provider.of<AppData>(context, listen: false).dropOffLocation;

    Map pickUpLocMap = {
      'latitude': pickUp!.latitude.toString(),
      'longitude': pickUp.longitude.toString(),
    };

    Map dropOffLocMap = {
      'latitude': dropOff!.latitude.toString(),
      'longitude': dropOff.longitude.toString(),
    };
    Map rideInfoMap = {
      'driver_id': 'waiting',
      'payment_method': 'cash',
      'pickup': pickUpLocMap,
      'drop off': dropOffLocMap,
      'created_at': DateTime.now().toString(),
      'rider_name': userCurrentInfo!.name,
      'rider_phone': userCurrentInfo!.phone,
      'pickup_address': pickUp.placeName,
      'dropoff_address': dropOff.placeName,
    };

    rideRequestRef!.set(rideInfoMap);
  }

  void cancelRideRequest() {
    rideRequestRef!.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      // appBar: AppBar(
      //   title: Text('Home Screen'),
      // ),
      drawer: Container(
        color: Colors.white,
        width: 255.0,
        child: DrawerWidget(),
      ),
      body: Stack(
        children: [
          GoogleMap(
            markers: markers,
            circles: circles,
            polylines: polylineSet,
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            initialCameraPosition: HomeScreen._kGooglePlex,
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _googleMapController.complete(controller);
              newGoogleMapController = controller;
              setState(() {
                bottomPaddingOfMap = 300.0;
              });
              locatePosition();
            },
          ),
          //hamburger menu for drawer
          Positioned(
            top: 45.0,
            left: 22.0,
            child: GestureDetector(
              onTap: () {
                if (drawerOpen) {
                  scaffoldKey.currentState!.openDrawer();
                } else {
                  resetApp();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    (drawerOpen) ? Icons.menu : Icons.close,
                    color: Colors.black,
                  ),
                  radius: 20.0,
                ),
              ),
            ),
          ),

          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: AnimatedSize(
              //vsync: this,
              curve: Curves.bounceIn,
              duration: Duration(milliseconds: 160),
              child: Container(
                height: searchContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 6.0,
                      ),
                      Text(
                        'Hi there',
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        'Where to?',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'bolt-semibold',
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () async {
                          var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchScreen()));

                          if (res == 'getDirection') {
                            displayRideDetailsContainer();
                            //await getPlaceDirection();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: Offset(0.7, 0.7),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.yellow,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text('Search drop off'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      AddressContent(
                        icon: Icons.home,
                        locationAddress:
                            Provider.of<AppData>(context).pickUpLocation != null
                                ? Provider.of<AppData>(context)
                                    .pickUpLocation!
                                    .placeName
                                : 'Add Home',
                        locationDescripton: 'Your living home address',
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      DividerWidget(),
                      SizedBox(
                        height: 16.0,
                      ),
                      AddressContent(
                        icon: Icons.work,
                        locationAddress: 'Add work',
                        locationDescripton: 'Your work address',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          RideDetails(
            rideDetailsContainerHeight: rideDetailsContainerHeight,
            tripDirectionDetails: tripDirectionDetails,
            onPressed: displayRequestDetailsContainer,
          ),
          RideRequest(
            requestRideContainerHeight: requestRideContainerHeight,
            resetOnpressed: resetApp,
            cancelOnPressed: cancelRideRequest,
          ),
        ],
      ),
    );
  }
}
