import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/api/api_url.dart';
import 'package:flutter_core/helpers/utils.dart';
import 'package:flutter_core/helpers/validators.dart';

class MessagesController {
  Validators validators = new Validators();

  onSubmitSendMessenger({
    String document_id_custommer,
    String document_id_owner_group,
    String hashDocumentIdCustommer,
    String messenges,
    String user_name,
    bool is_images,
    String email,
    SizeImages sizeImages,
    String linkImagesCustommer,
  }) async {
    int countError = 0;
    if (!validators.checkMessenger(messenges)) {
      countError++;
    }
    if (countError == 0) {
      HttpApi api = HttpApi();
      await api.sendMessage(
        type: await getType(),
        document_id_owner_group: document_id_owner_group,
        document_id_custommer: document_id_custommer,
        hashDocumentIdCustommer: hashDocumentIdCustommer,
        messenges: messenges,
        user_name: user_name,
        is_images: is_images,
        size_images: sizeImages,
        linkImagesCustommer: linkImagesCustommer,
        email: email,
      );
    }
  }

  onSubmitDelete({String hashDocumentIdCustommer, String send_at}) {
    HttpApi api = HttpApi();
    api.removeMessage(
        hashDocumentIdCustommer: hashDocumentIdCustommer, send_at: send_at);
  }

  onSubmitPickImages(
      {String document_id_custommer,
      String hashDocumentIdCustommer,
      String user_name,
      String email,
      File images}) async {
    Size _sizeImages = await getSizeImages(images_path: images);
    SizeImages sizeImagesPost = SizeImages();
    if (_sizeImages != null) {
      //print(_sizeImages.height);
      sizeImagesPost.height = _sizeImages.height;
      sizeImagesPost.weight = _sizeImages.width;
    }

    String _linkImages;
    HttpApi api = HttpApi();
    if (images != null) {
      _linkImages = await api.uploadImages(
          images: images, PathDatabase: PathDatabase.Images_Messenger);
    }
    if (_linkImages != null) {
      onSubmitSendMessenger(
          document_id_custommer: document_id_custommer,
          hashDocumentIdCustommer: hashDocumentIdCustommer,
          messenges: _linkImages,
          user_name: user_name,
          is_images: true,
          sizeImages: sizeImagesPost,
          email: email,
          linkImagesCustommer: await getLinkImages());
    }
  }
}
