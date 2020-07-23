import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_post_notify_system_user/post_notify_system_users_controller.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/widgets/text_field_boder.dart';
import 'package:flutter_core/widgets/text_field_many_line.dart';

class DialogPostNotifySystemUser extends StatefulWidget {
  @override
  _DialogPostNotifySystemUserState createState() =>
      _DialogPostNotifySystemUserState();
}

class _DialogPostNotifySystemUserState
    extends State<DialogPostNotifySystemUser> {
  PostNotifySystemUsersController postNotifySystemUsersController =
      PostNotifySystemUsersController();
  String document_id_custommer;
  String content;
  String title;

  getDocumentIdCustommer_() async {
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
    // TODO: implement initState
    super.initState();
    getDocumentIdCustommer_();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.only(top: setHeightSize(size: 20)),
      title: Text("Thêm thông báo"),
      content: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: setWidthSize(size: 20)),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      TextFieldBorder(
                        onChanged: (value) {
                          title = value;
                        },
                        hintText: "Tên thông báo",
                        colorTextWhite: false,
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      TextFieldManyLine(
                        onChanged: (value) {
                          content = value;
                        },
                        colorBorDer: Colors.white,
                        hintText: "Nhập nội dung thông báo",
                      ),
                      SizedBox(
                        height: 10,
                      ),
//                                Center(
//                                  child: Container(
//                                    child: StreamBuilder(
//                                      stream: addRealEstareController.errStream,
//                                      builder: (context, snapshot) => Text(
//                                        snapshot.hasError ? snapshot.error : '',
//                                        style: styleTextErrorBlack,
//                                      ),
//                                    ),
//                                  ),
//                                ),
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
            await postNotifySystemUsersController
                .onPostNotifySystemUsers(
                    title: title,
                    document_id_custommer: document_id_custommer,
                    content: content)
                .then((value) {
              if (value == true) {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDiaLogScreen(
                      title: "Thông báo",
                      message: "Thên thông báo thành công",
                    );
                  },
                ).then((value) {
                  Navigator.pop(context);
                });
              } else {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDiaLogScreen(
                      title: "Thông báo",
                      message: "Thêm thông báo thất bại",
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
