import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_to_become_a_partner_censorship/group_request_to_become_a_partner_screen/mail_reply_controller.dart';
import 'package:flutter_core/view_system/group_to_become_a_partner_censorship/group_request_to_become_a_partner_screen/request_to_become_a_partner_controller.dart';
import 'package:flutter_core/views/group_dialog/alert_dialog_screen.dart';
import 'package:flutter_core/widgets/creat_boder_shape.dart';

class DialogDetailRequestToBecomeAPartner extends StatefulWidget {
  DialogDetailRequestToBecomeAPartner(
      {this.requestToBecomeAPartnerModel, this.customerProfileModel});
  final CustomerProfileModel customerProfileModel;
  final RequestToBecomeAPartnerModel requestToBecomeAPartnerModel;

  @override
  _DialogDetailRequestToBecomeAPartnerState createState() =>
      _DialogDetailRequestToBecomeAPartnerState();
}

class _DialogDetailRequestToBecomeAPartnerState
    extends State<DialogDetailRequestToBecomeAPartner> {
  String email;
  String document_id_custommer;
  CustomerProfileModel customerProfileModelCensored = CustomerProfileModel();
  CustomerProfileModel customerProfileModelEdit = CustomerProfileModel();
  RequestToBecomeAPartnerController requestToBecomeAPartnerController =
      RequestToBecomeAPartnerController();
  MailReplyController mailReplyController = MailReplyController();
  getDocumentId() async {
    String docuemnt_idTmp;
    docuemnt_idTmp = await getDocumentIdCustommer();
    if (docuemnt_idTmp != null) {
      setState(() {
        document_id_custommer = docuemnt_idTmp;
      });
    }
  }

  getCustommerProifileModelCensored() async {
    if (widget.requestToBecomeAPartnerModel.censored == true) {
      CustomerProfileModel customerProfileModelCensoredTmp =
          CustomerProfileModel();
      customerProfileModelCensoredTmp = await requestToBecomeAPartnerController
          .onLoadGetDataProfileCustommerCensored(
              document_id_custommer:
                  widget.requestToBecomeAPartnerModel.censored_by);
      if (customerProfileModelCensoredTmp != null) {
        setState(() {
          customerProfileModelCensored = customerProfileModelCensoredTmp;
        });
      }
    }
  }

  getCustommerProifileModelEdit() async {
    if (widget.requestToBecomeAPartnerModel.censored == true) {
      CustomerProfileModel customerProfileModelCensoredTmp =
          CustomerProfileModel();
      customerProfileModelCensoredTmp = await requestToBecomeAPartnerController
          .onLoadGetDataProfileCustommerCensored(
              document_id_custommer:
                  widget.requestToBecomeAPartnerModel.edit_by);
      if (customerProfileModelCensoredTmp != null) {
        setState(() {
          customerProfileModelEdit = customerProfileModelCensoredTmp;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocumentId();
    getCustommerProifileModelCensored();
    getCustommerProifileModelEdit();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.only(top: setHeightSize(size: 20)),
      title: Text("Thông tin yêu cầu"),
      content: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(setWidthSize(size: 5)),
                  child: widget.customerProfileModel.linkImages == null
                      ? CircleAvatar(
                          radius: 30,
                          child: Container(
                            margin: EdgeInsets.all(setWidthSize(size: 10)),
                            child:
                                Image.asset("assets/images/library_image.png"),
                          ),
                        )
                      : CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              widget.customerProfileModel.linkImages),
                        ),
                ),
                SizedBox(
                  width: setWidthSize(size: 5),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.customerProfileModel.email,
                        style: styleTextContentBlack,
                      ),
                      Text(
                        widget.customerProfileModel.user_name,
                        style: styleTextContentBlack,
                      ),
                      Text(
                        "${getDateShow(widget.requestToBecomeAPartnerModel.send_at)} ",
                        style: styleTextContentBlack,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            widget.requestToBecomeAPartnerModel.censored
                ? Padding(
                    padding: EdgeInsets.all(setWidthSize(size: 5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Thông tin kiểm duyệt",
                          style: styleTextTitleInBodyBlack,
                        ),
                        Text(
                          "Nhân viên: ${customerProfileModelCensored.user_name}",
                          style: styleTextContentBlack,
                        ),
                        Text(
                          "Duyệt vào: ${getDateShow(widget.requestToBecomeAPartnerModel.censored_at)}",
                          style: styleTextContentBlack,
                        ),
                      ],
                    ),
                  )
                : Container(),
            widget.requestToBecomeAPartnerModel.edit_by != null
                ? Padding(
                    padding: EdgeInsets.all(setWidthSize(size: 5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Thông tin chỉnh sửa",
                          style: styleTextTitleInBodyBlack,
                        ),
                        Text(
                          "Nhân viên: ${customerProfileModelEdit.user_name}",
                          style: styleTextContentBlack,
                        ),
                        Text(
                          "Lần cuối chỉnh sửa: ${getDateShow(widget.requestToBecomeAPartnerModel.last_edit)}",
                          style: styleTextContentBlack,
                        ),
                      ],
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.all(setWidthSize(size: 5)),
              child: Text(
                widget.requestToBecomeAPartnerModel.accepted
                    ? "Trạng thái: Là đối tác"
                    : "Trạng thái: Không là đối tác",
                style: styleTextTitleInBodyBlack,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(
                setWidthSize(size: 10),
              ),
              child: Text(
                "Nội dung:",
                style: styleTextTitleInBodyBlack,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: setWidthSize(size: 10),
                right: setWidthSize(size: 10),
                bottom: setHeightSize(size: 10),
              ),
              child: CustomPaint(
                painter: MyPainter(
                    radius: 15, colorBoder: Colors.white, borderWidth: 2),
                child: Container(
                  height: setHeightSize(size: 200),
                  width: setWidthSize(size: double.infinity),
                  child: Padding(
                    padding: EdgeInsets.all(setWidthSize(size: 10)),
                    child: Text(
                      "${widget.requestToBecomeAPartnerModel.content}",
                      style: styleTextContentBlack,
                    ),
                  ),
                ),
              ),
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
      actions: widget.requestToBecomeAPartnerModel.censored
          ? <Widget>[
              widget.requestToBecomeAPartnerModel.accepted
                  ? FlatButton(
                      onPressed: () {
                        requestToBecomeAPartnerController
                            .onEditPartner(
                                document_id_custommer_send_request: widget
                                    .requestToBecomeAPartnerModel
                                    .document_id_custommer,
                                accepted: false,
                                document_id_request: widget
                                    .requestToBecomeAPartnerModel
                                    .document_id_request,
                                document_id_custommer: document_id_custommer)
                            .then((value) {
                          if (value == true) {
                            Navigator.pop(context, true);
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDiaLogScreen(
                                  title: "Thông báo",
                                  message: "Thu hồi thành công",
                                );
                              },
                            ).then((value) {
                              Navigator.pop(context, true);
                            });
                          } else {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDiaLogScreen(
                                  title: "Thông báo",
                                  message: "Thu hồi thất bại",
                                );
                              },
                            );
                          }
                        });
                      },
                      child: (Text("Thu hồi")),
                    )
                  : FlatButton(
                      onPressed: () {
                        requestToBecomeAPartnerController
                            .onEditPartner(
                                document_id_custommer_send_request: widget
                                    .requestToBecomeAPartnerModel
                                    .document_id_custommer,
                                accepted: true,
                                document_id_request: widget
                                    .requestToBecomeAPartnerModel
                                    .document_id_request,
                                document_id_custommer: document_id_custommer)
                            .then((value) {
                          if (value == true) {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDiaLogScreen(
                                  title: "Thông báo",
                                  message: "Cấp lại thành công",
                                );
                              },
                            ).then((value) {
                              Navigator.pop(context, true);
                            });
                          } else {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDiaLogScreen(
                                  title: "Thông báo",
                                  message: "Cấp lại thất bại",
                                );
                              },
                            );
                          }
                        });
                      },
                      child: (Text("Cấp lại")),
                    ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text("Đóng"),
              ),
            ]
          : <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  mailReplyController.MailReply(
                      recipents_email: widget.customerProfileModel.email,
                      Type: true);
                  requestToBecomeAPartnerController.onAcceptRequest(
                      document_id_custommer_send_request: widget
                          .requestToBecomeAPartnerModel.document_id_custommer,
                      accepted: true,
                      document_id_request: widget
                          .requestToBecomeAPartnerModel.document_id_request,
                      document_id_custommer: document_id_custommer);
                },
                child: (Text("Đồng ý")),
              ),
              FlatButton(
                onPressed: () {
                  mailReplyController.MailReply(
                      recipents_email: widget.customerProfileModel.email,
                      Type: false);
                  requestToBecomeAPartnerController.onAcceptRequest(
                      accepted: false,
                      document_id_request: widget
                          .requestToBecomeAPartnerModel.document_id_request,
                      document_id_custommer: document_id_custommer);
                },
                child: (Text("Từ chối")),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text("Đóng"),
              ),
            ],
    );
  }
}
