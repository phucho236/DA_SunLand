import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';

class SupportChatWithUserController {
  onLoadScreenSuportChatWithUser() async {
    var api = HttpApi();
    return await api.GetListCustommerProfileChatted();
  }

  onFindEmailUserChated({String email}) async {
    var api = HttpApi();
    return await api.FindCustomerProfileByEmailChated(email: email);
  }

  onGetDataUserNeedChated({String document_id_custommer}) async {
    var api = HttpApi();
    CustomerProfileModel customerProfileModel;
    var _result = await api.GetDataCustommer(
        document_id_custommer: document_id_custommer);
    if (_result != null) {
      customerProfileModel = CustomerProfileModel.fromJson(_result);
      customerProfileModel.document_id_custommer = document_id_custommer;
      return customerProfileModel;
    } else {
      return customerProfileModel;
    }
  }
}
