import 'package:flutter_core/api/api_http.dart';

class ControlPanelController {
  onGetDocumentIDDataCustommerSystem({String document_id_custommer}) async {
    var api = HttpApi();
    return api.GetDocumentIDDataCustomerSystem(
        document_id_custommer: document_id_custommer);
  }
}
