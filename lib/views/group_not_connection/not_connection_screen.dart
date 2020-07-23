import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';

class NotConnectionScreen extends StatelessWidget {
  static String id = "NotConnectionScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Container(
                child: Image.asset('assets/images/icon_sunland.png'),
                height: setHeightSize(size: 180),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: setHeightSize(size: 100),
                ),
                SizedBox(
                  child: Text(
                    'Không có kết nối mạng!',
                    style: styleTextTitleInAppBarBlack,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
