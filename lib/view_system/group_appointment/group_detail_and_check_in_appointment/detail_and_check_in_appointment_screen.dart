import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_appointment/group_detail_and_check_in_appointment/detail_and_check_in_appointment_controller.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/views/group_images_brain/images_brain.dart';
import 'package:flutter_core/widgets/build_item_product_in_appointment.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_core/group_metadata_images/metadata_images_controller.dart';

class DetailAndCheckInAppointmentScreen extends StatefulWidget {
  static String id = "DetailAndCheckInAppointmentScreen";
  DetailAndCheckInAppointmentScreen({this.appointmentModel});
  final AppointmentModel appointmentModel;
  @override
  _DetailAndCheckInAppointmentScreenState createState() =>
      _DetailAndCheckInAppointmentScreenState();
}

class _DetailAndCheckInAppointmentScreenState
    extends State<DetailAndCheckInAppointmentScreen> {
  DetailAndCheckInAppointmentScreen args;
  DetailAndCheckInAppointmentController detailAndCheckInAppointmentController =
      DetailAndCheckInAppointmentController();
  CustomerProfileModel customerProfileModelIsCustommer;
  CustomerProfileModel customerProfileModelIsUserHanding;
  CustomerProfileModel customerProfileModelIsUserPost;
  ProductModel productModel;
  ImagesBrain imagesBrain = ImagesBrain();
  GetDataCustommerProfileIsCustommer(args) async {
    CustomerProfileModel customerProfileModelTmp;
    customerProfileModelTmp =
        await detailAndCheckInAppointmentController.onGetCustomerProifile(
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
    productModelTmp = await detailAndCheckInAppointmentController.onGetProduct(
        document_id_product: args.appointmentModel.document_id_product);
    if (productModelTmp != null) {
      setState(() {
        productModel = productModelTmp;
      });
    }
  }

  GetDataCustommerProfileIsUserHanding(args) async {
    CustomerProfileModel customerProfileModelTmp;
    customerProfileModelTmp =
        await detailAndCheckInAppointmentController.onGetCustomerProifile(
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
        await detailAndCheckInAppointmentController.onGetCustomerProifile(
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
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments;
      });
      GetDataCustommerProfileIsCustommer(args);
      GetDataCustommerProfileIsUserHanding(args);
      GetDataCustommerProfileIsUserPost(args);
      GetDataProduct(args);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text(
          "Chi tiết lịch hẹn",
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
                        "Thông tin thêm:",
                        style: styleTextContentBlack,
                      ),
                      Text(
                          "Tạo bởi: ${customerProfileModelIsUserPost == null ? "" : customerProfileModelIsUserPost.user_name}"),
                      Text(
                          "Tạo vào: ${args == null ? "" : getDateShowHourAndMinute(args.appointmentModel.post_at)}"),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: setHeightSize(size: 10)),
              child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  child: BuildItemProduct(productModel: productModel)),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  File _imagesTMP;
                  GeoFirePoint geoFirePoint;
                  _imagesTMP = await imagesBrain.getImageCameraNoCrop(
                      source_picker: ImageSource.camera);
                  if (_imagesTMP != null) {
                    geoFirePoint = await checkGPSData(file_images: _imagesTMP);
                    if (geoFirePoint != null) {
                      bool result = false;
                      result = await detailAndCheckInAppointmentController
                          .onCheckInAppointment(
                              file_images_check_in: _imagesTMP,
                              documment_id_custommer:
                                  await getDocumentIdCustommer(),
                              document_id_appointment:
                                  args.appointmentModel.document_id_appointment,
                              coordinatesDoubleModel: CoordinatesDoubleModel(
                                  longitude: geoFirePoint.longitude,
                                  latitude: geoFirePoint.latitude));
                      if (result == true) {
                        Navigator.pop(context, true);
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDiaLogScreen(
                              title: "Thông báo",
                              message: "Check in thành công !.",
                            );
                          },
                        );
                      } else {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDiaLogScreen(
                              title: "Thông báo",
                              message:
                                  "Có lỗi !\n Vui lòng thử lại tính năng này sau.",
                            );
                          },
                        );
                      }
                    } else {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDiaLogScreen(
                            title: "Thông báo",
                            message:
                                "Ảnh không có dữ liệu vị trí !\n Vui lòng cấp quyền vị trí cho camera !",
                          );
                        },
                      );
                    }
                  }
                },
                child: Center(
                  child: Container(
                    height: setWidthSize(size: 120),
                    width: setWidthSize(size: 120),
                    decoration: BoxDecoration(
                      color: kColorYellow,
                      borderRadius: BorderRadius.circular(180),
                      gradient: LinearGradient(
                        colors: [Colors.teal, colorAppbar],
                        tileMode: TileMode
                            .mirror, // repeats the gradient over the canvas
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: Offset(0, 1),
                            spreadRadius: 1),
                      ],
                    ),
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Text(
                            "Check In",
                            style: styleTextTitleInAppWhite,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: FloatingActionButton(
                              onPressed: null,
                              mini: true,
                              backgroundColor: colorAppbar,
                              child: Icon(Icons.camera_alt)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
