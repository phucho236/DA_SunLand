/*
 * Copyright (C) 2019-2020 HERE Europe B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License")
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
 * License-Filename: LICENSE
 */
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:flutter_core/group_here_map/get_location_controller.dart';

class MapMarkerController {
  BuildContext _context;
  HereMapController _hereMapController;
  List<MapMarker> _mapMarkerList = [];
  List<MapMarker> _mapMarkerPlaceList = [];
  MapImage _poiMapImage;
  MapImage _photoMapImage;
  MapImage _circleMapImage;
  bool allowLongPressGestureHandler;
  GeoCoordinates geoCoordinates_return;

  MapMarkerController(
      {BuildContext context,
      HereMapController hereMapController,
      bool allowLongPressGestureHandler = true}) {
    _context = context;
    _hereMapController = hereMapController;

    double distanceToEarthInMeters = 8000;
    _hereMapController.camera.lookAtPointWithDistance(
        GeoCoordinates(52.530932, 13.384915), distanceToEarthInMeters);

    // Setting a tap handler to pick markers from map.
    _setTapGestureHandler();
    if (allowLongPressGestureHandler == true) {
      _setLongPressGestureHandler();
    }
  }
  _setLongPressGestureHandler() {
    _hereMapController.gestures.longPressListener =
        LongPressListener.fromLambdas(lambda_onLongPress:
            (GestureState gestureState, Point2D touchPoint) {
      var geoCoordinates =
          _toString(_hereMapController.viewToGeoCoordinates(touchPoint));

      if (gestureState == GestureState.begin) {
        geoCoordinates_return =
            _hereMapController.viewToGeoCoordinates(touchPoint);
        print(geoCoordinates_return);
        print('LongPress detected at: $geoCoordinates');
        showAnchoredMapMarkers(
            geoCoordinates:
                _hereMapController.viewToGeoCoordinates(touchPoint));
      }

//      if (gestureState == GestureState.update) {
//        print('LongPress update at: $geoCoordinates');
//      }
//
//      if (gestureState == GestureState.end) {
//        print('LongPress finger lifted at: $geoCoordinates');
//      }
    });
  }

  String _toString(GeoCoordinates geoCoordinates) {
    return geoCoordinates.latitude.toString() +
        ", " +
        geoCoordinates.longitude.toString();
  }

  void addPhotoMapMarkerWithImagesUrl(
      {GeoCoordinates geoCoordinates,
      bool internalupdateCoordinates = true,
      Uint8List imagePixelData}) {
//    GeoCoordinates geoCoordinates = _createRandomGeoCoordinatesInViewport();

    // Centered on location. Shown below the POI image to indicate the location.
    // The draw order is determined from what is first added to the map,
    // but since loading images is done async, we can make this explicit by setting
    // a draw order. High numbers are drawn on top of lower numbers.
    _clearMapMarkerPlace();

    // Anchored, pointing to location.
    _addPhotoMapMarkerWithImagesUrl(geoCoordinates, 0, imagePixelData);
    if (internalupdateCoordinates == true) {
      _hereMapController.camera.internalupdateCoordinates(
          GeoCoordinates(geoCoordinates.latitude, geoCoordinates.longitude));
    }
  }

  void showAnchoredMapMarkers({
    GeoCoordinates geoCoordinates,
    bool internalupdateCoordinates = false,
  }) {
//    GeoCoordinates geoCoordinates = _createRandomGeoCoordinatesInViewport();

    // Centered on location. Shown below the POI image to indicate the location.
    // The draw order is determined from what is first added to the map,
    // but since loading images is done async, we can make this explicit by setting
    // a draw order. High numbers are drawn on top of lower numbers.
    _clearMapMarkerPlace();
    _addCircleMapMarker(geoCoordinates, 0);

    // Anchored, pointing to location.
    _addPOIMapMarker(geoCoordinates, 1);
    geoCoordinates_return = geoCoordinates;
    if (internalupdateCoordinates == true) {
      _hereMapController.camera.internalupdateCoordinates(
          GeoCoordinates(geoCoordinates.latitude, geoCoordinates.longitude));
    }
  }

  // stream vị trí hiện tại và cập nhật camera
  Future<GeoCoordinates> StreamCenteredMapMarkers(
      GeoCoordinates geoCoordinates) {
    //GeoCoordinates geoCoordinates = _createRandomGeoCoordinatesInViewport();
    // Centered on location.

    clearMapMarker();
    _addPhotoMapMarker(geoCoordinates, 0);

    // Centered on location. Shown above the photo marker to indicate the location.
    // cập nhật độ cao

    //_hereMapController.camera.internalupdateAltitude(500);
    //cập nhật vị trí focus...
//    _hereMapController.camera.internalupdateCoordinates(
//        GeoCoordinates(geoCoordinates.latitude, geoCoordinates.longitude));
  }

  // lấy vị trí hiện tại và cập nhật camera
  Future<GeoCoordinates> showCenteredMapMarkers() async {
    GeoCoordinates geoCoordinates = await _getLocation();
    //GeoCoordinates geoCoordinates = _createRandomGeoCoordinatesInViewport();
    // Centered on location.
    _addPhotoMapMarker(geoCoordinates, 0);
    // Centered on location. Shown above the photo marker to indicate the location.
    // cập nhật độ cao
    _hereMapController.camera.internalupdateAltitude(500);
    // cập nhật vị trí focus...
    _hereMapController.camera.internalupdateCoordinates(
        GeoCoordinates(geoCoordinates.latitude, geoCoordinates.longitude));
  }

  void _clearMapMarkerPlace() {
    for (var mapMarker in _mapMarkerPlaceList) {
      _hereMapController.mapScene.removeMapMarker(mapMarker);
    }
    _mapMarkerPlaceList.clear();
  }

  void clearMapMarker() {
    for (var mapMarker in _mapMarkerList) {
      _hereMapController.mapScene.removeMapMarker(mapMarker);
    }
    _mapMarkerList.clear();
  }

  void clearMap() {
    for (var mapMarker in _mapMarkerList) {
      _hereMapController.mapScene.removeMapMarker(mapMarker);
    }
    for (var mapMarker in _mapMarkerPlaceList) {
      _hereMapController.mapScene.removeMapMarker(mapMarker);
    }
    _mapMarkerPlaceList.clear();
    _mapMarkerList.clear();
  }

  Future<void> _addPhotoMapMarkerWithImagesUrl(GeoCoordinates geoCoordinates,
      int drawOrder, Uint8List imagePixelData) async {
    // Reuse existing MapImage for new map markers.
    if (_photoMapImage == null) {
      _photoMapImage =
          MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);
    }

    MapMarker mapMarker = MapMarker(geoCoordinates, _photoMapImage);
    mapMarker.drawOrder = drawOrder;

    _hereMapController.mapScene.addMapMarker(mapMarker);
    _mapMarkerPlaceList.add(mapMarker);
  }

  Future<void> _addPOIMapMarker(
      GeoCoordinates geoCoordinates, int drawOrder) async {
    // Reuse existing MapImage for new map markers.
    if (_poiMapImage == null) {
      Uint8List imagePixelData = await _loadFileAsUint8List('poi.png');
      print(imagePixelData);
      _poiMapImage =
          MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);
    }

    // By default, the anchor point is set to 0.5, 0.5 (= centered).
    // Here the bottom, middle position should point to the location.
    Anchor2D anchor2D = Anchor2D.withHorizontalAndVertical(0.5, 1);

    MapMarker mapMarker =
        MapMarker.withAnchor(geoCoordinates, _poiMapImage, anchor2D);
    mapMarker.drawOrder = drawOrder;

    Metadata metadata = new Metadata();
    metadata.setString("key_poi", "Metadata: This is a POI.");
    mapMarker.metadata = metadata;

    _hereMapController.mapScene.addMapMarker(mapMarker);
    _mapMarkerPlaceList.add(mapMarker);
  }

  Future<void> _addPhotoMapMarker(
      GeoCoordinates geoCoordinates, int drawOrder) async {
    // Reuse existing MapImage for new map markers.
    if (_photoMapImage == null) {
      Uint8List imagePixelData = await _loadFileAsUint8List('my_location.png');
      _photoMapImage =
          MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);
    }

    MapMarker mapMarker = MapMarker(geoCoordinates, _photoMapImage);
    mapMarker.drawOrder = drawOrder;

    _hereMapController.mapScene.addMapMarker(mapMarker);
    _mapMarkerList.add(mapMarker);
  }

  Future<void> _addCircleMapMarker(
      GeoCoordinates geoCoordinates, int drawOrder) async {
    // Reuse existing MapImage for new map markers.
    if (_circleMapImage == null) {
      Uint8List imagePixelData = await _loadFileAsUint8List('circle.png');
      _circleMapImage =
          MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);
    }

    MapMarker mapMarker = MapMarker(geoCoordinates, _circleMapImage);
    mapMarker.drawOrder = drawOrder;

    _hereMapController.mapScene.addMapMarker(mapMarker);
    _mapMarkerPlaceList.add(mapMarker);
  }

  Future<Uint8List> _loadFileAsUint8List(String fileName) async {
    // The path refers to the assets directory as specified in pubspec.yaml.
    ByteData fileData = await rootBundle.load('assets/images/' + fileName);
    return Uint8List.view(fileData.buffer);
  }

// thằng này xử lí các điểm đánh dấu ấn vào hiển thị thông tin trong dialog

  void _setTapGestureHandler() {
    _hereMapController.gestures.tapListener =
        TapListener.fromLambdas(lambda_onTap: (Point2D touchPoint) {
      _pickMapMarker(touchPoint);
    });
  }

  _getDataInLocation({double lat, double long}) async {
    var api = HttpApi();
    return await api.GetDataInLocationHereMap(
        long: long.toString(), lat: lat.toString());
  }

  void _pickMapMarker(Point2D touchPoint) {
    double radiusInPixel = 5;
    _hereMapController.pickMapItems(touchPoint, radiusInPixel,
        (pickMapItemsResult) async {
      List<MapMarker> mapMarkerList = pickMapItemsResult.markers;
      if (mapMarkerList.length == 0) {
        print("No map markers found.");
        return;
      }

      MapMarker topmostMapMarker = mapMarkerList.first;

      //Metadata metadata = topmostMapMarker.metadata;
      AddressModelHereMapReturn addressModelHereMapReturn =
          await _getDataInLocation(
              lat: topmostMapMarker.coordinates.latitude,
              long: topmostMapMarker.coordinates.longitude);
      _showDialogDataInLocation(
          subdistrict: addressModelHereMapReturn.addressModel.Subdistrict,
          city: addressModelHereMapReturn.addressModel.City,
          county: addressModelHereMapReturn.addressModel.County,
          district: addressModelHereMapReturn.addressModel.District,
          street: addressModelHereMapReturn.addressModel.Street,
          country: addressModelHereMapReturn.addressModel.Country,
          houseNumber: addressModelHereMapReturn.addressModel.HouseNumber);
//      if (metadata != null) {
//        String message = metadata.getString("key_poi") ?? "No message found.";
//        _showDialog("Map Marker picked", message);
//        return;
//      }
//
//      _showDialog("Map Marker picked", "No metadata attached.");
    });
  }

  Future<GeoCoordinates> _getLocation() async {
    GetLocationController getLocationController = GetLocationController();
    CoordinatesDoubleModel coordinatesDoubleModel =
        await getLocationController.getLocationExisting();
    geoCoordinates_return = GeoCoordinates(
        coordinatesDoubleModel.latitude, coordinatesDoubleModel.longitude);
    return GeoCoordinates(
        coordinatesDoubleModel.latitude, coordinatesDoubleModel.longitude);
  }

  Future<void> _showDialogDataInLocation({
    String country,
    String county,
    String city,
    String district,
    String subdistrict,
    String street,
    String houseNumber,
  }) async {
    return showDialog<void>(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.only(top: setHeightSize(size: 20)),
          title: Text(
            "Thông tin chi tiết.",
            style: styleTextTitleInAppBarBlack,
          ),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(setWidthSize(size: 15.0)),
                  child: ListBody(
                    children: <Widget>[
                      houseNumber != null
                          ? Text(
                              "Số nhà: ${houseNumber}",
                              style: styleTextContentBlack,
                            )
                          : Container(),
                      street != null
                          ? Text(
                              "Đường: ${street}",
                              style: styleTextContentBlack,
                            )
                          : Container(),
                      subdistrict != null
                          ? Text(
                              "Phường: ${subdistrict}",
                              style: styleTextContentBlack,
                            )
                          : Container(),
                      Text(
                        "Quận,Xã: ${district}",
                        style: styleTextContentBlack,
                      ),
                      Text("Thành phố,Huyện: ${city}",
                          style: styleTextContentBlack),
                    ],
                  ),
                ),
                Container(
                  height: setHeightSize(size: 140),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/background_dialog_1.png"),
                  )),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
