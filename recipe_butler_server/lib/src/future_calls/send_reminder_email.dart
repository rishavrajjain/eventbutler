import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/email_service.dart';

class SendReminderEmailCall extends FutureCall<Reminder> {
  @override
  Future<void> invoke(Session session, Reminder? object) async {
    if (object == null || object.id == null) return;
    final latest = await Reminder.db.findById(session, object.id!);
    final target = latest ?? object;
    if (target.isDone) return;
    if (target.targetEmail == null || target.targetEmail!.isEmpty) return;
    await EmailService(session).sendReminderEmail(target);
  }
}
