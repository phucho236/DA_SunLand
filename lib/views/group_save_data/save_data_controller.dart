import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/utils.dart';

class SaveDataController {
  Future<bool> onLoadSaveData() async {
    bool returnValue = false;
    CustomerProfileModel customerProfile = CustomerProfileModel();
    String document_id_custommer = await getDocumentIdCustommer();
    print(document_id_custommer);
    var api = HttpApi();
    dynamic _result = await api.GetDataCustommer(
        document_id_custommer: document_id_custommer);
    print(_result);
    if (_result != null) {
      customerProfile = CustomerProfileModel.fromJson(_result);
      setUserName(
        last_name: customerProfile.last_name,
        first_name: customerProfile.first_name,
      );
      await setIsPartner(is_partner: customerProfile.is_partner);
      await setType(type: customerProfile.type);
      await setFirstName(first_name: customerProfile.first_name);
      await setLastName(last_name: customerProfile.last_name);
      await setLinkImages(linkImages: customerProfile.linkImages);
      await setCreatedAt(created_at: customerProfile.created_at);
      await setPhoneNumber(phone_number: customerProfile.phone_number);
      await setCreatedAt(created_at: customerProfile.created_at);
      await setEmail(email: customerProfile.email);
      await setLinkImagesCustommer(
          linkImagesCustommer: customerProfile.linkImages);

      returnValue = true;
    }
    return returnValue;
  }
}
