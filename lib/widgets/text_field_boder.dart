import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/widgets/creat_boder_shape.dart';

class TextFieldBorder extends StatelessWidget {
  TextFieldBorder({
    @required this.hintText,
    this.onChanged,
    this.stylePassWord = false,
    this.iconLeft,
    this.iconShowPas,
    this.ShowPass,
    this.controller,
    this.typeInputIsNumber = false,
    this.readOnly = false,
    this.colorTextWhite = true,
    this.isTextInputMoney = false,
    this.onTap,
  });
  final bool isTextInputMoney;
  final bool colorTextWhite;
  final String hintText;
  final Function onChanged;
  final bool stylePassWord;
  final Widget iconLeft;
  final Widget iconShowPas;
  final bool ShowPass;
  final TextEditingController controller;
  final bool typeInputIsNumber;
  final bool readOnly;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(radius: 60, borderWidth: 2, colorBoder: Colors.white),
      child: Container(
        height: setHeightSize(size: 45),
        child: TextField(
          onTap: onTap,
          textAlignVertical: TextAlignVertical.center,
          readOnly: readOnly,
          keyboardType: typeInputIsNumber
              ? TextInputType.numberWithOptions(signed: false)
              : TextInputType.text,
          controller: controller,
          style: colorTextWhite ? styleTextContentWhite : styleTextContentBlack,
          obscureText: stylePassWord,
          onChanged: onChanged,
          decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.only(
                left: setWidthSize(size: 10),
              ),
              alignLabelWithHint: true,
              hintText: hintText,
              hintStyle:
                  colorTextWhite ? styleTextHintWhite : styleTextHintBlack,
              prefixIcon: iconLeft,
              suffixIcon: iconShowPas,
              suffixText: isTextInputMoney ? "VNĐ   " : null,
              suffixStyle: styleTextContentBlack),
        ),
      ),
    );
  }
}
