import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AlertDiaLogScreen extends StatelessWidget {
  AlertDiaLogScreen(
      {this.title,
      this.message,
      this.buttonCance = false,
      this.allow_copy_text = false});
  String title;
  String message;
  bool buttonCance;
  bool allow_copy_text = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.only(top: setHeightSize(size: 20)),
      title: Text(title),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onLongPress: allow_copy_text
                  ? () {
                      Clipboard.setData(new ClipboardData(text: message));
                      //Fluttertoast.showToast(msg: "Đã sao chép");
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(message),
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
            Navigator.pop(context, true);
          },
          child: (Text("Đồng ý")),
        ),
        buttonCance
            ? FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text("Đóng"))
            : Container(),
      ],
    );
  }
}
