import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/helpers/utils.dart';

class Check_User_System_Controller {
  onLoadScreenHomeCenterCheckExistGroupPermission(
      {String document_id_custommer}) async {
    var api = HttpApi();
    await api.CheckExistGroupPermission(
        document_id_custommer: document_id_custommer);
  }

  onLoadScreenHomeGetListPermisstion({String document_id_custommer}) async {
    var api = HttpApi();
    await setListPermistionCustommerSystem(
        listPermistionCustommerSystem:
            await api.GetIDGroupPermissionInDataCustommerSystem(
                document_id_custommer: document_id_custommer));
  }
}
