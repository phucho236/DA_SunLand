import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';

Widget sizedBoxHeight({double size = 15}) {
  return SizedBox(height: setHeightSize(size: size));
}

Widget sizedBoxWidth({double size = 15}) {
  return SizedBox(width: setHeightSize(size: size));
}

Widget textTitle({String text = '', Alignment alignment = Alignment.topLeft}) {
  TextStyle style = TextStyle(
    fontSize: setFontSize(size: 21),
    fontWeight: FontWeight.w700,
  );
  return Align(alignment: alignment, child: Text(text, style: style));
}

Widget reusableBox({@required Widget child}) {
  BoxDecoration containStyle = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
          color: kColorYellow.withOpacity(0.5),
          blurRadius: 4,
          spreadRadius: 0.1),
    ],
  );
  return Container(
    decoration: containStyle,
    padding: EdgeInsets.all(setWidthSize(size: 15)),
    margin: EdgeInsets.only(bottom: setHeightSize(size: 15)),
    child: child,
  );
}
