import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_appointment/appointment_controller.dart';
import 'package:flutter_core/view_system/group_appointment/group_appointment_done/appointment_done_controller.dart';
import 'package:flutter_core/view_system/group_appointment/group_detail_appointment_done/detail_appointment_done_screen.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AppointmentAllSystemDoneScreen extends StatefulWidget {
  static String id = "AppointmentAllSystemDoneScreen";
  @override
  _AppointmentAllSystemDoneScreenState createState() =>
      _AppointmentAllSystemDoneScreenState();
}

class _AppointmentAllSystemDoneScreenState
    extends State<AppointmentAllSystemDoneScreen> {
  bool isLoading = false;
  List<AppointmentModel> listAppointmentModel = [];
  ProductModel productModel;
  CustomerProfileModel customerProfileModel;
  CustomerProfileModel customerProfileModelCustomer;

  ApointmentDoneController apointmentDoneController =
      ApointmentDoneController();
  GetDataCustommerProfile(AppointmentModel appointmentModel) async {
    CustomerProfileModel customerProfileModelCustomerTmp;
    customerProfileModelCustomerTmp =
        await apointmentDoneController.onGetCustomerProifile(
            document_id_custommer:
                appointmentModel.document_id_custommer_out_the_system);
    if (customerProfileModelCustomerTmp != null) {
      return customerProfileModelCustomerTmp;
    }
  }

  onGetListAppointmentUserHandingAllSystem() async {
    List<AppointmentModel> listAppointmentModelTmp = [];
    listAppointmentModelTmp =
        await apointmentDoneController.onGetListApointment(
            checked_in: true, get_list_appointment_user_handing: true);
    if (listAppointmentModelTmp.length > 0) {
      setState(() {
        listAppointmentModel = listAppointmentModelTmp;
        isLoading = false;
      });
    } else {
      setState(() {
        listAppointmentModel = [];
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
    onGetListAppointmentUserHandingAllSystem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text(
          "Lịch hẹn(Đã hoàn thành-Tất cã)",
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
                            return BuildItemUser(
                              appointmentModel: listAppointmentModel[index],
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  DetailInAppointmentDoneScreen.id,
                                  arguments: DetailInAppointmentDoneScreen(
                                    appointmentModel:
                                        listAppointmentModel[index],
                                  ),
                                ).then((value) {
                                  if (value == true) {
                                    onGetListAppointmentUserHandingAllSystem();
                                  }
                                });
                              },
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            "Chưa có lịch hẹn đã hoàn thành.",
                            style: styleTextContentBlack,
                          ),
                        ),
                ),
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: setHeightSize(size: 10)),
      child: GestureDetector(
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }
}
