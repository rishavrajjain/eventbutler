/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:recipe_butler_client/src/protocol/ai/butler_suggestion.dart'
    as _i3;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i4;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i5;
import 'package:recipe_butler_client/src/protocol/greetings/greeting.dart'
    as _i6;
import 'package:recipe_butler_client/src/protocol/recipes/recipe.dart' as _i7;
import 'package:recipe_butler_client/src/protocol/shopping/reminder.dart'
    as _i8;
import 'package:recipe_butler_client/src/protocol/shopping/shopping_list.dart'
    as _i9;
import 'package:recipe_butler_client/src/protocol/shopping/shopping_item.dart'
    as _i10;
import 'package:recipe_butler_client/src/protocol/shopping/shopping_list_event.dart'
    as _i11;
import 'package:recipe_butler_client/src/protocol/shopping/invite.dart' as _i12;
import 'package:recipe_butler_client/src/protocol/shopping/task_message.dart'
    as _i13;
import 'protocol.dart' as _i14;

/// {@category Endpoint}
class EndpointAi extends _i1.EndpointRef {
  EndpointAi(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'ai';

  _i2.Future<_i3.ButlerSuggestion> suggest(
    String userKey,
    int listId,
    String prompt,
  ) => caller.callServerEndpoint<_i3.ButlerSuggestion>(
    'ai',
    'suggest',
    {
      'userKey': userKey,
      'listId': listId,
      'prompt': prompt,
    },
  );
}

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _i4.EndpointEmailIdpBase {
  EndpointEmailIdp(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i2.Future<_i5.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i5.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i2.Future<_i1.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i2.Future<String> verifyRegistrationCode({
    required _i1.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i2.Future<_i5.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i5.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i2.Future<_i1.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i2.Future<String> verifyPasswordResetCode({
    required _i1.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i2.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );
}

/// Exposes Firebase ID token login so Flutter can sign in with Google via Firebase.
/// {@category Endpoint}
class EndpointFirebaseIdp extends _i4.EndpointFirebaseIdpBase {
  EndpointFirebaseIdp(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'firebaseIdp';

  /// Validates a Firebase ID token and either logs in the associated user or
  /// creates a new user account if the Firebase account ID is not yet known.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  @override
  _i2.Future<_i5.AuthSuccess> login({required String idToken}) =>
      caller.callServerEndpoint<_i5.AuthSuccess>(
        'firebaseIdp',
        'login',
        {'idToken': idToken},
      );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i5.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i2.Future<_i5.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i5.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// {@category Endpoint}
class EndpointDebug extends _i1.EndpointRef {
  EndpointDebug(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'debug';

  _i2.Future<String> checkFirebaseSecret() => caller.callServerEndpoint<String>(
    'debug',
    'checkFirebaseSecret',
    {},
  );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i1.EndpointRef {
  EndpointGreeting(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i2.Future<_i6.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i6.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

/// {@category Endpoint}
class EndpointImport extends _i1.EndpointRef {
  EndpointImport(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'import';

  _i2.Future<_i7.Recipe> importRecipeFromUrl(
    String userKey,
    String url,
  ) => caller.callServerEndpoint<_i7.Recipe>(
    'import',
    'importRecipeFromUrl',
    {
      'userKey': userKey,
      'url': url,
    },
  );
}

/// {@category Endpoint}
class EndpointRecipe extends _i1.EndpointRef {
  EndpointRecipe(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'recipe';

  /// Create a recipe owned by the authenticated user.
  _i2.Future<_i7.Recipe> createRecipe(
    String userKey,
    String title, {
    String? sourceUrl,
  }) => caller.callServerEndpoint<_i7.Recipe>(
    'recipe',
    'createRecipe',
    {
      'userKey': userKey,
      'title': title,
      'sourceUrl': sourceUrl,
    },
  );

  /// List recipes for the authenticated user.
  _i2.Future<List<_i7.Recipe>> listMyRecipes(String userKey) =>
      caller.callServerEndpoint<List<_i7.Recipe>>(
        'recipe',
        'listMyRecipes',
        {'userKey': userKey},
      );

  /// Get a single recipe; ensures ownership.
  _i2.Future<_i7.Recipe?> getRecipe(
    String userKey,
    int recipeId,
  ) => caller.callServerEndpoint<_i7.Recipe?>(
    'recipe',
    'getRecipe',
    {
      'userKey': userKey,
      'recipeId': recipeId,
    },
  );

  /// Delete a recipe; returns true if deleted.
  _i2.Future<bool> deleteRecipe(
    String userKey,
    int recipeId,
  ) => caller.callServerEndpoint<bool>(
    'recipe',
    'deleteRecipe',
    {
      'userKey': userKey,
      'recipeId': recipeId,
    },
  );
}

/// {@category Endpoint}
class EndpointReminders extends _i1.EndpointRef {
  EndpointReminders(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'reminders';

  _i2.Future<List<_i8.Reminder>> listMyReminders(
    String userKey, {
    DateTime? after,
  }) => caller.callServerEndpoint<List<_i8.Reminder>>(
    'reminders',
    'listMyReminders',
    {
      'userKey': userKey,
      'after': after,
    },
  );

  _i2.Future<List<_i8.Reminder>> listRemindersForList(
    String userKey,
    int listId,
  ) => caller.callServerEndpoint<List<_i8.Reminder>>(
    'reminders',
    'listRemindersForList',
    {
      'userKey': userKey,
      'listId': listId,
    },
  );

  _i2.Future<_i8.Reminder> addReminder(
    String userKey,
    int listId,
    String title,
    DateTime dueAt,
    String? targetEmail,
  ) => caller.callServerEndpoint<_i8.Reminder>(
    'reminders',
    'addReminder',
    {
      'userKey': userKey,
      'listId': listId,
      'title': title,
      'dueAt': dueAt,
      'targetEmail': targetEmail,
    },
  );

  _i2.Future<_i8.Reminder?> toggleReminder(
    String userKey,
    int reminderId,
    bool isDone,
  ) => caller.callServerEndpoint<_i8.Reminder?>(
    'reminders',
    'toggleReminder',
    {
      'userKey': userKey,
      'reminderId': reminderId,
      'isDone': isDone,
    },
  );

  _i2.Future<void> deleteReminder(
    String userKey,
    int reminderId,
  ) => caller.callServerEndpoint<void>(
    'reminders',
    'deleteReminder',
    {
      'userKey': userKey,
      'reminderId': reminderId,
    },
  );
}

/// {@category Endpoint}
class EndpointShopping extends _i1.EndpointRef {
  EndpointShopping(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'shopping';

  /// Create a shopping list for the user.
  _i2.Future<_i9.ShoppingList> createShoppingList(
    String userKey,
    String name,
  ) => caller.callServerEndpoint<_i9.ShoppingList>(
    'shopping',
    'createShoppingList',
    {
      'userKey': userKey,
      'name': name,
    },
  );

  /// List shopping lists the user owns or is a member of.
  _i2.Future<List<_i9.ShoppingList>> listMyShoppingLists(String userKey) =>
      caller.callServerEndpoint<List<_i9.ShoppingList>>(
        'shopping',
        'listMyShoppingLists',
        {'userKey': userKey},
      );

  /// Add a shopping item.
  _i2.Future<_i10.ShoppingItem> addShoppingItem(
    String userKey,
    int listId,
    String text,
    String? category,
  ) => caller.callServerEndpoint<_i10.ShoppingItem>(
    'shopping',
    'addShoppingItem',
    {
      'userKey': userKey,
      'listId': listId,
      'text': text,
      'category': category,
    },
  );

  /// Toggle an item.
  _i2.Future<_i10.ShoppingItem?> toggleShoppingItem(
    String userKey,
    int itemId,
    bool isChecked,
  ) => caller.callServerEndpoint<_i10.ShoppingItem?>(
    'shopping',
    'toggleShoppingItem',
    {
      'userKey': userKey,
      'itemId': itemId,
      'isChecked': isChecked,
    },
  );

  /// Update an item's category.
  _i2.Future<_i10.ShoppingItem?> updateShoppingItemCategory(
    String userKey,
    int itemId,
    String category,
  ) => caller.callServerEndpoint<_i10.ShoppingItem?>(
    'shopping',
    'updateShoppingItemCategory',
    {
      'userKey': userKey,
      'itemId': itemId,
      'category': category,
    },
  );

  /// List items for a list.
  _i2.Future<List<_i10.ShoppingItem>> listShoppingItems(
    String userKey,
    int listId,
  ) => caller.callServerEndpoint<List<_i10.ShoppingItem>>(
    'shopping',
    'listShoppingItems',
    {
      'userKey': userKey,
      'listId': listId,
    },
  );

  /// Subscribe to realtime updates for a shopping list.
  _i2.Stream<_i11.ShoppingListEvent> subscribeShoppingList(
    String userKey,
    int listId,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i11.ShoppingListEvent>,
        _i11.ShoppingListEvent
      >(
        'shopping',
        'subscribeShoppingList',
        {
          'userKey': userKey,
          'listId': listId,
        },
        {},
      );

  /// Create an invite token for a list.
  _i2.Future<_i12.Invite> createInvite(
    String userKey,
    int listId,
    String role,
  ) => caller.callServerEndpoint<_i12.Invite>(
    'shopping',
    'createInvite',
    {
      'userKey': userKey,
      'listId': listId,
      'role': role,
    },
  );

  /// Accept an invite; returns list id.
  _i2.Future<int?> acceptInvite(
    String userKey,
    String token,
  ) => caller.callServerEndpoint<int?>(
    'shopping',
    'acceptInvite',
    {
      'userKey': userKey,
      'token': token,
    },
  );
}

/// {@category Endpoint}
class EndpointTasks extends _i1.EndpointRef {
  EndpointTasks(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'tasks';

  _i2.Future<List<_i13.TaskMessage>> listTasks(
    String userKey,
    int listId,
  ) => caller.callServerEndpoint<List<_i13.TaskMessage>>(
    'tasks',
    'listTasks',
    {
      'userKey': userKey,
      'listId': listId,
    },
  );

  _i2.Future<_i13.TaskMessage> addTask(
    String userKey,
    int listId,
    String text,
  ) => caller.callServerEndpoint<_i13.TaskMessage>(
    'tasks',
    'addTask',
    {
      'userKey': userKey,
      'listId': listId,
      'text': text,
    },
  );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i4.Caller(client);
    serverpod_auth_core = _i5.Caller(client);
  }

  late final _i4.Caller serverpod_auth_idp;

  late final _i5.Caller serverpod_auth_core;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i14.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    ai = EndpointAi(this);
    emailIdp = EndpointEmailIdp(this);
    firebaseIdp = EndpointFirebaseIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    debug = EndpointDebug(this);
    greeting = EndpointGreeting(this);
    import = EndpointImport(this);
    recipe = EndpointRecipe(this);
    reminders = EndpointReminders(this);
    shopping = EndpointShopping(this);
    tasks = EndpointTasks(this);
    modules = Modules(this);
  }

  late final EndpointAi ai;

  late final EndpointEmailIdp emailIdp;

  late final EndpointFirebaseIdp firebaseIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointDebug debug;

  late final EndpointGreeting greeting;

  late final EndpointImport import;

  late final EndpointRecipe recipe;

  late final EndpointReminders reminders;

  late final EndpointShopping shopping;

  late final EndpointTasks tasks;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'ai': ai,
    'emailIdp': emailIdp,
    'firebaseIdp': firebaseIdp,
    'jwtRefresh': jwtRefresh,
    'debug': debug,
    'greeting': greeting,
    'import': import,
    'recipe': recipe,
    'reminders': reminders,
    'shopping': shopping,
    'tasks': tasks,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
