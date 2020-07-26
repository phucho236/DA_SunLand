import 'package:flutter_core/view_system/group_appointment/group_appointment_done/appointment_done_screen.dart';
import 'package:flutter_core/view_system/group_appointment/group_create_appointment/create_appointment_screen.dart';
import 'package:flutter_core/view_system/group_appointment/group_posted_appointment/posted_appointment_screen.dart';
import 'package:flutter_core/view_system/group_attendance_management/create_name_group_attendance_mangament.dart';
import 'package:flutter_core/view_system/group_attendance_management/group_add_user_system_to_group_attendance/add_user_system_to_group_attendance_screen.dart';
import 'package:flutter_core/view_system/group_decentralization/decentralization_screen.dart';
import 'package:flutter_core/view_system/group_decentralization/group_detail_decentralization/detail_decentralization_screen.dart';
import 'package:flutter_core/view_system/group_decentralization/group_edit_decentralization/dialog_edit_decentralization_screen.dart';
import 'package:flutter_core/view_system/group_decentralization/group_edit_user_in_group_decentralization/remove_user_in_group_decentralization_screen.dart';
import 'package:flutter_core/view_system/group_decentralization/group_post_decentralization/post_decentralization_screen.dart';
import 'package:flutter_core/view_system/group_edit_product/gridview_product_edit_screen.dart';
import 'package:flutter_core/view_system/group_note_screen/note_screen.dart';
import 'package:flutter_core/view_system/group_notify_system_users/notify_system_users_screen.dart';
import 'package:flutter_core/view_system/group_post_notify_system_user/group_detail_notify_system_user/detail_notify_system_user.dart';
import 'package:flutter_core/view_system/group_post_notify_system_user/post_notify_system_user_screen.dart';
import 'package:flutter_core/view_system/group_preview_product/preview_product_screen.dart';
import 'package:flutter_core/view_system/group_product/post_product_screen.dart';
import 'package:flutter_core/view_system/group_product_ads/group_detail_product_ads/detail_product_ads_screen.dart';
import 'package:flutter_core/view_system/group_product_ads/group_product_ads/product_ads_creen.dart';
import 'package:flutter_core/view_system/group_product_ads/post_product_ads/post_product_ads_screen.dart';
import 'package:flutter_core/view_system/group_product_censorship/product_censorship_screen.dart';
import 'package:flutter_core/view_system/group_support_chat_with_user/group_chat/chat_screen.dart';
import 'package:flutter_core/view_system/group_support_chat_with_user/support_chat_with_user_screen.dart';
import 'package:flutter_core/view_system/group_to_become_a_partner_censorship/request_to_become_a_partner_layout.dart';
import 'package:flutter_core/view_system/group_user_need_contact/group_detai_user_need_contact/detail_user_need_contact_screen.dart';
import 'package:flutter_core/view_system/group_user_need_contact/user_need_contact_layout.dart';
import 'package:flutter_core/views/group_accuracy/group_forgot_password/forgot_password_screen.dart';
import 'package:flutter_core/views/group_accuracy/group_login/login_screen.dart';
import 'package:flutter_core/views/group_accuracy/group_register/register_screen.dart';
import 'package:flutter_core/views/group_images_brain/show_images_screen.dart';
import 'package:flutter_core/views/group_introduce/introduce_screen.dart';
import 'package:flutter_core/views/group_message/message_screen.dart';
import 'package:flutter_core/views/group_not_connection/not_connection_screen.dart';
import 'package:flutter_core/views/group_notication/group_detail_notifycation/detail_notifycation_screen.dart';
import 'package:flutter_core/views/group_notication/notifycation_screen.dart';
import 'package:flutter_core/views/group_profile_page/group_product_posted/product_posted_screen.dart';
import 'package:flutter_core/views/group_profile_page/profile_screen.dart';
import 'package:flutter_core/views/group_save_data/save_data_screen.dart';
import 'package:flutter_core/views/home_center_screen.dart';
import 'package:flutter_core/views/group_home_page/group_detail_item/detail_item_screen.dart';
import 'package:flutter_core/view_system/system_center_screen.dart';
import 'package:flutter_core/view_system/group_edit_product/edit_detail_product_screen.dart';
import 'package:flutter_core/view_system/group_attendance_management/group_check_attendance/check_attendance_screen.dart';
import 'package:flutter_core/view_system/group_attendance_management/pick_location_here_map_screen.dart';
import 'package:flutter_core/view_system/group_attendance_management/group_history_attendance/history_attendance_screen.dart';
import 'package:flutter_core/view_system/group_attendance_management/group_history_attendance_all/history_attendance_all_screen.dart';
import 'package:flutter_core/view_system/group_appointment/group_create_appointment/group_pick_product/pick_product_screen.dart';
import 'package:flutter_core/view_system/group_appointment/appointment_screen.dart';
import 'package:flutter_core/view_system/group_appointment/group_detail_and_check_in_appointment/detail_and_check_in_appointment_screen.dart';
import 'package:flutter_core/view_system/group_appointment/group_detail_appointment_done/detail_appointment_done_screen.dart';
import 'package:flutter_core/view_system/group_appointment/group_detail_and_edit_appointment/detail_and_edit_appointment_screen.dart';
import 'package:flutter_core/view_system/group_appointment/group_appoiment_all_system/appoiment_all_system_screen.dart';
import 'package:flutter_core/view_system/group_appointment/group_appoitment_all_system_done/appointment_all_system_done_screen.dart';
//const initialRoute = 'splash_screen';
String initialRoute = LoginScreen.id;

//String initialRoute = IntroduceScreen.id;
//String initialRoute = PreviewProductScreen.id;
//String initialRoute = NoticatonScreen.id;
//String initialRoute = EditDetailProductScreen.id;
//String initialRoute = HomeCenterScreen.id;
//String initialRoute = DetailItemScreen.id;
var routes = {
  //TODO: Authenticate
  //'splash_screen': (context) => SplashScreen(),

  LoginScreen.id: (context) => LoginScreen(),
  RegisterScreen.id: (context) => RegisterScreen(),
  ForgotPasswordScreen.id: (context) => ForgotPasswordScreen(),
  HomeCenterScreen.id: (context) => HomeCenterScreen(),
  DetailItemScreen.id: (context) => DetailItemScreen(),
  ProfileScreen.id: (context) => ProfileScreen(),
  MessageScreen.id: (context) => MessageScreen(),
  SaveDataScreen.id: (context) => SaveDataScreen(),
  NotifycatonScreen.id: (context) => NotifycatonScreen(),
  SystemCenterScreen.id: (context) => SystemCenterScreen(),
  PostProductScreen.id: (context) => PostProductScreen(),
  PreviewProductScreen.id: (context) => PreviewProductScreen(),
  ProductCensorshipScreen.id: (context) => ProductCensorshipScreen(),
  SupportChatWithUserScreen.id: (context) => SupportChatWithUserScreen(),
  UserNeedContactLayout.id: (context) => UserNeedContactLayout(),
  GridViewShowProductEditScreen.id: (context) =>
      GridViewShowProductEditScreen(),
  EditDetailProductScreen.id: (context) => EditDetailProductScreen(),
  RequestToBecomeAPartnerLayout.id: (context) =>
      RequestToBecomeAPartnerLayout(),
  ProductPostedScreen.id: (context) => ProductPostedScreen(),
  NotifySystemUsersScreen.id: (context) => NotifySystemUsersScreen(),
  ShowImagesScreen.id: (context) => ShowImagesScreen(),
  NoteScreen.id: (context) => NoteScreen(),
  PostNotifySystemUsersScreen.id: (context) => PostNotifySystemUsersScreen(),
  DetailNotifySystemUser.id: (context) => DetailNotifySystemUser(),
  DetailUserNeedContact.id: (context) => DetailUserNeedContact(),
  PostProductAdsScreen.id: (context) => PostProductAdsScreen(),
  ChatScreen.id: (context) => ChatScreen(),
  DeatailNotifycationScreen.id: (context) => DeatailNotifycationScreen(),
  ProductAdsScreen.id: (context) => ProductAdsScreen(),
  DeatailProductAdsnScreen.id: (context) => DeatailProductAdsnScreen(),
  DecentralizationScreen.id: (context) => DecentralizationScreen(),
  PostDecentralizationScreen.id: (context) => PostDecentralizationScreen(),
  DetailDecentralizationScreen.id: (context) => DetailDecentralizationScreen(),
  DialogEditDecentralization.id: (context) => DialogEditDecentralization(),
  RemoveUserInGroupDecentralizationScreen.id: (context) =>
      RemoveUserInGroupDecentralizationScreen(),
  NotConnectionScreen.id: (context) => NotConnectionScreen(),
  PickLocationHereMapScreen.id: (context) => PickLocationHereMapScreen(),
  CreateNameGroupAttendanceMangamentScreen.id: (context) =>
      CreateNameGroupAttendanceMangamentScreen(),
  AddUserSystemToGroupAttendanceScreen.id: (context) =>
      AddUserSystemToGroupAttendanceScreen(),
  CheckAttendanceScreen.id: (context) => CheckAttendanceScreen(),
  HistoryAttendanceScreen.id: (context) => HistoryAttendanceScreen(),
  HistoryAttendanceAllScreen.id: (context) => HistoryAttendanceAllScreen(),
  CreateAppointmentScreen.id: (context) => CreateAppointmentScreen(),
  PickProductScreen.id: (context) => PickProductScreen(),
  AppointmentScreen.id: (context) => AppointmentScreen(),
  DetailAndCheckInAppointmentScreen.id: (context) =>
      DetailAndCheckInAppointmentScreen(),
  AppointmentDoneScreen.id: (context) => AppointmentDoneScreen(),
  DetailInAppointmentDoneScreen.id: (context) =>
      DetailInAppointmentDoneScreen(),
  AppointmentPostedScreen.id: (context) => AppointmentPostedScreen(),
  DetailAndEditAppointmentScreen.id: (context) =>
      DetailAndEditAppointmentScreen(),
  AppointmentAllSystemScreen.id: (context) => AppointmentAllSystemScreen(),
  AppointmentAllSystemDoneScreen.id: (context) =>
      AppointmentAllSystemDoneScreen(),
  IntroduceScreen.id: (context) => IntroduceScreen(),
};
