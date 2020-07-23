import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_post_notify_system_user/post_notify_system_users_controller.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';

class DetailNotifySystemUser extends StatefulWidget {
  static String id = "DetailNotifySystemUser";
  DetailNotifySystemUser(
      {this.customerProfileModel, this.notifySystemUsersModel});
  final CustomerProfileModel customerProfileModel;
  final NotifySystemUsersModel notifySystemUsersModel;
  @override
  _DetailNotifySystemUserState createState() => _DetailNotifySystemUserState();
}

class _DetailNotifySystemUserState extends State<DetailNotifySystemUser> {
  PostNotifySystemUsersController postNotifySystemUsersController =
      PostNotifySystemUsersController();

  String document_id_custommer;
  getDocuemntIdCustommer_() async {
    String document_id_custommerTmp;
    document_id_custommerTmp = await getDocumentIdCustommer();
    if (document_id_custommerTmp != null) ;
    setState(() {
      document_id_custommer = document_id_custommerTmp;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocuemntIdCustommer_();
  }

  @override
  Widget build(BuildContext context) {
    final DetailNotifySystemUser args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết thông báo"),
        backgroundColor: colorAppbar,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: setWidthSize(size: 15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: setHeightSize(size: 10),
            ),
            Text(
              "Thông tin người đăng",
              style: styleTextHintBlack,
            ),
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(setWidthSize(size: 5)),
                  child: args.customerProfileModel.linkImages == null
                      ? CircleAvatar(
                          radius: 30,
                          child: Container(
                            margin: EdgeInsets.all(setWidthSize(size: 10)),
                            child:
                                Image.asset("assets/images/library_image.png"),
                          ),
                        )
                      : CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              args.customerProfileModel.linkImages),
                        ),
                ),
                SizedBox(
                  width: setWidthSize(size: 5),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        args.customerProfileModel.email,
                        style: styleTextContentBlack,
                      ),
                      SizedBox(
                        height: setHeightSize(size: 5),
                      ),
                      Text(
                        args.customerProfileModel.user_name,
                        style: styleTextContentBlack,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: setHeightSize(size: 10),
            ),
            Text(
              "Thông tin thông báo",
              style: styleTextHintBlack,
            ),
            SizedBox(
              height: setHeightSize(size: 10),
            ),
            Text(
              "Tên thông báo: ${args.notifySystemUsersModel.title}",
              style: styleTextContentBlack,
            ),
            SizedBox(
              height: setHeightSize(size: 10),
            ),
            Text(
              "Nội dung: ${args.notifySystemUsersModel.content}",
              style: styleTextContentBlack,
            ),
            SizedBox(
              height: setHeightSize(size: 10),
            ),
            Text(
              "Đăng vào: ${getDateShow(args.notifySystemUsersModel.post_at)}",
              style: styleTextContentBlack,
            ),
            SizedBox(
              height: setHeightSize(size: 10),
            ),
            Text(
              "Xóa bởi user có id: ${args.notifySystemUsersModel.remove_by == null ? "Không có dữ liệu" : args.notifySystemUsersModel.remove_by}",
              style: styleTextContentBlack,
            ),
            SizedBox(
              height: setHeightSize(size: 10),
            ),
            Text(
              "Xóa vào: ${args.notifySystemUsersModel.remove_at == null ? "Không có dữ liệu" : getDateShow(args.notifySystemUsersModel.remove_at)}",
              style: styleTextContentBlack,
            ),
            SizedBox(
              height: setHeightSize(size: 10),
            ),
            Text(
              "Trạng thái: ${args.notifySystemUsersModel.removed ? "Đã xóa" : "Hoạt động"}",
              style: styleTextContentBlack,
            ),
            SizedBox(
              height: setHeightSize(size: 10),
            ),
          ],
        ),
      ),
      floatingActionButton: args.notifySystemUsersModel.removed == false
          ? FloatingActionButton(
              backgroundColor: colorAppbar,
              onPressed: () async {
                await postNotifySystemUsersController
                    .removeNotifySystemUsers(
                        document_id_custommer: document_id_custommer,
                        document_id_notify_system_users: args
                            .notifySystemUsersModel
                            .document_id_notify_system_users)
                    .then((value) {
                  if (value == true) {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDiaLogScreen(
                          title: "Thông báo",
                          message: "Xóa thông báo thành công.",
                        );
                      },
                    ).then((value) {
                      Navigator.pop(context, true);
                    });
                  } else {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDiaLogScreen(
                          title: "Thông báo",
                          message: "Xóa thông báo thất bại.",
                        );
                      },
                    );
                  }
                });
              },
              child: Icon(Icons.delete),
            )
          : Container(),
    );
  }
}
