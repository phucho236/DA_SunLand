import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'creat_boder_shape.dart';

class Search_TextField_Border extends StatelessWidget {
  Search_TextField_Border(
      {@required this.hintText,
      @required this.borderRadius,
      @required this.sizeBorder,
      this.onChanged,
      @required this.colorBorDer,
      this.onTap = null,
      this.controller});
  final String hintText;
  final double borderRadius;
  final double sizeBorder;
  final Function onChanged;
  final Color colorBorDer;
  final Function onTap;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: setHeightSize(size: 5.0)),
      child: CustomPaint(
        painter: MyPainter(
            borderWidth: sizeBorder,
            colorBoder: colorBorDer,
            radius: borderRadius),
        child: Padding(
          padding: EdgeInsets.all(setHeightSize(size: 1.4)),
          child: Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Container(
              height: setHeightSize(size: 40),
              child: CupertinoTextField(
                controller: controller,
                onTap: onTap,
                placeholder: hintText,
                style: styleTextContentBlack,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.left,
                onChanged: onChanged,
                padding: EdgeInsets.only(left: 15),
                suffix: IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
