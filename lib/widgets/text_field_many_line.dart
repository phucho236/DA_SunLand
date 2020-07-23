import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';

import 'creat_boder_shape.dart';

class TextFieldManyLine extends StatelessWidget {
  TextFieldManyLine(
      {@required this.hintText,
      @required this.onChanged,
      @required this.colorBorDer,
      this.width = 313.0});
  final double width;
  final String hintText;
  final Function onChanged;
  final Color colorBorDer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: setWidthSize(size: width),
          child: CustomPaint(
            painter: MyPainter(
                borderWidth: setWidthSize(size: 2.5),
                colorBoder: colorBorDer,
                radius: 5.0),
            child: TextField(
              maxLines: 10,
              textAlign: TextAlign.left,
              style: styleTextContentBlack,
              onChanged: onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: setWidthSize(size: 10),
                    vertical: setHeightSize(size: 10)),
                hintText: hintText,
                hintStyle: styleTextHintBlack,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
