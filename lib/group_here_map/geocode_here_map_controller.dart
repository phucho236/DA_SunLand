import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';

class GeocodeHereMapController {
  GetRequestingAutocompleteSuggestions({String data}) async {
    var api = HttpApi();
    return await api.RequestingAutocompleteSuggestions(data: data);
  }

  Future<AddressModelHereMapReturn> getGeocodeHereMap({
    String housenumber,
    String street,
    String district,
    String city,
    String county,
  }) async {
    var api = HttpApi();
    return await api.GetGeocodeHereMap(
        district: district,
        housenumber: housenumber,
        street: street,
        city: city,
        county: county);
  }
}
