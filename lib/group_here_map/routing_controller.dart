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

import 'package:flutter/material.dart';
import 'package:flutter_core/providers/global_provider.dart';
import 'dart:math';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart';
import 'package:here_sdk/routing.dart' as here;

import 'package:provider/provider.dart';

class RoutingController {
  BuildContext _context;
  HereMapController _hereMapController;
  List<MapPolyline> _mapPolylines = [];
  RoutingEngine _routingEngine;

  RoutingController(BuildContext context, HereMapController hereMapController) {
    _context = context;
    _hereMapController = hereMapController;

    double distanceToEarthInMeters = 10000;
    _hereMapController.camera.lookAtPointWithDistance(
        GeoCoordinates(52.520798, 13.409408), distanceToEarthInMeters);

    _routingEngine = new RoutingEngine();
  }

  Future<void> addRoute(
      {GeoCoordinates startGeoCoordinates,
      GeoCoordinates endGeoCoordinates}) async {
    var startWaypoint = Waypoint.withDefaults(startGeoCoordinates);
    var destinationWaypoint = Waypoint.withDefaults(endGeoCoordinates);
    List<Waypoint> waypoints = [startWaypoint, destinationWaypoint];
    await _routingEngine.calculateCarRoute(waypoints, CarOptions.withDefaults(),
        (RoutingError routingError, List<here.Route> routeList) async {
      if (routingError == null) {
        clearMap();
        here.Route route = routeList.first;

        _streamRouteDetails(route);
        //dialogg show thông tin chi tiết về tuyến đường
        //_showRouteDetails(route);
        _showRouteOnMap(route);
      } else {
        var error = routingError.toString();
        _showDialog('Error', 'Error while calculating a route: $error');
      }
    });
  }

  void clearMap() {
    for (var mapPolyline in _mapPolylines) {
      _hereMapController.mapScene.removeMapPolyline(mapPolyline);
    }
    _mapPolylines.clear();
  }

  void _streamRouteDetails(here.Route route) {
    int estimatedTravelTimeInSeconds = route.durationInSeconds;
    int lengthInMeters = route.lengthInMeters;

    _context
        .read<GlobalData>()
        .updateTravelLength(newValue: _formatLength(lengthInMeters));
    _context.read<GlobalData>().updateTravelTimeHouse(
        newValue: _formatHours(estimatedTravelTimeInSeconds));
    _context.read<GlobalData>().updateTravelTimeMinutes(
        newValue: _formatMinutes(estimatedTravelTimeInSeconds));
//    String routeDetails = 'Travel Time: ' +
//        _formatTime(estimatedTravelTimeInSeconds) +
//        ', Length: ' +
//        _formatLength(lengthInMeters);
  }

  void _showRouteDetails(here.Route route) {
    int estimatedTravelTimeInSeconds = route.durationInSeconds;
    int lengthInMeters = route.lengthInMeters;

    String routeDetails = 'Travel Time: ' +
        _formatTime(estimatedTravelTimeInSeconds) +
        ', Length: ' +
        _formatLength(lengthInMeters);

    _showDialog('Route Details', '$routeDetails');
  }

  String _formatHours(int sec) {
    int hours = sec ~/ 3600;

    return hours.toString();
  }

  String _formatMinutes(int sec) {
    int minutes = (sec % 3600) ~/ 60;

    return minutes.toString();
  }

  String _formatTime(int sec) {
    int hours = sec ~/ 3600;
    int minutes = (sec % 3600) ~/ 60;

    return '$hours giờ, $minutes phút.';
  }

  String _formatLength(int meters) {
    int kilometers = meters ~/ 1000;
    int remainingMeters = meters % 1000;

    return '$kilometers.$remainingMeters';
  }

  _showRouteOnMap(here.Route route) {
    // Show route as polyline.
    GeoPolyline routeGeoPolyline = GeoPolyline(route.polyline);

    double widthInPixels = 20;
    MapPolyline routeMapPolyline = MapPolyline(
        routeGeoPolyline, widthInPixels, Color.withAlpha(0, 144, 138, 160));

    _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
    _mapPolylines.add(routeMapPolyline);
  }

  GeoCoordinates _createRandomGeoCoordinatesInViewport() {
    GeoBox geoBox = _hereMapController.camera.boundingBox;
    if (geoBox == null) {
      // Happens only when map is not fully covering the viewport.
      return GeoCoordinates(52.530932, 13.384915);
    }

    GeoCoordinates northEast = geoBox.northEastCorner;
    GeoCoordinates southWest = geoBox.southWestCorner;

    double minLat = southWest.latitude;
    double maxLat = northEast.latitude;
    double lat = _getRandom(minLat, maxLat);

    double minLon = southWest.longitude;
    double maxLon = northEast.longitude;
    double lon = _getRandom(minLon, maxLon);

    return new GeoCoordinates(lat, lon);
  }

  double _getRandom(double min, double max) {
    return min + Random().nextDouble() * (max - min);
  }

  Future<void> _showDialog(String title, String message) async {
    return showDialog<void>(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
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
