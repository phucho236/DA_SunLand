import 'dart:io';
import 'package:exif/exif.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

checkGPSData({File file_images}) async {
  GeoFirePoint geoFirePoint;
  Map<String, IfdTag> imgTags =
      await readExifFromBytes(File(file_images.path).readAsBytesSync());

  if (imgTags.containsKey('GPS GPSLongitude')) {
    geoFirePoint = exifGPSToGeoFirePoint(imgTags);
  }
  return geoFirePoint;
}

GeoFirePoint exifGPSToGeoFirePoint(Map<String, IfdTag> tags) {
  final latitudeValue = tags['GPS GPSLatitude']
      .values
      .map<double>(
          (item) => (item.numerator.toDouble() / item.denominator.toDouble()))
      .toList();
  final latitudeSignal = tags['GPS GPSLatitudeRef'].printable;

  final longitudeValue = tags['GPS GPSLongitude']
      .values
      .map<double>(
          (item) => (item.numerator.toDouble() / item.denominator.toDouble()))
      .toList();
  final longitudeSignal = tags['GPS GPSLongitudeRef'].printable;

  double latitude =
      latitudeValue[0] + (latitudeValue[1] / 60) + (latitudeValue[2] / 3600);

  double longitude =
      longitudeValue[0] + (longitudeValue[1] / 60) + (longitudeValue[2] / 3600);

  if (latitudeSignal == 'S') latitude = -latitude;
  if (longitudeSignal == 'W') longitude = -longitude;

  return GeoFirePoint(latitude, longitude);
}
