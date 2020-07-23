import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_appointment/appointment_controller.dart';
import 'package:flutter_core/view_system/group_appointment/group_create_appointment/create_appointment_screen.dart';
import 'package:flutter_core/view_system/group_appointment/group_detail_and_check_in_appointment/detail_and_check_in_appointment_screen.dart';
import 'package:flutter_core/view_system/group_appointment/group_appointment_done/appointment_done_screen.dart';
import 'package:flutter_core/view_system/group_appointment/group_posted_appointment/posted_appointment_screen.dart';
import 'package:flutter_core/view_system/group_appointment/group_appoiment_all_system/appoiment_all_system_screen.dart';

class AppointmentScreen extends StatefulWidget {
  static String id = "AppointmentScreen";

  AppointmentScreen({this.permisstion_appointment_manager_all_system});

  final bool permisstion_appointment_manager_all_system;

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  bool isLoading = false;
  List<AppointmentModel> listAppointmentModel = [];
  ProductModel productModel;
  CustomerProfileModel customerProfileModel;
  CustomerProfileModel customerProfileModelCustomer;

  ApointmentController apointmentController = ApointmentController();

  GetDataCustommerProfile(AppointmentModel appointmentModel) async {
    CustomerProfileModel customerProfileModelCustomerTmp;
    customerProfileModelCustomerTmp =
        await apointmentController.onGetCustomerProifile(
            document_id_custommer:
                appointmentModel.document_id_custommer_out_the_system);
    if (customerProfileModelCustomerTmp != null) {
      return customerProfileModelCustomerTmp;
    }
  }

  onGetListAppointmentUserHanding() async {
    List<AppointmentModel> listAppointmentModelTmp = [];
    listAppointmentModelTmp = await apointmentController.onGetListApointment(
      checked_in: false,
      document_id_custommer: await getDocumentIdCustommer(),
    );
    if (listAppointmentModelTmp.length > 0) {
      setState(() {
        isLoading = false;
        listAppointmentModel = listAppointmentModelTmp;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
    onGetListAppointmentUserHanding();
  }

  @override
  Widget build(BuildContext context) {
    AppointmentScreen args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text(
          "Lịch hẹn được giao",
          style: styleTextTitleInAppWhite,
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: listAppointmentModel.length > 0
                      ? ListView.builder(
                          padding: EdgeInsets.all(setWidthSize(size: 15)),
                          itemCount: listAppointmentModel.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: setHeightSize(size: 10)),
                              child: BuildItemUser(
                                appointmentModel: listAppointmentModel[index],
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    DetailAndCheckInAppointmentScreen.id,
                                    arguments:
                                        DetailAndCheckInAppointmentScreen(
                                      appointmentModel:
                                          listAppointmentModel[index],
                                    ),
                                  ).then((value) {
                                    if (value == true) {
                                      onGetListAppointmentUserHanding();
                                    }
                                  });
                                },
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            "Không có lịch hẹn được giao.",
                            style: styleTextContentBlack,
                          ),
                        ),
                ),
              ],
            ),
      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: true,
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: colorAppbar,
        foregroundColor: Colors.white,
        elevation: 5.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.add),
            backgroundColor: colorAppbar,
            label: 'Thêm lịch hẹn'.toUpperCase(),
            labelStyle: styleTextContentBlack,
            onTap: () {
              Navigator.pushNamed(context, CreateAppointmentScreen.id)
                  .then((value) {
                if (value == true) {
                  onGetListAppointmentUserHanding();
                }
              });
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.done_all),
            backgroundColor: colorAppbar,
            label: 'Đã hoàn thành'.toUpperCase(),
            labelStyle: styleTextContentBlack,
            onTap: () {
              Navigator.pushNamed(context, AppointmentDoneScreen.id);
            },
          ),
          SpeedDialChild(
              child: Icon(Icons.call_made),
              backgroundColor: colorAppbar,
              label: 'Đã đăng'.toUpperCase(),
              labelStyle: styleTextContentBlack,
              onTap: () {
                Navigator.pushNamed(context, AppointmentPostedScreen.id)
                    .then((value) {
                  if (value == true) {
                    onGetListAppointmentUserHanding();
                  }
                });
              }),
          SpeedDialChild(
              child: Icon(Icons.filter_frames),
              backgroundColor: args.permisstion_appointment_manager_all_system
                  ? colorAppbar
                  : Colors.red,
              label: 'Lịch hẹn-Tất cã'.toUpperCase(),
              labelStyle: styleTextContentBlack,
              onTap: args.permisstion_appointment_manager_all_system
                  ? () {
                      Navigator.pushNamed(
                              context, AppointmentAllSystemScreen.id)
                          .then((value) {
                        if (value == true) {
                          AppointmentAllSystemScreen();
                        }
                      });
                    }
                  : () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDiaLogScreen(
                            title: "Thông báo",
                            message: "Bạn không có quyền này",
                          );
                        },
                      );
                    }),
        ],
      ),
    );
  }
}

class BuildItemUser extends StatefulWidget {
  const BuildItemUser({this.appointmentModel, this.onTap});

  final AppointmentModel appointmentModel;
  final Function onTap;

  @override
  _BuildItemUserState createState() => _BuildItemUserState();
}

class _BuildItemUserState extends State<BuildItemUser> {
  ApointmentController apointmentController = ApointmentController();
  CustomerProfileModel customerProfileModel;

  GetDataCustommerProfile() async {
    CustomerProfileModel customerProfileModelTmp;
    customerProfileModelTmp = await apointmentController.onGetCustomerProifile(
        is_custommer_profile_out_the_system:
            widget.appointmentModel.is_custommer_profile_out_the_system,
        document_id_custommer:
            widget.appointmentModel.document_id_custommer_out_the_system);
    if (customerProfileModelTmp != null) {
      setState(() {
        customerProfileModel = customerProfileModelTmp;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    GetDataCustommerProfile();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Material(
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
                    customerProfileModel != null &&
                            customerProfileModel.linkImages != null
                        ? CircleAvatar(
                            backgroundImage:
                                NetworkImage(customerProfileModel.linkImages),
                            radius: 30.0,
                          )
                        : CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/images/library_image.png"),
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
                          customerProfileModel == null
                              ? ""
                              : customerProfileModel.user_name,
                          style: styleTextContentBlack,
                        ),
                        Text(
                          customerProfileModel == null
                              ? ""
                              : customerProfileModel.email,
                          style: styleTextContentBlack,
                        ),
                        Text(
                          customerProfileModel == null
                              ? ""
                              : customerProfileModel.phone_number,
                          style: styleTextContentBlack,
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                    "Địa điểm: ${widget.appointmentModel.address_appointment}"),
                Text(
                    "Thời gian gặp: ${getDateShowHourAndMinute(widget.appointmentModel.time_metting)}"),
                Text(
                  "Trạng thái: ${widget.appointmentModel.checked_in == false ? "Chưa hoàn thành" : "Hoàn thành"}",
                  style: styleTextContentBlack,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
