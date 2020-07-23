import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';

class ButtonNormal extends StatelessWidget {
  ButtonNormal(
      {this.onTap, this.text = 'Tiếp Tục', this.TextColorsRed = false});

  final Function onTap;
  final String text;
  final bool TextColorsRed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: setHeightSize(size: 45),
        decoration: styleContainer,
        child: Center(
          child: Text(
            text.toUpperCase(),
            style: TextColorsRed ? styleTextColorsRed : styleText,
          ),
        ),
      ),
    );
  }

  BoxDecoration styleContainer = BoxDecoration(
    color: kColorYellow,
    borderRadius: BorderRadius.circular(30),
    gradient: LinearGradient(
      colors: [Colors.teal, colorAppbar],
      tileMode: TileMode.mirror, // repeats the gradient over the canvas
    ),
    boxShadow: [
      BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 5,
          offset: Offset(0, 1),
          spreadRadius: 1),
    ],
  );

  TextStyle styleText = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: setFontSize(size: 16),
    height: 1,
    shadows: [
      Shadow(
        blurRadius: .5,
        color: Colors.black.withOpacity(.5),
        offset: Offset(.5, .5),
      ),
    ],
  );
  TextStyle styleTextColorsRed = TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.w700,
    fontSize: setFontSize(size: 16),
    height: 1,
    shadows: [
      Shadow(
        blurRadius: .5,
        color: Colors.black.withOpacity(.5),
        offset: Offset(.5, .5),
      ),
    ],
  );
}
