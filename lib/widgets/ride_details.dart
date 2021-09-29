import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uber_clone/models/direction_details.dart';
import 'package:uber_clone/services/methods.dart';

class RideDetails extends StatefulWidget {
  const RideDetails({
    Key? key,
    required this.rideDetailsContainerHeight,
    required this.tripDirectionDetails,
    required this.onPressed,
  }) : super(key: key);

  final double rideDetailsContainerHeight;
  final DirectionDetails? tripDirectionDetails;
  final VoidCallback onPressed;

  @override
  State<RideDetails> createState() => _RideDetailsState();
}

class _RideDetailsState extends State<RideDetails>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: AnimatedSize(
        //vsync: this,
        curve: Curves.bounceIn,
        duration: Duration(milliseconds: 160),
        child: Container(
          height: widget.rideDetailsContainerHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                spreadRadius: 0.5,
                offset: Offset(0.7, 0.7),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 17.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.redAccent,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/taxi.png',
                          height: 70.0,
                          width: 80.0,
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Car',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'bolt-semibold',
                              ),
                            ),
                            Text(
                              ((widget.tripDirectionDetails != null)
                                  ? widget.tripDirectionDetails!.distanceText
                                  : ''),
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'bolt-semibold',
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Text(
                          ((widget.tripDirectionDetails != null)
                              ? '\Kes ${Methods.calculateFares(widget.tripDirectionDetails!)}'
                              : ''),
                          style: TextStyle(fontFamily: 'bolt-semibold'),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.moneyCheckAlt,
                        size: 13.0,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text('Cash'),
                      SizedBox(
                        width: 6.0,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black54,
                        size: 16.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary),
                    ),
                    onPressed: () {
                      widget.onPressed();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(17.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Request',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            FontAwesomeIcons.taxi,
                            color: Colors.white,
                            size: 26.0,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      right: 0.0,
      bottom: 0.0,
      left: 0.0,
    );
  }
}
