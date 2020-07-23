import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'creat_boder_shape.dart';

class buildIconInfrastructure extends StatefulWidget {
  buildIconInfrastructure({this.title, this.icon, this.onTap, this.isChoos});
  final IconData icon;
  final String title;
  final Function onTap;
  final bool isChoos;
  @override
  _buildIconInfrastructureState createState() =>
      _buildIconInfrastructureState();
}

class _buildIconInfrastructureState extends State<buildIconInfrastructure> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onTap,
      child: Stack(
        children: <Widget>[
          Visibility(
            visible: widget.isChoos,
            child: CustomPaint(
              //willChange: widget.enableInteraction,
              painter: MyPainter(
                  colorBoder: Colors.black26, borderWidth: 1, radius: 5),
              child: Container(),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: setWidthSize(size: 10),
                ),
                Icon(
                  widget.icon,
                  size: setHeightSize(size: 20),
                ),
                SizedBox(
                  width: setWidthSize(size: 5),
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: setFontSize(size: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
