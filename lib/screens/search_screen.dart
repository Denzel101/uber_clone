import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/components/divider.dart';
import 'package:uber_clone/provider/app_data.dart';
import 'package:uber_clone/models/place_predictions.dart';
import 'package:uber_clone/services/network_helper.dart';
import 'package:uber_clone/utils/config_map.dart';
import 'package:uber_clone/widgets/prediction_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
  List<PlacePredictions> placePredictionList = [];

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      var autoCompleteUrl = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&components=country:ke&key=$apiKey');

      var res = await NetworkHelper.getRequest(autoCompleteUrl);
      if (res == 'failed') {
        return;
      }
      if (res['status'] == 'OK') {
        var predictions = res['predictions'];
        var placesList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList();

        setState(() {
          placePredictionList = placesList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String? placeAddress =
        Provider.of<AppData>(context).pickUpLocation!.placeName;
    pickUpTextEditingController.text = placeAddress;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 215.0,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 6.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 25.0,
                  top: 20.0,
                  right: 25.0,
                  bottom: 20.0,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5.0,
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back)),
                        const Center(
                          child: Text(
                            'Set drop off',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'bolt-semibold',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/pickicon.png',
                          height: 16.0,
                          width: 16.0,
                        ),
                        const SizedBox(
                          width: 18.0,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: TextField(
                                controller: pickUpTextEditingController,
                                decoration: InputDecoration(
                                  hintText: 'Pickup Location',
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.only(
                                    left: 11.0,
                                    top: 8.0,
                                    bottom: 8.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/desticon.png',
                          height: 16.0,
                          width: 16.0,
                        ),
                        const SizedBox(
                          width: 18.0,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: TextField(
                                autofocus: true,
                                onChanged: (value) {
                                  findPlace(value);
                                },
                                controller: dropOffTextEditingController,
                                decoration: InputDecoration(
                                  hintText: 'Where to?',
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.only(
                                    left: 11.0,
                                    top: 8.0,
                                    bottom: 8.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            //Displaying prediction
            const SizedBox(
              height: 10.0,
            ),
            (placePredictionList.isNotEmpty)
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return PredictionTile(
                          placePredictions: placePredictionList[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const DividerWidget(),
                      itemCount: placePredictionList.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.all(0.0),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
