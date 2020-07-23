import 'package:flutter_core/api/api_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' hide LocationAccuracy;

class GetLocationController {
  getLocationExisting() async {
    print("Thằng này bị gọi hoài ");
    Location location = new Location();
    CoordinatesDoubleModel coordinatesModel = CoordinatesDoubleModel();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    Position _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    coordinatesModel.latitude = _locationData.latitude;
    coordinatesModel.longitude = _locationData.longitude;
    return coordinatesModel;
  }
}
