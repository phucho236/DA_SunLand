import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/widgets/custom_widgets.dart';

class TaskBox extends StatefulWidget {
  TaskBox({this.title, this.description = '', this.time = '09:30', this.onDelete});

  final String title;
  final String description;
  final String time;
  final Function onDelete;
  @override
  _TaskBoxState createState() => _TaskBoxState();
}

class _TaskBoxState extends State<TaskBox> {
  bool showTool = false;

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(
      fontWeight: FontWeight.w700,
    );
    TextStyle descriptionStyle = TextStyle();

    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx < 0 && showTool == false) {
          setState(() {
            showTool = !showTool;
          });
        }
        if (details.delta.dx > 0 && showTool == true) {
          setState(() {
            showTool = !showTool;
          });
        }
      },
      child: reusableBox(
        child: Stack(
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.title,
                          style: titleStyle,
                        ),
                      ),
                      Text(
                        widget.time,
                        style: titleStyle,
                      ),
                    ],
                  ),
                  sizedBoxHeight(size: 5),
                  Text(
                    widget.description,
                    style: descriptionStyle,
                  ),
                ],
              ),
            ),
            AnimatedPositioned(
              top: 0,
              right: showTool ? 0 : -100,
              duration: Duration(milliseconds: 100),
              child: Row(
                children: <Widget>[
                  GestureDetector(onTap: () {}, child: iconAction()),
                  sizedBoxWidth(size: 5),
                  GestureDetector(onTap: () {
                    widget.onDelete();
                  }, child: iconAction(type: 2)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget iconAction({int type = 1}) {
    return Container(
      width: setWidthSize(size: 40),
      height: setWidthSize(size: 40),
      decoration: BoxDecoration(
          color: type == 1 ? Colors.green : Colors.red, shape: BoxShape.circle),
      child: Icon(
        type == 1 ? Icons.check : Icons.close,
        color: Colors.white,
      ),
    );
  }
}
