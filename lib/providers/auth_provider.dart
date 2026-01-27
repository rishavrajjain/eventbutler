import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:serverpod_auth_idp_flutter_firebase/serverpod_auth_idp_flutter_firebase.dart';

import '../firebase_options.dart';

import '../services/serverpod_client_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({ServerpodClientService? clientService})
    : _clientService = clientService ?? ServerpodClientService.instance;

  final ServerpodClientService _clientService;
  FirebaseAuthController? _firebaseController;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _userId;
  String? _error;
  bool _initialized = false;
  bool _usingGuest = false;
  static bool _googleInitialized = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get userId => _userId;
  String? get error => _error;
  bool get initialized => _initialized;

  static const _defaultBaseUrl = 'https://recipebutler.api.serverpod.space/';

  String _resolveBaseUrl() {
    // Always use the fixed Cloud API endpoint.
    // The web app is served from recipebutler.serverpod.space, but the
    // Serverpod RPC/WS endpoints live on recipebutler.api.serverpod.space.
    return _defaultBaseUrl;
  }

  Future<void> _ensureClient() async {
    await _clientService.init(baseUrl: _resolveBaseUrl());
    if (!_initialized) {
      await _clientService.authManager.initialize();
      _clientService.authManager.authInfoListenable.addListener(
        _onAuthInfoChanged,
      );
      _firebaseController = FirebaseAuthController(
        client: _clientService.client,
        onAuthenticated: _onServerAuthenticated,
        onError: (error) {
          debugPrint('[Auth] Serverpod auth failed: $error');
          _error ??= 'Could not sign in. Please try again.';
          _isAuthenticated = false;
          _isLoading = false;
          notifyListeners();
        },
      );
      _initialized = true;
    }
  }

  void _onAuthInfoChanged() {
    if (_usingGuest) return;
    final authInfo = _clientService.authManager.authInfo;
    _isAuthenticated = authInfo != null;
    _userId = authInfo?.authUserId.toString();
    notifyListeners();
  }

  void _onServerAuthenticated() {
    _usingGuest = false;
    final authInfo = _clientService.authManager.authInfo;
    _isAuthenticated = authInfo != null;
    _userId = authInfo?.authUserId.toString();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signInGuest() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    await _ensureClient();
    // Generate a simple device-based identity for guest mode.
    _usingGuest = true;
    _userId = 'guest-${DateTime.now().millisecondsSinceEpoch}';
    _isAuthenticated = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _ensureClient();
      _usingGuest = false;

      debugPrint(
        '[EmailAuth] Step 1: Signing in with Firebase email/password...',
      );
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('[EmailAuth] Step 1 OK: uid = ${credential.user?.uid}');

      debugPrint('[EmailAuth] Step 2: Getting Firebase ID token...');
      final firebaseIdToken = await credential.user?.getIdToken();
      if (firebaseIdToken == null) {
        throw Exception('Missing Firebase ID token');
      }
      debugPrint(
        '[EmailAuth] Step 2 OK: token length = ${firebaseIdToken.length}',
      );

      debugPrint('[EmailAuth] Step 3: Exchanging token with Serverpod...');
      await _firebaseController?.login(credential.user);
      if (!_clientService.authManager.isAuthenticated) {
        throw Exception('Server authentication failed');
      }
      _userId = _clientService.authManager.authInfo?.authUserId.toString();
      _isAuthenticated = true;
      debugPrint('[EmailAuth] DONE');
    } on FirebaseAuthException catch (e) {
      debugPrint(
        '[EmailAuth] FAILED (FirebaseAuthException): code = ${e.code}, message = ${e.message}',
      );
      _error = _firebaseErrorMessage(e.code);
      _isAuthenticated = false;
    } catch (e) {
      debugPrint(
        '[EmailAuth] FAILED: runtimeType = ${e.runtimeType}, message = $e',
      );
      _error = 'Sign in failed: $e';
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _ensureClient();
      _usingGuest = false;

      debugPrint('[EmailSignUp] Step 1: Creating Firebase user...');
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      debugPrint('[EmailSignUp] Step 1 OK: uid = ${credential.user?.uid}');

      debugPrint('[EmailSignUp] Step 2: Getting Firebase ID token...');
      final firebaseIdToken = await credential.user?.getIdToken();
      if (firebaseIdToken == null) {
        throw Exception('Missing Firebase ID token');
      }
      debugPrint(
        '[EmailSignUp] Step 2 OK: token length = ${firebaseIdToken.length}',
      );

      debugPrint('[EmailSignUp] Step 3: Exchanging token with Serverpod...');
      await _firebaseController?.login(credential.user);
      if (!_clientService.authManager.isAuthenticated) {
        throw Exception('Server authentication failed');
      }
      _userId = _clientService.authManager.authInfo?.authUserId.toString();
      _isAuthenticated = true;
      debugPrint('[EmailSignUp] DONE');
    } on FirebaseAuthException catch (e) {
      debugPrint(
        '[EmailSignUp] FAILED (FirebaseAuthException): code = ${e.code}, message = ${e.message}',
      );
      _error = _firebaseErrorMessage(e.code);
      _isAuthenticated = false;
    } catch (e) {
      debugPrint(
        '[EmailSignUp] FAILED: runtimeType = ${e.runtimeType}, message = $e',
      );
      _error = 'Sign up failed: $e';
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _ensureClient();
      _usingGuest = false;

      UserCredential credential;
      if (kIsWeb) {
        debugPrint(
          '[GoogleAuth] Step 1 (web): Starting Firebase signInWithPopup...',
        );
        credential = await FirebaseAuth.instance.signInWithPopup(
          GoogleAuthProvider(),
        );
      } else {
        debugPrint(
          '[GoogleAuth] Step 1 (mobile): Launching Google sign-in flow...',
        );
        if (!_googleInitialized) {
          await GoogleSignIn.instance.initialize(
            clientId: defaultTargetPlatform == TargetPlatform.iOS
                ? DefaultFirebaseOptions.ios.iosClientId
                : null,
            // Access token not required for Firebase; ID token is enough.
            serverClientId: defaultTargetPlatform == TargetPlatform.iOS
                ? DefaultFirebaseOptions.ios.iosClientId
                : null,
          );
          _googleInitialized = true;
        }

        final googleUser = await GoogleSignIn.instance.authenticate();
        final googleAuth = googleUser.authentication;
        final oauthCredential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );
        credential = await FirebaseAuth.instance.signInWithCredential(
          oauthCredential,
        );
      }
      debugPrint(
        '[GoogleAuth] Step 1 OK: credential.user.uid = ${credential.user?.uid}',
      );

      debugPrint('[GoogleAuth] Step 2: Getting Firebase ID token...');
      final firebaseIdToken = await credential.user?.getIdToken();
      if (firebaseIdToken == null) {
        throw Exception('Missing Firebase ID token');
      }
      debugPrint(
        '[GoogleAuth] Step 2 OK: token length = ${firebaseIdToken.length}',
      );

      debugPrint('[GoogleAuth] Step 3: Exchanging token with Serverpod...');
      await _firebaseController?.login(credential.user);
      if (!_clientService.authManager.isAuthenticated) {
        throw Exception('Server authentication failed');
      }
      _userId = _clientService.authManager.authInfo?.authUserId.toString();
      _isAuthenticated = true;
      debugPrint('[GoogleAuth] DONE');
    } on GoogleSignInException catch (e) {
      debugPrint(
        '[GoogleAuth] FAILED (GoogleSignInException): code = ${e.code}, description = ${e.description}',
      );
      _error = e.code == GoogleSignInExceptionCode.canceled
          ? 'Google sign-in was cancelled.'
          : 'Google sign-in failed: ${e.description ?? e.code.name}';
      _isAuthenticated = false;
    } on FirebaseAuthException catch (e) {
      debugPrint(
        '[GoogleAuth] FAILED (FirebaseAuthException): code = ${e.code}, message = ${e.message}',
      );
      _error = 'Google sign-in failed: ${e.message}';
      _isAuthenticated = false;
    } catch (e) {
      debugPrint(
        '[GoogleAuth] FAILED: runtimeType = ${e.runtimeType}, message = $e',
      );
      // Friendly fallback in local dev: continue as guest so the app remains usable.
      try {
        await signInGuest();
        _error = 'Google sign-in unavailable; continued as guest.';
      } catch (_) {
        _error = 'Google sign-in failed: $e';
        _isAuthenticated = false;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _usingGuest = false;
    await _clientService.authManager.signOutDevice();
    await _clientService.authManager.signOutFromFirebase();
    if (!kIsWeb && _googleInitialized) {
      await GoogleSignIn.instance.signOut();
    }
    await FirebaseAuth.instance.signOut();
    _isAuthenticated = false;
    _userId = null;
    notifyListeners();
  }

  String _firebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found for this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
