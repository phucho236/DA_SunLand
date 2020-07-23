import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_add_new_real_estate/dialog_add_real_estate.dart';
import 'package:flutter_core/view_system/group_appointment/appointment_screen.dart';
import 'package:flutter_core/view_system/group_attendance_management/group_add_user_system_to_group_attendance/add_user_system_to_group_attendance_screen.dart';
import 'package:flutter_core/view_system/group_control_panel/control_panel_controller.dart';
import 'package:flutter_core/view_system/group_decentralization/decentralization_screen.dart';
import 'package:flutter_core/view_system/group_edit_product/gridview_product_edit_screen.dart';
import 'package:flutter_core/view_system/group_post_notify_system_user/post_notify_system_user_screen.dart';
import 'package:flutter_core/view_system/group_product/post_product_screen.dart';
import 'package:flutter_core/view_system/group_product_ads/group_product_ads/product_ads_creen.dart';
import 'package:flutter_core/view_system/group_product_censorship/product_censorship_screen.dart';
import 'package:flutter_core/view_system/group_support_chat_with_user/support_chat_with_user_screen.dart';
import 'package:flutter_core/view_system/group_to_become_a_partner_censorship/request_to_become_a_partner_layout.dart';
import 'package:flutter_core/view_system/group_user_need_contact/user_need_contact_layout.dart';
import 'package:flutter_core/views/group_accuracy/group_login/login_screen.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/views/home_center_screen.dart';
import 'package:flutter_core/widgets/creat_boder_shape.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_core/view_system/group_attendance_management/group_history_attendance_all/history_attendance_all_screen.dart';

class ControlPanelScreen extends StatefulWidget {
  static String id = "ControlPanelScreen";
  @override
  _ControlPanelScreenState createState() => _ControlPanelScreenState();
}

class _ControlPanelScreenState extends State<ControlPanelScreen> {
  bool is_admin = false;
  String document_id_custommer;
  String document_id_data_custommer_system;
  bool permisstion_post_project = false;
  bool permisstion_user_need_contact_all = false;
  bool permisstion_appointment_manager_all_system = false;
  bool permisstion_to_become_a_partner_censorship_all = false;
  ControlPanelController controlPanelController = ControlPanelController();
  List<PermistionModel> listPermistionCustommerSystemModelUse = [];
  void getListPermistion() async {
    List<String> listPermistionCustommerSystem = [];
    listPermistionCustommerSystem = await getListPermistionCustommerSystem();
    listPermistionCustommerSystemModelUse =
        await returnListPermistionCustommerSystemModel(
            listPermistionCustommerSystem: listPermistionCustommerSystem);
    setState(() {});
  }

  GetDocumentDataCustommerSystem() async {
    String document_id_data_custommer_systemtmp;
    document_id_data_custommer_systemtmp =
        await controlPanelController.onGetDocumentIDDataCustommerSystem(
            document_id_custommer: document_id_custommer);
    if (document_id_data_custommer_systemtmp != null) {
      setState(() {
        document_id_data_custommer_system =
            document_id_data_custommer_systemtmp;
      });
    }
  }

  GetDocumentIDCustommer__() async {
    String document_id_custommertmp;
    document_id_custommertmp = await getDocumentIdCustommer();
    if (document_id_custommertmp != null) {
      setState(() {
        document_id_custommer = document_id_custommer;
      });
    }
  }

  List<PermistionModel> returnListPermistionCustommerSystemModel(
      {List<String> listPermistionCustommerSystem}) {
    List<PermistionModel> _returnListPermistionCustommerSystemModel = [];
    for (var item1 in listPermisstionModelInSystem) {
      for (var item2 in listPermistionCustommerSystem) {
        if (item2 == "all_permisstion") {
          setState(() {
            permisstion_post_project = true;
            permisstion_user_need_contact_all = true;
            permisstion_appointment_manager_all_system = true;
            permisstion_to_become_a_partner_censorship_all = true;
            is_admin = true;
          });
          break;
        }
        if (item1.id == item2) {
          _returnListPermistionCustommerSystemModel.add(item1);
        }
        if (item2 == "post_project") {
          setState(() {
            permisstion_post_project = true;
          });
        }
        if (item2 == "permisstion_user_need_contact_all") {
          setState(() {
            permisstion_user_need_contact_all = true;
          });
        }

        if (item2 == "permisstion_to_become_a_partner_censorship_all") {
          setState(() {
            permisstion_to_become_a_partner_censorship_all = true;
          });
        }
        if (item2 == "permisstion_appointment_manager_all_system") {
          setState(() {
            permisstion_appointment_manager_all_system = true;
          });
        }
      }
    }
    return _returnListPermistionCustommerSystemModel;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetDocumentIDCustommer__();
    getListPermistion();
    GetDocumentDataCustommerSystem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, HomeCenterScreen.id);
          },
          child: Padding(
            padding: EdgeInsets.only(left: setWidthSize(size: 15)),
            child: Container(
              child: Image.asset(
                "assets/images/icon_sunland.png",
              ),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(MdiIcons.logout),
            onPressed: () {
              setDocumentIdCustommer(newValue: '');
              Navigator.pushReplacementNamed(
                context,
                LoginScreen.id,
              );
            },
          ),
        ],
        backgroundColor: Colors.grey[300],
        title: Text(
          "Bàn làm việc",
          style: styleTextTitleInAppBarBlack,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(setWidthSize(size: 5)),
        child: Column(
          children: <Widget>[
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 1.45),
                itemBuilder: (BuildContext context, index) => is_admin
                    ? listPermisstionModelInSystem[index].id !=
                                "permisstion_user_need_contact_all" &&
                            listPermisstionModelInSystem[index].id !=
                                "permisstion_to_become_a_partner_censorship_all" &&
                            listPermisstionModelInSystem[index].id !=
                                "appointment_management_all_system"
                        ? BuildIButton(
                            isItemTwo: index % 2 != 0 ? true : false,
                            permisstion_appointment_manager_all_system:
                                permisstion_appointment_manager_all_system,
                            permisstion_user_need_contact_all:
                                permisstion_user_need_contact_all,
                            permisstion_to_become_a_partner_censorship_all:
                                permisstion_to_become_a_partner_censorship_all,
                            permisstion_post_project: permisstion_post_project,
                            document_id_custommer: document_id_custommer,
                            PermistionCustommerSystemModelUse:
                                listPermisstionModelInSystem[index],
                          )
                        : BuildIButton(
                            isItemTwo: index % 2 != 0 ? true : false,
                            view_only: true,
                            permisstion_user_need_contact_all:
                                permisstion_user_need_contact_all,
                            permisstion_to_become_a_partner_censorship_all:
                                permisstion_to_become_a_partner_censorship_all,
                            permisstion_post_project: permisstion_post_project,
                            document_id_custommer: document_id_custommer,
                            permisstion_appointment_manager_all_system:
                                permisstion_appointment_manager_all_system,
                            PermistionCustommerSystemModelUse:
                                listPermisstionModelInSystem[index],
                          )
                    : listPermistionCustommerSystemModelUse[index].id !=
                                "permisstion_user_need_contact_all" &&
                            listPermistionCustommerSystemModelUse[index].id !=
                                "permisstion_to_become_a_partner_censorship_all" &&
                            listPermistionCustommerSystemModelUse[index].id !=
                                "appointment_management_all_system"
                        ? BuildIButton(
                            isItemTwo: index % 2 != 0 ? true : false,
                            permisstion_appointment_manager_all_system:
                                permisstion_appointment_manager_all_system,
                            permisstion_to_become_a_partner_censorship_all:
                                permisstion_to_become_a_partner_censorship_all,
                            permisstion_user_need_contact_all:
                                permisstion_user_need_contact_all,
                            permisstion_post_project: permisstion_post_project,
                            document_id_custommer: document_id_custommer,
                            PermistionCustommerSystemModelUse:
                                listPermistionCustommerSystemModelUse[index],
                          )
                        : BuildIButton(
                            isItemTwo: index % 2 != 0 ? true : false,
                            permisstion_appointment_manager_all_system:
                                permisstion_appointment_manager_all_system,
                            permisstion_to_become_a_partner_censorship_all:
                                permisstion_to_become_a_partner_censorship_all,
                            view_only: true,
                            permisstion_user_need_contact_all:
                                permisstion_user_need_contact_all,
                            permisstion_post_project: permisstion_post_project,
                            document_id_custommer: document_id_custommer,
                            PermistionCustommerSystemModelUse:
                                listPermisstionModelInSystem[index],
                          ),
                itemCount: is_admin
                    ? listPermisstionModelInSystem.length
                    : listPermistionCustommerSystemModelUse.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BuildIButton extends StatefulWidget {
  const BuildIButton({
    Key key,
    @required this.document_id_custommer,
    @required this.PermistionCustommerSystemModelUse,
    this.permisstion_post_project,
    this.permisstion_user_need_contact_all,
    this.permisstion_to_become_a_partner_censorship_all,
    this.permisstion_appointment_manager_all_system,
    this.view_only = false,
    this.isItemTwo = true,
  }) : super(key: key);

  final String document_id_custommer;
  final bool permisstion_post_project;
  final PermistionModel PermistionCustommerSystemModelUse;
  final bool permisstion_user_need_contact_all;
  final bool permisstion_to_become_a_partner_censorship_all;
  final bool permisstion_appointment_manager_all_system;
  final bool view_only;
  final bool isItemTwo;

  @override
  _BuildIButtonState createState() => _BuildIButtonState();
}

class _BuildIButtonState extends State<BuildIButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: setWidthSize(size: 10),
          left: setWidthSize(size: 10),
          right: setWidthSize(size: 10)),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: setWidthSize(size: widget.isItemTwo ? 10 : 0),
          ),
          Container(
            height: setWidthSize(size: 100),
            decoration: BoxDecoration(
              color: widget.view_only ? Colors.grey[350] : Colors.grey[300],
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[500],
                    offset: Offset(2.0, 2.0),
                    blurRadius: 8.0,
                    spreadRadius: 1.0),
                BoxShadow(
                    color: Colors.white,
                    offset: Offset(-2.0, -2.0),
                    blurRadius: 8.0,
                    spreadRadius: 1.0),
              ],
            ),
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: setWidthSize(size: 1),
                  vertical: setWidthSize(size: 1)),
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: setWidthSize(size: 10),
                    vertical: setWidthSize(size: 10)),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (widget.PermistionCustommerSystemModelUse.id ==
                        "appointment_management") {
                      Navigator.pushNamed(context, AppointmentScreen.id,
                          arguments: AppointmentScreen(
                            permisstion_appointment_manager_all_system: widget
                                .permisstion_appointment_manager_all_system,
                          ));
                    }
                    if (widget.PermistionCustommerSystemModelUse.id ==
                        "attendance_management") {
                      Navigator.pushNamed(
                          context, HistoryAttendanceAllScreen.id);
                    }

                    if (widget.PermistionCustommerSystemModelUse.id ==
                        "product_ads") {
                      Navigator.pushNamed(context, ProductAdsScreen.id);
                    }
                    if (widget.PermistionCustommerSystemModelUse.id ==
                        "decentralization") {
                      Navigator.pushNamed(context, DecentralizationScreen.id);
                    }
                    if (widget.PermistionCustommerSystemModelUse.id ==
                        "post_notify_system_users") {
                      Navigator.pushNamed(
                          context, PostNotifySystemUsersScreen.id);
                    }
                    if (widget.PermistionCustommerSystemModelUse.id ==
                        "post_product") {
                      Navigator.pushNamed(
                        context,
                        PostProductScreen.id,
                        arguments: PostProductScreen(
                          permisstion_post_project:
                              widget.permisstion_post_project,
                        ),
                      );
                    }
                    if (widget.PermistionCustommerSystemModelUse.id ==
                        "edit_product") {
                      Navigator.pushNamed(
                          context, GridViewShowProductEditScreen.id,
                          arguments: GridViewShowProductEditScreen(
                            permisstion_post_project:
                                widget.permisstion_post_project,
                          ));
                    }

                    if (widget.PermistionCustommerSystemModelUse.id ==
                        "support_chat_with_user") {
                      Navigator.pushNamed(
                          context, SupportChatWithUserScreen.id);
                    }
                    if (widget.PermistionCustommerSystemModelUse.id ==
                        "product_censorship") {
                      Navigator.pushNamed(context, ProductCensorshipScreen.id);
                    }
                    if (widget.PermistionCustommerSystemModelUse.id ==
                        "user_need_contact") {
                      Navigator.pushNamed(
                        context,
                        UserNeedContactLayout.id,
                        arguments: UserNeedContactLayout(
                          permisstion_user_need_contact_all:
                              widget.permisstion_user_need_contact_all,
                        ),
                      );
                    }
                    if (widget.PermistionCustommerSystemModelUse.id ==
                        "to_become_a_partner_censorship") {
                      Navigator.pushNamed(
                        context,
                        RequestToBecomeAPartnerLayout.id,
                        arguments: RequestToBecomeAPartnerLayout(
                          permisstion_to_become_a_partner_censorship_all: widget
                              .permisstion_to_become_a_partner_censorship_all,
                        ),
                      );
                    }
                    if (widget.PermistionCustommerSystemModelUse.id ==
                        "post_project") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogAddRealEstateScreen(
                              document_id_custommer:
                                  widget.document_id_custommer);
                        },
                      ).then((value) {
                        if (value == true) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDiaLogScreen(
                                title: "Thông báo",
                                message: "Thêm thành công",
                              );
                            },
                          );
                        }
                        if (value == false) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDiaLogScreen(
                                title: "Thông báo",
                                message: "Thêm thất bại",
                              );
                            },
                          );
                        }
                      });
                    }
                  },
                  child: Center(
                    child: Text(
                      widget.PermistionCustommerSystemModelUse.title
                          .toUpperCase(),
                      style: styleTextContentGrey,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
