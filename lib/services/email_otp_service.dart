import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class EmailOtpService{
  static Future sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    final serviceId = 'service_wgqd3mn';
    final templateId = 'template_2vv29td';
    final userId = 'zeuCrEzl2YovcgkR9';
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final response = await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'from_name': name,
            'user_email': email,
            'user_subject': subject,
            'message': message,
          }
        }));
    print(response.body);
    print('done');
  }

  Future launchEmail({
    required String toEmail,
    required String subject,
    required String message,
  }) async {
    try {
      final url = 'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(message)}';

      if (await canLaunch(url)) {
        await launch(url);
      }
    } catch (e) {
      print('something went wrong $e');
    }
  }
}