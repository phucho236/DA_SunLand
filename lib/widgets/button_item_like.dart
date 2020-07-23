import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/widgets/scrolling_text.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ButtonItemLike extends StatefulWidget {
  ButtonItemLike(
      {this.nameApartment,
      this.price,
      this.acreageApartment,
      this.amountBedroom,
      this.district,
      this.urlImagesAvataProduct,
      this.itemLiked = false,
      this.seen,
      this.like,
      this.is_selected = false,
      this.onTap,
      this.onLongPress,
      this.censored = false,
      this.show_censored = false});
  final String nameApartment;
  final num price;
  final String district;
  final String acreageApartment;
  final String amountBedroom;
  final dynamic urlImagesAvataProduct;
  final bool itemLiked;
  final num seen;
  final bool is_selected;
  final Function onTap;
  final Function onLongPress;
  final num like;
  final bool censored;
  final bool show_censored;

  @override
  _ButtonItemLikeState createState() => _ButtonItemLikeState();
}

class _ButtonItemLikeState extends State<ButtonItemLike> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            widget.is_selected
                ? BoxShadow(
                    color: Colors.blueAccent.withOpacity(.5),
                    blurRadius: 3, // has the effect of softening the shadow
                    spreadRadius: 0.1, // has the effect of extending the shadow
                    offset: Offset(
                      1.5, // horizontal, move right 10
                      1.5, // vertical, move down 10
                    ),
                  )
                : BoxShadow(
                    color: Colors.black.withOpacity(.5),
                    blurRadius: 3, // has the effect of softening the shadow
                    spreadRadius: 0.1, // has the effect of extending the shadow
                    offset: Offset(
                      1.5, // horizontal, move right 10
                      1.5, // vertical, move down 10
                    ),
                  )
          ],
        ),
        margin: EdgeInsets.symmetric(
            vertical: setHeightSize(size: 5),
            horizontal: setWidthSize(size: 5)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          margin: EdgeInsets.symmetric(
            vertical: setHeightSize(size: 2.5),
            horizontal: setWidthSize(size: 2.5),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    widget.urlImagesAvataProduct == null
                        ? Center(
                            child: Image.asset(
                              "assets/images/icon_sunland.png",
                              height: 70,
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: new BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: widget.urlImagesAvataProduct
                                            .runtimeType !=
                                        String
                                    ? FileImage(widget.urlImagesAvataProduct)
                                    : CachedNetworkImageProvider(
                                        widget.urlImagesAvataProduct),
                                // NetworkImage(urlImagesAvataProduct)
                              ),
                              color: Colors.white,
                              // border color

                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10)),
                            ),
                          ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: setHeightSize(size: 5),
                    ),
                    widget.nameApartment != null
                        ? widget.nameApartment.length > 18
                            ? Container(
                                height: setHeightSize(size: 20),
                                margin: EdgeInsets.symmetric(
                                    horizontal: setWidthSize(size: 5)),
                                child: ScrollingText(
                                  text: Text(
                                    widget.nameApartment,
                                    style: styleTextTitleInBodyBlack,
                                  ),
                                ),
                              )
                            : Container(
                                height: setHeightSize(size: 20),
                                child: Text(
                                  widget.nameApartment,
                                  style: styleTextTitleInBodyBlack,
                                ),
                              )
                        : Container(
                            height: setHeightSize(size: 20),
                            child: Text(
                              "Căn hộ ABCD",
                              style: styleTextTitleInBodyNoInput,
                            ),
                          ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.location_on),
                              Text(
                                widget.district == null
                                    ? "ABCD"
                                    : widget.district,
                                style: widget.district == null
                                    ? styleTextContenIconNoInput
                                    : styleTextContentIconBlack,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.monetization_on),
                              Text(
                                widget.price == null
                                    ? "999.999.999 VNĐ"
                                    : PriceFortmatMoney(
                                        value: double.parse(
                                            widget.price.toString())),
                                style: widget.price == null
                                    ? styleTextContenIconNoInput
                                    : styleTextContentIconBlack,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              //Icon(Icons.),
                              Icon(MdiIcons.bedQueen),
                              Text(
                                widget.amountBedroom == null
                                    ? "999"
                                    : widget.amountBedroom,
                                style: widget.amountBedroom == null
                                    ? styleTextContenIconNoInput
                                    : styleTextContentIconBlack,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              //Icon(Icons.),
                              Icon(MdiIcons.officeBuilding),
                              Text(
                                widget.acreageApartment == null
                                    ? "999m\u00B2"
                                    : "${widget.acreageApartment}m\u00B2",
                                style: widget.acreageApartment == null
                                    ? styleTextContenIconNoInput
                                    : styleTextContentIconBlack,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              //Icon(Icons.),
                              widget.itemLiked
                                  ? Row(
                                      children: <Widget>[
                                        widget.show_censored
                                            ? widget.censored
                                                ? Text(
                                                    "Đã duyệt",
                                                    style:
                                                        styleTextContentBlack,
                                                  )
                                                : Text(
                                                    "Chưa duyệt",
                                                    style:
                                                        styleTextContentNoInput,
                                                  )
                                            : Container(),
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          "${widget.like}",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: <Widget>[
                                        widget.show_censored
                                            ? widget.censored
                                                ? Text(
                                                    "Đã duyệt",
                                                    style:
                                                        styleTextContentBlack,
                                                  )
                                                : Text(
                                                    "Chưa duyệt",
                                                    style:
                                                        styleTextContentNoInput,
                                                  )
                                            : Container(),
                                        Icon(
                                          Icons.favorite_border,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          "${widget.like}",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                              Icon(
                                MdiIcons.eyeCheckOutline,
                              ),
                              Text(
                                widget.seen == null
                                    ? " 0 "
                                    : "${" ${widget.seen} "}",
                                style: styleTextContentIconBlack,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
