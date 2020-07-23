import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_appointment/group_create_appointment/create_appointment_controller.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/widgets/build_item_product_in_appointment.dart';
import 'package:flutter_core/widgets/button_normal.dart';
import 'package:flutter_core/widgets/search_textfield_border.dart';
import 'package:flutter_core/widgets/text_field_boder.dart';
import 'package:flutter_core/view_system/group_appointment/group_create_appointment/group_pick_product/pick_product_screen.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_core/view_system/group_appointment/group_detail_and_edit_appointment/detail_and_edit_appointment_controller.dart';

class DetailAndEditAppointmentScreen extends StatefulWidget {
  static String id = "DetailAndEditAppointmentScreen";
  DetailAndEditAppointmentScreen({this.appointmentModel});
  AppointmentModel appointmentModel;
  @override
  _DetailAndEditAppointmentScreenState createState() =>
      _DetailAndEditAppointmentScreenState();
}

class _DetailAndEditAppointmentScreenState
    extends State<DetailAndEditAppointmentScreen> {
  DetailAndEditAppointmentScreen args;
  ProductModel productModelTmp_;
  ProductModel productModel;
  CustomerProfileModel customerProfileModelTmp_;
  CustomerProfileModel customerProfileModel;
  DateTime time_mettingTmp_;
  DateTime time_metting;
  String address_appointment;
  CustomerProfileModel customerProfileModelCustomerTmp_;
  CustomerProfileModel customerProfileModelCustomer;
  bool is_custommer_profile_out_the_system;
  TextEditingController textDateController = TextEditingController();
  TextEditingController textAddressAppointmentController =
      TextEditingController();
  DetailAndEditAppoinmentController detailAndEditAppoinmentController =
      new DetailAndEditAppoinmentController();

  getDataCustommerProfile(DetailAndEditAppointmentScreen args) async {
    CustomerProfileModel customerProfileModelTmp;
    customerProfileModelTmp =
        await detailAndEditAppoinmentController.onGetCustomerProfile(
            document_id_custommer:
                args.appointmentModel.document_id_user_handing);
    if (customerProfileModelTmp != null) {
      setState(() {
        customerProfileModelTmp_ = customerProfileModelTmp;
      });
    }
  }

  getDataCustommerProfileCustomer(DetailAndEditAppointmentScreen args) async {
    CustomerProfileModel customerProfileModelTmp;
    if (args.appointmentModel.is_custommer_profile_out_the_system == true) {
      customerProfileModelTmp = await detailAndEditAppoinmentController
          .onGetCustomerProfileOutTheSysten(
              document_id_custommer:
                  args.appointmentModel.document_id_custommer_out_the_system);
    } else {
      customerProfileModelTmp =
          await detailAndEditAppoinmentController.onGetCustomerProfile(
              document_id_custommer:
                  args.appointmentModel.document_id_custommer_out_the_system);
    }
    if (customerProfileModelTmp != null) {
      setState(() {
        customerProfileModelCustomerTmp_ = customerProfileModelTmp;
      });
    }
  }

  getDataProduct(DetailAndEditAppointmentScreen args) async {
    ProductModel productModelTmp;
    productModelTmp = await detailAndEditAppoinmentController.onGetProduct(
        document_id_product: args.appointmentModel.document_id_product);
    if (productModelTmp != null) {
      setState(() {
        productModelTmp_ = productModelTmp;
      });
    }
  }

  onUpDateAppointment() async {
    await detailAndEditAppoinmentController
        .onUpdateAppointment(
            document_id_appointment:
                args.appointmentModel.document_id_appointment,
            document_id_user_handing: customerProfileModel == null
                ? null
                : customerProfileModel.document_id_custommer,
            document_id_custommer: await getDocumentIdCustommer(),
            document_id_product:
                productModel == null ? null : productModel.ducument_id_product,
            custommer_out_the_system: customerProfileModelCustomer,
            is_custommer_profile_out_the_system:
                is_custommer_profile_out_the_system,
            address_appointment: address_appointment,
            time_metting: time_metting)
        .then((value) {
      if (value == true) {
        Navigator.pop(context, true);
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDiaLogScreen(
              title: "Thông báo",
              message: "Cập nhật lịch hẹn thành công",
            );
          },
        );
      } else {
        Navigator.pop(context, false);
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDiaLogScreen(
              title: "Thông báo",
              message: "Cập nhật lịch hẹn thất bại",
            );
          },
        );
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments;
      });
      getDataCustommerProfile(args);
      getDataCustommerProfileCustomer(args);
      getDataProduct(args);

      textDateController.text =
          getDateShowHourAndMinute(args.appointmentModel.time_metting);
      textAddressAppointmentController.text =
          args.appointmentModel.address_appointment;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text(
          "Chi tiết và chỉnh sửa lịch hẹn",
          style: styleTextTitleInAppWhite,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(setWidthSize(size: 10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Người xử lí:",
                    style: styleTextContentBlack,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context_) {
                          return buildAlertDialogPickUserSystem(
                            type: 1,
                          );
                        },
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            customerProfileModel = value;
                          });
                        }
                      });
                    },
                    child: BuildItemUser(
                        customerProfileModel: customerProfileModel == null
                            ? customerProfileModelTmp_
                            : customerProfileModel),
                  ),
                  Text(
                    "Khách hàng:",
                    style: styleTextContentBlack,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      //showModalBottomSheet__(context: context);
                    },
                    child: customerProfileModelCustomer == null
                        ? BuildItemUser(
                            customerProfileModel:
                                customerProfileModelCustomerTmp_)
                        : BuildItemUser(
                            customerProfileModel: customerProfileModelCustomer),
                  ),
                  Text(
                    "Sản phẩm:",
                    style: styleTextContentBlack,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.pushNamed(context, PickProductScreen.id)
                          .then((value) {
                        if (value != null) {
                          setState(() {
                            productModel = value;
                          });
                        }
                      });
                    },
                    child: productModel == null
                        ? BuildItemProduct(productModel: productModelTmp_)
                        : BuildItemProduct(productModel: productModel),
                  ),
                  SizedBox(
                    height: setHeightSize(size: 5),
                  ),
                  Text(
                    "Địa chỉ:",
                    style: styleTextContentBlack,
                  ),
                  SizedBox(
                    height: setHeightSize(size: 5),
                  ),
                  TextFieldBorder(
                    controller: textAddressAppointmentController,
                    hintText: "Số nhà/Đường/Phường/Quận",
                    colorTextWhite: false,
                    onChanged: (value) {
                      address_appointment = value;
                    },
                  ),
                  SizedBox(
                    height: setHeightSize(size: 5),
                  ),
                  Text(
                    "Thời gian gặp mặt:",
                    style: styleTextContentBlack,
                  ),
                  SizedBox(
                    height: setHeightSize(size: 5),
                  ),
                  TextFieldBorder(
                    hintText: "Giờ:Phút Ngày/Tháng/Năm",
                    colorTextWhite: false,
                    controller: textDateController,
                    onTap: () {
                      DatePicker.showDateTimePicker(context,
                          theme: DatePickerTheme(
                              cancelStyle: styleTextContentWhite,
                              doneStyle: styleTextContentWhite,
                              headerColor: colorAppbar),
                          showTitleActions: true,
                          minTime: DateTime(2020, 1, 1, 12, 30),
                          maxTime: DateTime(2050, 1, 1, 12, 30),
                          onConfirm: (date) {
                        textDateController.text =
                            getDateShowHourAndMinute(date.toString());
                        time_metting = date;
                        setState(() {});
                      }, currentTime: time_mettingTmp_, locale: LocaleType.vi);
                    },
                    readOnly: true,
                    iconLeft: Icon(Icons.date_range),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                child: StreamBuilder(
                  stream: detailAndEditAppoinmentController.errStream,
                  builder: (context, snapshot) => Text(
                    snapshot.hasError ? snapshot.error : '',
                    style: styleTextErrorBlack,
                  ),
                ),
              ),
            ),
            Container(
              width: setWidthSize(size: 200),
              child: ButtonNormal(
                onTap: () async {
                  await onUpDateAppointment();
                },
                text: "Lưu",
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showModalBottomSheet__({BuildContext context}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  title: new Text('Người dùng trong hệ thống'),
                  onTap: () async {
                    Navigator.pop(context);
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context_) {
                        return buildAlertDialogPickUserSystem(
                          type: 0,
                        );
                      },
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          customerProfileModelCustomer = value;
                          is_custommer_profile_out_the_system = false;
                        });
                      }
                    });
                  },
                ),
                ListTile(
                  title: Text('Người dùng ngoài hệ thống'),
                  onTap: () async {
                    Navigator.pop(context);
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context_) {
                        return buildAlertDialogPickUserOutTheSystem();
                      },
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          customerProfileModelCustomer = value;
                          if (value.type == null) {
                            is_custommer_profile_out_the_system = true;
                          } else {
                            is_custommer_profile_out_the_system = false;
                          }
                        });
                      }
                    });
                  },
                ),
              ],
            ),
          );
        });
  }
}

class BuildItemUser extends StatelessWidget {
  const BuildItemUser({
    @required this.customerProfileModel,
  });

  final CustomerProfileModel customerProfileModel;

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
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class buildAlertDialogPickUserSystem extends StatefulWidget {
  buildAlertDialogPickUserSystem({this.type});
  final int type;
  @override
  _buildAlertDialogPickUserSystemState createState() =>
      _buildAlertDialogPickUserSystemState();
}

class _buildAlertDialogPickUserSystemState
    extends State<buildAlertDialogPickUserSystem> {
  CreateAppoinmentController createAppoinmentController =
      new CreateAppoinmentController();
  List<CustomerProfileModel> listCustommerProfile = [];

  FindCustommerProfileByEmailOrUserName({String email, int type}) async {
    CustomerProfileModel customerProfileModelTmp;
    customerProfileModelTmp = await createAppoinmentController
        .onFindCustommerProfileByEmail(email: email, type: type);
    if (customerProfileModelTmp != null) {
      setState(() {
        listCustommerProfile = [customerProfileModelTmp];
      });
    } else {
      setState(() {
        listCustommerProfile = [];
      });
    }
  }

  getListDataCustommerProfile({num type}) async {
    List<CustomerProfileModel> listCustommerProfileTmp = [];
    listCustommerProfileTmp =
        await createAppoinmentController.onGetListCustommerProfile(type: type);
    if (listCustommerProfileTmp.length > 0) {
      setState(() {
        listCustommerProfile = listCustommerProfileTmp;
      });
    } else
      setState(() {
        listCustommerProfile = [];
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListDataCustommerProfile(type: widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.only(top: setHeightSize(size: 20)),
      title: Text(
        widget.type == 1 ? "Chọn nhân viên" : "Chọn khách hàng",
        style: styleTextTitleInAppBarBlack,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(setWidthSize(size: 10)),
            child: Search_TextField_Border(
              borderRadius: 5,
              hintText: "Nhập email.",
              sizeBorder: 2,
              colorBorDer: Colors.white,
              onChanged: (value) async {
                await FindCustommerProfileByEmailOrUserName(
                    email: value, type: widget.type);
                if (value == "") {
                  getListDataCustommerProfile(type: widget.type);
                }
              },
            ),
          ),
          Container(
            height: setHeightSize(size: 350),
            width: setWidthSize(size: 300),
            child: ListView.builder(
              padding: EdgeInsets.all(setWidthSize(size: 15)),
              itemCount: listCustommerProfile.length,
              itemBuilder: (BuildContext context, int index) {
                return listCustommerProfile.length > 0
                    ? GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.pop(context, listCustommerProfile[index]);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: setWidthSize(size: 5),
                            horizontal: setWidthSize(size: 5),
                          ),
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                listCustommerProfile[index].linkImages != null
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            listCustommerProfile[index]
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
                                      listCustommerProfile[index].email,
                                      style: styleTextContentBlack,
                                    ),
                                    Text(
                                      listCustommerProfile[index].user_name,
                                      style: styleTextContentBlack,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                        "Không có dữ liệu",
                        style: styleTextContentBlack,
                      ));
              },
            ),
          ),
          Container(
            height: setHeightSize(size: 140),
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/background_dialog_1.png"),
            )),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: Text("Đóng"))
      ],
    );
    ;
  }
}

class buildAlertDialogPickUserOutTheSystem extends StatefulWidget {
  @override
  _buildAlertDialogPickUserOutTheSystemState createState() =>
      _buildAlertDialogPickUserOutTheSystemState();
}

class _buildAlertDialogPickUserOutTheSystemState
    extends State<buildAlertDialogPickUserOutTheSystem> {
  CreateAppoinmentController createAppoinmentController =
      new CreateAppoinmentController();
  List<CustomerProfileModel> listCustommerProfileOutTheSystem = [];
  FindCustommerProfileOutTheSystemByEmail({String email}) async {
    CustomerProfileModel customerProfileModelTmp;
    customerProfileModelTmp = await createAppoinmentController
        .onFindCustommerProfileOutTheSystemByEmail(
      email: email,
    );
    if (customerProfileModelTmp != null) {
      setState(() {
        listCustommerProfileOutTheSystem = [customerProfileModelTmp];
      });
    } else {
      setState(() {
        listCustommerProfileOutTheSystem = [];
      });
    }
  }

  getListDataCustommerProfileOutTheSystem() async {
    List<CustomerProfileModel> listCustommerProfileTmp = [];
    listCustommerProfileTmp = await createAppoinmentController
        .onGetListCustommerProfileOutTheSystem();
    if (listCustommerProfileTmp.length > 0) {
      setState(() {
        listCustommerProfileOutTheSystem = listCustommerProfileTmp;
      });
    } else
      setState(() {
        listCustommerProfileOutTheSystem = [];
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListDataCustommerProfileOutTheSystem();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.only(top: setHeightSize(size: 20)),
      title: Text(
        "Chọn khách hàng",
        style: styleTextTitleInAppBarBlack,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(setWidthSize(size: 10)),
            child: Search_TextField_Border(
              borderRadius: 5,
              hintText: "Nhập email.",
              sizeBorder: 2,
              colorBorDer: Colors.white,
              onChanged: (value) async {
                await FindCustommerProfileOutTheSystemByEmail(email: value);
                if (value == "") {
                  getListDataCustommerProfileOutTheSystem();
                }
              },
            ),
          ),
          Container(
            height: setHeightSize(size: 350),
            width: setWidthSize(size: 300),
            child: ListView.builder(
              padding: EdgeInsets.all(setWidthSize(size: 15)),
              itemCount: listCustommerProfileOutTheSystem.length,
              itemBuilder: (BuildContext context, int index) {
                return listCustommerProfileOutTheSystem.length > 0
                    ? GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.pop(
                              context, listCustommerProfileOutTheSystem[index]);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: setWidthSize(size: 5),
                            horizontal: setWidthSize(size: 5),
                          ),
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                listCustommerProfileOutTheSystem[index]
                                            .linkImages !=
                                        null
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            listCustommerProfileOutTheSystem[
                                                    index]
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
                                      listCustommerProfileOutTheSystem[index]
                                          .email,
                                      style: styleTextContentBlack,
                                    ),
                                    Text(
                                      listCustommerProfileOutTheSystem[index]
                                          .user_name,
                                      style: styleTextContentBlack,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                        "Không có dữ liệu",
                        style: styleTextContentBlack,
                      ));
              },
            ),
          ),
          Container(
            height: setHeightSize(size: 140),
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/background_dialog_1.png"),
            )),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: Text("Đóng")),
        FlatButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context_) {
                  return buildAlertDialogCreateUserCustommerOutsideTheSystem(
                      context_);
                },
              ).then((value) {
                if (value != null) {
                  Navigator.pop(context, value);
                }
              });
            },
            child: Text("Tạo mới"))
      ],
    );
  }

  buildAlertDialogCreateUserCustommerOutsideTheSystem(BuildContext context_) {
    CustomerProfileModel _customerProfileModel = CustomerProfileModel();
    CreateAppoinmentController _createAppoinmentController =
        new CreateAppoinmentController();
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.only(top: setHeightSize(size: 20)),
      title: Text(
        "Tạo thông tin khách hàng",
        style: styleTextTitleInAppBarBlack,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFieldBorder(
                  hintText: "Email",
                  colorTextWhite: false,
                  onChanged: (value) {
                    _customerProfileModel.email = value;
                  },
                ),
                SizedBox(
                  height: setHeightSize(size: 15),
                ),
                TextFieldBorder(
                  hintText: "Họ",
                  colorTextWhite: false,
                  onChanged: (value) {
                    _customerProfileModel.last_name = value;
                  },
                ),
                SizedBox(
                  height: setHeightSize(size: 15),
                ),
                TextFieldBorder(
                  hintText: "Tên",
                  colorTextWhite: false,
                  onChanged: (value) {
                    _customerProfileModel.first_name = value;
                  },
                ),
                SizedBox(
                  height: setHeightSize(size: 15),
                ),
                TextFieldBorder(
                  typeInputIsNumber: true,
                  hintText: "Số điện thoại",
                  colorTextWhite: false,
                  onChanged: (value) {
                    _customerProfileModel.phone_number = value;
                  },
                ),
                SizedBox(
                  height: setHeightSize(size: 15),
                ),
                Center(
                  child: Container(
                    child: StreamBuilder(
                      stream: _createAppoinmentController.errStream,
                      builder: (context, snapshot) => Text(
                        snapshot.hasError ? snapshot.error : '',
                        style: styleTextErrorBlack,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: setHeightSize(size: 140),
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/background_dialog_1.png"),
            )),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context_, null);
          },
          child: Text("Đóng"),
        ),
        FlatButton(
          onPressed: () {
            bool _result = false;
            _result = _createAppoinmentController
                .checkDataCustommerProfileUserOutTheSystem(
                    customerProfileModel: _customerProfileModel);
            if (_result == true) {
              _customerProfileModel.user_name =
                  "${_customerProfileModel.last_name} ${_customerProfileModel.first_name}";
              Navigator.pop(context_, _customerProfileModel);
            }
          },
          child: Text("Đồng ý"),
        ),
      ],
    );
  }
}
