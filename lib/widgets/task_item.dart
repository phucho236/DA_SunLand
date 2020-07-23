import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';

import 'custom_widgets.dart';

Widget taskItem({
  bool isDone = false,
  String time = '08:00',
  String title = 'RUN',
  String description =
      'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs.',
}) {
  TextStyle descriptionStyle = TextStyle(
    decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
    //color: isDone ? kColorGreenLighter : kColorMainBolder,
  );

  TextStyle titleStyle = descriptionStyle.copyWith(
      fontWeight: FontWeight.w700, fontSize: setFontSize(size: 18));

  TextStyle timeStyle = titleStyle.copyWith(
      color: isDone ? kColorGreenLighter : kColorRed, height: 2);

  BoxDecoration iconStyle = BoxDecoration(
    color: kColorMainLighter,
    shape: BoxShape.circle,
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment(1.7, 0.0),
      //colors: [kColorMainBolder, kColorMainLighter],
      tileMode: TileMode.mirror, // repeats the gradient over the canvas
    ),
    boxShadow: [
      BoxShadow(
          color: kColorMainLighter.withOpacity(0.3),
          blurRadius: 3,
          offset: Offset(0, 3),
          spreadRadius: 1),
    ],
  );

  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(time, style: timeStyle),
      sizedBoxWidth(size: 15),
      Container(
        color: Colors.white,
        child: GestureDetector(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            width: 40,
            height: 40,
            decoration: iconStyle,
            child: Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
        ),
      ),
      sizedBoxWidth(size: 15),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(title.toUpperCase(), style: titleStyle),
            Text(description, style: descriptionStyle),
            sizedBoxHeight(size: 15),
          ],
        ),
      ),
    ],
  );
}
