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
import 'greetings/greeting.dart' as _i2;
import 'recipes/ingredient.dart' as _i3;
import 'recipes/recipe.dart' as _i4;
import 'recipes/recipe_step.dart' as _i5;
import 'shopping/invite.dart' as _i6;
import 'shopping/reminder.dart' as _i7;
import 'shopping/shopping_item.dart' as _i8;
import 'shopping/shopping_list.dart' as _i9;
import 'shopping/shopping_list_event.dart' as _i10;
import 'shopping/shopping_list_member.dart' as _i11;
import 'shopping/task_message.dart' as _i12;
import 'package:recipe_butler_client/src/protocol/recipes/recipe.dart' as _i13;
import 'package:recipe_butler_client/src/protocol/shopping/reminder.dart'
    as _i14;
import 'package:recipe_butler_client/src/protocol/shopping/shopping_list.dart'
    as _i15;
import 'package:recipe_butler_client/src/protocol/shopping/shopping_item.dart'
    as _i16;
import 'package:recipe_butler_client/src/protocol/shopping/task_message.dart'
    as _i17;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i18;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i19;
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
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

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

    if (t == _i2.Greeting) {
      return _i2.Greeting.fromJson(data) as T;
    }
    if (t == _i3.Ingredient) {
      return _i3.Ingredient.fromJson(data) as T;
    }
    if (t == _i4.Recipe) {
      return _i4.Recipe.fromJson(data) as T;
    }
    if (t == _i5.RecipeStep) {
      return _i5.RecipeStep.fromJson(data) as T;
    }
    if (t == _i6.Invite) {
      return _i6.Invite.fromJson(data) as T;
    }
    if (t == _i7.Reminder) {
      return _i7.Reminder.fromJson(data) as T;
    }
    if (t == _i8.ShoppingItem) {
      return _i8.ShoppingItem.fromJson(data) as T;
    }
    if (t == _i9.ShoppingList) {
      return _i9.ShoppingList.fromJson(data) as T;
    }
    if (t == _i10.ShoppingListEvent) {
      return _i10.ShoppingListEvent.fromJson(data) as T;
    }
    if (t == _i11.ShoppingListMember) {
      return _i11.ShoppingListMember.fromJson(data) as T;
    }
    if (t == _i12.TaskMessage) {
      return _i12.TaskMessage.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Greeting?>()) {
      return (data != null ? _i2.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Ingredient?>()) {
      return (data != null ? _i3.Ingredient.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Recipe?>()) {
      return (data != null ? _i4.Recipe.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.RecipeStep?>()) {
      return (data != null ? _i5.RecipeStep.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Invite?>()) {
      return (data != null ? _i6.Invite.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Reminder?>()) {
      return (data != null ? _i7.Reminder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.ShoppingItem?>()) {
      return (data != null ? _i8.ShoppingItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.ShoppingList?>()) {
      return (data != null ? _i9.ShoppingList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.ShoppingListEvent?>()) {
      return (data != null ? _i10.ShoppingListEvent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.ShoppingListMember?>()) {
      return (data != null ? _i11.ShoppingListMember.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.TaskMessage?>()) {
      return (data != null ? _i12.TaskMessage.fromJson(data) : null) as T;
    }
    if (t == List<_i13.Recipe>) {
      return (data as List).map((e) => deserialize<_i13.Recipe>(e)).toList()
          as T;
    }
    if (t == List<_i14.Reminder>) {
      return (data as List).map((e) => deserialize<_i14.Reminder>(e)).toList()
          as T;
    }
    if (t == List<_i15.ShoppingList>) {
      return (data as List)
              .map((e) => deserialize<_i15.ShoppingList>(e))
              .toList()
          as T;
    }
    if (t == List<_i16.ShoppingItem>) {
      return (data as List)
              .map((e) => deserialize<_i16.ShoppingItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i17.TaskMessage>) {
      return (data as List)
              .map((e) => deserialize<_i17.TaskMessage>(e))
              .toList()
          as T;
    }
    try {
      return _i18.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i19.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Greeting => 'Greeting',
      _i3.Ingredient => 'Ingredient',
      _i4.Recipe => 'Recipe',
      _i5.RecipeStep => 'RecipeStep',
      _i6.Invite => 'Invite',
      _i7.Reminder => 'Reminder',
      _i8.ShoppingItem => 'ShoppingItem',
      _i9.ShoppingList => 'ShoppingList',
      _i10.ShoppingListEvent => 'ShoppingListEvent',
      _i11.ShoppingListMember => 'ShoppingListMember',
      _i12.TaskMessage => 'TaskMessage',
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
      case _i2.Greeting():
        return 'Greeting';
      case _i3.Ingredient():
        return 'Ingredient';
      case _i4.Recipe():
        return 'Recipe';
      case _i5.RecipeStep():
        return 'RecipeStep';
      case _i6.Invite():
        return 'Invite';
      case _i7.Reminder():
        return 'Reminder';
      case _i8.ShoppingItem():
        return 'ShoppingItem';
      case _i9.ShoppingList():
        return 'ShoppingList';
      case _i10.ShoppingListEvent():
        return 'ShoppingListEvent';
      case _i11.ShoppingListMember():
        return 'ShoppingListMember';
      case _i12.TaskMessage():
        return 'TaskMessage';
    }
    className = _i18.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i19.Protocol().getClassNameForObject(data);
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
      return deserialize<_i2.Greeting>(data['data']);
    }
    if (dataClassName == 'Ingredient') {
      return deserialize<_i3.Ingredient>(data['data']);
    }
    if (dataClassName == 'Recipe') {
      return deserialize<_i4.Recipe>(data['data']);
    }
    if (dataClassName == 'RecipeStep') {
      return deserialize<_i5.RecipeStep>(data['data']);
    }
    if (dataClassName == 'Invite') {
      return deserialize<_i6.Invite>(data['data']);
    }
    if (dataClassName == 'Reminder') {
      return deserialize<_i7.Reminder>(data['data']);
    }
    if (dataClassName == 'ShoppingItem') {
      return deserialize<_i8.ShoppingItem>(data['data']);
    }
    if (dataClassName == 'ShoppingList') {
      return deserialize<_i9.ShoppingList>(data['data']);
    }
    if (dataClassName == 'ShoppingListEvent') {
      return deserialize<_i10.ShoppingListEvent>(data['data']);
    }
    if (dataClassName == 'ShoppingListMember') {
      return deserialize<_i11.ShoppingListMember>(data['data']);
    }
    if (dataClassName == 'TaskMessage') {
      return deserialize<_i12.TaskMessage>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i18.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i19.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

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
      return _i18.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i19.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
