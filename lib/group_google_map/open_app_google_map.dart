import 'package:map_launcher/map_launcher.dart';

class MapUtils {
  MapUtils._();

  static openMap({String lat, String long, String title}) async {
    final coords = Coords(double.parse(lat), double.parse(long));
    if (await MapLauncher.isMapAvailable(MapType.google)) {
      await MapLauncher.launchMap(
        description: "",
        mapType: MapType.google,
        coords: coords,
        title: title,
      );
    }
  }
}
