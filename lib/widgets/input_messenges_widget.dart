import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';

class InputMessengerWidget extends StatelessWidget {
  InputMessengerWidget(
      {this.onChanged,
      this.onPressed,
      this.textEditingController,
      this.listScrollController,
      this.onPressedOpenCamera,
      this.onPressedOpenLibrary});
  final Function onPressed;
  final Function onChanged;
  final TextEditingController textEditingController;
  final ScrollController listScrollController;
  final Function onPressedOpenCamera;
  final Function onPressedOpenLibrary;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 1.0),
          child: IconButton(
            icon: Icon(Icons.camera),
            onPressed: onPressedOpenCamera,
            //color: primaryColor,
          ),
        ),
        // Button send image
        Container(
          margin: EdgeInsets.symmetric(horizontal: 1.0),
          child: IconButton(
            icon: Icon(Icons.image),
            onPressed: onPressedOpenLibrary,
            //color: primaryColor,
          ),
        ),

        // Edit text
        Expanded(
          child: Container(
            //height: 45,
            child: TextField(
              style: styleTextContentBlack,
              onChanged: onChanged,
              controller: textEditingController,
              decoration: InputDecoration.collapsed(
                hintText: 'Nhập tin nhắn của bạn...',
                hintStyle: styleTextHintBlack,
              ),
            ),
          ),
        ),

        // Button send message
        Container(
          //margin: EdgeInsets.symmetric(horizontal: 15.0),
          child: IconButton(
            icon: Icon(Icons.send),
            onPressed: onPressed,
            color: Colors.green,
          ),
        ),
      ],
    );
    ;
  }
}
