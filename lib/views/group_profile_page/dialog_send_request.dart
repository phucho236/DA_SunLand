import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/views/group_profile_page/request_to_become_a_partner_controller.dart';
import 'package:flutter_core/widgets/text_field_many_line.dart';

class DialogSendRequest extends StatefulWidget {
  @override
  _DialogSendRequestState createState() => _DialogSendRequestState();
}

class _DialogSendRequestState extends State<DialogSendRequest> {
  String content;
  String document_id_custommer;
  RequestToBecome_A_Partner requestToBecome_A_Partner =
      RequestToBecome_A_Partner();
  getdataLocal() async {
    document_id_custommer = await getDocumentIdCustommer();

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdataLocal();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.only(top: setHeightSize(size: 20)),
      title: Text("Yêu cầu trở thành đối tác"),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(setWidthSize(size: 15)),
              child: TextFieldManyLine(
                onChanged: (value) {
                  content = value;
                },
                colorBorDer: Colors.white,
                hintText: "Nhập nội dung yêu cầu",
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
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Đóng"),
        ),
        FlatButton(
          onPressed: () async {
            requestToBecome_A_Partner
                .onSubmitSendRequest(
                    content: content,
                    document_id_custommer: document_id_custommer)
                .then((value) {
              if (value == true) {
                Navigator.pop(context);
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDiaLogScreen(
                      title: "Thông báo",
                      message:
                          "SunLand đã nhận được yêu cầu của bạn, sau khi xem xét chúng tôi sẽ phản hồi qua email !",
                    );
                  },
                );
              } else {
                Navigator.pop(context);
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDiaLogScreen(
                      title: "Thông báo",
                      message: "Đã có lỗi xin vui lòng thử lại sau.",
                    );
                  },
                );
              }
            });
          },
          child: (Text("Gửi")),
        ),
      ],
    );
  }
}
