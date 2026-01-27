import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class EmailService {
  EmailService(this.session);

  final Session session;

  static const _resendEndpoint = 'https://api.resend.com/emails';
  static const _from = 'Event Butler <notifications@eventbutler.dev>';

  Future<void> sendReminderEmail(Reminder reminder) async {
    final apiKey = session.serverpod.getPassword('RESEND_API_KEY');
    if (apiKey == null || apiKey.isEmpty) {
      session.log(
        'RESEND_API_KEY missing; skipping reminder email.',
        level: LogLevel.warning,
      );
      return;
    }
    final to = reminder.targetEmail;
    if (to == null || to.isEmpty) return;

    final subject = 'Reminder: ${reminder.title}';
    final formattedDue =
        reminder.dueAt.toLocal().toIso8601String().replaceFirst('T', ' ');
    final body = '''
Hi,

This is your Event Butler reminder:
- Title: ${reminder.title}
- List ID: ${reminder.shoppingListId}
- When: $formattedDue (local time)

Mark it done in the app if you've already completed it.

— Event Butler
''';

    final response = await http.post(
      Uri.parse(_resendEndpoint),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'from': _from,
        'to': [to],
        'subject': subject,
        'text': body,
      }),
    );

    if (response.statusCode >= 300) {
      session.log(
        'Resend email failed (${response.statusCode}): ${response.body}',
        level: LogLevel.warning,
      );
    }
  }
}
