import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/widgets/scrolling_text.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ButtonItem extends StatelessWidget {
  ButtonItem(
      {this.onTap,
      this.nameApartment,
      this.price,
      this.acreageApartment,
      this.amountBedroom,
      this.district,
      this.urlImagesAvataProduct,
      this.itemLiked = false,
      this.seen,
      this.like = 0});
  final String nameApartment;
  final num price;
  final String district;
  final String acreageApartment;
  final String amountBedroom;
  final dynamic urlImagesAvataProduct;
  final Function onTap;
  final bool itemLiked;
  final num seen;
  final num like;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
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
                    urlImagesAvataProduct == null
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
                                image:
                                    urlImagesAvataProduct.runtimeType != String
                                        ? FileImage(urlImagesAvataProduct)
                                        : CachedNetworkImageProvider(
                                            urlImagesAvataProduct),
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
                    nameApartment != null
                        ? nameApartment.length > 18
                            ? Container(
                                height: setHeightSize(size: 20),
                                margin: EdgeInsets.symmetric(
                                    horizontal: setWidthSize(size: 5)),
                                child: ScrollingText(
                                  text: Text(
                                    nameApartment,
                                    style: styleTextTitleInBodyBlack,
                                  ),
                                ),
                              )
                            : Container(
                                height: setHeightSize(size: 20),
                                child: Text(
                                  nameApartment,
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
                                district == null ? "ABCD" : district,
                                style: district == null
                                    ? styleTextContenIconNoInput
                                    : styleTextContentIconBlack,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.monetization_on),
                              Text(
                                price == null
                                    ? "999.999.999 VNĐ"
                                    : PriceFortmatMoney(
                                        value: price.toDouble()),
                                style: price == null
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
                                amountBedroom == null ? "999" : amountBedroom,
                                style: amountBedroom == null
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
                                acreageApartment == null
                                    ? "999m\u00B2"
                                    : "${acreageApartment}m\u00B2",
                                style: acreageApartment == null
                                    ? styleTextContenIconNoInput
                                    : styleTextContentIconBlack,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              //Icon(Icons.),
                              itemLiked
                                  ? Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          "${like}",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.favorite_border,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          "${like}",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                              Icon(
                                MdiIcons.eyeCheckOutline,
                              ),
                              Text(
                                seen == null ? " 0 " : "${" $seen "}",
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
