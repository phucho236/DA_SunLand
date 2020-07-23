import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/widgets/button_item.dart';

class PreviewProductScreen extends StatefulWidget {
  static String id = "PreviewProductScreen";
  PreviewProductScreen(
      {this.nameApartment,
      this.price,
      this.acreageApartment,
      this.amountBedroom,
      this.district,
      this.urlImagesAvataProduct});
  final String nameApartment;
  final num price;
  final String district;
  final String acreageApartment;
  final String amountBedroom;
  final File urlImagesAvataProduct;

  @override
  _PreviewProductScreenState createState() => _PreviewProductScreenState();
}

class _PreviewProductScreenState extends State<PreviewProductScreen> {
  @override
  Widget build(BuildContext context) {
    final PreviewProductScreen args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text("Sản phẩm"),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SizedBox(
          width: setWidthSize(size: 200),
          height: setHeightSize(size: 330),
          child: ButtonItem(
            urlImagesAvataProduct: args.urlImagesAvataProduct,
            price: args.price,
            nameApartment: args.nameApartment,
            district: args.district,
            amountBedroom: args.amountBedroom,
            acreageApartment: args.acreageApartment,
            onTap: () {},
          ),
        ),
      ),
    );
  }
}
