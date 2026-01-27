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

abstract class TaskMessage implements _i1.SerializableModel {
  TaskMessage._({
    this.id,
    required this.shoppingListId,
    required this.userId,
    required this.text,
    required this.createdAt,
  });

  factory TaskMessage({
    int? id,
    required int shoppingListId,
    required String userId,
    required String text,
    required DateTime createdAt,
  }) = _TaskMessageImpl;

  factory TaskMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return TaskMessage(
      id: jsonSerialization['id'] as int?,
      shoppingListId: jsonSerialization['shoppingListId'] as int,
      userId: jsonSerialization['userId'] as String,
      text: jsonSerialization['text'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int shoppingListId;

  String userId;

  String text;

  DateTime createdAt;

  /// Returns a shallow copy of this [TaskMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TaskMessage copyWith({
    int? id,
    int? shoppingListId,
    String? userId,
    String? text,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TaskMessage',
      if (id != null) 'id': id,
      'shoppingListId': shoppingListId,
      'userId': userId,
      'text': text,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaskMessageImpl extends TaskMessage {
  _TaskMessageImpl({
    int? id,
    required int shoppingListId,
    required String userId,
    required String text,
    required DateTime createdAt,
  }) : super._(
         id: id,
         shoppingListId: shoppingListId,
         userId: userId,
         text: text,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TaskMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TaskMessage copyWith({
    Object? id = _Undefined,
    int? shoppingListId,
    String? userId,
    String? text,
    DateTime? createdAt,
  }) {
    return TaskMessage(
      id: id is int? ? id : this.id,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      userId: userId ?? this.userId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
