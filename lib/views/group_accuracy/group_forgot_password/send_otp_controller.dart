import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class SendOTPController {
  Future<bool> SendOTP({String recipents_email, String otp}) async {
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
      ..subject = 'SunLandOTP'
      ..text = otp;
    //..html = "<h1>SunLandOTP</h1>"; ///thay thế cho phần text kế bên này thiết kế email theo dạng html

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
