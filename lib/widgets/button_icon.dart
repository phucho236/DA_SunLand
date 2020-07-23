import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/helpers/constant.dart';

class ButtonIcon extends StatelessWidget {
  ButtonIcon(
      {@required this.textButton,
      @required this.colorButton,
      @required this.onPress,
      @required this.asset,
      @required this.height,
      @required this.width});
  final String textButton;
  final Color colorButton; // có thể tách ra một cái cho nền một cái cho viền
  final double width;
  final Function onPress;
  final String asset;
  final double height;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPress,
      color: colorButton,
      child: Row(
        children: <Widget>[
          Image.asset(asset),
          Container(
            width: setWidthSize(size: width),
            height: setHeightSize(size: height),
            child: Center(child: Text(textButton, style: styleText)),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
    );
  }

  TextStyle styleText = TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    fontSize: setFontSize(size: 12),
    //height: 1,
  );
}
