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
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i3;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i4;
import 'ai/butler_reminder.dart' as _i5;
import 'ai/butler_shopping.dart' as _i6;
import 'ai/butler_suggestion.dart' as _i7;
import 'greetings/greeting.dart' as _i8;
import 'recipes/ingredient.dart' as _i9;
import 'recipes/recipe.dart' as _i10;
import 'recipes/recipe_step.dart' as _i11;
import 'shopping/invite.dart' as _i12;
import 'shopping/reminder.dart' as _i13;
import 'shopping/shopping_item.dart' as _i14;
import 'shopping/shopping_list.dart' as _i15;
import 'shopping/shopping_list_event.dart' as _i16;
import 'shopping/shopping_list_member.dart' as _i17;
import 'shopping/task_message.dart' as _i18;
import 'package:recipe_butler_server/src/generated/recipes/recipe.dart' as _i19;
import 'package:recipe_butler_server/src/generated/shopping/reminder.dart'
    as _i20;
import 'package:recipe_butler_server/src/generated/shopping/shopping_list.dart'
    as _i21;
import 'package:recipe_butler_server/src/generated/shopping/shopping_item.dart'
    as _i22;
import 'package:recipe_butler_server/src/generated/shopping/task_message.dart'
    as _i23;
export 'ai/butler_reminder.dart';
export 'ai/butler_shopping.dart';
export 'ai/butler_suggestion.dart';
export 'greetings/greeting.dart';
export 'recipes/ingredient.dart';
export 'recipes/recipe.dart';
export 'recipes/recipe_step.dart';
export 'shopping/invite.dart';
export 'shopping/reminder.dart';
export 'shopping/shopping_item.dart';
export 'shopping/shopping_list.dart';
export 'shopping/shopping_list_event.dart';
export 'shopping/shopping_list_member.dart';
export 'shopping/task_message.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'ingredient',
      dartName: 'Ingredient',
      schema: 'public',
      module: 'recipe_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'ingredient_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'recipeId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'text',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'ingredient_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'ingredient_recipe_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'recipeId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'invite',
      dartName: 'Invite',
      schema: 'public',
      module: 'recipe_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'invite_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'targetType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'targetId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'token',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'role',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'expiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'acceptedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'invite_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'invite_token_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'token',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'recipe',
      dartName: 'Recipe',
      schema: 'public',
      module: 'recipe_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'recipe_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'ownerUserId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'sourceUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'recipe_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'recipe_owner_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'ownerUserId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'recipe_step',
      dartName: 'RecipeStep',
      schema: 'public',
      module: 'recipe_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'recipe_step_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'recipeId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'orderIndex',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'text',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'recipe_step_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'step_recipe_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'recipeId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'reminder',
      dartName: 'Reminder',
      schema: 'public',
      module: 'recipe_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'reminder_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'shoppingListId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdByUserId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'dueAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'isDone',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'targetEmail',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'reminder_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'reminder_list_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'shoppingListId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'reminder_due_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'dueAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'shopping_item',
      dartName: 'ShoppingItem',
      schema: 'public',
      module: 'recipe_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'shopping_item_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'shoppingListId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'text',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'isChecked',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'category',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedByUserId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'shopping_item_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'shopping_item_list_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'shoppingListId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'shopping_list',
      dartName: 'ShoppingList',
      schema: 'public',
      module: 'recipe_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'shopping_list_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'ownerUserId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'shopping_list_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'shopping_list_owner_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'ownerUserId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'shopping_list_member',
      dartName: 'ShoppingListMember',
      schema: 'public',
      module: 'recipe_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'shopping_list_member_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'shoppingListId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'role',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'shopping_list_member_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'task_message',
      dartName: 'TaskMessage',
      schema: 'public',
      module: 'recipe_butler',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'task_message_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'shoppingListId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'text',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'task_message_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'task_message_list_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'shoppingListId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i5.ButlerReminder) {
      return _i5.ButlerReminder.fromJson(data) as T;
    }
    if (t == _i6.ButlerShopping) {
      return _i6.ButlerShopping.fromJson(data) as T;
    }
    if (t == _i7.ButlerSuggestion) {
      return _i7.ButlerSuggestion.fromJson(data) as T;
    }
    if (t == _i8.Greeting) {
      return _i8.Greeting.fromJson(data) as T;
    }
    if (t == _i9.Ingredient) {
      return _i9.Ingredient.fromJson(data) as T;
    }
    if (t == _i10.Recipe) {
      return _i10.Recipe.fromJson(data) as T;
    }
    if (t == _i11.RecipeStep) {
      return _i11.RecipeStep.fromJson(data) as T;
    }
    if (t == _i12.Invite) {
      return _i12.Invite.fromJson(data) as T;
    }
    if (t == _i13.Reminder) {
      return _i13.Reminder.fromJson(data) as T;
    }
    if (t == _i14.ShoppingItem) {
      return _i14.ShoppingItem.fromJson(data) as T;
    }
    if (t == _i15.ShoppingList) {
      return _i15.ShoppingList.fromJson(data) as T;
    }
    if (t == _i16.ShoppingListEvent) {
      return _i16.ShoppingListEvent.fromJson(data) as T;
    }
    if (t == _i17.ShoppingListMember) {
      return _i17.ShoppingListMember.fromJson(data) as T;
    }
    if (t == _i18.TaskMessage) {
      return _i18.TaskMessage.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.ButlerReminder?>()) {
      return (data != null ? _i5.ButlerReminder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.ButlerShopping?>()) {
      return (data != null ? _i6.ButlerShopping.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.ButlerSuggestion?>()) {
      return (data != null ? _i7.ButlerSuggestion.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Greeting?>()) {
      return (data != null ? _i8.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Ingredient?>()) {
      return (data != null ? _i9.Ingredient.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.Recipe?>()) {
      return (data != null ? _i10.Recipe.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.RecipeStep?>()) {
      return (data != null ? _i11.RecipeStep.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.Invite?>()) {
      return (data != null ? _i12.Invite.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.Reminder?>()) {
      return (data != null ? _i13.Reminder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.ShoppingItem?>()) {
      return (data != null ? _i14.ShoppingItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.ShoppingList?>()) {
      return (data != null ? _i15.ShoppingList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.ShoppingListEvent?>()) {
      return (data != null ? _i16.ShoppingListEvent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.ShoppingListMember?>()) {
      return (data != null ? _i17.ShoppingListMember.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.TaskMessage?>()) {
      return (data != null ? _i18.TaskMessage.fromJson(data) : null) as T;
    }
    if (t == List<_i6.ButlerShopping>) {
      return (data as List)
              .map((e) => deserialize<_i6.ButlerShopping>(e))
              .toList()
          as T;
    }
    if (t == List<_i5.ButlerReminder>) {
      return (data as List)
              .map((e) => deserialize<_i5.ButlerReminder>(e))
              .toList()
          as T;
    }
    if (t == List<_i19.Recipe>) {
      return (data as List).map((e) => deserialize<_i19.Recipe>(e)).toList()
          as T;
    }
    if (t == List<_i20.Reminder>) {
      return (data as List).map((e) => deserialize<_i20.Reminder>(e)).toList()
          as T;
    }
    if (t == List<_i21.ShoppingList>) {
      return (data as List)
              .map((e) => deserialize<_i21.ShoppingList>(e))
              .toList()
          as T;
    }
    if (t == List<_i22.ShoppingItem>) {
      return (data as List)
              .map((e) => deserialize<_i22.ShoppingItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i23.TaskMessage>) {
      return (data as List)
              .map((e) => deserialize<_i23.TaskMessage>(e))
              .toList()
          as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i5.ButlerReminder => 'ButlerReminder',
      _i6.ButlerShopping => 'ButlerShopping',
      _i7.ButlerSuggestion => 'ButlerSuggestion',
      _i8.Greeting => 'Greeting',
      _i9.Ingredient => 'Ingredient',
      _i10.Recipe => 'Recipe',
      _i11.RecipeStep => 'RecipeStep',
      _i12.Invite => 'Invite',
      _i13.Reminder => 'Reminder',
      _i14.ShoppingItem => 'ShoppingItem',
      _i15.ShoppingList => 'ShoppingList',
      _i16.ShoppingListEvent => 'ShoppingListEvent',
      _i17.ShoppingListMember => 'ShoppingListMember',
      _i18.TaskMessage => 'TaskMessage',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'recipe_butler.',
        '',
      );
    }

    switch (data) {
      case _i5.ButlerReminder():
        return 'ButlerReminder';
      case _i6.ButlerShopping():
        return 'ButlerShopping';
      case _i7.ButlerSuggestion():
        return 'ButlerSuggestion';
      case _i8.Greeting():
        return 'Greeting';
      case _i9.Ingredient():
        return 'Ingredient';
      case _i10.Recipe():
        return 'Recipe';
      case _i11.RecipeStep():
        return 'RecipeStep';
      case _i12.Invite():
        return 'Invite';
      case _i13.Reminder():
        return 'Reminder';
      case _i14.ShoppingItem():
        return 'ShoppingItem';
      case _i15.ShoppingList():
        return 'ShoppingList';
      case _i16.ShoppingListEvent():
        return 'ShoppingListEvent';
      case _i17.ShoppingListMember():
        return 'ShoppingListMember';
      case _i18.TaskMessage():
        return 'TaskMessage';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'ButlerReminder') {
      return deserialize<_i5.ButlerReminder>(data['data']);
    }
    if (dataClassName == 'ButlerShopping') {
      return deserialize<_i6.ButlerShopping>(data['data']);
    }
    if (dataClassName == 'ButlerSuggestion') {
      return deserialize<_i7.ButlerSuggestion>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i8.Greeting>(data['data']);
    }
    if (dataClassName == 'Ingredient') {
      return deserialize<_i9.Ingredient>(data['data']);
    }
    if (dataClassName == 'Recipe') {
      return deserialize<_i10.Recipe>(data['data']);
    }
    if (dataClassName == 'RecipeStep') {
      return deserialize<_i11.RecipeStep>(data['data']);
    }
    if (dataClassName == 'Invite') {
      return deserialize<_i12.Invite>(data['data']);
    }
    if (dataClassName == 'Reminder') {
      return deserialize<_i13.Reminder>(data['data']);
    }
    if (dataClassName == 'ShoppingItem') {
      return deserialize<_i14.ShoppingItem>(data['data']);
    }
    if (dataClassName == 'ShoppingList') {
      return deserialize<_i15.ShoppingList>(data['data']);
    }
    if (dataClassName == 'ShoppingListEvent') {
      return deserialize<_i16.ShoppingListEvent>(data['data']);
    }
    if (dataClassName == 'ShoppingListMember') {
      return deserialize<_i17.ShoppingListMember>(data['data']);
    }
    if (dataClassName == 'TaskMessage') {
      return deserialize<_i18.TaskMessage>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i4.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i9.Ingredient:
        return _i9.Ingredient.t;
      case _i10.Recipe:
        return _i10.Recipe.t;
      case _i11.RecipeStep:
        return _i11.RecipeStep.t;
      case _i12.Invite:
        return _i12.Invite.t;
      case _i13.Reminder:
        return _i13.Reminder.t;
      case _i14.ShoppingItem:
        return _i14.ShoppingItem.t;
      case _i15.ShoppingList:
        return _i15.ShoppingList.t;
      case _i17.ShoppingListMember:
        return _i17.ShoppingListMember.t;
      case _i18.TaskMessage:
        return _i18.TaskMessage.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'recipe_butler';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i4.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
