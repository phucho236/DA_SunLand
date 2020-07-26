import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_attendance_management/create_name_group_attendance_mangament_controller.dart';
import 'package:flutter_core/view_system/group_attendance_management/pick_location_here_map_screen.dart';
import 'package:flutter_core/widgets/text_field_boder.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:numberpicker/numberpicker.dart';

class CreateNameGroupAttendanceMangamentScreen extends StatefulWidget {
  static String id = "CreateNameGroupAttendanceMangamentScreen";
  @override
  _CreateNameGroupAttendanceMangamentScreenState createState() =>
      _CreateNameGroupAttendanceMangamentScreenState();
}

class _CreateNameGroupAttendanceMangamentScreenState
    extends State<CreateNameGroupAttendanceMangamentScreen> {
  String name_group_attendance_mangament;
  int hour_start = 8;
  int hours_end = 18;
  int minute_start = 0;
  int minute_end = 0;
  String name_group;
  CreateNameGroupAttendanceMangamentController
      createNameGroupAttendanceMangamentController =
      CreateNameGroupAttendanceMangamentController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Tạo nhóm điểm danh.(1/2)"),
        backgroundColor: colorAppbar,
      ),
      body: Stack(
        children: <Widget>[
          PositionedDirectional(
            height: setWidthSize(size: 500),
            width: setWidthSize(size: 500),
//              right: 50,
            start: 50,
            bottom: 450,
//              top: 50,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360),
                gradient: LinearGradient(
                  colors: [Colors.deepOrangeAccent, Colors.amberAccent],
                  tileMode:
                      TileMode.mirror, // repeats the gradient over the canvas
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: Offset(0, 1),
                      spreadRadius: 1),
                ],
              ),
            ),
          ),
          PositionedDirectional(
            start: setWidthSize(size: 70),
            bottom: setHeightSize(size: 645),
            width: setWidthSize(size: 400),
            child: Padding(
              padding: EdgeInsets.all(setWidthSize(size: 15)),
              child: TextFieldBorder(
                onChanged: (value) {
                  name_group = value;
                },
                hintText: "Tên nhóm",
              ),
            ),
          ),
          PositionedDirectional(
            height: setWidthSize(size: 200),
            width: setWidthSize(size: 200),
            start: 150,
            bottom: 370,
            child: Container(
              decoration: BoxDecoration(
                color: kColorYellow,
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [Colors.teal[300], colorAppbar],
                  tileMode:
                      TileMode.mirror, // repeats the gradient over the canvas
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: Offset(0, 1),
                      spreadRadius: 1),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: setHeightSize(size: 20),
                  ),
                  Text(
                    "Thời gian bắt đầu",
                    style: styleTextTitleInAppBarBlack,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            "Giờ",
                            style: styleTextTitleInBodyBlack,
                          ),
                          NumberPicker.integer(
                              initialValue: hour_start,
                              minValue: 0,
                              maxValue: 23,
                              onChanged: (newValue) {
                                setState(() {
                                  hour_start = newValue;
                                });
                              }),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            "Phút",
                            style: styleTextTitleInBodyBlack,
                          ),
                          NumberPicker.integer(
                              initialValue: minute_start,
                              minValue: 0,
                              maxValue: 60,
                              onChanged: (newValue) {
                                setState(() {
                                  minute_start = newValue;
                                });
                              }),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          PositionedDirectional(
            height: setWidthSize(size: 200),
            width: setWidthSize(size: 200),
            start: 15,
            bottom: 100,
            child: Container(
              decoration: BoxDecoration(
                color: kColorYellow,
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [Colors.teal[300], colorAppbar],
                  tileMode:
                      TileMode.mirror, // repeats the gradient over the canvas
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: Offset(0, 1),
                      spreadRadius: 1),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: setHeightSize(size: 20),
                  ),
                  Text(
                    "Thời gian kết thúc",
                    style: styleTextTitleInAppBarBlack,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            "Giờ",
                            style: styleTextTitleInBodyBlack,
                          ),
                          NumberPicker.integer(
                              initialValue: hours_end,
                              minValue: 0,
                              maxValue: 23,
                              onChanged: (newValue) {
                                setState(() {
                                  hours_end = newValue;
                                });
                              }),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            "Phút",
                            style: styleTextTitleInBodyBlack,
                          ),
                          NumberPicker.integer(
                              initialValue: minute_end,
                              minValue: 0,
                              maxValue: 60,
                              onChanged: (newValue) {
                                setState(() {
                                  minute_end = newValue;
                                });
                              }),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          PositionedDirectional(
            start: 50,
            bottom: 40,
            child: Center(
              child: Container(
                width: setWidthSize(size: 150),
                child: StreamBuilder(
                  stream:
                      createNameGroupAttendanceMangamentController.errStream,
                  builder: (context, snapshot) => Text(
                    snapshot.hasError ? snapshot.error : '',
                    style: styleTextErrorBlack,
                  ),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            height: setWidthSize(size: 100),
            width: setWidthSize(size: 100),
//              right: 50,
//              left: 50,
            start: 280,
            bottom: 20,
//              top: 50,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                bool _result =
                    createNameGroupAttendanceMangamentController.onSubmitOke(
                  name_group:
                      name_group != null ? name_group.trim() : name_group,
                  time_end: TimeModel(hours: hours_end, minute: minute_end),
                  time_start:
                      TimeModel(hours: hour_start, minute: minute_start),
                );
                print("ABCD");
                print(_result);
                if (_result == true) {
                  Navigator.pushNamed(
                    context,
                    PickLocationHereMapScreen.id,
                    arguments: PickLocationHereMapScreen(
                      name_group: name_group,
                      time_end: TimeModel(hours: hours_end, minute: minute_end),
                      time_start:
                          TimeModel(hours: hour_start, minute: minute_start),
                    ),
                  ).then((value) {
                    if (value == true) {
                      Navigator.pop(context, true);
                    }
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: kColorYellow,
                  borderRadius: BorderRadius.circular(180),
                  gradient: LinearGradient(
                    colors: [Colors.teal, colorAppbar],
                    tileMode:
                        TileMode.mirror, // repeats the gradient over the canvas
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        offset: Offset(0, 1),
                        spreadRadius: 1),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Đồng ý",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
