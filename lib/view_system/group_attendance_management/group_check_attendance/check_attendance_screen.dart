import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/group_here_map/map_maker_controller.dart';
import 'package:flutter_core/group_here_map/routing_controller.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/providers/global_provider.dart';
import 'package:flutter_core/view_system/group_attendance_management/group_check_attendance/check_attendance_controller.dart';
import 'package:flutter_core/view_system/group_attendance_management/group_history_attendance/history_attendance_screen.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/widgets/creat_boder_shape.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:location/location.dart' as foo;
import 'package:provider/provider.dart';
import 'dart:async';

class CheckAttendanceScreen extends StatefulWidget {
  static String id = "CheckAttendanceScreen";
  @override
  _CheckAttendanceScreenState createState() => _CheckAttendanceScreenState();
}

class _CheckAttendanceScreenState extends State<CheckAttendanceScreen> {
  CoordinatesDoubleModel coordinatesDoubleModel = CoordinatesDoubleModel();
  List<GroupAttendanceModel> listGroupAttendanceModel = [];
  GroupAttendanceModel groupAttendanceModel;
  String document_id_custommer;
  bool ischeckFakeLocation = false;
  bool stream_location = false;
//  StreamSubscription<Position> locationSubscription;
  BuildContext _context;
  RoutingController _routingController;
  MapMarkerController _mapMarkerController;
  bool serviceEnabled = false;
  foo.Location location = foo.Location();
  var geolocator = Geolocator();
  StreamSubscription<Position> positionStream;
  var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high, distanceFilter: 0, timeInterval: 3000);
  SessionAttendanceModel sessionAttendanceModel;
  checkPermistionLocation() async {
    bool _serviceEnabled;
    foo.PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      setState(() {
        serviceEnabled = _serviceEnabled;
      });
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == foo.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != foo.PermissionStatus.granted) {
        return;
      }
    }
  }

  streamLocationExisting() {
    try {
      positionStream = geolocator
          .getPositionStream(locationOptions)
          .listen((currentLocation) {
        GeoCoordinates geoCoordinates = GeoCoordinates.withAltitude(
          currentLocation.latitude,
          currentLocation.longitude,
          currentLocation.latitude,
        );
        bool mocked = ischeckFakeLocation ? currentLocation.mocked : false;

        if (mocked == true) {
          positionStream.cancel();
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context_) {
              return AlertDiaLogScreen(
                title: "Thông báo",
                message: "Vui lòng tắt vị trí giả !",
              );
            },
          ).then((value) {
            if (value == true) {
              streamLocationExisting();
            }
          });
        }
        if (mocked == false) {
          if (geoCoordinates != null) {
            _SteamCenteredMapMarkers(
                geoCoordinates: geoCoordinates,
                stream_location: stream_location);
          }
          if (groupAttendanceModel != null) {
            _addRoute(
                startgeoCoordinates: geoCoordinates,
                endgeoCoordinates: GeoCoordinates.withAltitude(
                  groupAttendanceModel.coordinatesDoubleModel.latitude,
                  groupAttendanceModel.coordinatesDoubleModel.longitude,
                  1000,
                ));
          }
        }

//      context.read<GlobalData>().updateCoordinatesDoubleModel(
//            newValue: CoordinatesDoubleModel(
//                longitude: currentLocation.longitude,
//                latitude: currentLocation.latitude),
//          );
      });
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }
  }

  getDocumentIdCustommer__() async {
    String document_id_custommerTmp;
    document_id_custommer = await getDocumentIdCustommer();
    if (document_id_custommerTmp != null) {
      setState(() {
        document_id_custommer = document_id_custommerTmp;
      });
    }
  }

  checkTimeCheckOutAttendance(
      GroupAttendanceModel groupAttendanceModel, DateTime dateTime) {
    double hours = dateTime.hour.toDouble();
    double minute = dateTime.minute.toDouble();
    if (hours < groupAttendanceModel.time_end.hours) {
      return true;
    }
    if (hours == groupAttendanceModel.time_end.hours &&
        minute <= groupAttendanceModel.time_end.minute) {
      return true;
    }
    return false;
  }

  checkTimeCheckInAttendance(
      GroupAttendanceModel groupAttendanceModel, DateTime dateTime) {
    double hours = dateTime.hour.toDouble();
    double minute = dateTime.minute.toDouble();
    if (hours < groupAttendanceModel.time_start.hours) {
      return false;
    }
    if (hours == groupAttendanceModel.time_start.hours &&
        minute < groupAttendanceModel.time_start.minute) {
      return false;
    }
    return true;
  }

  createSessionAttendance() async {
    DateTime dateTime = DateTime.now();
    String time_minute_check_in_late =
        (((dateTime.hour * 60 + dateTime.minute)) -
                groupAttendanceModel.time_start.hours * 60 +
                groupAttendanceModel.time_start.minute)
            .toString();
    bool islate = checkTimeCheckInAttendance(groupAttendanceModel, dateTime);
    return await checkAttendanceController.onCreateSessionAttendance(
        time_check_in: dateTime.toString(),
        time_minute_check_in_late: islate ? time_minute_check_in_late : null,
        document_id_attendance:
            groupAttendanceModel.document_id_group_attendance,
        check_in_late: islate,
        document_id_custommer: document_id_custommer);
  }

  updateCheckOutSessitonAttendace() async {
    DateTime dateTime = DateTime.now();
    String time_minute_check_out_soon =
        ((groupAttendanceModel.time_end.hours * 60 +
                    groupAttendanceModel.time_end.minute) -
                (dateTime.hour * 60 + dateTime.minute))
            .toString();
    bool islate = checkTimeCheckOutAttendance(groupAttendanceModel, dateTime);
    return await checkAttendanceController.onUpdateSessionAttendance(
        time_check_out: dateTime.toString(),
        document_id_custommer: document_id_custommer,
        document_session_attendance:
            sessionAttendanceModel.document_id_session_attendance,
        time_minute_check_out_soon: islate ? time_minute_check_out_soon : null,
        check_out_soon: islate);
  }

  getDataSessionAttendanceInDay(
      {GroupAttendanceModel groupAttendanceModel_}) async {
    SessionAttendanceModel sessionAttendanceModelTmp;
    sessionAttendanceModelTmp =
        await checkAttendanceController.onGetDataSessionAttendanceInToDay(
            document_id_custommer: document_id_custommer,
            document_id_group_attendance:
                groupAttendanceModel_.document_id_group_attendance);
    if (sessionAttendanceModelTmp != null) {
      setState(() {
        sessionAttendanceModel = sessionAttendanceModelTmp;
      });
    }
  }

  getListGroupAttendanceModel() async {
    if (document_id_custommer == null) {
      await getDocumentIdCustommer__();
    }
    List<GroupAttendanceModel> listGroupAttendanceModelTmp = [];
    listGroupAttendanceModelTmp =
        await checkAttendanceController.getListModelAttendanceOfTheUser(
            document_id_custommer: document_id_custommer);
    if (listGroupAttendanceModelTmp != null) {
      setState(() {
        listGroupAttendanceModel = listGroupAttendanceModelTmp;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListGroupAttendanceModel();
    coordinatesDoubleModel.latitude = 10.808820;
    coordinatesDoubleModel.longitude = 106.623436;
  }

  CheckAttendanceController checkAttendanceController =
      CheckAttendanceController();
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GlobalData>(context);
    _context = context;
    return Scaffold(
      backgroundColor: colorBackGroundGrey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: Row(
              children: <Widget>[
                DropdownButton<GroupAttendanceModel>(
                  value: groupAttendanceModel,
                  onTap: () {
                    setState(() {
                      sessionAttendanceModel = null;
                      groupAttendanceModel = null;
                    });
                  },
                  onChanged: (GroupAttendanceModel value) async {
                    await getDataSessionAttendanceInDay(
                        groupAttendanceModel_: value);
                    _showMakerEnd(
                        endtgeoCoordinates: GeoCoordinates.withAltitude(
                      value.coordinatesDoubleModel.latitude,
                      value.coordinatesDoubleModel.longitude,
                      1000,
                    ));
                    setState(() {
                      groupAttendanceModel = value;
                    });
                  },
                  style: styleTextContentBlack,
                  hint: Text(
                    'Nhóm điếm danh',
                    style: styleTextHintBlack,
                  ),
                  icon: Icon(Icons.arrow_drop_down),
                  items: listGroupAttendanceModel
                      .map((GroupAttendanceModel groupAttendanceModel) {
                    return DropdownMenuItem<GroupAttendanceModel>(
                      value: groupAttendanceModel,
                      child: Text(
                        groupAttendanceModel.name_group,
                        style: styleTextContentBlack,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: colorAppbarGrey,
        title: Text(
          "Điểm danh",
          style: styleTextTitleInAppBarBlack,
        ),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
//                Text(
//                  "${provider.coordinatesModel.longitude},${provider.coordinatesModel.longitude}",
//                  style: styleTextContentBlack,
//                ),
              SizedBox(
                height: setHeightSize(size: 10),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: setWidthSize(size: 15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Visibility(
                      visible: groupAttendanceModel != null ? true : false,
                      child: Column(
                        children: <Widget>[
                          Text(groupAttendanceModel == null
                              ? ""
                              : "Bắt đầu: ${groupAttendanceModel.time_start.hours}:${groupAttendanceModel.time_start.minute} phút"),
                          Text(groupAttendanceModel == null
                              ? ""
                              : "Kết thúc: ${groupAttendanceModel.time_end.hours}:${groupAttendanceModel.time_end.minute} phút")
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        FlutterSwitch(
                          activeColor: colorAppbar,
                          width: setWidthSize(size: 50),
                          height: setHeightSize(size: 30),
                          valueFontSize: 14.0,
                          toggleSize: 10.0,
                          value: ischeckFakeLocation,
                          borderRadius: 30.0,
                          padding: 5.0,
                          showOnOff: true,
                          onToggle: (val) {
                            setState(() {
                              ischeckFakeLocation = val;
                            });
                          },
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Theo dõi vị trí: ",
                              style: styleTextContentBlack,
                            ),
                            FlutterSwitch(
                              activeColor: colorAppbar,
                              width: setWidthSize(size: 50),
                              height: setHeightSize(size: 30),
                              valueFontSize: 14.0,
                              toggleSize: 10.0,
                              value: stream_location,
                              borderRadius: 30.0,
                              padding: 5.0,
                              showOnOff: true,
                              onToggle: (val) {
                                setState(() {
                                  stream_location = val;
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),

              groupAttendanceModel != null
                  ? sessionAttendanceModel == null
                      ? Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              if (double.parse(provider.travelLength) > 0.1 ||
                                  provider.travelLength == '0.0') {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDiaLogScreen(
                                      title: "Thông báo",
                                      message:
                                          "Khoảng cách tối thiểu là 100m để điểm danh.",
                                    );
                                  },
                                );
                              } else {
                                createSessionAttendance();
                                getDataSessionAttendanceInDay(
                                    groupAttendanceModel_:
                                        groupAttendanceModel);
                              }
                            },
                            child: Center(
                              child: Container(
                                height: setWidthSize(size: 150),
                                width: setWidthSize(size: 150),
                                decoration: BoxDecoration(
                                  color: kColorYellow,
                                  borderRadius: BorderRadius.circular(180),
                                  gradient: LinearGradient(
                                    colors:
                                        double.parse(provider.travelLength) <=
                                                0.1
                                            ? [Colors.teal, colorAppbar]
                                            : [Colors.red, Colors.orange],
                                    tileMode: TileMode
                                        .mirror, // repeats the gradient over the canvas
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[500],
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 8.0,
                                        spreadRadius: 1.0),
                                    BoxShadow(
                                        color: Colors.white,
                                        offset: Offset(-2.0, -2.0),
                                        blurRadius: 8.0,
                                        spreadRadius: 1.0),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "Điểm danh",
                                    style: styleTextTitleInAppWhite,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : sessionAttendanceModel.took_check_out == false
                          ? Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  if (double.parse(provider.travelLength) >
                                      0.1) {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDiaLogScreen(
                                          title: "Thông báo",
                                          message:
                                              "Khoảng cách tối thiểu là 100m để điểm danh.",
                                        );
                                      },
                                    );
                                  } else {
                                    updateCheckOutSessitonAttendace();
                                    getDataSessionAttendanceInDay(
                                        groupAttendanceModel_:
                                            groupAttendanceModel);
                                  }
                                },
                                child: Center(
                                  child: Container(
                                    height: setWidthSize(size: 150),
                                    width: setWidthSize(size: 150),
                                    decoration: BoxDecoration(
                                      color: kColorYellow,
                                      borderRadius: BorderRadius.circular(180),
                                      gradient: LinearGradient(
                                        colors: double.parse(
                                                    provider.travelLength) <=
                                                0.1
                                            ? [Colors.teal, colorAppbar]
                                            : [Colors.red, Colors.orange],
                                        tileMode: TileMode
                                            .mirror, // repeats the gradient over the canvas
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey[500],
                                            offset: Offset(2.0, 2.0),
                                            blurRadius: 8.0,
                                            spreadRadius: 1.0),
                                        BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(-2.0, -2.0),
                                            blurRadius: 8.0,
                                            spreadRadius: 1.0),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Hoàn thành",
                                        style: styleTextTitleInAppWhite,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              child: Center(
                                child: Container(
                                  height: setWidthSize(size: 150),
                                  width: setWidthSize(size: 150),
                                  decoration: BoxDecoration(
                                    color: kColorYellow,
                                    borderRadius: BorderRadius.circular(180),
                                    gradient: LinearGradient(
                                      colors: [Colors.teal, colorAppbar],

                                      tileMode: TileMode
                                          .mirror, // repeats the gradient over the canvas
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[500],
                                          offset: Offset(2.0, 2.0),
                                          blurRadius: 8.0,
                                          spreadRadius: 1.0),
                                      BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(-2.0, -2.0),
                                          blurRadius: 8.0,
                                          spreadRadius: 1.0),
                                    ],
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          setWidthSize(size: 15.0)),
                                      child: Text(
                                        "Đã hoàn thành điểm danh",
                                        textAlign: TextAlign.center,
                                        style: styleTextTitleInAppWhite,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                  : Expanded(
                      child: Center(
                        child: Container(
                          height: setWidthSize(size: 150),
                          width: setWidthSize(size: 150),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.red, Colors.orange],
                              tileMode: TileMode
                                  .mirror, // repeats the gradient over the canvas
                            ),
                            borderRadius: BorderRadius.circular(180),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[500],
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 8.0,
                                  spreadRadius: 1.0),
                              BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-2.0, -2.0),
                                  blurRadius: 8.0,
                                  spreadRadius: 1.0),
                            ],
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(setWidthSize(size: 15.0)),
                              child: Text(
                                "Vui lòng chọn nhóm",
                                textAlign: TextAlign.center,
                                style: styleTextTitleInAppWhite,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              sessionAttendanceModel != null &&
                      sessionAttendanceModel.took_check_out == true
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(
                            setWidthSize(size: 10),
                          ),
                          child: Text(
                            "Ngày: ${getDateNoHour(sessionAttendanceModel.time_check_in)}",
                            style: styleTextContentBlack,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                    "Đến lúc:${getDateShowOnlyHourAndMinute(sessionAttendanceModel.time_check_in)}"),
                                Row(
                                  children: <Widget>[
                                    Text("Đến trể: "),
                                    sessionAttendanceModel.check_in_late
                                        ? Icon(
                                            Icons.check_circle_outline,
                                            color: Colors.red,
                                          )
                                        : Icon(Icons.remove_circle_outline)
                                  ],
                                ),
                                Text(
                                    "Trể: ${sessionAttendanceModel.time_minute_check_in_late == null ? "Không có dữ liệu" : "${(num.parse(sessionAttendanceModel.time_minute_check_in_late) / 60).toStringAsFixed(2)} Tiếng"}"),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                    "Về lúc:${getDateShowOnlyHourAndMinute(sessionAttendanceModel.time_check_out)}"),
                                Row(
                                  children: <Widget>[
                                    Text("Về sớm: "),
                                    sessionAttendanceModel.check_out_soon
                                        ? Icon(
                                            Icons.check_circle_outline,
                                            color: Colors.red,
                                          )
                                        : Icon(Icons.remove_circle_outline)
                                  ],
                                ),
                                Text(
                                    "Sớm: ${sessionAttendanceModel.time_minute_check_out_soon == null ? "Không có dữ liệu" : "${(num.parse(sessionAttendanceModel.time_minute_check_out_soon) / 60).toStringAsFixed(2)} Tiếng"}"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  : groupAttendanceModel != null
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: setWidthSize(size: 15)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SizedBox(
                                height: setHeightSize(size: 10),
                              ),
                              Text(
                                "Khoảng cách: ${provider.travelLength} km",
                                style: styleTextContentBlack,
                              ),
                              Text(
                                "Thời gian: ${provider.travelTimeHouse} giờ, ${provider.travelTimeMinutes} phút",
                                style: styleTextContentBlack,
                              ),
                            ],
                          ),
                        )
                      : Container(),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(
              setWidthSize(size: 15),
            ),
            child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[500],
                        offset: Offset(2.0, 2.0),
                        blurRadius: 8.0,
                        spreadRadius: 1.0),
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(-2.0, -2.0),
                        blurRadius: 8.0,
                        spreadRadius: 1.0),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(setWidthSize(size: 2)),
                        child: HereMap(onMapCreated: _onMapCreated),
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, HistoryAttendanceScreen.id);
                            },
                            icon: Icon(Icons.assignment),
                          ),
                          IconButton(
                            onPressed: () => _centeredMapMarkers(),
                            icon: Icon(Icons.gps_fixed),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ]),
    );
  }

  void _onMapCreated(HereMapController hereMapController) {
    hereMapController.setWatermarkPosition(WatermarkPlacement.bottomLeft, 1);
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
        (MapError error) {
      if (error == null) {
        checkPermistionLocation();
        _routingController = RoutingController(_context, hereMapController);
        //GesturesController(_context, hereMapController);
        _mapMarkerController = MapMarkerController(
            allowLongPressGestureHandler: false,
            context: _context,
            hereMapController: hereMapController);
        streamLocationExisting();
      } else {
        print("Map scene not loaded. MapERequested imageUri is emptyrror: " +
            error.toString());
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

  void _SteamCenteredMapMarkers(
      {GeoCoordinates geoCoordinates, bool stream_location}) {
    if (geoCoordinates != null) {
      _mapMarkerController.StreamCenteredMapMarkers(
          geoCoordinates, stream_location);
    }
  }

  void _clearMapMarker() {
    _mapMarkerController.clearMapMarker();
  }

  void _centeredMapMarkers() async {
    if (serviceEnabled == false) {
      checkPermistionLocation();
    } else {
      _clearMapMarker();
      _mapMarkerController.showCenteredMapMarkers();
    }
  }

  void _showMakerEnd({GeoCoordinates endtgeoCoordinates}) {
    _mapMarkerController.showAnchoredMapMarkers(
        geoCoordinates: endtgeoCoordinates, internalupdateCoordinates: false);
  }

  void _addRoute(
      {GeoCoordinates startgeoCoordinates, GeoCoordinates endgeoCoordinates}) {
    _routingController.addRoute(
        startGeoCoordinates: startgeoCoordinates,
        endGeoCoordinates: endgeoCoordinates);
  }

  @override
  void dispose() {
    if (positionStream != null) {
      positionStream.cancel();
    }
    super.dispose();
  }
}
