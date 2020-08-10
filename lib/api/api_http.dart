import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/hash/hast_value.dart';
import 'api_url.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:http/http.dart' as http;

class HttpApi {
  String apiKeyHereMap = "ylfY2r09fnNGJJ8HBM1MO47vcC2DY8BTgeC57COp084";
  final firestoreInstance = Firestore.instance;
  _post({String path, Map<String, dynamic> data}) async {
    String _documentID;
    await firestoreInstance.collection(path).add(data).then((docRef) {
      _documentID = docRef.documentID;
    });
    return _documentID;
  }

  Future<dynamic> loginGG({String gg_id}) async {
    print("========== Đăng nhập GG==========");
    dynamic _result;
    await firestoreInstance
        .collection(PathDatabase.CustomerProfile)
        .where("gg_id", isEqualTo: gg_id)
        .getDocuments()
        .then((value) {
      if (value != null) {
        value.documents.forEach((result) {
          _result = result;
        });
      }
    });
    return _result;
  }

  Future<dynamic> GetDocumentIDDataCustomerSystem(
      {String document_id_custommer}) async {
    print("========== GetDocumentIDDataCustomerSystem==========");
    String _result;
    await firestoreInstance
        .collection(PathDatabase.DataCustommerSystem)
        .where("document_id_custommer", isEqualTo: document_id_custommer)
        .getDocuments()
        .then((value) {
      if (value != null) {
        value.documents.forEach((result) {
          _result = result.documentID;
        });
      }
    });
    return _result;
  }

  Future<dynamic> loginFB({String fb_id}) async {
    print("========== Đăng nhập FB==========");
    dynamic _result = null;
    await firestoreInstance
        .collection(PathDatabase.CustomerProfile)
        .where("fb_id", isEqualTo: fb_id)
        .getDocuments()
        .then((value) {
      if (value != null) {
        value.documents.forEach((result) {
          _result = result;
        });
      }
    });
    return _result;
  }

  Future<bool> changePassword(
      {String password, String email, String last_change_password}) async {
    print("========== Đổi mật khẩu ==========");
    bool _result = false;
    String documentID = null;
    Map<String, dynamic> data = Map<String, dynamic>();
    data["pass"] =
        generateSignature(dataIn: password, signature: "SunLandGroup");
    data["last_change_password"] = last_change_password;

    // tìm id user bằng email sau đó gửi id user để tìm feild Đăng nhập cập nhật mật khẩu
    await firestoreInstance
        .collection(PathDatabase.Authenticator)
        .where("email", isEqualTo: email)
        .getDocuments()
        .then((value) {
      value.documents.forEach((value) {
        //print(value.documentID);
        documentID = value.documentID;
        return documentID;
      });
    });
    if (documentID != null) {
      await firestoreInstance
          .collection(PathDatabase.Authenticator)
          .document(documentID)
          .updateData(data)
          .then((value) {
        _result = true;
      });
    }

    return _result;
  }

  Future<bool> CheckEmailExist({String email}) async {
    print("========== Kiểm tra email có tồn tại ? ==========");
    dynamic _result = null;
    await firestoreInstance
        .collection(PathDatabase.Authenticator)
        .where("email", isEqualTo: email)
        .getDocuments()
        .then((value) {
      if (value != null) {
        value.documents.forEach((result) {
          _result = result.data;
        });
      }
    });
    if (_result != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> GetDataCustommerOutTheSystem(
      {String document_id_custommer}) async {
    print("========== Lấy thông tin người dùng ngoài hệ thống ==========");
    dynamic _result = null;
    await firestoreInstance
        .collection(PathDatabase.CustommerProfileOutTheSystem)
        .document(document_id_custommer)
        .get()
        .then((value) {
      if (value != null) {
        _result = value.data;
      }
    });
    return _result;
  }

  Future<dynamic> GetDataCustommer({String document_id_custommer}) async {
    print("========== Lấy thông tin người dùng ==========");
    dynamic _result = null;
    await firestoreInstance
        .collection(PathDatabase.CustomerProfile)
        .document(document_id_custommer)
        .get()
        .then((value) {
      if (value != null) {
        _result = value.data;
      }
    });
    return _result;
  }

  Future<dynamic> CheckOTPExist({String otp}) async {
    print("========== Kiêm tra OTP ==========");
    dynamic _result = null;
    await firestoreInstance
        .collection(PathDatabase.OTP)
        .document(otp)
        .get()
        .then((value) {
      if (value != null) {
        _result = value.data;
      }
    });
    return _result;
  }

  Future<bool> RemoveGroupDecentralization({
    String document_id_decentralization,
    String document_id_custommer,
    bool removed,
  }) async {
    Map<String, dynamic> data = Map<String, dynamic>();

    data["removed"] = removed;
    data["last_edit_at"] = DateTime.now().toString();
    data["last_edit_by"] = document_id_custommer;
    data["list_permission"] = [];
    await firestoreInstance
        .collection(PathDatabase.GroupPermission)
        .document(document_id_decentralization)
        .updateData(data)
        .catchError((err) {
      return false;
    });
    return true;
  }

  Future<bool> RemoveUserInGroupDecentralization({
    String id_group_permission,
    String document_id_custommer,
  }) async {
    print("========thu hồi group quyền một số user");
    var val = [id_group_permission];
    Map<String, dynamic> data = Map<String, dynamic>();
    data["list_id_group_permission"] = FieldValue.arrayRemove(val);
    await firestoreInstance
        .collection(PathDatabase.DataCustommerSystem)
        .where("document_id_custommer", isEqualTo: document_id_custommer)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) async {
        print(element.documentID);
        await firestoreInstance
            .collection(PathDatabase.DataCustommerSystem)
            .document(element.documentID)
            .updateData(data)
            .catchError((err) {
          return false;
        });
        return true;
        ;
      });
    });
  }

  Future<bool> UpdateListPermissionInGroupDecentralization({
    String document_id_decentralization,
    List<String> list_permission,
    String document_id_custommer,
  }) async {
    Map<String, dynamic> data = Map<String, dynamic>();

    data["last_edit_at"] = DateTime.now().toString();
    data["last_edit_by"] = document_id_custommer;
    data["list_permission"] = list_permission;
    await firestoreInstance
        .collection(PathDatabase.GroupPermission)
        .document(document_id_decentralization)
        .updateData(data)
        .catchError((err) {
      return false;
    });
    return true;
  }

  Future<bool> CreateGroupDecentralization({
    String nameGroup,
    List<String> list_permission,
    String document_id_custommer,
  }) async {
    print("========== tạo group phân quyền==========");
    Map<String, dynamic> data = Map<String, dynamic>();
    //list quyền ban đầu
    data["post_at"] = DateTime.now().toString();
    data["post_by"] = document_id_custommer;
    data["removed"] = false;
    data["last_edit_at"] = null;
    data["last_edit_by"] = null;
    data["list_permission"] = list_permission;
    await firestoreInstance
        .collection(PathDatabase.GroupPermission)
        .document(nameGroup)
        .setData(data)
        .catchError((err) {
      return false;
    });
    return true;
  }

  Future<List<String>> GetListIdCustommerProfileInGroupPermission(
      {String document_id_permission}) async {
    print(
        "========== Lấy danh sách thông tin người dùng trong group quyền==========");
    List<String> list_document_id_custommer = [];
    await firestoreInstance
        .collection(PathDatabase.DataCustommerSystem)
        .where("list_id_group_permission",
            arrayContains: document_id_permission)
        .getDocuments()
        .then((value) {
      if (value != null) {
        value.documents.forEach((element) {
          list_document_id_custommer.add(element["document_id_custommer"]);
        });
      }
    });
    return list_document_id_custommer;
  }

  Future<bool> CheckExistGroupPermission({String document_id_custommer}) async {
    print("==========  CheckExistGroupPermission ==========");
    bool _result = false;
    await firestoreInstance
        .collection(PathDatabase.GroupPermission)
        .getDocuments()
        .then((value) async {
      print(value.documents.length);

      if (value.documents.length < 1) {
        //bằng null mới tạo mới
        // người đăng nhập vào hệ thống đầu tiên...
        Map<String, dynamic> data = Map<String, dynamic>();
        //list quyền ban đầu
        data["post_at"] = DateTime.now().toString();
        data["post_by"] = "system";
        data["removed"] = false;
        data["last_edit_at"] = null;
        data["last_edit_by"] = null;
        data["list_permission"] = ['all_permisstion'];
        await firestoreInstance
            .collection(PathDatabase.GroupPermission)
            .document("admin")
            .setData(data);

        Map<String, dynamic> data1 = Map<String, dynamic>();
        //list group quyền ban đầu
        data1["document_id_custommer"] = document_id_custommer;
        data1["list_id_group_permission"] = ['admin'];
        await firestoreInstance
            .collection(PathDatabase.DataCustommerSystem)
            .document()
            .setData(data1);
      }
    });
    return _result;
  }

  Future<bool> UpdateTypeCustommerProfile(
      {List<CustomerProfileModel> list_custommer_profile_model}) async {
    print("========== cập nhật type của người dùng thành 1 ==========");
    bool _result = false;
    Map<String, dynamic> data = Map<String, dynamic>();
    data["type"] = 1;

    for (var item in list_custommer_profile_model) {
      await firestoreInstance
          .collection(PathDatabase.CustomerProfile)
          .document(item.document_id_custommer)
          .updateData(data);
    }
    return true;
  }

  Future<bool> UpdateDataCustommerSystem(
      {List<CustomerProfileModel> list_custommer_profile_model,
      String id_group_permission}) async {
    print("========== cập nhật list id group quyền ==========");
    var val = [id_group_permission];
    for (var item in list_custommer_profile_model) {
      Map<String, dynamic> data = Map<String, dynamic>();
      data["list_id_group_permission"] = FieldValue.arrayUnion(val);

      await firestoreInstance
          .collection(PathDatabase.DataCustommerSystem)
          .where("document_id_custommer", isEqualTo: item.document_id_custommer)
          .getDocuments()
          .then((value) {
        if (value.documents.length > 0) {
          value.documents.forEach((element) {
            firestoreInstance
                .collection(PathDatabase.DataCustommerSystem)
                .document(element.documentID)
                .updateData(data);
          });
        } else {
          Map<String, dynamic> data1 = Map<String, dynamic>();
          data1["document_id_custommer"] = item.document_id_custommer;
          data1["list_id_group_permission"] = FieldValue.arrayUnion(val);
          _post(path: PathDatabase.DataCustommerSystem, data: data1);
        }
      });
    }
    return true;
  }

  Future<GroupDecentralizationModel> GetGroupDecentralization(
      {String document_id_group_decentralizatio}) async {
    print("==========  Lấy chi tiết group quyền ==========");
    GroupDecentralizationModel GroupDecentralization;
    await firestoreInstance
        .collection(PathDatabase.GroupPermission)
        .document(document_id_group_decentralizatio)
        .get()
        .then((value) async {
      if (value != null) {
        print(value.data);
        GroupDecentralization = GroupDecentralizationModel.fromJson(value.data);
        GroupDecentralization.document_id_group = value.documentID;
      }
    });
    return GroupDecentralization;
  }

  Future<List<GroupDecentralizationModel>>
      GetListDetailGroupDecentralization() async {
    print("==========  Lấy chi tiết list group quyền ==========");
    List<GroupDecentralizationModel> listNameGroupDecentralization = [];
    GroupDecentralizationModel groupDecentralizationModel =
        GroupDecentralizationModel();
    await firestoreInstance
        .collection(PathDatabase.GroupPermission)
        .getDocuments()
        .then((value) async {
      //lấy list quyền
      if (value != null) {
        value.documents.forEach((_value) {
          groupDecentralizationModel =
              GroupDecentralizationModel.fromJson(_value.data);
          groupDecentralizationModel.document_id_group = _value.documentID;
          listNameGroupDecentralization.add(groupDecentralizationModel);
        });
      }
    });
    return listNameGroupDecentralization;
  }

  Future<List<String>> GetListNameGroupDecentralization(
      {String document_id_custommer}) async {
    print("==========  Lấy list tên group quyền ==========");
    List<String> listNameGroupDecentralization = [];
    await firestoreInstance
        .collection(PathDatabase.GroupPermission)
        .where("document_id_custommer", isEqualTo: document_id_custommer)
        .getDocuments()
        .then((value) async {
      //lấy list quyền
      if (value != null) {
        value.documents.forEach((_value) {
          listNameGroupDecentralization.add(_value.documentID);
        });
      }
    });
    return listNameGroupDecentralization;
  }

  Future<List<String>> GetIDGroupPermissionInDataCustommerSystem(
      {String document_id_custommer}) async {
    print("==========  GetPermissionToDataCustommer ==========");
    List<String> listIDGroupPermission = [];
    List<String> listPermission = [];
    await firestoreInstance
        .collection(PathDatabase.DataCustommerSystem)
        .where("document_id_custommer", isEqualTo: document_id_custommer)
        .getDocuments()
        .then((value) async {
      //lấy list quyền
      if (value != null) {
        value.documents.forEach((_value) {
          //DataCustommerSystem dataCustommerSystem = DataCustommerSystem();
          _value.data['list_id_group_permission'].forEach((_value) {
            listIDGroupPermission.add(_value);
          });
        });
      }
    });
    if (listIDGroupPermission != null) {
      for (var item in listIDGroupPermission) {
        await firestoreInstance
            .collection(PathDatabase.GroupPermission)
            .document(item)
            .get()
            .then((value) {
          value.data["list_permission"].forEach((value) {
            if (listPermission.contains(value) == false) {
              listPermission.add(value);
            }
          });
        });
      }
    }
    return listPermission;
  }

  Future<dynamic> login({String email}) async {
    print("========== Đăng nhập ==========");
    dynamic _result = null;
    await firestoreInstance
        .collection(PathDatabase.Authenticator)
        .where("email", isEqualTo: email)
        .getDocuments()
        .then((value) {
      if (value != null) {
        value.documents.forEach((result) {
          _result = result.data;
        });
      }
    });
    return _result;
  }

  Future<String> Authenticator(
      {String document_id_custommer, String email, String pass}) async {
    print("========== Tạo tài khoản ==========");
    Map<String, dynamic> data = Map<String, dynamic>();
    data["document_id_custommer"] = document_id_custommer;
    data["email"] = email;
    data["pass"] = generateSignature(dataIn: pass, signature: "SunLandGroup");
    return await _post(path: PathDatabase.Authenticator, data: data);
  }

  Future<String> CreateOTP({String email}) async {
    print("========== Tạo OTP ==========");
    Map<String, dynamic> data = Map<String, dynamic>();
    data["email"] = email;
    data["time_create_otp"] = DateTime.now().toString();
    return await _post(path: PathDatabase.OTP, data: data);
  }

  Future<String> CustomerProfile({
    String first_name,
    String last_name,
    String email,
    String phone_number,
    String fb_id,
    String gg_id,
    String linkImages,
    String created_at,
    String deleted_at,
    String last_login,
    int total_days,
  }) async {
    print("========== Lưu Thông Tin Người Dung ==========");
    Map<String, dynamic> data = Map<String, dynamic>();
    data["first_name"] = first_name;
    data["last_name"] = last_name;
    data["user_name"] = "$last_name $first_name";
    data["chatting_with"] = null;
    data["email"] = email;
    data["phone_number"] = phone_number;
    data["type"] = 0;
    data["is_partner"] = false;
    data["status"] = true;
    data["fb_id"] = fb_id;
    data["gg_id"] = gg_id;
    data["is_partner"] = false;
    data["linkImages"] = linkImages;
    data["created_at"] = created_at;
    data["deleted_at"] = deleted_at;
    data["last_login"] = last_login;
    data["total_days"] = total_days;
    data["list_item_like"] = null;
    data["chatted"] = false;
    print('dataRequest $data');
    // chổ này thực hiện một câu select coi database có người dùng chưa nếu chưa có người dùng set type =1
    return await _post(path: PathDatabase.CustomerProfile, data: data);
  }

  removeMessage({
    String hashDocumentIdCustommer,
    String send_at,
  }) async {
    await firestoreInstance
        .collection(PathDatabase.Messenges)
        .document(hashDocumentIdCustommer)
        .collection(hashDocumentIdCustommer)
        .document(send_at)
        .updateData({"remove_message_at": DateTime.now().toString()});
  }

  updateTokenFirebaseMessaging({
    String documentIdCustommer,
    String token,
  }) async {
    await firestoreInstance
        .collection(PathDatabase.CustomerProfile)
        .document(documentIdCustommer)
        .updateData({'tokenFirebaseMessaging': token});
  }

  updateChated({
    String documentIdCustommer,
  }) async {
    await firestoreInstance
        .collection(PathDatabase.CustomerProfile)
        .document(documentIdCustommer)
        .updateData({'chated': true});
  }

  sendMessage({
    String messenges,
    String hashDocumentIdCustommer,
    String document_id_custommer,
    String document_id_owner_group,
    String user_name,
    bool is_images,
    SizeImages size_images,
    String linkImagesCustommer,
    String email,
    num type,
  }) async {
    String send_at = DateTime.now().millisecondsSinceEpoch.toString();
    var documentReference = firestoreInstance
        .collection('Messages')
        .document(hashDocumentIdCustommer)
        .collection(hashDocumentIdCustommer)
        .document(send_at);

    firestoreInstance.runTransaction((transaction) async {
      Map<String, dynamic> data = Map<String, dynamic>();
      data['document_id_customer'] = document_id_custommer;
      data['document_id_owner_group'] = document_id_owner_group;
      data['user_name'] = user_name;
      data['send_at'] = send_at;
      data['messenges'] = messenges;
      data['is_images'] = is_images;
      data['remove_message_at'] = 'null';
      data['type'] = type;
      data['linkImagesCustommer'] = linkImagesCustommer;
      data['email'] = email;
      if (is_images == true) {
        data['size_images'] = size_images.toJson();
      }
      if (linkImagesCustommer != null) {
        data['linkImagesCustommer'] = linkImagesCustommer;
      }
      await transaction.set(documentReference, data);
      await updateChated(documentIdCustommer: document_id_custommer);
    });
  }

  Future<String> uploadImages({File images, String PathDatabase}) async {
    String _linkImages;
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('${PathDatabase}/${Path.basename(images.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(images);
    await uploadTask.onComplete;
    print('File Uploaded');
    _linkImages = await storageReference.getDownloadURL();
    if (_linkImages != null) {
      return _linkImages;
    }
  }

  Future<String> CreatProduct({
    @required String nameApartment,
    @required num price,
    @required DistrictModel district,
    @required num acreageApartment,
    @required num amountBedroom,
    @required String urlImagesAvataProduct,
  }) async {
    print("========== tạo sản phẩm ==========");
    Map<String, dynamic> data = Map<String, dynamic>();

    data["name_apartment"] = nameApartment;
    data["price"] = price;
    data["district"] = district.name;
    data["acreage_apartment"] = acreageApartment;
    data["amount_bedroom"] = amountBedroom;
    data["url_images_avatar_product"] = urlImagesAvataProduct;
    data["seen"] = 0;
    data["like"] = 0;
    String id_document_product =
        await _post(path: PathDatabase.Product, data: data);
    if (id_document_product != null) {
      return id_document_product;
    }
  }

  Future<bool> CreatDetailProduct({
    @required String document_id_product,
    @required String document_id_custommer,
    @required RealEstateModel realEstate,
    @required TypeFloorModel typeFloor,
    @required TypeApartmentModel typeApartment,
    @required int amountBathrooms,
    @required List<String> listUrlImages,
    @required List<ItemsIcon> listItemInfrastructure,
    @required CostModel cost,
  }) async {
    print("========== tạo chi tiết sản phẩm ==========");
    Map<String, dynamic> data = Map<String, dynamic>();
    data["document_id_product"] = document_id_product;
    data["document_id_real_estate"] = realEstate.document_id_estate;
    data["type_floor"] = typeFloor.name;
    data["type_apartment"] = typeApartment.name;
    data["amount_bathrooms"] = amountBathrooms;
    data["list_images"] = listUrlImages;
    data["cost"] = cost.toJson();
    data["list_item_infrastructure"] =
        listItemInfrastructure.map((itemsIcon) => itemsIcon.toJson()).toList();
    data["post_by"] = document_id_custommer;
    data["post_at"] = DateTime.now().toString();
    data["last_edit"] = null;
    data["last_edit_by"] = null;
    data["censored"] = false;
    data["censored_by"] = null;
    data["remove_at"] = null;
    String id_document_product =
        await _post(path: PathDatabase.DetailProduct, data: data);
    if (id_document_product != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> CreatRealEstate({
    String document_id_custommer,
    String name_real_estate,
    CoordinatesModel coordinates,
  }) async {
    print("========== Tạo dự án bất động sản ==========");
    Map<String, dynamic> data = Map<String, dynamic>();

    data["name_real_estate"] = name_real_estate;
    data["coordinates"] = coordinates.toJson();
    data["post_by"] = document_id_custommer;
    data["post_at"] = DateTime.now().toString();
    data["last_edit"] = null;
    data["last_edit_by"] = null;
    String id_document = await _post(path: PathDatabase.RealRstate, data: data);
    if (id_document != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<RealEstateModel>> GetListRealEstate() async {
    print("==========  Get List dự án bất động sản ==========");
    List<RealEstateModel> listRealEstate = [];
    RealEstateModel realEstateModel = RealEstateModel();
    await firestoreInstance
        .collection(PathDatabase.RealRstate)
        .getDocuments()
        .then((value) async {
      //lấy list bất động sản
      if (value != null) {
        value.documents.forEach((_value) {
          realEstateModel = RealEstateModel.fromJson(_value.data);
          realEstateModel.document_id_estate = _value.documentID;
          listRealEstate.add(realEstateModel);
        });
      }
    });
    return listRealEstate;
  }

  Future<RealEstateModel> GetRealEstate(String document_id_real_estate) async {
    print("==========  Get Dự án bất động sản ==========");

    RealEstateModel realEstateModel = RealEstateModel();
    await firestoreInstance
        .collection(PathDatabase.RealRstate)
        .document(document_id_real_estate)
        .get()
        .then((value) async {
      //lấy list bất động sản
      if (value != null) {
        realEstateModel = RealEstateModel.fromJson(value.data);
        realEstateModel.document_id_estate = value.documentID;
      }
    });
    return realEstateModel;
  }

  Future<List<String>> GetListIDProduct({bool censored = false}) async {
    print("==========  Get list id sản phẩm ==========");
    List<String> listIDProduct = [];
    await firestoreInstance
        .collection(PathDatabase.DetailProduct)
        .where("censored", isEqualTo: censored)
        .getDocuments()
        .then((value) {
      if (value != null) {
        value.documents.forEach((_value) {
          listIDProduct.add(_value["document_id_product"]);
        });
      }
    });
    return listIDProduct;
  }

  Future<List<dynamic>> GetListItemLike({String document_id_custommer}) async {
    print("==========  Get list item like ==========");
    List<dynamic> listItemLikeModel = [];
    await firestoreInstance
        .collection(PathDatabase.CustomerProfile)
        .document(document_id_custommer)
        .get()
        .then(
      (value) {
        if (value.data["list_item_like"] != null) {
          listItemLikeModel = value.data["list_item_like"];
        }
      },
    );
    return listItemLikeModel;
  }

  Future<DetailProductModel> GetDetailProduct(
      {String document_id_product}) async {
    print("==========  Get chi tiết sản phẩm ==========");
    DetailProductModel detailProductModel = DetailProductModel();
    await firestoreInstance
        .collection(PathDatabase.DetailProduct)
        .where("document_id_product", isEqualTo: document_id_product)
        .getDocuments()
        .then((value) {
      if (value != null) {
        value.documents.forEach((_value) {
          print(_value.data);
          detailProductModel = DetailProductModel.fromJson(_value.data);
          detailProductModel.document_id_detail_product = _value.documentID;
          print(detailProductModel);
        });
      }
    });
    return detailProductModel;
  }

  Future<bool> BrowseProduct(
      {String document_id_product, String document_id_custommer}) async {
    print("========== Tìm sản phẩm ==========");
    bool _result = false;
    String document_id_detai_product;
    Map<String, dynamic> data = Map<String, dynamic>();
    data["censored"] = true;
    data["censored_by"] = document_id_custommer;

    await firestoreInstance
        .collection(PathDatabase.DetailProduct)
        .where("document_id_product", isEqualTo: document_id_product)
        .getDocuments()
        .then((value) {
      if (value != null) {
        value.documents.forEach((_value) {
          print(_value.documentID);
          document_id_detai_product = _value.documentID;
        });
      }
    });
    if (document_id_product != null) {
      await firestoreInstance
          .collection(PathDatabase.DetailProduct)
          .document(document_id_detai_product)
          .updateData(data)
          .then((value) {
        _result = true;
      });
    }
    return _result;
  }

  Future<List<ProductModel>> GetListProduct(
      {List<String> listDocumentIDProduct}) async {
    print("==========  Get list sản phẩm theo list id ==========");
    ProductModel productModel = ProductModel();
    List<ProductModel> _listIDProduct = [];
    for (var item in listDocumentIDProduct) {
      print(listDocumentIDProduct);
      await firestoreInstance
          .collection(PathDatabase.Product)
          .document(item)
          .get()
          .then(
        (value) {
          if (value != null) {
            print(value.data);
            productModel = ProductModel.fromJson(value.data);
            productModel.ducument_id_product = value.documentID;
            productModel.is_selected = false;
            _listIDProduct.add(productModel);
          }
        },
      );
    }
    return _listIDProduct;
  }

  Future<bool> AddLikeProductInCustommer(
      {String document_id_product, String document_id_custommer}) async {
    print("========== Thêm yêu thích==========");
    bool _result = false;
    List<String> val = [];
    val.add(document_id_product);
    Map<String, dynamic> data = Map<String, dynamic>();
    data["list_item_like"] = FieldValue.arrayUnion(val);
    await firestoreInstance
        .collection(PathDatabase.CustomerProfile)
        .document(document_id_custommer)
        .updateData(data)
        .then((value) {
      _result = true;
    });
    return _result;
  }

  Future<bool> UpdateSeenProduct({String document_id_product}) async {
    print("========== cập nhật lượt xem ==========");
    bool _result = false;
    num seen;

    await firestoreInstance
        .collection(PathDatabase.Product)
        .document(document_id_product)
        .get()
        .then((value) {
      if (value != null) {
        seen = value.data["seen"];
      }
    });

    if (seen != null) {
      seen = seen + 1;
      Map<String, dynamic> data = Map<String, dynamic>();
      data["seen"] = seen;
      await firestoreInstance
          .collection(PathDatabase.Product)
          .document(document_id_product)
          .updateData(data);
    }

    return _result;
  }

  Future<bool> UpdateLikeProduct({String document_id_product}) async {
    print("========== cập nhật lượt thích của sản phẩm ==========");
    bool _result = false;
    num like;
    await firestoreInstance
        .collection(PathDatabase.Product)
        .document(document_id_product)
        .get()
        .then((value) {
      if (value != null) {
        like = value.data["like"];
      }
    });
    if (like != null) {
      like = like + 1;
      Map<String, dynamic> data = Map<String, dynamic>();
      data["like"] = like;
      await firestoreInstance
          .collection(PathDatabase.Product)
          .document(document_id_product)
          .updateData(data);
    }

    return _result;
  }

  Future<bool> RemoveLikeProductInCustommer(
      {String document_id_product, String document_id_custommer}) async {
    print("========== xóa yêu thích==========");
    bool _result = false;
    var val = [];

    val.add(document_id_product);
    Map<String, dynamic> data = Map<String, dynamic>();
    //data["list_item_like"] = val;
    data["list_item_like"] = FieldValue.arrayRemove(val);

    await firestoreInstance
        .collection(PathDatabase.CustomerProfile)
        .document(document_id_custommer)
        .updateData(data)
        .then((value) {
      _result = true;
    });
    return _result;
  }

  Future<List<CustomerProfileModel>> GetListCustommerProfileChatted() async {
    print("==========  Get List Custommer Đã chat ==========");

    List<CustomerProfileModel> list_customer_profile_model = [];
    CustomerProfileModel customerProfileModel = CustomerProfileModel();
    await firestoreInstance
        .collection(PathDatabase.CustomerProfile)
        .where("chated", isEqualTo: true)
        .where("type", isEqualTo: 0)
        .getDocuments()
        .then((value) async {
      if (value != null) {
        value.documents.forEach((element) {
          customerProfileModel = CustomerProfileModel.fromJson(element.data);
          customerProfileModel.document_id_custommer = element.documentID;
          list_customer_profile_model.add(customerProfileModel);
        });
      }
    });
    if (list_customer_profile_model != null) {
      return list_customer_profile_model;
    }
  }

  Future<List<CustomerProfileModel>>
      GetListCustommerProfileOutTheSystem() async {
    print("==========  Get List Custommer ==========");

    List<CustomerProfileModel> list_customer_profile_model = [];
    CustomerProfileModel customerProfileModel = CustomerProfileModel();
    await firestoreInstance
        .collection(PathDatabase.CustommerProfileOutTheSystem)
        .getDocuments()
        .then((value) async {
      if (value != null) {
        value.documents.forEach((element) {
          customerProfileModel = CustomerProfileModel.fromJson(element.data);
          customerProfileModel.document_id_custommer = element.documentID;
          list_customer_profile_model.add(customerProfileModel);
        });
      }
    });
    if (list_customer_profile_model != null) {
      return list_customer_profile_model;
    }
  }

  Future<List<CustomerProfileModel>> GetListCustommerProfile({num type}) async {
    print("==========  Get List Custommer ==========");

    List<CustomerProfileModel> list_customer_profile_model = [];
    CustomerProfileModel customerProfileModel = CustomerProfileModel();
    await firestoreInstance
        .collection(PathDatabase.CustomerProfile)
        .where("status", isEqualTo: true)
        .where("type", isEqualTo: type)
        .getDocuments()
        .then((value) async {
      if (value != null) {
        value.documents.forEach((element) {
          customerProfileModel = CustomerProfileModel.fromJson(element.data);
          customerProfileModel.document_id_custommer = element.documentID;
          list_customer_profile_model.add(customerProfileModel);
        });
      }
    });
    if (list_customer_profile_model != null) {
      return list_customer_profile_model;
    }
  }

  Future<CustomerProfileModel> FindCustomerProfileOutTheSystemByEmail(
      {String email, num type}) async {
    print(
        "==========  tìm kiếm người dùng ngoài hệ thống theo email ==========");
    CustomerProfileModel customerProfileModel = null;
    await firestoreInstance
        .collection(PathDatabase.CustommerProfileOutTheSystem)
        .where("email", isEqualTo: email)
        .getDocuments()
        .then((value) async {
      if (value != null) {
        value.documents.forEach((element) {
          customerProfileModel = CustomerProfileModel.fromJson(element.data);
          customerProfileModel.document_id_custommer = element.documentID;
          print(customerProfileModel);
        });
      }
    });
    return customerProfileModel;
  }

  Future<CustomerProfileModel> FindCustomerProfileByEmail(
      {String email, num type}) async {
    print("==========  tìm kiếm người dùng theo email ==========");
    CustomerProfileModel customerProfileModel = null;
    await firestoreInstance
        .collection(PathDatabase.CustomerProfile)
        .where("email", isEqualTo: email)
        .where("type", isEqualTo: type)
        .getDocuments()
        .then((value) async {
      if (value != null) {
        value.documents.forEach((element) {
          customerProfileModel = CustomerProfileModel.fromJson(element.data);
          customerProfileModel.document_id_custommer = element.documentID;
          print(customerProfileModel);
        });
      }
    });
    return customerProfileModel;
  }

  Future<CustomerProfileModel> FindCustomerProfileByEmailChated(
      {String email}) async {
    print("==========  tìm kiếm người dùng theo email đã chat ==========");
    CustomerProfileModel customerProfileModel = null;
    await firestoreInstance
        .collection(PathDatabase.CustomerProfile)
        .where("email", isEqualTo: email)
        .where("type", isEqualTo: 0)
        .where("chated", isEqualTo: true)
        .getDocuments()
        .then((value) async {
      if (value != null) {
        value.documents.forEach((element) {
          customerProfileModel = CustomerProfileModel.fromJson(element.data);
          customerProfileModel.document_id_custommer = element.documentID;
          print(customerProfileModel);
        });
      }
    });
    return customerProfileModel;
  }

  Future<String> GetDocumetIdCustommerAdmin() async {
    print("==========  lấy thông tin admin ==========");
    String document_id_custommer;
    await firestoreInstance
        .collection(PathDatabase.DataCustommerSystem)
        .where("list_id_group_permission", isEqualTo: ["admin"])
        .getDocuments()
        .then((value) async {
          if (value != null) {
            value.documents.forEach((element) {
              document_id_custommer = element.data["document_id_custommer"];
            });
          }
        });
    return document_id_custommer;
  }

  Future<bool> PostProductNeedSuport({
    String document_id_custommer_need_contact,
    List<String> list_document_id_product,
  }) async {
    String _result;
    print("========== gửi list các sản phẩm cần hỗ trợ==========");
    Map<String, dynamic> data = Map<String, dynamic>();
    data["document_id_custommer_need_contact"] =
        document_id_custommer_need_contact;
    data["list_document_id_product"] = list_document_id_product;
    data["post_at"] = DateTime.now().toString();
    data["contacted_at"] = null;
    data["contacted"] = false;
    data["contacted_by"] = null;
    data["taked_by"] = null;
    data["taked"] = false;
    data["taked_at"] = null;
    data["note"] = null;
    data["edit_by"] = null;
    data["last_edit"] = null;
    _result = await _post(path: PathDatabase.ProductNeedSuport, data: data);
    if (_result != null) {
      return true;
    }
    return false;
  }

  Future<List<ProductModel>> GetListProductSentRequested(
      {String document_id_custommer}) async {
    print("==========  Get sản phẩm đã gửi yêu cầu ==========");

    List<String> list_document_id_product = [];
    List<ProductModel> list__product_model = [];
    await firestoreInstance
        .collection(PathDatabase.ProductNeedSuport)
        .where("document_id_custommer_need_contact",
            isEqualTo: document_id_custommer)
        .getDocuments()
        .then((value) async {
      if (value != null) {
        value.documents.forEach((element) {
          for (var item in element.data["list_document_id_product"]) {
            list_document_id_product.add(item);
          }
        });
      }
    });
    if (list_document_id_product != null) {
      list__product_model =
          await GetListProduct(listDocumentIDProduct: list_document_id_product);
    }
    return list__product_model;
  }

  Future<List<ProductNeedSuportModel>> GetListProductNeedSuportModel(
      {bool taked, bool contacted, String contact_by}) async {
    print("==========  Get đối tượng sản phẩm đã gửi yêu cầu ==========");

    List<ProductNeedSuportModel> list_product_need_suport_model = [];
    ProductNeedSuportModel productNeedSuportModel;
    await firestoreInstance
        .collection(PathDatabase.ProductNeedSuport)
        .where("taked", isEqualTo: taked)
        .where("contacted", isEqualTo: contacted)
        .where("taked_by", isEqualTo: contact_by)
        .getDocuments()
        .then((value) {
      if (value.documents.length > 0) {
        value.documents.forEach((element) {
          productNeedSuportModel =
              ProductNeedSuportModel.fromJson(element.data);
          productNeedSuportModel.document_id_product_need_support =
              element.documentID;
          list_product_need_suport_model.add(productNeedSuportModel);
        });
      }
    });
    return list_product_need_suport_model;
  }

  Future<bool> UpdateProductNeedSuport(
      {String document_id_product_need_sp,
      String document_id_custommer_contact,
      String document_id_custommer_taked,
      bool contacted,
      bool taked,
      String last_edit,
      String edit_by}) async {
    print("========== cập nhật sản phẩm cần hỗ trợ ==========");

    Map<String, dynamic> data = Map<String, dynamic>();
    if (document_id_custommer_contact != null) {
      data["contacted_by"] = document_id_custommer_contact;
    }
    if (document_id_custommer_taked != null) {
      data["taked_by"] = document_id_custommer_taked;
    }
    if (taked == true) {
      data["taked"] = taked;
      data["taked_at"] = DateTime.now().toString();
    }

    if (contacted == true) {
      data["contacted"] = contacted;
      data["contacted_at"] = DateTime.now().toString();
    }
    if (edit_by != null) {
      data["edit_by"] = edit_by;
      data["last_edit"] = DateTime.now().toString();
    }

    await firestoreInstance
        .collection(PathDatabase.ProductNeedSuport)
        .document(document_id_product_need_sp)
        .updateData(data)
        .catchError((err) {
      return false;
    });
    return true;
  }

  Future<bool> PostNoteProductNeedSuport(
      {String note,
      String document_id_product_need_sp,
      String document_id_custommer}) async {
    print("========== đăng chú thích sản phẩm cần hỗ trợ ==========");

    List<NotedModel> listNotedModel = [];
    NotedModel notedModel = NotedModel();
    notedModel.content = note;
    notedModel.post_at = DateTime.now().toString();
    notedModel.note_by = document_id_custommer;
    listNotedModel.add(notedModel);
    Map<String, dynamic> data = Map<String, dynamic>();
    data["note"] = FieldValue.arrayUnion(
        listNotedModel.map((itemsIcon) => itemsIcon.toJson()).toList());

    await firestoreInstance
        .collection(PathDatabase.ProductNeedSuport)
        .document(document_id_product_need_sp)
        .updateData(data)
        .catchError((err) {
      return false;
    });
    return true;
  }

  Future<bool> CheckTakedProductNeedSuport(
      {String document_id_product_need_support}) async {
    print("==========  Kiểm tra hỗ trợ đã đc nhận hay chưa ? ==========");
    ProductNeedSuportModel productModel;
    await firestoreInstance
        .collection(PathDatabase.ProductNeedSuport)
        .document(document_id_product_need_support)
        .get()
        .then((value) async {
      print(value.data);

      if (value != null) {
        productModel = ProductNeedSuportModel.fromJson(value.data);
      }
    });
    if (productModel != null) {
      return productModel.taked;
    } else {
      return false;
    }
  }

  Future<List<NotedModel>> GetListNotedProductNeedSuport(
      {String document_id_product_need_support}) async {
    print("==========  Get list Chú thích sản phẩm đã gửi yêu cầu ==========");

    List<NotedModel> list_noted_model = [];
    NotedModel notedModel = NotedModel();
    await firestoreInstance
        .collection(PathDatabase.ProductNeedSuport)
        .document(document_id_product_need_support)
        .get()
        .then((value) async {
      print(value.data);
      if (value.data["note"] != null) {
        for (int i = value.data["note"].length - 1; i >= 0; i--) {
          notedModel = NotedModel.fromJson(value.data["note"][i]);
          list_noted_model.add(notedModel);
        }
      }
    });
    return list_noted_model;
  }

// không sử dụng được, chỉ tìm kiếm theo bảng chử cái giới hạn từ x đến z có phân biệt hoa thường và có dấu :)
  Future<ProductModel> GetProductFindByName({String name_apartment}) async {
    print("==========  Get sản phẩm theo tên ==========");
    ProductModel productModel;
    await firestoreInstance
        .collection(PathDatabase.Product)
        .where('name_apartment', isEqualTo: name_apartment)
        .getDocuments()
        .then(
      (value) {
        print(value.documents);
        print(value.documents);
        if (value.documents != null) {
          value.documents.forEach((element) {
            productModel = ProductModel.fromJson(element.data);
            productModel.ducument_id_product = element.documentID;
            productModel.is_selected = false;
          });
        }
      },
    );
    return productModel;
  }

  Future<ProductModel> GetProductFindByID({String document_id_product}) async {
    print("==========  Get sản phẩm theo 1 id ==========");
    ProductModel productModel;

    await firestoreInstance
        .collection(PathDatabase.Product)
        .document(document_id_product)
        .get()
        .then(
      (value) {
        if (value.data != null) {
          productModel = ProductModel.fromJson(value.data);
          productModel.ducument_id_product = value.documentID;
          productModel.is_selected = false;
        }
      },
    );
    return productModel;
  }

  Future<List<ProductModel>> GetListAllProduct() async {
    print("==========  Get list tất cã sản phẩm ==========");
    ProductModel productModel = ProductModel();
    List<ProductModel> _listIDProduct = [];
    await firestoreInstance
        .collection(PathDatabase.Product)
        .getDocuments()
        .then(
      (value) {
        value.documents.forEach((element) {
          productModel = ProductModel.fromJson(element.data);
          productModel.ducument_id_product = element.documentID;
          _listIDProduct.add(productModel);
        });
      },
    );

    return _listIDProduct;
  }

  Future<bool> UpdateProduct({
    String document_id_product,
    num acreage_apartment,
    num amount_bedroom,
    String district,
    String name_apartment,
    num price,
    String url_images_avatar_product,
  }) async {
    print("========== cập nhật sản phẩm ==========");
    bool _result = false;
    Map<String, dynamic> data = Map<String, dynamic>();
    if (acreage_apartment != null) {
      data["acreage_apartment"] = acreage_apartment;
    }
    if (amount_bedroom != null) {
      data["amount_bedroom"] = amount_bedroom;
    }
    if (district != null) {
      data["district"] = district;
    }
    if (name_apartment != null) {
      data["name_apartment"] = name_apartment;
    }
    if (price != null) {
      data["price"] = price;
    }
    if (url_images_avatar_product != null) {
      data["url_images_avatar_product"] = url_images_avatar_product;
    }
    print(data);

    await firestoreInstance
        .collection(PathDatabase.Product)
        .document(document_id_product)
        .updateData(data)
        .then((value) {
      _result = true;
    }).catchError((err) {
      _result = false;
    });
    return _result;
  }

  Future<bool> UpdateDetailProduct({
    String document_id_detail_product,
    num amount_bathrooms,
    bool censored,
    CostModel cost,
    String document_id_real_estate,

    //last_edit
    String last_edit_by,
    List<String> list_images,
    List<ItemsIcon> list_item_infrastructure,
    String type_apartment,
    String type_floor,
  }) async {
    print("========== Cập nhật chi tiết sản phẩm ==========");

    Map<String, dynamic> data = Map<String, dynamic>();
    if (amount_bathrooms != null) {
      data["amount_bathrooms"] = amount_bathrooms;
    }
    data["censored"] = false;
    if (cost != null) {
      if (cost.management_cost != null) {
        data["cost.management_cost"] = cost.management_cost;
      }
      if (cost.motorbike_parking_cost != null) {
        data["cost.motorbike_parking_cost"] = cost.motorbike_parking_cost;
      }
      if (cost.car_parking_cost != null) {
        data["cost.car_parking_cost"] = cost.car_parking_cost;
      }
      if (cost.gym_cost != null) {
        data["cost.gym_cost"] = cost.gym_cost;
      }
      if (cost.swimming_pool_cost != null) {
        data["cost.swimming_pool_cost"] = cost.swimming_pool_cost;
      }
    }
    if (document_id_real_estate != null) {
      data["document_id_real_estate"] = document_id_real_estate;
    }

    data["last_edit"] = DateTime.now().toString();

    data["last_edit_by"] = last_edit_by;
    if (list_images != null) {
      data["list_images"] = list_images;
    }
    if (list_item_infrastructure != null) {
      data["list_item_infrastructure"] = list_item_infrastructure
          .map((itemsIcon) => itemsIcon.toJson())
          .toList();
    }
    if (type_apartment != null) {
      data["type_apartment"] = type_apartment;
    }
    if (type_floor != null) {
      data["type_floor"] = type_floor;
    }
    print(data);
    await firestoreInstance
        .collection(PathDatabase.DetailProduct)
        .document(document_id_detail_product)
        .updateData(data)
        .catchError((err) {
      return false;
    });
    return true;
  }

  Future<List<String>> FilterFindProduct({
    String district,
    num star_price,
    num end_price,
    String document_id_real_estate,
    String type_apartment,
    String type_floor,
    num start_acreage_apartment,
    num end_acreage_apartment,
  }) async {
    print("========== lấy id sản phẩm theo tên dự án, giá tiền==========");
    List<String> list_document_id_product1 = [];
    List<String> list_document_id_product2 = [];
    await firestoreInstance
        .collection(PathDatabase.DetailProduct)
        .where('document_id_real_estate', isEqualTo: document_id_real_estate)
        .where('type_apartment', isEqualTo: type_apartment)
        .where('type_floor', isEqualTo: type_floor)
        .getDocuments()
        .then(
      (value) {
        if (value.documents != null) {
          value.documents.forEach((element) {
            print(element.data['document_id_product']);
            list_document_id_product1.add(element.data['document_id_product']);
          });
        }
      },
    );
    if (list_document_id_product1 != null) {
      for (var item in list_document_id_product1) {
        await firestoreInstance
            .collection(PathDatabase.Product)
            .document(item)
            .get()
            .then(
          (value) {
            print(value.data);
            if (district != null
                ? value.data["district"] == district
                : value.data["district"] != district &&
                    value.data["acreage_apartment"] > start_acreage_apartment &&
                    value.data["acreage_apartment"] < end_acreage_apartment &&
                    value.data["price"] > star_price &&
                    value.data["price"] < end_price) {
              list_document_id_product2.add(value.documentID);
            }
          },
        );
      }
    }
    return list_document_id_product2;
  }

  Future<String> CreateRequestToBecomeAPartner(
      {String document_id_custommer, String content}) async {
    print("========== yêu cầu thành đối tác ==========");
    Map<String, dynamic> data = Map<String, dynamic>();
    data["accepted"] = false;
    data["document_id_custommer"] = document_id_custommer;
    data["content"] = content;
    data["edit_by"] = null;
    data["censored"] = false;
    data["censored_at"] = null;
    data["censored_by"] = null;
    data["send_at"] = DateTime.now().toString();
    return await _post(path: PathDatabase.RequestToBecomeAPartner, data: data);
  }

  Future<List<RequestToBecomeAPartnerModel>> GetListRequestToBecomeAPartner(
      {String document_id_custommer, bool censored}) async {
    print(
        "========== List người dùng gửi yêu cầu trở thành đối tác ==========");
    List<RequestToBecomeAPartnerModel> listRequestToBecomeAPartnerModel = [];
    RequestToBecomeAPartnerModel requestToBecomeAPartnerModel =
        RequestToBecomeAPartnerModel();
    await firestoreInstance
        .collection(PathDatabase.RequestToBecomeAPartner)
        .where("document_id_custommer", isEqualTo: document_id_custommer)
        .where("censored", isEqualTo: censored)
        .getDocuments()
        .then((value) {
      if (value != null) {
        value.documents.forEach((element) {
          requestToBecomeAPartnerModel =
              RequestToBecomeAPartnerModel.fromJson(element.data);
          requestToBecomeAPartnerModel.document_id_request = element.documentID;
          listRequestToBecomeAPartnerModel.add(requestToBecomeAPartnerModel);
        });
      }
    });
    if (listRequestToBecomeAPartnerModel.length > 0) {
      return listRequestToBecomeAPartnerModel;
    } else {
      return [];
    }
  }

  Future<bool> AcceptRequest(
      {String document_id_custommer_send_request,
      String document_id_custommer,
      String document_id_request,
      bool accepted}) async {
    bool _result = true;
    Map<String, dynamic> data = Map<String, dynamic>();
    data["accepted"] = accepted;
    data["censored"] = true;
    data["censored_at"] = DateTime.now().toString();
    data["censored_by"] = document_id_custommer;
    await firestoreInstance
        .collection(PathDatabase.RequestToBecomeAPartner)
        .document(document_id_request)
        .updateData(data)
        .catchError((err) {
      _result = false;
    });
    if (accepted == true) {
      Map<String, dynamic> data1 = Map<String, dynamic>();
      data["is_partner"] = true;
      await firestoreInstance
          .collection(PathDatabase.CustomerProfile)
          .document(document_id_custommer_send_request)
          .updateData(data1)
          .catchError((err) {
        _result = false;
      });
    }
    return _result;
  }

  Future<bool> EditPartner(
      {String document_id_custommer_send_request,
      String document_id_custommer,
      String document_id_request,
      bool accepted}) async {
    bool _result = true;
    Map<String, dynamic> data = Map<String, dynamic>();
    data["accepted"] = accepted;
    data["last_edit"] = DateTime.now().toString();
    data["edit_by"] = document_id_custommer;
    print("========= sửa yêu cầu thành đối tác ==============");
    await firestoreInstance
        .collection(PathDatabase.RequestToBecomeAPartner)
        .document(document_id_request)
        .updateData(data)
        .catchError((err) {
      _result = false;
    });
    print(
        "==================cập nhật thông tin custommer profile===============");
    Map<String, dynamic> data1 = Map<String, dynamic>();
    data1["is_partner"] = accepted;
    await firestoreInstance
        .collection(PathDatabase.CustomerProfile)
        .document(document_id_custommer_send_request)
        .updateData(data1)
        .catchError((err) {
      _result = false;
    });
    return _result;
  }

  Future<List<DetailProductModel>> GetListDetailProductPostByUser(
      {String document_id_custommer}) async {
    print("==========  Get list chi tiết sản phẩm đăng bởi user ==========");
    // ProductModel productModel = ProductModel();
    DetailProductModel detailProductModel = DetailProductModel();
    List<DetailProductModel> _listDetaildProduct = [];
    await firestoreInstance
        .collection(PathDatabase.DetailProduct)
        .where("post_by", isEqualTo: document_id_custommer)
        .getDocuments()
        .then(
      (value) {
        value.documents.forEach((element) {
          detailProductModel = DetailProductModel.fromJson(element.data);
          detailProductModel.document_id_detail_product = element.documentID;
          _listDetaildProduct.add(detailProductModel);
          print(detailProductModel);
          detailProductModel = null;
        });
      },
    );
    return _listDetaildProduct;
  }

  Future<bool> PostNotifySystemUsers(
      {String document_id_custommer, String content, String title}) async {
    print("========== Thêm thông báo cho user hệ thống ==========");
    Map<String, dynamic> data = Map<String, dynamic>();
    data["times_stamp"] = DateTime.now().millisecondsSinceEpoch.toString();
    data["title"] = title;
    data["post_by"] = document_id_custommer;
    data["content"] = content;
    data["post_at"] = DateTime.now().toString();
    data["remove_at"] = null;
    data["remove_by"] = null;
    data["removed"] = false;
    await _post(path: PathDatabase.NotifySystemUsers, data: data)
        .catchError((err) {
      return false;
    });
    return true;
  }

  Future<List<NotifySystemUsersModel>> getListNotifySystemUsers(
      {bool removed}) async {
    print("========== lấy danh sách thông báo ==========");
    List<NotifySystemUsersModel> listNotifySystemUsersModel = [];
    NotifySystemUsersModel notifySystemUsersModel = NotifySystemUsersModel();
    await firestoreInstance
        .collection(PathDatabase.NotifySystemUsers)
        .where("removed", isEqualTo: removed)
        .orderBy("times_stamp", descending: true)
        .getDocuments()
        .then((value) {
      if (value != null) {
        value.documents.forEach((element) {
          notifySystemUsersModel =
              NotifySystemUsersModel.fromJson(element.data);
          notifySystemUsersModel.document_id_notify_system_users =
              element.documentID;
          listNotifySystemUsersModel.add(notifySystemUsersModel);
          notifySystemUsersModel = null;
        });
      }
    });
    return listNotifySystemUsersModel;
  }

  Future<bool> RemoveNotifySystemUsers(
      {String document_id_notify_system_users,
      String document_id_custommer}) async {
    print("========== loại bõ thông báo user hệ thống ==========");
    Map<String, dynamic> data = Map<String, dynamic>();
    data["removed"] = true;
    data["remove_at"] = DateTime.now().toString();
    data["remove_by"] = document_id_custommer;
    await firestoreInstance
        .collection(PathDatabase.NotifySystemUsers)
        .document(document_id_notify_system_users)
        .updateData(data)
        .catchError((err) {
      return false;
    });
    return true;
  }

  Future<bool> PostNotifyProductAds(
      {String document_id_custommer,
      String content,
      String title,
      List<String> list_document_id_product}) async {
    print("========== Thêm gợi ý sản phẩm cho người dùng ==========");
    Map<String, dynamic> data = Map<String, dynamic>();
    data["title"] = title;
    data["post_by"] = document_id_custommer;
    data["content"] = content;
    data["list_document_id_product"] = list_document_id_product;
    data["post_at"] = DateTime.now().toString();
    data["remove_at"] = null;
    data["remove_by"] = null;
    data["removed"] = false;
    await _post(path: PathDatabase.NotifyProductAds, data: data)
        .catchError((err) {
      return false;
    });
    return true;
  }

  Future<bool> RemoveNotifyProductAds(
      {String document_id_notify_product_ads,
      String document_id_custommer}) async {
    print("========== Thêm gợi ý sản phẩm cho người dùng ==========");
    Map<String, dynamic> data = Map<String, dynamic>();
    data["remove_at"] = DateTime.now().toString();
    data["remove_by"] = document_id_custommer;
    data["removed"] = true;
    firestoreInstance
        .collection(PathDatabase.NotifyProductAds)
        .document(document_id_notify_product_ads)
        .updateData(data)
        .catchError((err) {
      return false;
    });
    return true;
  }

  Future<List<NotifiProductAdsModel>> getListNotifyProductAds(
      {bool removed}) async {
    print("========== lấy danh sách gợi ý sản phẩm ==========");
    List<NotifiProductAdsModel> listNotifiProductAdsModel = [];
    NotifiProductAdsModel notifiProductAdsModel = NotifiProductAdsModel();
    await firestoreInstance
        .collection(PathDatabase.NotifyProductAds)
        .where("removed", isEqualTo: removed)
        .getDocuments()
        .then((value) {
      if (value != null) {
        value.documents.forEach((element) {
          notifiProductAdsModel = NotifiProductAdsModel.fromJson(element.data);
          notifiProductAdsModel.document_id_notify_product_ads =
              element.documentID;
          listNotifiProductAdsModel.add(notifiProductAdsModel);
          notifiProductAdsModel = null;
        });
      }
    });
    return listNotifiProductAdsModel;
  }

  Future<List<SuggestionsModel>> RequestingAutocompleteSuggestions(
      {String data}) async {
    String api =
        "https://autocomplete.geocoder.ls.hereapi.com/6.2/suggest.json?apiKey=${apiKeyHereMap}&query=${data}&country=VNM&beginHighlight=<b>&endHighlight=</b>";
    try {
      if (data != null) {
        List<SuggestionsModel> listSuggestionsModel = [];
        http.Response response = await http.get(api);
        var x = jsonDecode(response.body);
        print(x);
        List<dynamic> y = x["suggestions"];
        for (var item in y) {
          print(item);
          listSuggestionsModel.add(SuggestionsModel.fromJson(item));
        }

        listSuggestionsModel.removeWhere((element) {
          if (element.matchLevel == "city" ||
              element.matchLevel == "county" ||
              element.matchLevel == "country") {
            return true;
          } else {
            return false;
          }
        });

        return listSuggestionsModel;
      }
    } catch (e) {
      print("Lỗi Server: $e");
      return [];
    }
  }

  Future<AddressModelHereMapReturn> GetGeocodeHereMap(
      {String housenumber = '',
      String street = '',
      String district = '',
      String county = '',
      String city = ''}) async {
    AddressModelHereMapReturn addressModelHereMapReturn =
        AddressModelHereMapReturn();
    String api =
        "https://geocoder.ls.hereapi.com/6.2/geocode.json?apiKey=${apiKeyHereMap}&housenumber=${housenumber}&street=${street}&district=${district}&city=${city}&county=${county}&country=Việt Nam";
    print(api);
    try {
      http.Response response = await http.get(api);
      var x = jsonDecode(response.body);
      var y = x["Response"]["View"][0];
      var z = y["Result"][0];

      addressModelHereMapReturn.displayPositionModel =
          DisplayPositionModel.fromJson(z["Location"]["DisplayPosition"]);
      addressModelHereMapReturn.addressModel =
          AddressModel.fromJson(z["Location"]["Address"]);

      return addressModelHereMapReturn;
    } catch (e) {
      print("Lỗi Server: $e");
      return null;
    }
  }

  Future<AddressModelHereMapReturn> GetDataInLocationHereMap({
    String lat,
    String long,
  }) async {
    AddressModelHereMapReturn addressModelHereMapReturn =
        AddressModelHereMapReturn();
    String api =
        "https://reverse.geocoder.ls.hereapi.com/6.2/reversegeocode.json?apiKey=${apiKeyHereMap}&mode=retrieveAddresses&prox=$lat,$long";
    try {
      http.Response response = await http.get(api);
      print(response.body);
      var x = jsonDecode(response.body);
      var y = x["Response"]["View"][0];
      var z = y["Result"][0];

      addressModelHereMapReturn.displayPositionModel =
          DisplayPositionModel.fromJson(z["Location"]["DisplayPosition"]);
      addressModelHereMapReturn.addressModel =
          AddressModel.fromJson(z["Location"]["Address"]);

      return addressModelHereMapReturn;
    } catch (e) {
      print("Lỗi Server: $e");
      return null;
    }
  }

  Future<dynamic> CreateGroupAttendance(
      {TimeModel time_start,
      TimeModel time_end,
      String name_group,
      CoordinatesDoubleModel coordinatesDoubleModel,
      String document_id_custommer}) async {
    print("========== tạo group điểm danh ==========");
    Map<String, dynamic> data = Map<String, dynamic>();
    data["time_start"] = time_start.toJson();
    data["time_end"] = time_end.toJson();
    data["name_group"] = name_group;
    data["coordinatesDoubleModel"] = coordinatesDoubleModel.toJson();
    data["post_by"] = document_id_custommer;
    data["post_at"] = DateTime.now().toString();
    data["last_edit_by"] = null;
    data["last_edit_at"] = null;
    data["removed"] = false;
    return await _post(path: PathDatabase.GroupAttendance, data: data);
  }

  Future<List<GroupAttendanceModel>> getListGroupAttendance() async {
    List<GroupAttendanceModel> listGroupAttendance = [];
    GroupAttendanceModel groupAttendanceModel = GroupAttendanceModel();
    await firestoreInstance
        .collection(PathDatabase.GroupAttendance)
        .getDocuments()
        .then((value) {
      if (value != null) {
        value.documents.forEach((element) {
          groupAttendanceModel = GroupAttendanceModel.fromJson(element.data);
          groupAttendanceModel.document_id_group_attendance =
              element.documentID;
          listGroupAttendance.add(groupAttendanceModel);
        });
      }
    });
    return listGroupAttendance;
  }

  Future<List<dynamic>> getListDocumentIdCustomerInGroupAttendance(
      {String documemt_id_group_attendance}) async {
    List<dynamic> listDocumentIdCustomerInGroupAttendance = [];
    print(documemt_id_group_attendance);
    await firestoreInstance
        .collection(PathDatabase.UserInGroupAttendance)
        .where("documemt_id_group_attendance",
            isEqualTo: documemt_id_group_attendance)
        .getDocuments()
        .then((value) {
      if (value != null) {
        value.documents.forEach((element) {
          print(element);
          listDocumentIdCustomerInGroupAttendance
              .addAll(element.data["list_document_id_custommer"]);
        });
      }
    });
    return listDocumentIdCustomerInGroupAttendance;
  }

  Future<List<GroupAttendanceModel>> getListModelAttendanceOfTheUser(
      {String document_id_custommer}) async {
    GroupAttendanceModel groupAttendanceModel = GroupAttendanceModel();
    List<dynamic> listDocumentIdAttendanceOfTheUser = [];
    List<GroupAttendanceModel> listModelAttendanceOfTheUser = [];
    listDocumentIdAttendanceOfTheUser =
        await getListDocumentIdAttendanceOfTheUser(
            document_id_custommer: document_id_custommer);
    print(listDocumentIdAttendanceOfTheUser);
    if (listDocumentIdAttendanceOfTheUser.length > 0) {
      for (var item in listDocumentIdAttendanceOfTheUser) {
        await firestoreInstance
            .collection(PathDatabase.GroupAttendance)
            .document(item)
            .get()
            .then((value) {
          if (value != null) {
            groupAttendanceModel = GroupAttendanceModel.fromJson(value.data);
            groupAttendanceModel.document_id_group_attendance =
                value.documentID;
            listModelAttendanceOfTheUser.add(groupAttendanceModel);
          }
        });
      }
    }

    return listModelAttendanceOfTheUser;
  }

  Future<List<dynamic>> getListDocumentIdAttendanceOfTheUser(
      {String document_id_custommer}) async {
    List<dynamic> listDocumentIdAttendanceOfTheUser = [];
    await firestoreInstance
        .collection(PathDatabase.UserInGroupAttendance)
        .where("list_document_id_custommer",
            arrayContains: document_id_custommer)
        .getDocuments()
        .then((value) {
      if (value != null) {
        value.documents.forEach((element) {
          print(element);
          listDocumentIdAttendanceOfTheUser
              .add(element.data["documemt_id_group_attendance"]);
        });
      }
    });
    return listDocumentIdAttendanceOfTheUser;
  }

  Future<bool> UpdateUserInGroupAttendance(
      {List<CustomerProfileModel> list_custommer_profile_model,
      String documemt_id_group_attendance}) async {
    print(
        "========== cập nhật list người dùng trong group điểm danh ==========");
    List<String> listDocumentIdCustommer = [];
    for (var item in list_custommer_profile_model) {
      listDocumentIdCustommer.add(item.document_id_custommer);
    }
    for (var item in list_custommer_profile_model) {
      Map<String, dynamic> data = Map<String, dynamic>();
      data["documemt_id_group_attendance"] = documemt_id_group_attendance;
      data["list_document_id_custommer"] = listDocumentIdCustommer;
      await firestoreInstance
          .collection(PathDatabase.UserInGroupAttendance)
          .where("documemt_id_group_attendance",
              isEqualTo: documemt_id_group_attendance)
          .getDocuments()
          .then((value) {
        if (value.documents.length > 0) {
          value.documents.forEach((element) {
            firestoreInstance
                .collection(PathDatabase.UserInGroupAttendance)
                .document(element.documentID)
                .setData(data);
          });
        } else {
          Map<String, dynamic> data1 = Map<String, dynamic>();
          data1["documemt_id_group_attendance"] = documemt_id_group_attendance;
          data1["list_document_id_custommer"] = listDocumentIdCustommer;
          _post(path: PathDatabase.UserInGroupAttendance, data: data1);
        }
      });
    }
    return true;
  }

  Future<bool> CreateSessionAttendance(
      {String document_id_attendance,
      bool check_in_late,
      String time_minute_check_in_late,
      String document_id_custommer,
      String time_check_in}) async {
    print("========== tạo phiên điểm danh và thực hiện điểm danh ==========");
    DateTime dateTime = DateTime.now();
    bool _result = false;
    Map<String, dynamic> data = Map<String, dynamic>();
    data["time_check_in"] = time_check_in;
    data["check_in_late"] = check_in_late;
    data["time_minute_check_in_late"] = time_minute_check_in_late;
    data["took_check_in"] = true;

    data["time_check_out"] = null;
    data["check_out_soon"] = false;
    data["took_check_out"] = false;
    data["time_minute_check_out_soon"] = null;
    data["document_id_group_attendance"] = document_id_attendance;
    data["day"] = dateTime.day.toString();
    await firestoreInstance
        .collection(PathDatabase.SessionAttendance)
        .document(document_id_custommer)
        .collection(dateTime.year.toString())
        .document(dateTime.month.toString())
        .collection(dateTime.month.toString())
        .add(data)
        .catchError((err) {
      _result = false;
    });
    return _result;
  }

  Future<String> CreateCustommerProfileOutTheSystem(
      {CustomerProfileModel customerProfileModel}) async {
    print(
        "========== tạo thông tin khách hàng không có trong hệ thống ==========");
    customerProfileModel.created_at = DateTime.now().toString();
    return await _post(
        data: customerProfileModel.toJson(),
        path: PathDatabase.CustommerProfileOutTheSystem);
  }

  Future<bool> CheckInAppointment(
      {String documment_id_custommer,
      CoordinatesDoubleModel coordinatesDoubleModel,
      String document_id_appointment,
      String url_images_check_in}) async {
    print("========== Thực hiện check in ==========");
    DateTime date_time_now = DateTime.now();
    Map<String, dynamic> data = Map<String, dynamic>();
    data["checked_in"] = true;
    data["checked_in_at"] = date_time_now.toString();
    data["checked_in_by"] = documment_id_custommer;
    data["location_images_check_in"] = coordinatesDoubleModel.toJson();
    data["url_images_check_in"] = url_images_check_in;

    await firestoreInstance
        .collection(PathDatabase.Appointment)
        .document(document_id_appointment)
        .updateData(data)
        .catchError((err) {
      return false;
    });
    return true;
  }

  Future<List<AppointmentModel>> GetListAppointmentModel(
      {String document_id_custommer,
      bool get_list_appointment_user_handing,
      bool checked_in}) async {
    AppointmentModel appointmentModel;
    List<AppointmentModel> listAppointmentModel = [];
    await firestoreInstance
        .collection(PathDatabase.Appointment)
        .where("document_id_user_handing", isEqualTo: document_id_custommer)
        .where("checked_in", isEqualTo: checked_in)
        .getDocuments()
        .then((value) {
      if (value.documents.length > 0) {
        value.documents.forEach((element) {
          appointmentModel = AppointmentModel.fromJson(element.data);
          appointmentModel.document_id_appointment = element.documentID;
          listAppointmentModel.add(appointmentModel);
        });
      }
    });
    return listAppointmentModel;
  }

  Future<List<AppointmentModel>> GetListAppointmentModelUserPosted(
      {String document_id_custommer}) async {
    AppointmentModel appointmentModel;
    List<AppointmentModel> listAppointmentModel = [];
    await firestoreInstance
        .collection(PathDatabase.Appointment)
        .where("post_by", isEqualTo: document_id_custommer)
        .getDocuments()
        .then((value) {
      if (value.documents.length > 0) {
        value.documents.forEach((element) {
          appointmentModel = AppointmentModel.fromJson(element.data);
          appointmentModel.document_id_appointment = element.documentID;
          listAppointmentModel.add(appointmentModel);
        });
      }
    });
    return listAppointmentModel;
  }

  Future<bool> UpdateAppointment(
      {String document_id_appointment,
      String document_id_user_handing,
      String document_id_custommer_out_the_system,
      String document_id_product,
      String document_id_custommer,
      String address_appointment,
      DateTime time_metting,
      bool is_custommer_profile_out_the_system}) async {
    print("========== Cập nhật lịch hẹn ==========");
    bool _result = true;
    Map<String, dynamic> data = Map<String, dynamic>();
    if (document_id_user_handing != null) {
      data["document_id_user_handing"] = document_id_user_handing;
    }
    if (document_id_custommer_out_the_system != null) {
      data["document_id_custommer_out_the_system"] =
          document_id_custommer_out_the_system;
    }
    if (is_custommer_profile_out_the_system != null) {
      data["is_custommer_profile_out_the_system"] =
          is_custommer_profile_out_the_system;
    }
    if (document_id_product != null) {
      data["document_id_product"] = document_id_product;
    }
    if (address_appointment != null) {
      data["address_appointment"] = address_appointment;
    }

    data["last_edit_by"] = document_id_custommer;
    if (time_metting != null) {
      data["time_metting"] = time_metting.toString();
    }
    data["last_edit_at"] = DateTime.now().toString();
    await firestoreInstance
        .collection(PathDatabase.Appointment)
        .document(document_id_appointment)
        .updateData(data)
        .catchError((err) {
      print(err);
      _result = false;
    });
    return _result;
  }

  Future<String> CreateAppointment(
      {String document_id_user_handing,
      String document_id_custommer_out_the_system,
      String document_id_product,
      String document_id_custommer,
      String address_appointment,
      DateTime time_metting,
      bool is_custommer_profile_out_the_system}) async {
    print("========== Tạo lịch hẹn ==========");
    Map<String, dynamic> data = Map<String, dynamic>();
    data["document_id_user_handing"] = document_id_user_handing;
    data["document_id_custommer_out_the_system"] =
        document_id_custommer_out_the_system;
    data["is_custommer_profile_out_the_system"] =
        is_custommer_profile_out_the_system;
    data["document_id_product"] = document_id_product;
    data["address_appointment"] = address_appointment;
    data["post_by"] = document_id_custommer;
    data["post_at"] = DateTime.now().toString();
    data["url_images_check_in"] = null;
    data["location_images_check_in"] = null;
    data["checked_in"] = false;
    data["checked_in_at"] = null;
    data["checked_in_by"] = null;
    data["last_edit_by"] = null;
    data["time_metting"] = time_metting.toString();
    data["last_edit_at"] = null;
    data["removed"] = false;
    data["removed_at"] = null;
    data["remove_by"] = null;
    return await _post(data: data, path: PathDatabase.Appointment);
  }

  Future<bool> UpdateSessionAttendance(
      {String document_session_attendance,
      String time_minute_check_out_soon,
      String document_id_custommer,
      bool check_out_soon,
      String time_check_out}) async {
    print("========== update check out cho phiên điểm danh ==========");
    bool _result = false;
    Map<String, dynamic> data = Map<String, dynamic>();
    data["time_check_out"] = time_check_out;
    data["took_check_out"] = true;
    data["check_out_soon"] = check_out_soon;
    data["time_minute_check_out_soon"] = time_minute_check_out_soon;
    await firestoreInstance
        .collection(PathDatabase.SessionAttendance)
        .document(document_id_custommer)
        .collection(DateTime.now().year.toString())
        .document(DateTime.now().month.toString())
        .collection(DateTime.now().month.toString())
        .document(document_session_attendance)
        .updateData(data)
        .catchError((err) {
      _result = false;
    });
    return _result;
  }

  Future<SessionAttendanceModel> GetDataSessionAttendanceInToDay(
      {String document_id_custommer,
      String document_id_group_attendance}) async {
    SessionAttendanceModel sessionAttendanceModel;
    await firestoreInstance
        .collection(PathDatabase.SessionAttendance)
        .document(document_id_custommer)
        .collection(DateTime.now().year.toString())
        .document(DateTime.now().month.toString())
        .collection(DateTime.now().month.toString())
        .where("document_id_group_attendance",
            isEqualTo: document_id_group_attendance)
        .where("day", isEqualTo: DateTime.now().day.toString())
        .getDocuments()
        .then((value) {
      if (value != null) {
        value.documents.forEach((element) {
          print(element.data);
          sessionAttendanceModel =
              SessionAttendanceModel.fromJson(element.data);
          sessionAttendanceModel.document_id_session_attendance =
              element.documentID;
        });
      }
    });
    return sessionAttendanceModel;
  }

  Future<List<SessionAttendanceModel>> FindDataSessionAttendanceInDay(
      {String document_id_custommer,
      String document_id_group_attendance,
      DateTime TimeSessionAttendanceInDay}) async {
    SessionAttendanceModel sessionAttendanceModel;
    List<SessionAttendanceModel> listSessionAttendanceModel = [];
    await firestoreInstance
        .collection(PathDatabase.SessionAttendance)
        .document(document_id_custommer)
        .collection(TimeSessionAttendanceInDay.year.toString())
        .document(TimeSessionAttendanceInDay.month.toString())
        .collection(TimeSessionAttendanceInDay.month.toString())
        .where("document_id_group_attendance",
            isEqualTo: document_id_group_attendance)
        .where("day", isEqualTo: TimeSessionAttendanceInDay.day.toString())
        .getDocuments()
        .then((value) {
      if (value != null) {
        value.documents.forEach((element) {
          sessionAttendanceModel =
              SessionAttendanceModel.fromJson(element.data);
          sessionAttendanceModel.document_id_session_attendance =
              element.documentID;
          listSessionAttendanceModel.add(sessionAttendanceModel);
        });
      }
    });
    return listSessionAttendanceModel;
  }

  Future<List<SessionAttendanceModel>> FindDataSessionAttendanceInMon(
      {String document_id_custommer,
      String document_id_group_attendance,
      DateTime TimeSessionAttendanceInDay}) async {
    SessionAttendanceModel sessionAttendanceModel;
    List<SessionAttendanceModel> listsessionAttendanceModel = [];
    await firestoreInstance
        .collection(PathDatabase.SessionAttendance)
        .document(document_id_custommer)
        .collection(TimeSessionAttendanceInDay.year.toString())
        .document(TimeSessionAttendanceInDay.month.toString())
        .collection(TimeSessionAttendanceInDay.month.toString())
        .where("document_id_group_attendance",
            isEqualTo: document_id_group_attendance)
        .getDocuments()
        .then((value) {
      if (value != null) {
        value.documents.forEach((element) {
          sessionAttendanceModel =
              SessionAttendanceModel.fromJson(element.data);
          sessionAttendanceModel.document_id_session_attendance =
              element.documentID;
          listsessionAttendanceModel.add(sessionAttendanceModel);
        });
      }
    });

    return listsessionAttendanceModel;
  }
}
