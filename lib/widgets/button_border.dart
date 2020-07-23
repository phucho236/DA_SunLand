import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';

import 'creat_boder_shape.dart';

class ButtonBorder extends StatelessWidget {
  ButtonBorder({
    @required this.text,
    @required this.onTap,
    @required this.sizeBorder = 2,
    this.colorBorder = Colors.green,
    this.colorText = Colors.black,
    this.colorButton = Colors.white,
  });
  final String text;
  final Function onTap;

  final Color colorBorder;
  final double sizeBorder;
  final Color colorText;
  final Color colorButton;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: MyPainter(
            borderWidth: sizeBorder, colorBoder: colorBorder, radius: 60.0),
        child: Container(
          height: setHeightSize(size: 50),
          //color: colorButton,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontStyle: FontStyle.normal,
                color: colorText,
                fontWeight: FontWeight.w700,
                fontSize: setFontSize(size: 18),
                //height: 5,
                shadows: [
                  Shadow(
                    blurRadius: .5,
                    color: colorText.withOpacity(.5),
                    offset: Offset(.5, .5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
