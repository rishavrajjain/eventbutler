import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_idp_flutter_firebase/serverpod_auth_idp_flutter_firebase.dart';

import 'package:recipe_butler_client/recipe_butler_client.dart';

/// Lightweight singleton wrapper to initialize and share the Serverpod client.
class ServerpodClientService {
  ServerpodClientService._();

  static final ServerpodClientService instance = ServerpodClientService._();

  late final Client client;
  late final FlutterAuthSessionManager authManager;
  bool _initialized = false;

  Future<void> init({required String baseUrl}) async {
    if (_initialized) return;
    // TODO: Load baseUrl from remote config / app config route.
    authManager = FlutterAuthSessionManager();
    client = Client(baseUrl)
      ..connectivityMonitor = FlutterConnectivityMonitor()
      ..authSessionManager = authManager;

    // Ensure Firebase sign-in is wired to Serverpod auth (idempotent).
    authManager.initializeFirebaseSignIn();

    _initialized = true;
  }
}
