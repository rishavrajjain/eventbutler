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
import 'ai/butler_reminder.dart' as _i2;
import 'ai/butler_shopping.dart' as _i3;
import 'ai/butler_suggestion.dart' as _i4;
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
import 'package:recipe_butler_client/src/protocol/recipes/recipe.dart' as _i16;
import 'package:recipe_butler_client/src/protocol/shopping/reminder.dart'
    as _i17;
import 'package:recipe_butler_client/src/protocol/shopping/shopping_list.dart'
    as _i18;
import 'package:recipe_butler_client/src/protocol/shopping/shopping_item.dart'
    as _i19;
import 'package:recipe_butler_client/src/protocol/shopping/task_message.dart'
    as _i20;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i21;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i22;
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

    if (t == _i2.ButlerReminder) {
      return _i2.ButlerReminder.fromJson(data) as T;
    }
    if (t == _i3.ButlerShopping) {
      return _i3.ButlerShopping.fromJson(data) as T;
    }
    if (t == _i4.ButlerSuggestion) {
      return _i4.ButlerSuggestion.fromJson(data) as T;
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
    if (t == _i1.getType<_i2.ButlerReminder?>()) {
      return (data != null ? _i2.ButlerReminder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.ButlerShopping?>()) {
      return (data != null ? _i3.ButlerShopping.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.ButlerSuggestion?>()) {
      return (data != null ? _i4.ButlerSuggestion.fromJson(data) : null) as T;
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
    if (t == List<_i3.ButlerShopping>) {
      return (data as List)
              .map((e) => deserialize<_i3.ButlerShopping>(e))
              .toList()
          as T;
    }
    if (t == List<_i2.ButlerReminder>) {
      return (data as List)
              .map((e) => deserialize<_i2.ButlerReminder>(e))
              .toList()
          as T;
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
      return _i21.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i22.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.ButlerReminder => 'ButlerReminder',
      _i3.ButlerShopping => 'ButlerShopping',
      _i4.ButlerSuggestion => 'ButlerSuggestion',
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
      case _i2.ButlerReminder():
        return 'ButlerReminder';
      case _i3.ButlerShopping():
        return 'ButlerShopping';
      case _i4.ButlerSuggestion():
        return 'ButlerSuggestion';
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
    className = _i21.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i22.Protocol().getClassNameForObject(data);
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
      return deserialize<_i2.ButlerReminder>(data['data']);
    }
    if (dataClassName == 'ButlerShopping') {
      return deserialize<_i3.ButlerShopping>(data['data']);
    }
    if (dataClassName == 'ButlerSuggestion') {
      return deserialize<_i4.ButlerSuggestion>(data['data']);
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
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i21.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i22.Protocol().deserializeByClassName(data);
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
      return _i21.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i22.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
