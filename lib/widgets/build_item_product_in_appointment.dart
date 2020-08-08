import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';

class BuildItemProduct extends StatelessWidget {
  const BuildItemProduct({
    @required this.productModel,
  });

  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: setWidthSize(size: 5),
        horizontal: setWidthSize(size: 5),
      ),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            productModel != null &&
                    productModel.url_images_avatar_product != null
                ? Container(
                    width: setWidthSize(size: 100),
                    height: setWidthSize(size: 80),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              productModel.url_images_avatar_product)),
                    ),
                  )
                : Container(
                    height: setWidthSize(size: 150),
                    width: setWidthSize(size: 120),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage("assets/images/library_image.png"),
                      ),
                    ),
                  ),
            SizedBox(
              width: setWidthSize(size: 10),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  productModel == null ? "" : "${productModel.name_apartment}",
                  style: styleTextContentBlack,
                ),
                Text(
                  productModel == null
                      ? ""
                      : "${PriceFortmatMoney(value: double.parse(productModel.price.toString()), symbol: true)}",
                  style: styleTextContentBlack,
                ),
                Text(
                  productModel == null ? "" : "${productModel.district}",
                  style: styleTextContentBlack,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
