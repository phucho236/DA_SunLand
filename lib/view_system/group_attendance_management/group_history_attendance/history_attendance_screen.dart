import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_attendance_management/group_history_attendance/history_atten_screen_controller.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/widgets/creat_boder_shape.dart';
import 'package:flutter_core/widgets/text_field_boder.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class HistoryAttendanceScreen extends StatefulWidget {
  static String id = "HistoryAttendancScreen";
  HistoryAttendanceScreen({this.document_id_user = null});
  final document_id_user;
  @override
  _HistoryAttendanceScreenState createState() =>
      _HistoryAttendanceScreenState();
}

class _HistoryAttendanceScreenState extends State<HistoryAttendanceScreen> {
  HistoryAttendanceScreen args;
  DateTime CurenDate = DateTime.now();
  HistoryAttendanceController historyAttendanceController =
      HistoryAttendanceController();
  List<GroupAttendanceModel> listGroupAttendanceModel = [];
  List<SessionAttendanceModel> listsessionAttendanceModel = [];
  GroupAttendanceModel groupAttendanceModel;
  var textDateController = TextEditingController();
  String document_id_custommer;
  String type_sort_time;
  getDocumentIdCustommer__() async {
    String document_id_custommerTmp;
    document_id_custommer = await getDocumentIdCustommer();
    if (document_id_custommerTmp != null) {
      setState(() {
        document_id_custommer = document_id_custommerTmp;
      });
    }
  }

  onFindDataSessionAttendanceInMon(
      {GroupAttendanceModel groupAttendanceModel_, DateTime CurenDate_}) async {
    List<SessionAttendanceModel> listSessionAttendanceModelTmp = [];
    listSessionAttendanceModelTmp =
        await historyAttendanceController.onFindDataSessionAttendanceInMon(
            TimeSessionAttendanceInDay: CurenDate_,
            document_id_custommer: document_id_custommer,
            document_id_group_attendance:
                groupAttendanceModel_.document_id_group_attendance);
    setState(() {
      listsessionAttendanceModel = listSessionAttendanceModelTmp;
    });
  }

  onFindDataSessionAttendanceInDay(
      {GroupAttendanceModel groupAttendanceModel_, DateTime CurenDate_}) async {
    List<SessionAttendanceModel> listSessionAttendanceModelTmp = [];
    listSessionAttendanceModelTmp =
        await historyAttendanceController.onFindDataSessionAttendanceInDay(
            TimeSessionAttendanceInDay: CurenDate_,
            document_id_custommer: document_id_custommer,
            document_id_group_attendance:
                groupAttendanceModel_.document_id_group_attendance);
    if (listSessionAttendanceModelTmp != null) {
      listsessionAttendanceModel = listSessionAttendanceModelTmp;
    } else {
      listsessionAttendanceModel = [];
    }
    setState(() {});
  }

  getListGroupAttendanceModel(HistoryAttendanceScreen args) async {
    if (args == null) {
      if (document_id_custommer == null) {
        await getDocumentIdCustommer__();
      }
    } else {
      setState(() {
        document_id_custommer = args.document_id_user;
      });
    }
    List<GroupAttendanceModel> listGroupAttendanceModelTmp = [];
    listGroupAttendanceModelTmp =
        await historyAttendanceController.getListModelAttendanceOfTheUser(
            document_id_custommer: document_id_custommer);
    if (listGroupAttendanceModelTmp.length > 0) {
      setState(() {
        groupAttendanceModel = listGroupAttendanceModelTmp[0];
        onFindDataSessionAttendanceInDay(
            groupAttendanceModel_: listGroupAttendanceModelTmp[0],
            CurenDate_: CurenDate);
        listGroupAttendanceModel = listGroupAttendanceModelTmp;
      });
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDiaLogScreen(
            title: "Thông báo",
            message: args == null
                ? "Bạn chưa có nhóm điểm danh"
                : "Nhân viên không thuộc nhóm điểm danh nào",
          );
        },
      ).then((value) {
        if (value) {
          Navigator.pop(context, true);
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments;
      });
      getListGroupAttendanceModel(args);
      type_sort_time = listTypeSortTime[0];
      textDateController.text = getDateNoHour(DateTime.now().toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: setWidthSize(size: 10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<GroupAttendanceModel>(
                value: groupAttendanceModel,
                onChanged: (GroupAttendanceModel value) {
                  setState(() {
                    groupAttendanceModel = value;
                  });
                  if (type_sort_time == listTypeSortTime[1]) {
                    onFindDataSessionAttendanceInMon(
                        CurenDate_: CurenDate,
                        groupAttendanceModel_: groupAttendanceModel);
                  }
                  if (type_sort_time == listTypeSortTime[0]) {
                    onFindDataSessionAttendanceInDay(
                        CurenDate_: CurenDate,
                        groupAttendanceModel_: groupAttendanceModel);
                  }
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
            ),
          ),
        ],
        backgroundColor: colorAppbar,
        title: Text(
          "Lịch sử điểm danh",
          style: styleTextTitleInAppWhite,
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: setHeightSize(size: 15),
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: setWidthSize(size: 15),
              ),
              CustomPaint(
                painter: MyPainter(
                    radius: 60, borderWidth: 2, colorBoder: Colors.white),
                child: Container(
                  height: setHeightSize(size: 45),
                  child: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: setWidthSize(size: 15)),
                      child: Row(
                        children: <Widget>[
                          DropdownButton<String>(
                            value: type_sort_time,
                            onChanged: (String value) {
                              if (value == listTypeSortTime[1]) {
                                onFindDataSessionAttendanceInMon(
                                    CurenDate_: CurenDate,
                                    groupAttendanceModel_:
                                        groupAttendanceModel);
                              }
                              if (value == listTypeSortTime[0]) {
                                onFindDataSessionAttendanceInDay(
                                    CurenDate_: CurenDate,
                                    groupAttendanceModel_:
                                        groupAttendanceModel);
                              }
                              setState(() {
                                type_sort_time = value;
                              });
                            },
                            style: styleTextContentBlack,
                            hint: Text(
                              'Phân loại',
                              style: styleTextHintBlack,
                            ),
                            icon: Icon(Icons.arrow_drop_down),
                            items:
                                listTypeSortTime.map((String type_sort_time) {
                              return DropdownMenuItem<String>(
                                value: type_sort_time,
                                child: Text(
                                  type_sort_time,
                                  style: styleTextContentBlack,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: setWidthSize(size: 15),
              ),
              Expanded(
                flex: 3,
                child: TextFieldBorder(
                  hintText: "Ngày/Tháng/Năm",
                  colorTextWhite: false,
                  controller: textDateController,
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        theme: DatePickerTheme(
                            cancelStyle: styleTextContentWhite,
                            doneStyle: styleTextContentWhite,
                            headerColor: colorAppbar),
                        showTitleActions: true,
                        minTime: DateTime(2020, 1, 1),
                        maxTime: DateTime(2050, 1, 1), onConfirm: (date) {
                      onFindDataSessionAttendanceInDay(
                          groupAttendanceModel_: groupAttendanceModel,
                          CurenDate_: date);
                      textDateController.text = getDateNoHour(date.toString());
                      CurenDate = date;

                      if (type_sort_time == listTypeSortTime[1]) {
                        onFindDataSessionAttendanceInMon(
                            CurenDate_: date,
                            groupAttendanceModel_: groupAttendanceModel);
                      }
                      if (type_sort_time == listTypeSortTime[0]) {
                        onFindDataSessionAttendanceInDay(
                            CurenDate_: date,
                            groupAttendanceModel_: groupAttendanceModel);
                      }
                      setState(() {});
                    }, currentTime: CurenDate, locale: LocaleType.vi);
                  },
                  readOnly: true,
                  iconLeft: Icon(Icons.date_range),
                ),
              ),
              SizedBox(
                width: setWidthSize(size: 15),
              ),
            ],
          ),
          Expanded(
            child: listsessionAttendanceModel.length > 0
                ? ListView.builder(
                    padding: EdgeInsets.all(setWidthSize(size: 15)),
                    itemCount: listsessionAttendanceModel.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(
                              setWidthSize(size: 10),
                            ),
                            child: Text(
                              "Ngày: ${getDateNoHour(listsessionAttendanceModel[index].time_check_in)}",
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
                                    "Đến lúc: ${getDateShowOnlyHourAndMinute(listsessionAttendanceModel[index].time_check_in)}",
                                    style: styleTextContentBlack,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text("Đến trể: "),
                                      listsessionAttendanceModel[index]
                                              .check_in_late
                                          ? Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.red,
                                            )
                                          : Icon(Icons.remove_circle_outline)
                                    ],
                                  ),
                                  Text(
                                    "Trể: ${listsessionAttendanceModel[index].time_minute_check_in_late == null ? "Không có dữ liệu" : "${(num.parse(listsessionAttendanceModel[index].time_minute_check_in_late) / 60).toStringAsFixed(2)} Tiếng"}",
                                    style: styleTextContentBlack,
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Về lúc: ${getDateShowOnlyHourAndMinute(listsessionAttendanceModel[index].time_check_out)}",
                                    style: styleTextContentBlack,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Về sớm: ",
                                        style: styleTextContentBlack,
                                      ),
                                      listsessionAttendanceModel[index]
                                              .check_out_soon
                                          ? Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.red,
                                            )
                                          : Icon(Icons.remove_circle_outline)
                                    ],
                                  ),
                                  Text(
                                    "Sớm: ${listsessionAttendanceModel[index].time_minute_check_out_soon == null ? "Không có dữ liệu" : "${(num.parse(listsessionAttendanceModel[index].time_minute_check_out_soon) / 60).toStringAsFixed(2)} Tiếng"}",
                                    style: styleTextContentBlack,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  )
                : Center(
                    child: Text(
                      "Không có dữ liệu",
                      style: styleTextContentBlack,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
