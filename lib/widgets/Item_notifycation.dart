import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';

class ItemNotifycation extends StatelessWidget {
  ItemNotifycation({this.notifiProductAdsModel, this.onTap});
  final NotifiProductAdsModel notifiProductAdsModel;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Material(
          borderRadius: BorderRadius.circular(15),
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding:
                            EdgeInsets.only(bottom: setHeightSize(size: 20)),
                        child: Icon(
                          Icons.notifications_active,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            notifiProductAdsModel.title,
                            style: styleTextTitleInBodyBlack,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: setWidthSize(size: 10),
                      ),
                    ),
                  ],
                ),
                Text(
                  notifiProductAdsModel.content,
                  style: styleTextContentBlack,
                  textAlign: TextAlign.start,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
