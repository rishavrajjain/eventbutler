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
import 'greetings/greeting.dart' as _i5;
import 'recipes/ingredient.dart' as _i6;
import 'recipes/recipe.dart' as _i7;
import 'recipes/recipe_step.dart' as _i8;
import 'shopping/invite.dart' as _i9;
import 'shopping/reminder.dart' as _i10;
import 'shopping/shopping_item.dart' as _i11;
import 'shopping/shopping_list.dart' as _i12;
import 'shopping/shopping_list_event.dart' as _i13;
import 'shopping/shopping_list_member.dart' as _i14;
import 'shopping/task_message.dart' as _i15;
import 'package:recipe_butler_server/src/generated/recipes/recipe.dart' as _i16;
import 'package:recipe_butler_server/src/generated/shopping/reminder.dart'
    as _i17;
import 'package:recipe_butler_server/src/generated/shopping/shopping_list.dart'
    as _i18;
import 'package:recipe_butler_server/src/generated/shopping/shopping_item.dart'
    as _i19;
import 'package:recipe_butler_server/src/generated/shopping/task_message.dart'
    as _i20;
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

    if (t == _i5.Greeting) {
      return _i5.Greeting.fromJson(data) as T;
    }
    if (t == _i6.Ingredient) {
      return _i6.Ingredient.fromJson(data) as T;
    }
    if (t == _i7.Recipe) {
      return _i7.Recipe.fromJson(data) as T;
    }
    if (t == _i8.RecipeStep) {
      return _i8.RecipeStep.fromJson(data) as T;
    }
    if (t == _i9.Invite) {
      return _i9.Invite.fromJson(data) as T;
    }
    if (t == _i10.Reminder) {
      return _i10.Reminder.fromJson(data) as T;
    }
    if (t == _i11.ShoppingItem) {
      return _i11.ShoppingItem.fromJson(data) as T;
    }
    if (t == _i12.ShoppingList) {
      return _i12.ShoppingList.fromJson(data) as T;
    }
    if (t == _i13.ShoppingListEvent) {
      return _i13.ShoppingListEvent.fromJson(data) as T;
    }
    if (t == _i14.ShoppingListMember) {
      return _i14.ShoppingListMember.fromJson(data) as T;
    }
    if (t == _i15.TaskMessage) {
      return _i15.TaskMessage.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.Greeting?>()) {
      return (data != null ? _i5.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Ingredient?>()) {
      return (data != null ? _i6.Ingredient.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Recipe?>()) {
      return (data != null ? _i7.Recipe.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.RecipeStep?>()) {
      return (data != null ? _i8.RecipeStep.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Invite?>()) {
      return (data != null ? _i9.Invite.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.Reminder?>()) {
      return (data != null ? _i10.Reminder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.ShoppingItem?>()) {
      return (data != null ? _i11.ShoppingItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.ShoppingList?>()) {
      return (data != null ? _i12.ShoppingList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.ShoppingListEvent?>()) {
      return (data != null ? _i13.ShoppingListEvent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.ShoppingListMember?>()) {
      return (data != null ? _i14.ShoppingListMember.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.TaskMessage?>()) {
      return (data != null ? _i15.TaskMessage.fromJson(data) : null) as T;
    }
    if (t == List<_i16.Recipe>) {
      return (data as List).map((e) => deserialize<_i16.Recipe>(e)).toList()
          as T;
    }
    if (t == List<_i17.Reminder>) {
      return (data as List).map((e) => deserialize<_i17.Reminder>(e)).toList()
          as T;
    }
    if (t == List<_i18.ShoppingList>) {
      return (data as List)
              .map((e) => deserialize<_i18.ShoppingList>(e))
              .toList()
          as T;
    }
    if (t == List<_i19.ShoppingItem>) {
      return (data as List)
              .map((e) => deserialize<_i19.ShoppingItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i20.TaskMessage>) {
      return (data as List)
              .map((e) => deserialize<_i20.TaskMessage>(e))
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
      _i5.Greeting => 'Greeting',
      _i6.Ingredient => 'Ingredient',
      _i7.Recipe => 'Recipe',
      _i8.RecipeStep => 'RecipeStep',
      _i9.Invite => 'Invite',
      _i10.Reminder => 'Reminder',
      _i11.ShoppingItem => 'ShoppingItem',
      _i12.ShoppingList => 'ShoppingList',
      _i13.ShoppingListEvent => 'ShoppingListEvent',
      _i14.ShoppingListMember => 'ShoppingListMember',
      _i15.TaskMessage => 'TaskMessage',
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
      case _i5.Greeting():
        return 'Greeting';
      case _i6.Ingredient():
        return 'Ingredient';
      case _i7.Recipe():
        return 'Recipe';
      case _i8.RecipeStep():
        return 'RecipeStep';
      case _i9.Invite():
        return 'Invite';
      case _i10.Reminder():
        return 'Reminder';
      case _i11.ShoppingItem():
        return 'ShoppingItem';
      case _i12.ShoppingList():
        return 'ShoppingList';
      case _i13.ShoppingListEvent():
        return 'ShoppingListEvent';
      case _i14.ShoppingListMember():
        return 'ShoppingListMember';
      case _i15.TaskMessage():
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
    if (dataClassName == 'Greeting') {
      return deserialize<_i5.Greeting>(data['data']);
    }
    if (dataClassName == 'Ingredient') {
      return deserialize<_i6.Ingredient>(data['data']);
    }
    if (dataClassName == 'Recipe') {
      return deserialize<_i7.Recipe>(data['data']);
    }
    if (dataClassName == 'RecipeStep') {
      return deserialize<_i8.RecipeStep>(data['data']);
    }
    if (dataClassName == 'Invite') {
      return deserialize<_i9.Invite>(data['data']);
    }
    if (dataClassName == 'Reminder') {
      return deserialize<_i10.Reminder>(data['data']);
    }
    if (dataClassName == 'ShoppingItem') {
      return deserialize<_i11.ShoppingItem>(data['data']);
    }
    if (dataClassName == 'ShoppingList') {
      return deserialize<_i12.ShoppingList>(data['data']);
    }
    if (dataClassName == 'ShoppingListEvent') {
      return deserialize<_i13.ShoppingListEvent>(data['data']);
    }
    if (dataClassName == 'ShoppingListMember') {
      return deserialize<_i14.ShoppingListMember>(data['data']);
    }
    if (dataClassName == 'TaskMessage') {
      return deserialize<_i15.TaskMessage>(data['data']);
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
      case _i6.Ingredient:
        return _i6.Ingredient.t;
      case _i7.Recipe:
        return _i7.Recipe.t;
      case _i8.RecipeStep:
        return _i8.RecipeStep.t;
      case _i9.Invite:
        return _i9.Invite.t;
      case _i10.Reminder:
        return _i10.Reminder.t;
      case _i11.ShoppingItem:
        return _i11.ShoppingItem.t;
      case _i12.ShoppingList:
        return _i12.ShoppingList.t;
      case _i14.ShoppingListMember:
        return _i14.ShoppingListMember.t;
      case _i15.TaskMessage:
        return _i15.TaskMessage.t;
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
