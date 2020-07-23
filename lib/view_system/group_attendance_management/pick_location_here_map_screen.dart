import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/group_here_map/geocode_here_map_controller.dart';
import 'package:flutter_core/group_here_map/gestures_controller.dart';
import 'package:flutter_core/group_here_map/map_maker_controller.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_attendance_management/create_name_group_attendance_mangament_controller.dart';
import 'package:flutter_core/view_system/group_attendance_management/pick_location_here_map_controller.dart';
import 'package:flutter_core/widgets/button_normal.dart';
import 'package:flutter_core/widgets/search_textfield_border.dart';
import 'package:here_sdk/core.dart';
import 'package:flutter_core/group_here_map/routing_controller.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:here_sdk/mapview.dart';

class PickLocationHereMapScreen extends StatefulWidget {
  static String id = "PickLocationHereMapScreen";
  PickLocationHereMapScreen({this.time_start, this.time_end, this.name_group});
  final TimeModel time_start;
  final TimeModel time_end;
  final String name_group;
  @override
  _PickLocationHereMapScreenState createState() =>
      _PickLocationHereMapScreenState();
}

class _PickLocationHereMapScreenState extends State<PickLocationHereMapScreen> {
  BuildContext _context;
  RoutingController _routingController;
  MapMarkerController _mapMarkerController;
  GeocodeHereMapController geocodeHereMapController =
      GeocodeHereMapController();
  PickLocationHereMapController pickLocationHereMapController =
      PickLocationHereMapController();
  TextEditingController textEditingControllerSearchFeild =
      TextEditingController();
  CoordinatesDoubleModel coordinatesDoubleModel = CoordinatesDoubleModel();
  GeoCoordinates geoCoordinates_on_hold;
  List<SuggestionsModel> listSuggestionsModel = [];
  getlistSuggestionsModel({String data}) async {
    List<SuggestionsModel> listSuggestionsModelTmp = [];
    listSuggestionsModelTmp =
        await geocodeHereMapController.GetRequestingAutocompleteSuggestions(
            data: data);
    if (listSuggestionsModelTmp != null) {
      setState(() {
        listSuggestionsModel = listSuggestionsModelTmp;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    coordinatesDoubleModel.latitude = 10.808820;
    coordinatesDoubleModel.longitude = 106.623436;
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    PickLocationHereMapScreen args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text(
          "Chọn địa điểm(2/2)",
          style: styleTextTitleInAppWhite,
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                HereMap(onMapCreated: _onMapCreated),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Search_TextField_Border(
                        controller: textEditingControllerSearchFeild,
                        hintText: "Địa chỉ",
                        onChanged: (value) {
                          getlistSuggestionsModel(data: value);
                        },
                        borderRadius: 1.5,
                        colorBorDer: Colors.white,
                        sizeBorder: 2,
                      ),
                    ),
                    listSuggestionsModel.length > 0
                        ? Container(
                            height: setHeightSize(size: 300),
                            child: ListView.separated(
                              padding: EdgeInsets.symmetric(
                                  horizontal: setWidthSize(size: 15)),
                              itemCount: listSuggestionsModel.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    if (listSuggestionsModel[index]
                                            .matchLevel ==
                                        'houseNumber') {
                                      geocodeHereMapController
                                          .getGeocodeHereMap(
                                              street: removeb(
                                                  exist_value_b:
                                                      listSuggestionsModel[
                                                              index]
                                                          .address_lever_house_number
                                                          .street),
                                              housenumber: removeb(
                                                  exist_value_b:
                                                      listSuggestionsModel[
                                                              index]
                                                          .address_lever_house_number
                                                          .houseNumber),
                                              district: removeb(
                                                  exist_value_b:
                                                      listSuggestionsModel[
                                                              index]
                                                          .address_lever_house_number
                                                          .district),
                                              county: removeb(
                                                  exist_value_b:
                                                      listSuggestionsModel[
                                                              index]
                                                          .address_lever_house_number
                                                          .county),
                                              city: removeb(
                                                  exist_value_b:
                                                      listSuggestionsModel[
                                                              index]
                                                          .address_lever_house_number
                                                          .city))
                                          .then((value) {
                                        if (value != null) {
                                          GeoCoordinates geoCoordinates =
                                              GeoCoordinates(
                                                  value.displayPositionModel
                                                      .Latitude,
                                                  value.displayPositionModel
                                                      .Longitude);
                                          _mapMarkerController
                                              .showAnchoredMapMarkers(
                                                  geoCoordinates:
                                                      geoCoordinates,
                                                  internalupdateCoordinates:
                                                      true);
                                          textEditingControllerSearchFeild
                                              .clear();
                                          setState(() {
                                            listSuggestionsModel = [];
                                          });
                                        }
                                      });
                                    }
                                    if (listSuggestionsModel[index]
                                            .matchLevel ==
                                        'street') {
                                      geocodeHereMapController
                                          .getGeocodeHereMap(
                                              street: removeb(
                                                  exist_value_b:
                                                      listSuggestionsModel[
                                                              index]
                                                          .address_lever_street
                                                          .street),
                                              district: removeb(
                                                  exist_value_b:
                                                      listSuggestionsModel[
                                                              index]
                                                          .address_lever_street
                                                          .district),
                                              county: removeb(
                                                  exist_value_b:
                                                      listSuggestionsModel[
                                                              index]
                                                          .address_lever_street
                                                          .county),
                                              city: removeb(
                                                  exist_value_b:
                                                      listSuggestionsModel[
                                                              index]
                                                          .address_lever_street
                                                          .city))
                                          .then((value) {
                                        if (value != null) {
                                          GeoCoordinates geoCoordinates =
                                              GeoCoordinates(
                                                  value.displayPositionModel
                                                      .Latitude,
                                                  value.displayPositionModel
                                                      .Longitude);
                                          _mapMarkerController
                                              .showAnchoredMapMarkers(
                                                  geoCoordinates:
                                                      geoCoordinates,
                                                  internalupdateCoordinates:
                                                      true);
                                          textEditingControllerSearchFeild
                                              .clear();
                                          setState(() {
                                            listSuggestionsModel = [];
                                          });
                                        }
                                      });
                                    } else {
                                      geocodeHereMapController
                                          .getGeocodeHereMap(
                                              street: removeb(
                                                  exist_value_b:
                                                      listSuggestionsModel[
                                                              index]
                                                          .address_lever_district
                                                          .street),
                                              district: removeb(
                                                  exist_value_b:
                                                      listSuggestionsModel[
                                                              index]
                                                          .address_lever_district
                                                          .district),
                                              county: removeb(
                                                  exist_value_b:
                                                      listSuggestionsModel[
                                                              index]
                                                          .address_lever_district
                                                          .county),
                                              city: removeb(
                                                  exist_value_b:
                                                      listSuggestionsModel[
                                                              index]
                                                          .address_lever_district
                                                          .city))
                                          .then((value) {
                                        if (value != null) {
                                          GeoCoordinates geoCoordinates =
                                              GeoCoordinates(
                                                  value.displayPositionModel
                                                      .Latitude,
                                                  value.displayPositionModel
                                                      .Longitude);
                                          _mapMarkerController
                                              .showAnchoredMapMarkers(
                                                  geoCoordinates:
                                                      geoCoordinates,
                                                  internalupdateCoordinates:
                                                      true);
                                          textEditingControllerSearchFeild
                                              .clear();
                                          setState(() {
                                            listSuggestionsModel = [];
                                          });
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    color: Colors.orange[50],
                                    child: Padding(
                                        padding: EdgeInsets.all(
                                            setWidthSize(size: 5)),
                                        child: listSuggestionsModel[index]
                                                    .matchLevel ==
                                                "houseNumber"
                                            ? Text(
                                                "${removeb(exist_value_b: listSuggestionsModel[index].address_lever_house_number.houseNumber)},${removeb(exist_value_b: listSuggestionsModel[index].address_lever_house_number.street)},${removeb(exist_value_b: listSuggestionsModel[index].address_lever_house_number.district)},${listSuggestionsModel[index].address_lever_house_number.city}",
                                                style: styleTextContentBlack,
                                              )
                                            : listSuggestionsModel[index]
                                                        .matchLevel ==
                                                    "street"
                                                ? Text(
                                                    "${removeb(exist_value_b: listSuggestionsModel[index].address_lever_street.street)},${removeb(exist_value_b: listSuggestionsModel[index].address_lever_street.district)},${listSuggestionsModel[index].address_lever_street.city == '' ? removeb(exist_value_b: listSuggestionsModel[index].address_lever_street.city) : removeb(exist_value_b: listSuggestionsModel[index].address_lever_street.county)}",
                                                    style:
                                                        styleTextContentBlack,
                                                  )
                                                : listSuggestionsModel[index]
                                                            .matchLevel ==
                                                        "district"
                                                    ? Text(
                                                        "${removeb(exist_value_b: listSuggestionsModel[index].address_lever_district.district)},${listSuggestionsModel[index].address_lever_district.county == listSuggestionsModel[index].address_lever_district.city ? removeb(exist_value_b: listSuggestionsModel[index].address_lever_district.county) : removeb(exist_value_b: listSuggestionsModel[index].address_lever_district.county) + ',' + removeb(exist_value_b: listSuggestionsModel[index].address_lever_district.city)}",
                                                        style:
                                                            styleTextContentBlack,
                                                      )
                                                    : Text(
                                                        "Không tìm thấy địa chỉ.")),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Container(
                                  height: 10,
                                );
                              },
                            ),
                          )
                        : Container(),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                      children: [
//                        button('Add Route', _addRouteButtonClicked),
//                        button('Clear Map', _clearMapButtonClicked),
//                      ],
//                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: setWidthSize(size: 10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Center(
                        child: Container(
                          child: StreamBuilder(
                            stream: pickLocationHereMapController.errStream,
                            builder: (context, snapshot) => Text(
                              snapshot.hasError ? snapshot.error : '',
                              style: styleTextContentNoInput,
                            ),
                          ),
                          color: Colors.amberAccent[100],
                        ),
                      ),
                      Container(
                        width: setWidthSize(size: 200),
                        child: ButtonNormal(
                          onTap: () async {
                            await pickLocationHereMapController
                                .onSubmitOkePickLocation(
                                    time_start: args.time_start,
                                    time_end: args.time_end,
                                    name_group: args.name_group,
                                    geoCoordinates: _mapMarkerController
                                        .geoCoordinates_return)
                                .then((value) {
                              if (value == true) {
                                Navigator.pop(context, true);
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDiaLogScreen(
                                      title: "Thông báo",
                                      message: "Tạo nhóm điểm danh thành công",
                                    );
                                  },
                                );
                              } else {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDiaLogScreen(
                                      title: "Thông báo",
                                      message: "Tạo nhóm điểm danh thất bại",
                                    );
                                  },
                                );
                              }
                            });
                          },
                          text: "Đồng ý",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(
            onPressed: () => _centeredMapMarkersButtonClicked(),
            icon: Icon(Icons.my_location),
          ),
          SizedBox(
            height: setHeightSize(size: 10),
          ),
        ],
      ),
    );
  }

  // A helper method to add a button on top of the HERE map.
  Align button(String buttonLabel, Function callbackFunction) {
    return Align(
      alignment: Alignment.topCenter,
      child: RaisedButton(
        color: Colors.lightBlueAccent,
        textColor: Colors.white,
        onPressed: () => callbackFunction(),
        child: Text(buttonLabel, style: TextStyle(fontSize: 20)),
      ),
    );
  }

  void _onMapCreated(HereMapController hereMapController) {
    hereMapController.setWatermarkPosition(WatermarkPlacement.bottomLeft, 1);
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
        (MapError error) {
      if (error == null) {
        _routingController = RoutingController(_context, hereMapController);
//        GesturesController(_context, hereMapController);
        _mapMarkerController = MapMarkerController(
            hereMapController: hereMapController,
            context: _context,
            allowLongPressGestureHandler: true);
      } else {
        print("Map scene not loaded. MapError: " + error.toString());
      }

      if (error != null) {
        print('Map scene not loaded. MapError: ${error.toString()}');
        return;
      }

      const double distanceToEarthInMeters = 8000;
      hereMapController.camera.lookAtPointWithDistance(
          GeoCoordinates(coordinatesDoubleModel.latitude,
              coordinatesDoubleModel.longitude),
          distanceToEarthInMeters);
    });
  }

  void _centeredMapMarkersButtonClicked() {
    _clearButtonClicked();
    _mapMarkerController.showCenteredMapMarkers();
  }

  void _clearButtonClicked() {
    _mapMarkerController.clearMap();
  }

  void _addRouteButtonClicked() {
    _routingController.addRoute();
  }

  void _clearMapButtonClicked() {
    _routingController.clearMap();
  }
}
