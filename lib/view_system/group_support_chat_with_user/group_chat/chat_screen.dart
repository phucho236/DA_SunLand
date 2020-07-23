import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/api/api_url.dart';
import 'package:flutter_core/hash/hast_value.dart';
import 'package:flutter_core/helpers/constant.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/view_system/group_support_chat_with_user/support_chat_with_user_controller.dart';
import 'package:flutter_core/views/group_images_brain/images_brain.dart';
import 'package:flutter_core/views/group_images_brain/show_images_screen.dart';
import 'package:flutter_core/views/group_message/message_controller.dart';
import 'package:flutter_core/widgets/input_messenges_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatScreen extends StatefulWidget {
  static String id = "ChatScreen";
  ChatScreen({this.document_id_custommer_need_chat});
  final String document_id_custommer_need_chat;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  SupportChatWithUserController supportChatWithUserController =
      new SupportChatWithUserController();
  ChatScreen args;
  TextEditingController textEditingController = TextEditingController();
  MessagesController messagesController = MessagesController();
  Firestore _firestore =
      new Firestore(); // xử lí chổ snapshot nên phải tạo ở trên đây
  ImagesBrain imagesBrain = ImagesBrain();
  RefreshController _refreshController = RefreshController();
  ScrollController _scrollController = ScrollController();
  CustomerProfileModel DataCustommerNeedChat;
  String hashDocumentIdCustommerNeedChat;
  String document_id_custommer;
  String user_name;
  String email;
  String messenges;
  int limitLoadData = 10;
  getCurentUser(args) async {
    String documentIdCustommertmp = await getDocumentIdCustommer();
    if (documentIdCustommertmp != null) {
      document_id_custommer = documentIdCustommertmp;
    }
    hashDocumentIdCustommerNeedChat = generateSignature(
        dataIn: args.document_id_custommer_need_chat, signature: "SunLand");
    email = await getEmail();
    user_name = await getUserName();
    setState(() {});
  }

  getDataCustommerNeedChat(args) async {
    CustomerProfileModel DataCustommerNeedChatTmp =
        await supportChatWithUserController.onGetDataUserNeedChated(
            document_id_custommer: args.document_id_custommer_need_chat);
    if (DataCustommerNeedChatTmp != null) {
      setState(() {
        DataCustommerNeedChat = DataCustommerNeedChatTmp;
      });
    }
  }

  String lastIdDocumentPersonSendMess;
  bool sameIdDocumentPerson(String b) {
    bool _result = false;
    if (lastIdDocumentPersonSendMess == b) {
      _result = true;
    }

    return _result;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments;
      });
      getCurentUser(args);
      getDataCustommerNeedChat(args);
    });
  }

  @override
  // TODO: implement wantKeepAlive
  @override
  Widget build(BuildContext context) {
    return args == null
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)),
            ),
          )
        : Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
                backgroundColor: colorAppbar,
                titleSpacing: 0,
                title: DataCustommerNeedChat == null
                    ? Container()
                    : Row(
                        children: <Widget>[
                          Container(
                            child: DataCustommerNeedChat.linkImages == null
                                ? CircleAvatar(
                                    radius: 20,
                                    child: Container(
                                      margin: EdgeInsets.all(
                                          setWidthSize(size: 10)),
                                      child: Image.asset(
                                          "assets/images/library_image.png"),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                        DataCustommerNeedChat.linkImages),
                                  ),
                          ),
                          SizedBox(
                            width: setWidthSize(size: 5),
                          ),
                          Text(
                            DataCustommerNeedChat.user_name,
                            style: styleTextContentWhite,
                          ),
                        ],
                      )),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection(PathDatabase.Messenges)
                        .document(hashDocumentIdCustommerNeedChat)
                        .collection(hashDocumentIdCustommerNeedChat)
                        .orderBy('send_at', descending: true)
                        .limit(limitLoadData)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.orange)),
                        );
                      } else {
                        final list_message = snapshot.data.documents;
                        lastIdDocumentPersonSendMess =
                            list_message[0].data["document_id_customer"];
                        return SmartRefresher(
                          enablePullDown: false,
                          onLoading: () {
                            limitLoadData = limitLoadData + 10;

                            setState(() {});
                            _refreshController.loadComplete();
                          },
                          footer: CustomFooter(
                            loadStyle: LoadStyle.ShowAlways,
                            builder: (context, mode) {
                              if (mode == LoadStatus.loading) {
                                return Container(
                                  height: 60.0,
                                  child: Container(
                                    height: 20.0,
                                    width: 20.0,
                                    child: CupertinoActivityIndicator(),
                                  ),
                                );
                              } else
                                return Container();
                            },
                          ),
                          enablePullUp: true,
                          child: ListView.builder(
                            itemCount: list_message.length,
                            itemBuilder: (context, index) {
                              int indexTmp = index + 1;
                              if (indexTmp > list_message.length - 1) {
                                lastIdDocumentPersonSendMess = '';
                              } else {
                                lastIdDocumentPersonSendMess =
                                    list_message[indexTmp]
                                        .data["document_id_customer"];
                              }
                              return BuildMessBubble(
                                user_name:
                                    list_message[index].data["user_name"],
                                mess_text:
                                    list_message[index].data["messenges"],
                                itme: list_message[index]
                                        .data["document_id_customer"] ==
                                    document_id_custommer,
                                is_images:
                                    list_message[index].data["is_images"],
                                samePerson: sameIdDocumentPerson(
                                  list_message[index]
                                      .data["document_id_customer"],
                                ),
                                linkImagesCustommer: list_message[index]
                                    .data["linkImagesCustommer"],
                                send_at: list_message[index].data["send_at"],
                                remove_at: list_message[index]
                                    .data["remove_message_at"]
                                    .toString(),
                              );
                            },
                            controller: _scrollController,
                            reverse: true,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                          ),
                          controller: _refreshController,
                        );
                      }
                    },
                  ),
                ),

                // Input content
                InputMessengerWidget(
                  onPressedOpenCamera: () async {
                    File _imagesTMP;
                    _imagesTMP = await imagesBrain.getImageCameraNoCrop(
                        source_picker: ImageSource.camera);
                    messagesController.onSubmitPickImages(
                        user_name: user_name,
                        hashDocumentIdCustommer:
                            hashDocumentIdCustommerNeedChat,
                        document_id_custommer: document_id_custommer,
                        images: _imagesTMP);
                  },
                  onPressedOpenLibrary: () async {
                    File _imagesTMP;
                    _imagesTMP = await imagesBrain.getImageCameraNoCrop(
                        source_picker: ImageSource.gallery);
                    messagesController.onSubmitPickImages(
                        user_name: user_name,
                        hashDocumentIdCustommer:
                            hashDocumentIdCustommerNeedChat,
                        document_id_custommer: document_id_custommer,
                        images: _imagesTMP);
                  },
                  listScrollController: _scrollController,
                  textEditingController: textEditingController,
                  onChanged: (value) {
                    messenges = value;
                  },
                  onPressed: () async {
                    textEditingController.clear();
                    messagesController.onSubmitSendMessenger(
                        document_id_owner_group:
                            args.document_id_custommer_need_chat,
                        linkImagesCustommer: await getLinkImages(),
                        user_name: user_name,
                        messenges: messenges,
                        hashDocumentIdCustommer:
                            hashDocumentIdCustommerNeedChat,
                        document_id_custommer: document_id_custommer,
                        is_images: false,
                        email: email);
                    _scrollController.animateTo(0.0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                    setState(() {
                      messenges = null;
                    });
                  },
                )
              ],
            ),
          );
  }

  void showModalBottomSheetRemoveMess(
      {BuildContext context, String hashDocumentIdCustommer, String send_at}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(
                      Icons.delete,
                      // color: kColorBorDer,
                    ),
                    title: new Text('Xóa tin nhắn'),
                    onTap: () async {
                      Navigator.pop(context);
                      messagesController.onSubmitDelete(
                          hashDocumentIdCustommer: hashDocumentIdCustommer,
                          send_at: send_at);
                    }),
              ],
            ),
          );
        });
  }

  Widget BuildMessBubble(
      {String user_name,
      String mess_text,
      bool itme,
      bool is_images,
      SizeImages size_images,
      bool samePerson,
      String linkImagesCustommer,
      String send_at,
      String remove_at}) {
    return Padding(
      padding: EdgeInsets.only(
          left: setWidthSize(size: 10),
          right: setWidthSize(size: 10),
          top: setHeightSize(size: samePerson ? 0 : 15),
          bottom: setHeightSize(size: 5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        //mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment:
            itme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          itme == false
              ? samePerson == false
                  ? Stack(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            linkImagesCustommer != null
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(linkImagesCustommer),
                                    radius: 10.0,
                                  )
                                : CircleAvatar(
                                    backgroundImage: AssetImage(
                                        "assets/images/library_image.png"),
                                    radius: 10.0,
                                  ),
                            Text(
                              ' $user_name',
                              style: TextStyle(
                                height: 1,
                                color: Colors.black45,
                                fontWeight: FontWeight.normal,
                                fontSize: setFontSize(size: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container()
              : Container(),
          remove_at == 'null'
              ? is_images == false
                  ? GestureDetector(
                      onLongPress: itme
                          ? () {
                              showModalBottomSheetRemoveMess(
                                  context: context,
                                  hashDocumentIdCustommer:
                                      hashDocumentIdCustommerNeedChat,
                                  send_at: send_at);
                            }
                          : null,
                      child: Material(
                        borderRadius: BorderRadius.circular(30.0),
                        elevation: 2.0,
                        color: itme ? Colors.amberAccent : Colors.black12,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Text(
                            '$mess_text',
                            style: styleTextContentBlack,
                          ),
                        ),
                      ),
                    )
                  : Row(
                      children: <Widget>[
                        itme
                            ? Expanded(
                                child: Container(),
                              )
                            : Container(),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onLongPress: () {
                              showModalBottomSheetRemoveMess(
                                  context: context,
                                  hashDocumentIdCustommer:
                                      hashDocumentIdCustommerNeedChat,
                                  send_at: send_at);
                            },
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                ShowImagesScreen.id,
                                arguments: ShowImagesScreen(
                                  url: mess_text,
                                  sendBy: user_name,
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: mess_text,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                  child: Container(
                                    margin:
                                        EdgeInsets.all(setWidthSize(size: 10)),
                                    height: setWidthSize(size: 15),
                                    width: setWidthSize(size: 15),
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        itme == false
                            ? Expanded(
                                child: Container(),
                              )
                            : Container(),
                      ],
                    )
              : Material(
                  borderRadius: BorderRadius.circular(30.0),
                  elevation: 2.0,
                  color: Colors.black12,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text(
                      "Tin nhắn đã xóa\n${getDateShow(remove_at)}",
                      style: styleTextContentBlack,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
