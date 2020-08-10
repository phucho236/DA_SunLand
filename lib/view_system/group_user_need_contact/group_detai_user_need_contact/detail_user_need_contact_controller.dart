import 'package:flutter_core/api/api_http.dart';
import 'package:flutter_core/api/api_model.dart';
import 'package:flutter_core/helpers/utils.dart';

class DetailUserNeedContactController {
  onGetListGetListProduct({List<String> list_item_like}) async {
    var api = HttpApi();
    return await api.GetListProduct(listDocumentIDProduct: list_item_like);
  }

  onGetRealEstate({String document_id_real_estate}) async {
    var api = HttpApi();
    return await api.GetRealEstate(document_id_real_estate);
  }

  onGetDetailProduct({String document_id_product}) async {
    var api = HttpApi();
    return await api.GetDetailProduct(document_id_product: document_id_product);
  }

  Future<bool> onSubmitUpdateUserTakedNeedSuport(
      {String document_id_custommer_taked,
      String document_id_product_need_sp,
      String document_id_custommer_edit}) async {
    var api = HttpApi();
    return await api.UpdateProductNeedSuport(
        edit_by: document_id_custommer_edit,
        document_id_custommer_taked: document_id_custommer_taked,
        document_id_product_need_sp: document_id_product_need_sp);
  }

  Future<bool> CheckTaked({String document_id_product_need_sp}) async {
    var api = HttpApi();
    return await api.CheckTakedProductNeedSuport(
        document_id_product_need_support: document_id_product_need_sp);
  }

  Future<bool> onSubmitUpdateProductNeedSuport({
    String document_id_custommer_taked,
    String document_id_custommer_contact,
    String document_id_product_need_sp,
    bool taked,
    bool contacted,
  }) async {
    bool take_it = false;
    var api = HttpApi();
    take_it = await CheckTaked(
        document_id_product_need_sp: document_id_product_need_sp);

    print("ABCD $take_it");
    if (take_it == false) {
      return await api.UpdateProductNeedSuport(
          document_id_custommer_contact: document_id_custommer_contact,
          contacted: contacted,
          taked: taked,
          document_id_custommer_taked: document_id_custommer_taked,
          document_id_product_need_sp: document_id_product_need_sp);
    } else {
      return false;
    }
  }

  Future<bool> onSubmitPostNoteProductNeedSuport(
      {String document_id_product_need_sp, String note}) async {
    String document_id_custommer = await getDocumentIdCustommer();
    var api = HttpApi();
    return await api.PostNoteProductNeedSuport(
        document_id_product_need_sp: document_id_product_need_sp,
        note: note,
        document_id_custommer: document_id_custommer);
  }

  getCustommerProfileUser({String document_id_custommer}) async {
    var api = HttpApi();
    var _result = await api.GetDataCustommer(
        document_id_custommer: document_id_custommer);
    if (_result != null) {
      return CustomerProfileModel.fromJson(_result);
    } else {
      return null;
    }
  }

  onGetListCustommerProfile({num type}) async {
    var api = HttpApi();
    return await api.GetListCustommerProfile(type: type);
  }

  onFindCustommerProfileByEmail({String email, int type}) async {
    var api = HttpApi();
    return await api.FindCustomerProfileByEmail(email: email, type: type);
  }
}
