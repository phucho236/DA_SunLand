import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class MailReplyController {
  Future<bool> MailReply({String recipents_email, bool Type}) async {
    String username = 'hophuc236@gmail.com';
    String password = 'LIMITEDEDITION!236';

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address(username, 'SunLand')
      ..recipients.add(recipents_email)
//      ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])  // gửi nhiều người
//      ..bccRecipients.add(Address('bccAddress@example.com'))   //bbc người vào
      ..subject = 'SunLand'
      ..text = 'ABCD'
      ..html = Type
          ? "<body style='font-size:20px'><center><img src='https://firebasestorage.googleapis.com/v0/b/sunland-2b6ba.appspot.com/o/Images_App%2FSunland_Logo.png?alt=media&token=20220d50-75e9-465e-9cda-dac5f0a25f0b' width='300px'></center><center>SunLand Xin chào!</center><center>Bạn đã được duyệt trở thành đối tác.</center><center>Vui lòng đăng nhập lại để cập nhật một số tính năng mới nhé!</center></body>"
          : "<body style='font-size:20px'><center><img src='https://firebasestorage.googleapis.com/v0/b/sunland-2b6ba.appspot.com/o/Images_App%2FSunland_Logo.png?alt=media&token=20220d50-75e9-465e-9cda-dac5f0a25f0b' width='300px'></center><center>SunLand Xin chào!</center><center>Sau khi xem xét.</center><center>Chúng tôi không thể duyệt bạn thành đối tác.</center><center>Cám ơn bạn vì đã đồng hành cùng Sunland!</center></body>";

    ///thay thế cho phần text kế bên này thiết kế email theo dạng html

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      return true;
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
