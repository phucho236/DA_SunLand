import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_decentralization/group_create_group_decentralization/dialog_create_group_decentralization_controller.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/widgets/text_field_boder.dart';
import 'package:flutter_switch/flutter_switch.dart';

class DialogCreateGroupDecentralization extends StatefulWidget {
  @override
  _DialogCreateGroupDecentralizationState createState() =>
      _DialogCreateGroupDecentralizationState();
}

class _DialogCreateGroupDecentralizationState
    extends State<DialogCreateGroupDecentralization> {
  String nameGroup;
  DialogCreateGroupDecentralizationController
      dialogCreateGroupDecentralizationController =
      DialogCreateGroupDecentralizationController();
  final List<PermistionModel> _listPermisstionModelInSystem =
      listPermisstionModelInSystem;
  //List<String> listPermisstionIDPost = [];
  String document_id_custommer;
  getListPermisstionIDPost() {
    List<String> listPermisstionIDPostTmp = [];
    for (var item in _listPermisstionModelInSystem) {
      if (item.isSelected == true) {
        listPermisstionIDPostTmp.add(item.id);
      }
    }

    return listPermisstionIDPostTmp;
  }

  getdocumentIdCustommer__() async {
    String document_id_custommerTmp;
    document_id_custommerTmp = await getDocumentIdCustommer();
    if (document_id_custommerTmp != null) {
      setState(() {
        document_id_custommer = document_id_custommerTmp;
      });
    }
  }

  @override
  void initState() {
    for (var item in _listPermisstionModelInSystem) {
      item.isSelected = false;
    }
    // TODO: implement initState
    super.initState();
    getdocumentIdCustommer__();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.only(top: setHeightSize(size: 20)),
      title: Text("Thêm nhóm quyền"),
      content: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          TextFieldBorder(
                            onChanged: (value) {
                              nameGroup = value;
                            },
                            hintText: "Tên nhóm(Không thay đổi)",
                            colorTextWhite: false,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: setHeightSize(size: 10),
                      ),
                      Text(
                        "Danh sách các quyền",
                        style: styleTextTitleInBodyBlack,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        child: Container(
                          height: 350,
                          width: 300,
                          child: ListView.builder(
                            padding: EdgeInsets.all(setWidthSize(size: 15)),
                            itemCount: _listPermisstionModelInSystem.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Build_Items_(
                                permistionModel:
                                    _listPermisstionModelInSystem[index],
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          child: StreamBuilder(
                            stream: dialogCreateGroupDecentralizationController
                                .errStream,
                            builder: (context, snapshot) => Text(
                              snapshot.hasError ? snapshot.error : '',
                              style: styleTextErrorBlack,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
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
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Đóng")),
        FlatButton(
          onPressed: () async {
            await dialogCreateGroupDecentralizationController
                .onCreateGroupDecentralization(
                    nameGroup: nameGroup,
                    list_permission: getListPermisstionIDPost(),
                    document_id_custommer: document_id_custommer)
                .then((value) {
              if (value == true) {
                Navigator.pop(context, true);
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDiaLogScreen(
                      title: "Thông báo",
                      message: "Tạo nhóm quyền thành công",
                    );
                  },
                );
              }
              if (value == false) {
                Navigator.pop(context);
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDiaLogScreen(
                      title: "Thông báo",
                      message: "Lỗi.\n vui lòng thử lại sau.",
                    );
                  },
                );
              }
            });
          },
          child: (Text("Thêm")),
        ),
      ],
    );
  }
}

class Build_Items_ extends StatefulWidget {
  const Build_Items_({this.permistionModel});
  final PermistionModel permistionModel;
  @override
  _Build_Items_State createState() => _Build_Items_State();
}

class _Build_Items_State extends State<Build_Items_> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: setHeightSize(size: 5)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              widget.permistionModel.title,
              style: styleTextTitleInBodyBlack,
            ),
          ),
          FlutterSwitch(
            activeColor: colorAppbar,
            width: setWidthSize(size: 50),
            height: setHeightSize(size: 30),
            valueFontSize: 14.0,
            toggleSize: 10.0,
            value: _isSelected,
            borderRadius: 30.0,
            padding: 5.0,
            showOnOff: true,
            onToggle: (val) {
              setState(() {
                print(val);
                _isSelected = val;
                widget.permistionModel.isSelected = val;
              });
            },
          ),
        ],
      ),
    );
  }
}
