import 'package:flutter_email_sender/flutter_email_sender.dart';

class Emailcontroller {
  Emailcontroller() {}

  void enviarEmail(String assunto, String body, String emailAEnviar) async {
    final Email email = Email(
      body: body,
      subject: assunto,
      recipients: [emailAEnviar],
      isHTML: false,
    );

    print("classe de email");
    await FlutterEmailSender.send(email);
    print("enviou");
  }
}
