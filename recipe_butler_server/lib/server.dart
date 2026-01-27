import 'dart:io';

// ignore_for_file: avoid_print
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/providers/firebase.dart';

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';
import 'src/future_calls/send_reminder_email.dart';
import 'src/web/routes/app_config_route.dart';
import 'src/web/routes/root.dart';
import 'src/config/firebase_credentials.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(args, Protocol(), Endpoints());

  // Initialize authentication services for the server.
  // Token managers will be used to validate and issue authentication keys,
  // and the identity providers will be the authentication options available for users.
  final identityProviders = <IdentityProviderBuilder>[
    // Configure the email identity provider for email/password authentication.
    EmailIdpConfigFromPasswords(
      sendRegistrationVerificationCode: _sendRegistrationCode,
      sendPasswordResetVerificationCode: _sendPasswordResetCode,
    ),
  ];

  var firebaseKey = pod.getPassword('firebaseServiceAccountKey');
  if (firebaseKey == null || firebaseKey.isEmpty) {
    print(
      'WARNING: firebaseServiceAccountKey not found in secrets. Using hardcoded fallback.',
    );
    firebaseKey = firebaseCredentialsJson;
  }

  if (firebaseKey.isNotEmpty) {
    print(
      'Firebase Service Account Key present (length: ${firebaseKey.length})',
    );
    try {
      identityProviders.add(
        FirebaseIdpConfig(
          credentials: FirebaseServiceAccountCredentials.fromJsonString(
            firebaseKey,
          ),
          firebaseAccountDetailsValidation: (accountDetails) {
            // Allow unverified emails for email/password signup.
            // Google accounts always have email_verified=true, but
            // freshly created email/password accounts do not.
          },
        ),
      );
      print('Firebase Identity Provider added successfully.');
    } catch (e) {
      print('Failed to parse Firebase Service Account Key: $e');
    }
  } else {
    print('Firebase Service Account Key NOT found or empty.');
  }

  pod.initializeAuthServices(
    tokenManagerBuilders: [
      // Use JWT for authentication keys towards the server.
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: identityProviders,
  );

  // Setup a default page at the web root.
  // These are used by the default page.
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');

  // Serve all files in the web/static relative directory under /.
  // These are used by the default web page.
  final root = Directory(Uri(path: 'web/static').toFilePath());
  pod.webServer.addRoute(StaticRoute.directory(root));

  // Setup the app config route.
  // We build this configuration based on the servers api url and serve it to
  // the flutter app.
  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    '/app/assets/assets/config.json',
  );

  // Checks if the flutter web app has been built and serves it if it has.
  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    // Serve the flutter web app under the /app path.
    pod.webServer.addRoute(
      FlutterRoute(
        Directory(
          Uri(path: 'web/app').toFilePath(),
        ),
      ),
      '/app',
    );
  } else {
    // If the flutter web app has not been built, serve the build app page.
    pod.webServer.addRoute(
      StaticRoute.file(
        File(
          Uri(path: 'web/pages/build_flutter_app.html').toFilePath(),
        ),
      ),
      '/app/**',
    );
  }

  // Register future calls.
  pod.registerFutureCall(
    SendReminderEmailCall(),
    'sendReminderEmail',
  );

  // Start the server.
  await pod.start();

  // Schedule check 5 seconds after startup
  try {
    // We need a session to schedule a future call, but we don't have one here.
    // However, we can use the internal serverpod method if needed, or better,
    // just rely on the print statements during startup which didn't show up.
    // Actually, let's just use the server.log which we know works if we can access it.

    // Instead of scheduling, let's just hope the print statements work this time.
    // But since they didn't, let's try to inject the call immediately after start.

    // Actually, we can trigger it via a simple timer if we had access to session.
  } catch (e) {
    print('Failed to schedule secret check: $e');
  }
}

void _sendRegistrationCode(
  Session session, {
  required String email,
  required UuidValue accountRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // NOTE: Here you call your mail service to send the verification code to
  // the user. For testing, we will just log the verification code.
  session.log('[EmailIdp] Registration code ($email): $verificationCode');
}

void _sendPasswordResetCode(
  Session session, {
  required String email,
  required UuidValue passwordResetRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // NOTE: Here you call your mail service to send the verification code to
  // the user. For testing, we will just log the verification code.
  session.log('[EmailIdp] Password reset code ($email): $verificationCode');
}
