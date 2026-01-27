import 'package:serverpod/serverpod.dart';

class DebugEndpoint extends Endpoint {
  Future<String> checkFirebaseSecret(Session session) async {
    final firebaseKey = session.serverpod.getPassword(
      'firebaseServiceAccountKey',
    );

    if (firebaseKey == null) {
      session.log('Debug: Firebase secret is NULL', level: LogLevel.error);
      return 'NULL';
    } else if (firebaseKey.isEmpty) {
      session.log('Debug: Firebase secret is EMPTY', level: LogLevel.error);
      return 'EMPTY';
    } else {
      session.log(
        'Debug: Firebase secret found, length: ${firebaseKey.length}',
        level: LogLevel.info,
      );
      // Try to parse it to see if it's valid JSON
      try {
        session.log(
          'Debug: First 20 chars: ${firebaseKey.substring(0, 20)}',
          level: LogLevel.info,
        );
        return 'FOUND (Length: ${firebaseKey.length})';
      } catch (e) {
        return 'FOUND but read error: $e';
      }
    }
  }
}
