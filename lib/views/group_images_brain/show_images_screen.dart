import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:photo_view/photo_view.dart';

class ShowImagesScreen extends StatefulWidget {
  static String id = "ShowImagesScreen";
  ShowImagesScreen({this.url, this.sendBy});
  final String url;
  final String sendBy;
  @override
  _ShowImagesScreenState createState() => _ShowImagesScreenState();
}

class _ShowImagesScreenState extends State<ShowImagesScreen> {
  ThemeData theme = ThemeData(
    primaryColor: Colors.black,
    backgroundColor: Colors.white10,
  );

  @override
  Widget build(BuildContext context) {
    final ShowImagesScreen args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          args.sendBy,
          style: styleTextContentWhite,
        ),
      ),
      body: Container(child: PhotoView(imageProvider: NetworkImage(args.url))),
    );
  }
}
