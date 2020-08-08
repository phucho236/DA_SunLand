import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/group_here_map/map_maker_controller.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_appointment/group_detail_appointment_done/detail_appointment_done_controller.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/views/group_images_brain/images_brain.dart';
import 'package:flutter_core/views/group_images_brain/show_images_screen.dart';
import 'package:flutter_core/widgets/build_item_product_in_appointment.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';

class DetailInAppointmentDoneScreen extends StatefulWidget {
  static String id = "DetailInAppointmentDoneScreen";
  DetailInAppointmentDoneScreen({this.appointmentModel});
  final AppointmentModel appointmentModel;
  @override
  _DetailInAppointmentDoneScreenState createState() =>
      _DetailInAppointmentDoneScreenState();
}

class _DetailInAppointmentDoneScreenState
    extends State<DetailInAppointmentDoneScreen> {
  DetailInAppointmentDoneScreen args;
  BuildContext _context;
  Uint8List ImagePixelData;
  ProductModel productModel;
  CoordinatesDoubleModel coordinatesDoubleModel = CoordinatesDoubleModel();
  DetailAppointmentDoneController detailAppointmentDoneController =
      DetailAppointmentDoneController();
  CustomerProfileModel customerProfileModelIsCustommer;
  CustomerProfileModel customerProfileModelIsUserHanding;
  CustomerProfileModel customerProfileModelIsUserPost;
  MapMarkerController _mapMarkerController;
  ImagesBrain imagesBrain = ImagesBrain();
  GetDataCustommerProfileIsCustommer(args) async {
    CustomerProfileModel customerProfileModelTmp;
    customerProfileModelTmp =
        await detailAppointmentDoneController.onGetCustomerProifile(
            document_id_custommer:
                args.appointmentModel.document_id_custommer_out_the_system,
            is_custommer_profile_out_the_system:
                args.appointmentModel.is_custommer_profile_out_the_system);
    if (customerProfileModelTmp != null) {
      setState(() {
        customerProfileModelIsCustommer = customerProfileModelTmp;
      });
    }
  }

  GetDataProduct(args) async {
    ProductModel productModelTmp;
    productModelTmp = await detailAppointmentDoneController.onGetProduct(
        document_id_product: args.appointmentModel.document_id_product);
    if (productModelTmp != null) {
      setState(() {
        productModel = productModelTmp;
      });
    }
  }

  getImagePixelData(args) async {
    Uint8List ImagePixelDataTmp;
    ImagePixelDataTmp =
        await networkImageToByte(args.appointmentModel.url_images_check_in);
    GeoCoordinates geoCoordinates = GeoCoordinates.withAltitude(
        args.appointmentModel.location_images_check_in.latitude,
        args.appointmentModel.location_images_check_in.longitude,
        1000);

    showAnchoredMapMarkersWithImages(
      geoCoordinates,
      ImagePixelDataTmp,
    );
  }

  GetDataCustommerProfileIsUserHanding(args) async {
    CustomerProfileModel customerProfileModelTmp;
    customerProfileModelTmp =
        await detailAppointmentDoneController.onGetCustomerProifile(
            document_id_custommer:
                args.appointmentModel.document_id_user_handing);
    if (customerProfileModelTmp != null) {
      setState(() {
        customerProfileModelIsUserHanding = customerProfileModelTmp;
      });
    }
  }

  GetDataCustommerProfileIsUserPost(args) async {
    CustomerProfileModel customerProfileModelTmp;
    customerProfileModelTmp =
        await detailAppointmentDoneController.onGetCustomerProifile(
            document_id_custommer: args.appointmentModel.post_by);
    if (customerProfileModelTmp != null) {
      setState(() {
        customerProfileModelIsUserPost = customerProfileModelTmp;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    coordinatesDoubleModel.latitude = 10.808820;
    coordinatesDoubleModel.longitude = 106.623436;
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments;
      });
      GetDataCustommerProfileIsCustommer(args);
      GetDataCustommerProfileIsUserHanding(args);
      GetDataCustommerProfileIsUserPost(args);

      GetDataProduct(args);
//      showAnchoredMapMarkersWithImages(
//          args.appointmentModel.url_images_check_in);
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    DetailInAppointmentDoneScreen args1 =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text(
          "Chi tiết lịch hẹn đã hoàn thành",
          style: styleTextTitleInAppWhite,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(setWidthSize(size: 15)),
        child: Column(
          children: <Widget>[
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: setWidthSize(size: 5),
                  horizontal: setWidthSize(size: 5),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        "Khách hàng:",
                        style: styleTextContentBlack,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          customerProfileModelIsCustommer != null &&
                                  customerProfileModelIsCustommer.linkImages !=
                                      null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      customerProfileModelIsCustommer
                                          .linkImages),
                                  radius: 30.0,
                                )
                              : CircleAvatar(
                                  backgroundImage: AssetImage(
                                      "assets/images/library_image.png"),
                                  radius: 30.0,
                                ),
                          SizedBox(
                            width: setWidthSize(size: 10),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                customerProfileModelIsCustommer == null
                                    ? ""
                                    : customerProfileModelIsCustommer.user_name,
                                style: styleTextContentBlack,
                              ),
                              Text(
                                customerProfileModelIsCustommer == null
                                    ? ""
                                    : customerProfileModelIsCustommer.email,
                                style: styleTextContentBlack,
                              ),
                              Text(
                                customerProfileModelIsCustommer == null
                                    ? ""
                                    : "SĐT: ${customerProfileModelIsCustommer.phone_number}",
                                style: styleTextContentBlack,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: setHeightSize(size: 10),
            ),
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: setWidthSize(size: 5),
                  horizontal: setWidthSize(size: 5),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        "Được phân công:",
                        style: styleTextContentBlack,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          customerProfileModelIsCustommer != null &&
                                  customerProfileModelIsCustommer.linkImages !=
                                      null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      customerProfileModelIsCustommer
                                          .linkImages),
                                  radius: 30.0,
                                )
                              : CircleAvatar(
                                  backgroundImage: AssetImage(
                                      "assets/images/library_image.png"),
                                  radius: 30.0,
                                ),
                          SizedBox(
                            width: setWidthSize(size: 10),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                customerProfileModelIsUserHanding == null
                                    ? ""
                                    : customerProfileModelIsUserHanding
                                        .user_name,
                                style: styleTextContentBlack,
                              ),
                              Text(
                                customerProfileModelIsUserHanding == null
                                    ? ""
                                    : customerProfileModelIsUserHanding.email,
                                style: styleTextContentBlack,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: setHeightSize(size: 10),
            ),
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: setWidthSize(size: 5),
                  horizontal: setWidthSize(size: 5),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        "Thông tin lịch hẹn:",
                        style: styleTextContentBlack,
                      ),
                      Text(
                          "Địa điểm: ${args == null ? "" : args.appointmentModel.address_appointment}"),
                      Text(
                          "Thời gian gặp: ${args == null ? "" : getDateShowHourAndMinute(args.appointmentModel.time_metting)}"),
                      Text(
                        "Trạng thái: ${args == null ? "" : args.appointmentModel.checked_in == false ? "Chưa hoàn thành" : "Hoàn thành"}",
                        style: styleTextContentBlack,
                      ),
                      Text(
                          "Check In vào: ${args == null ? "" : getDateShowHourAndMinute(args.appointmentModel.checked_in_at)}"),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: setHeightSize(size: 10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ShowImagesScreen.id,
                        arguments: ShowImagesScreen(
                          url: args.appointmentModel.url_images_check_in,
                          sendBy: "",
                        ));
                  },
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    child: Container(
                      width: setWidthSize(size: 150),
                      height: setHeightSize(size: 30),
                      margin: EdgeInsets.symmetric(
                        vertical: setWidthSize(size: 5),
                        horizontal: setWidthSize(size: 5),
                      ),
                      child: Center(
                        child: Center(
                          child: Text(
                            "Xem hình",
                            style: styleTextContentBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          contentPadding:
                              EdgeInsets.only(top: setHeightSize(size: 20)),
                          title: Text(
                            "Thông tin thêm",
                            style: styleTextTitleInAppBarBlack,
                          ),
                          content: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          "Tạo bởi: ${customerProfileModelIsUserPost == null ? "" : customerProfileModelIsUserPost.user_name}"),
                                      Text(
                                          "Tạo vào: ${args == null ? "" : getDateShowHourAndMinute(args.appointmentModel.post_at)}"),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: setHeightSize(size: 10),
                                    horizontal: setWidthSize(size: 10),
                                  ),
                                  child: Material(
                                      elevation: 2,
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                      child: BuildItemProduct(
                                          productModel: productModel)),
                                ),
                                Container(
                                  height: setHeightSize(size: 140),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        "assets/images/background_dialog_1.png"),
                                  )),
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: (Text("Đồng ý")),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    child: Container(
                      width: setWidthSize(size: 150),
                      height: setHeightSize(size: 30),
                      margin: EdgeInsets.symmetric(
                        vertical: setWidthSize(size: 5),
                        horizontal: setWidthSize(size: 5),
                      ),
                      child: Center(
                        child: Text(
                          "Thông tin thêm",
                          style: styleTextContentBlack,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: setHeightSize(size: 10),
            ),
            Expanded(
              child: HereMap(onMapCreated: _onMapCreated),
            ),
          ],
        ),
      ),
    );
  }

  void _onMapCreated(HereMapController hereMapController) {
    hereMapController.setWatermarkPosition(WatermarkPlacement.bottomLeft, 1);
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
        (MapError error) {
      if (error == null) {
        _mapMarkerController = MapMarkerController(
            allowLongPressGestureHandler: false,
            context: _context,
            hereMapController: hereMapController);
        getImagePixelData(args);
      } else {
        print("Map scene not loaded. MapError: " + error.toString());
      }

      if (error != null) {
        print('Map scene not loaded. MapError: ${error.toString()}');
        return;
      }

      const double distanceToEarthInMeters = 8000;
      hereMapController.camera.lookAtPointWithDistance(
          GeoCoordinates(coordinatesDoubleModel.latitude,
              coordinatesDoubleModel.longitude),
          distanceToEarthInMeters);
    });
  }

  void showAnchoredMapMarkersWithImages(
      GeoCoordinates geoCoordinates, Uint8List ImagePixelData) {
    _mapMarkerController.addPhotoMapMarkerWithImagesUrl(
        internalupdateCoordinates: true,
        imagePixelData: ImagePixelData,
        geoCoordinates: geoCoordinates);
  }
}
