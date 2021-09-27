class PlacePredictions {
  late String secondaryText;
  late String mainText;
  late String placeId;

  PlacePredictions(
      {required this.secondaryText,
      required this.mainText,
      required this.placeId});
  PlacePredictions.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    mainText = json['structured_formatting']['main_text'];
    secondaryText = json['structured_formatting']['secondary_text'];
  }
}
