import 'package:geolocator/geolocator.dart';
import 'package:uber_clone/models/config_map.dart';
import 'package:uber_clone/services/network_helper.dart';

class Methods {
  static Future<String> searchCoordinateAddress(Position position) async {
    String placeAddress = '';
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey');

    var response = await NetworkHelper.getRequest(url);

    if (response != 'Failed') {
      placeAddress = response['results'][0]['formatted_address'];
    }
    return placeAddress;
  }
}
