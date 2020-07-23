import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_appointment/group_detail_appointment_done/detail_appointment_done_screen.dart';
import 'package:flutter_core/view_system/group_appointment/group_posted_appointment/posted_appointment_controller.dart';
import 'package:flutter_core/view_system/group_appointment/group_detail_and_edit_appointment/detail_and_edit_appointment_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AppointmentPostedScreen extends StatefulWidget {
  static String id = "AppointmentPostedScreen";
  @override
  _AppointmentPostedScreenState createState() =>
      _AppointmentPostedScreenState();
}

class _AppointmentPostedScreenState extends State<AppointmentPostedScreen> {
  List<AppointmentModel> listAppointmentModel = [];
  bool isLoading = false;
  ProductModel productModel;
  CustomerProfileModel customerProfileModel;
  CustomerProfileModel customerProfileModelCustomer;
  List<CustomerProfileModel> listCustommerProfile = [];
  ApointmentPostedController apointmentPostedController =
      ApointmentPostedController();
  GetDataCustommerProfile(AppointmentModel appointmentModel) async {
    CustomerProfileModel customerProfileModelCustomerTmp;
    customerProfileModelCustomerTmp =
        await apointmentPostedController.onGetCustomerProfile(
            document_id_custommer:
                appointmentModel.document_id_custommer_out_the_system);
    if (customerProfileModelCustomerTmp != null) {
      return customerProfileModelCustomerTmp;
    }
  }

  onGetListCustommerProfile(List<AppointmentModel> listAppointmentModel) async {
    List<CustomerProfileModel> listCustommerProfileTmp = [];
    CustomerProfileModel customerProfileModel;
    for (var item in listAppointmentModel) {
      customerProfileModel =
          await apointmentPostedController.onGetCustomerProfile(
              document_id_custommer: item.document_id_custommer_out_the_system,
              is_custommer_profile_out_the_system:
                  item.is_custommer_profile_out_the_system);
      listCustommerProfileTmp.add(customerProfileModel);
    }
    setState(() {
      isLoading = false;
    });
    if (listCustommerProfileTmp != null) {
      setState(() {
        listCustommerProfile = listCustommerProfileTmp;
      });
    }
  }

  onGetListAppointmentUserPosted() async {
    setState(() {
      isLoading = true;
    });
    List<AppointmentModel> listAppointmentModelTmp = [];
    listAppointmentModelTmp =
        await apointmentPostedController.onGetListPostedApointment(
            document_id_custommer: await getDocumentIdCustommer());
    if (listAppointmentModelTmp != null) {
      await onGetListCustommerProfile(listAppointmentModelTmp);
      setState(() {
        listAppointmentModel = listAppointmentModelTmp;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onGetListAppointmentUserPosted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text(
          "Lịch hẹn đã đăng",
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
                                customerProfileModel:
                                    listCustommerProfile[index],
                                appointmentModel: listAppointmentModel[index],
                                onTap: () async {
                                  if (listAppointmentModel[index].checked_in ==
                                      true) {
                                    Navigator.pushNamed(
                                      context,
                                      DetailInAppointmentDoneScreen.id,
                                      arguments: DetailInAppointmentDoneScreen(
                                        appointmentModel:
                                            listAppointmentModel[index],
                                      ),
                                    ).then((value) {
                                      if (value == true) {
                                        onGetListAppointmentUserPosted();
                                      }
                                    });
                                  }
                                  if (listAppointmentModel[index].checked_in ==
                                      false) {
                                    Navigator.pushNamed(
                                      context,
                                      DetailAndEditAppointmentScreen.id,
                                      arguments: DetailAndEditAppointmentScreen(
                                        appointmentModel:
                                            listAppointmentModel[index],
                                      ),
                                    ).then((value) {
                                      if (value == true) {
                                        onGetListAppointmentUserPosted();
                                      }
                                    });
                                  }
                                },
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            "Không có dữ liệu",
                            style: styleTextContentBlack,
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}

class BuildItemUser extends StatelessWidget {
  BuildItemUser({this.appointmentModel, this.onTap, this.customerProfileModel});
  final AppointmentModel appointmentModel;
  final Function onTap;
  CustomerProfileModel customerProfileModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                Text("Địa điểm: ${appointmentModel.address_appointment}"),
                Text(
                    "Thời gian gặp: ${getDateShowHourAndMinute(appointmentModel.time_metting)}"),
                Text(
                  "Trạng thái: ${appointmentModel.checked_in == false ? "Chưa hoàn thành" : "Hoàn thành"}",
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
