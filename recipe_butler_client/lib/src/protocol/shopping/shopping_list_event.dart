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
import '../shopping/shopping_item.dart' as _i2;
import '../shopping/task_message.dart' as _i3;
import 'package:recipe_butler_client/src/protocol/protocol.dart' as _i4;

abstract class ShoppingListEvent implements _i1.SerializableModel {
  ShoppingListEvent._({
    required this.listId,
    required this.type,
    this.item,
    this.itemId,
    this.isChecked,
    this.category,
    this.text,
    this.task,
    this.taskId,
    this.updatedByUserId,
    required this.sentAt,
  });

  factory ShoppingListEvent({
    required int listId,
    required String type,
    _i2.ShoppingItem? item,
    int? itemId,
    bool? isChecked,
    String? category,
    String? text,
    _i3.TaskMessage? task,
    int? taskId,
    String? updatedByUserId,
    required DateTime sentAt,
  }) = _ShoppingListEventImpl;

  factory ShoppingListEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return ShoppingListEvent(
      listId: jsonSerialization['listId'] as int,
      type: jsonSerialization['type'] as String,
      item: jsonSerialization['item'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.ShoppingItem>(
              jsonSerialization['item'],
            ),
      itemId: jsonSerialization['itemId'] as int?,
      isChecked: jsonSerialization['isChecked'] as bool?,
      category: jsonSerialization['category'] as String?,
      text: jsonSerialization['text'] as String?,
      task: jsonSerialization['task'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.TaskMessage>(
              jsonSerialization['task'],
            ),
      taskId: jsonSerialization['taskId'] as int?,
      updatedByUserId: jsonSerialization['updatedByUserId'] as String?,
      sentAt: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['sentAt']),
    );
  }

  int listId;

  String type;

  _i2.ShoppingItem? item;

  int? itemId;

  bool? isChecked;

  String? category;

  String? text;

  _i3.TaskMessage? task;

  int? taskId;

  String? updatedByUserId;

  DateTime sentAt;

  /// Returns a shallow copy of this [ShoppingListEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShoppingListEvent copyWith({
    int? listId,
    String? type,
    _i2.ShoppingItem? item,
    int? itemId,
    bool? isChecked,
    String? category,
    String? text,
    _i3.TaskMessage? task,
    int? taskId,
    String? updatedByUserId,
    DateTime? sentAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShoppingListEvent',
      'listId': listId,
      'type': type,
      if (item != null) 'item': item?.toJson(),
      if (itemId != null) 'itemId': itemId,
      if (isChecked != null) 'isChecked': isChecked,
      if (category != null) 'category': category,
      if (text != null) 'text': text,
      if (task != null) 'task': task?.toJson(),
      if (taskId != null) 'taskId': taskId,
      if (updatedByUserId != null) 'updatedByUserId': updatedByUserId,
      'sentAt': sentAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShoppingListEventImpl extends ShoppingListEvent {
  _ShoppingListEventImpl({
    required int listId,
    required String type,
    _i2.ShoppingItem? item,
    int? itemId,
    bool? isChecked,
    String? category,
    String? text,
    _i3.TaskMessage? task,
    int? taskId,
    String? updatedByUserId,
    required DateTime sentAt,
  }) : super._(
         listId: listId,
         type: type,
         item: item,
         itemId: itemId,
         isChecked: isChecked,
         category: category,
         text: text,
         task: task,
         taskId: taskId,
         updatedByUserId: updatedByUserId,
         sentAt: sentAt,
       );

  /// Returns a shallow copy of this [ShoppingListEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ShoppingListEvent copyWith({
    int? listId,
    String? type,
    Object? item = _Undefined,
    Object? itemId = _Undefined,
    Object? isChecked = _Undefined,
    Object? category = _Undefined,
    Object? text = _Undefined,
    Object? task = _Undefined,
    Object? taskId = _Undefined,
    Object? updatedByUserId = _Undefined,
    DateTime? sentAt,
  }) {
    return ShoppingListEvent(
      listId: listId ?? this.listId,
      type: type ?? this.type,
      item: item is _i2.ShoppingItem? ? item : this.item?.copyWith(),
      itemId: itemId is int? ? itemId : this.itemId,
      isChecked: isChecked is bool? ? isChecked : this.isChecked,
      category: category is String? ? category : this.category,
      text: text is String? ? text : this.text,
      task: task is _i3.TaskMessage? ? task : this.task?.copyWith(),
      taskId: taskId is int? ? taskId : this.taskId,
      updatedByUserId: updatedByUserId is String?
          ? updatedByUserId
          : this.updatedByUserId,
      sentAt: sentAt ?? this.sentAt,
    );
  }
}
