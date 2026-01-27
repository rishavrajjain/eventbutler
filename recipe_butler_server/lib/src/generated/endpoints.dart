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
import 'package:serverpod/serverpod.dart' as _i1;
import '../auth/email_idp_endpoint.dart' as _i2;
import '../auth/firebase_idp_endpoint.dart' as _i3;
import '../auth/jwt_refresh_endpoint.dart' as _i4;
import '../endpoints/debug_endpoint.dart' as _i5;
import '../greetings/greeting_endpoint.dart' as _i6;
import '../import/import_endpoint.dart' as _i7;
import '../recipes/recipe_endpoint.dart' as _i8;
import '../shopping/reminders_endpoint.dart' as _i9;
import '../shopping/shopping_endpoint.dart' as _i10;
import '../shopping/tasks_endpoint.dart' as _i11;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i12;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i13;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailIdp': _i2.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'firebaseIdp': _i3.FirebaseIdpEndpoint()
        ..initialize(
          server,
          'firebaseIdp',
          null,
        ),
      'jwtRefresh': _i4.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'debug': _i5.DebugEndpoint()
        ..initialize(
          server,
          'debug',
          null,
        ),
      'greeting': _i6.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
      'import': _i7.ImportEndpoint()
        ..initialize(
          server,
          'import',
          null,
        ),
      'recipe': _i8.RecipeEndpoint()
        ..initialize(
          server,
          'recipe',
          null,
        ),
      'reminders': _i9.RemindersEndpoint()
        ..initialize(
          server,
          'reminders',
          null,
        ),
      'shopping': _i10.ShoppingEndpoint()
        ..initialize(
          server,
          'shopping',
          null,
        ),
      'tasks': _i11.TasksEndpoint()
        ..initialize(
          server,
          'tasks',
          null,
        ),
    };
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
      },
    );
    connectors['firebaseIdp'] = _i1.EndpointConnector(
      name: 'firebaseIdp',
      endpoint: endpoints['firebaseIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['firebaseIdp'] as _i3.FirebaseIdpEndpoint).login(
                    session,
                    idToken: params['idToken'],
                  ),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i4.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['debug'] = _i1.EndpointConnector(
      name: 'debug',
      endpoint: endpoints['debug']!,
      methodConnectors: {
        'checkFirebaseSecret': _i1.MethodConnector(
          name: 'checkFirebaseSecret',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['debug'] as _i5.DebugEndpoint)
                  .checkFirebaseSecret(session),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i6.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    connectors['import'] = _i1.EndpointConnector(
      name: 'import',
      endpoint: endpoints['import']!,
      methodConnectors: {
        'importRecipeFromUrl': _i1.MethodConnector(
          name: 'importRecipeFromUrl',
          params: {
            'userKey': _i1.ParameterDescription(
              name: 'userKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'url': _i1.ParameterDescription(
              name: 'url',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['import'] as _i7.ImportEndpoint)
                  .importRecipeFromUrl(
                    session,
                    params['userKey'],
                    params['url'],
                  ),
        ),
      },
    );
    connectors['recipe'] = _i1.EndpointConnector(
      name: 'recipe',
      endpoint: endpoints['recipe']!,
      methodConnectors: {
        'createRecipe': _i1.MethodConnector(
          name: 'createRecipe',
          params: {
            'userKey': _i1.ParameterDescription(
              name: 'userKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'sourceUrl': _i1.ParameterDescription(
              name: 'sourceUrl',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recipe'] as _i8.RecipeEndpoint).createRecipe(
                    session,
                    params['userKey'],
                    params['title'],
                    sourceUrl: params['sourceUrl'],
                  ),
        ),
        'listMyRecipes': _i1.MethodConnector(
          name: 'listMyRecipes',
          params: {
            'userKey': _i1.ParameterDescription(
              name: 'userKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recipe'] as _i8.RecipeEndpoint).listMyRecipes(
                    session,
                    params['userKey'],
                  ),
        ),
        'getRecipe': _i1.MethodConnector(
          name: 'getRecipe',
          params: {
            'userKey': _i1.ParameterDescription(
              name: 'userKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'recipeId': _i1.ParameterDescription(
              name: 'recipeId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['recipe'] as _i8.RecipeEndpoint).getRecipe(
                session,
                params['userKey'],
                params['recipeId'],
              ),
        ),
        'deleteRecipe': _i1.MethodConnector(
          name: 'deleteRecipe',
          params: {
            'userKey': _i1.ParameterDescription(
              name: 'userKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'recipeId': _i1.ParameterDescription(
              name: 'recipeId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recipe'] as _i8.RecipeEndpoint).deleteRecipe(
                    session,
                    params['userKey'],
                    params['recipeId'],
                  ),
        ),
      },
    );
    connectors['reminders'] = _i1.EndpointConnector(
      name: 'reminders',
      endpoint: endpoints['reminders']!,
      methodConnectors: {
        'listMyReminders': _i1.MethodConnector(
          name: 'listMyReminders',
          params: {
            'userKey': _i1.ParameterDescription(
              name: 'userKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'after': _i1.ParameterDescription(
              name: 'after',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reminders'] as _i9.RemindersEndpoint)
                  .listMyReminders(
                    session,
                    params['userKey'],
                    after: params['after'],
                  ),
        ),
        'listRemindersForList': _i1.MethodConnector(
          name: 'listRemindersForList',
          params: {
            'userKey': _i1.ParameterDescription(
              name: 'userKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'listId': _i1.ParameterDescription(
              name: 'listId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reminders'] as _i9.RemindersEndpoint)
                  .listRemindersForList(
                    session,
                    params['userKey'],
                    params['listId'],
                  ),
        ),
        'addReminder': _i1.MethodConnector(
          name: 'addReminder',
          params: {
            'userKey': _i1.ParameterDescription(
              name: 'userKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'listId': _i1.ParameterDescription(
              name: 'listId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'dueAt': _i1.ParameterDescription(
              name: 'dueAt',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'targetEmail': _i1.ParameterDescription(
              name: 'targetEmail',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['reminders'] as _i9.RemindersEndpoint).addReminder(
                    session,
                    params['userKey'],
                    params['listId'],
                    params['title'],
                    params['dueAt'],
                    params['targetEmail'],
                  ),
        ),
        'toggleReminder': _i1.MethodConnector(
          name: 'toggleReminder',
          params: {
            'userKey': _i1.ParameterDescription(
              name: 'userKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'reminderId': _i1.ParameterDescription(
              name: 'reminderId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'isDone': _i1.ParameterDescription(
              name: 'isDone',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reminders'] as _i9.RemindersEndpoint)
                  .toggleReminder(
                    session,
                    params['userKey'],
                    params['reminderId'],
                    params['isDone'],
                  ),
        ),
        'deleteReminder': _i1.MethodConnector(
          name: 'deleteReminder',
          params: {
            'userKey': _i1.ParameterDescription(
              name: 'userKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'reminderId': _i1.ParameterDescription(
              name: 'reminderId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reminders'] as _i9.RemindersEndpoint)
                  .deleteReminder(
                    session,
                    params['userKey'],
                    params['reminderId'],
                  ),
        ),
      },
    );
    connectors['shopping'] = _i1.EndpointConnector(
      name: 'shopping',
      endpoint: endpoints['shopping']!,
      methodConnectors: {
        'createShoppingList': _i1.MethodConnector(
          name: 'createShoppingList',
          params: {
            'userKey': _i1.ParameterDescription(
              name: 'userKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shopping'] as _i10.ShoppingEndpoint)
                  .createShoppingList(
                    session,
                    params['userKey'],
                    params['name'],
                  ),
        ),
        'listMyShoppingLists': _i1.MethodConnector(
          name: 'listMyShoppingLists',
          params: {
            'userKey': _i1.ParameterDescription(
              name: 'userKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shopping'] as _i10.ShoppingEndpoint)
                  .listMyShoppingLists(
                    session,
                    params['userKey'],
                  ),
        ),
        'addShoppingItem': _i1.MethodConnector(
          name: 'addShoppingItem',
          params: {
            'userKey': _i1.ParameterDescription(
              name: 'userKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'listId': _i1.ParameterDescription(
              name: 'listId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'text': _i1.ParameterDescription(
              name: 'text',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shopping'] as _i10.ShoppingEndpoint)
                  .addShoppingItem(
                    session,
                    params['userKey'],
                    params['listId'],
                    params['text'],
                    params['category'],
                  ),
        ),
        'toggleShoppingItem': _i1.MethodConnector(
          name: 'toggleShoppingItem',
          params: {
            'userKey': _i1.ParameterDescription(
              name: 'userKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'itemId': _i1.ParameterDescription(
              name: 'itemId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'isChecked': _i1.ParameterDescription(
              name: 'isChecked',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shopping'] as _i10.ShoppingEndpoint)
                  .toggleShoppingItem(
                    session,
                    params['userKey'],
                    params['itemId'],
                    params['isChecked'],
                  ),
        ),
        'updateShoppingItemCategory': _i1.MethodConnector(
          name: 'updateShoppingItemCategory',
          params: {
            'userKey': _i1.ParameterDescription(
              name: 'userKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'itemId': _i1.ParameterDescription(
              name: 'itemId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shopping'] as _i10.ShoppingEndpoint)
                  .updateShoppingItemCategory(
                    session,
                    params['userKey'],
                    params['itemId'],
                    params['category'],
                  ),
        ),
        'listShoppingItems': _i1.MethodConnector(
          name: 'listShoppingItems',
          params: {
            'userKey': _i1.ParameterDescription(
              name: 'userKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'listId': _i1.ParameterDescription(
              name: 'listId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shopping'] as _i10.ShoppingEndpoint)
                  .listShoppingItems(
                    session,
                    params['userKey'],
                    params['listId'],
                  ),
        ),
        'createInvite': _i1.MethodConnector(
          name: 'createInvite',
          params: {
            'userKey': _i1.ParameterDescription(
              name: 'userKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'listId': _i1.ParameterDescription(
              name: 'listId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'role': _i1.ParameterDescription(
              name: 'role',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['shopping'] as _i10.ShoppingEndpoint).createInvite(
                    session,
                    params['userKey'],
                    params['listId'],
                    params['role'],
                  ),
        ),
        'acceptInvite': _i1.MethodConnector(
          name: 'acceptInvite',
          params: {
            'userKey': _i1.ParameterDescription(
              name: 'userKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['shopping'] as _i10.ShoppingEndpoint).acceptInvite(
                    session,
                    params['userKey'],
                    params['token'],
                  ),
        ),
        'subscribeShoppingList': _i1.MethodStreamConnector(
          name: 'subscribeShoppingList',
          params: {
            'userKey': _i1.ParameterDescription(
              name: 'userKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'listId': _i1.ParameterDescription(
              name: 'listId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['shopping'] as _i10.ShoppingEndpoint)
                  .subscribeShoppingList(
                    session,
                    params['userKey'],
                    params['listId'],
                  ),
        ),
      },
    );
    connectors['tasks'] = _i1.EndpointConnector(
      name: 'tasks',
      endpoint: endpoints['tasks']!,
      methodConnectors: {
        'listTasks': _i1.MethodConnector(
          name: 'listTasks',
          params: {
            'userKey': _i1.ParameterDescription(
              name: 'userKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'listId': _i1.ParameterDescription(
              name: 'listId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['tasks'] as _i11.TasksEndpoint).listTasks(
                session,
                params['userKey'],
                params['listId'],
              ),
        ),
        'addTask': _i1.MethodConnector(
          name: 'addTask',
          params: {
            'userKey': _i1.ParameterDescription(
              name: 'userKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'listId': _i1.ParameterDescription(
              name: 'listId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'text': _i1.ParameterDescription(
              name: 'text',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['tasks'] as _i11.TasksEndpoint).addTask(
                session,
                params['userKey'],
                params['listId'],
                params['text'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i12.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i13.Endpoints()
      ..initializeEndpoints(server);
  }
}
