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

abstract class Reminder implements _i1.SerializableModel {
  Reminder._({
    this.id,
    required this.shoppingListId,
    required this.createdByUserId,
    required this.title,
    required this.dueAt,
    required this.isDone,
    required this.createdAt,
    this.targetEmail,
  });

  factory Reminder({
    int? id,
    required int shoppingListId,
    required String createdByUserId,
    required String title,
    required DateTime dueAt,
    required bool isDone,
    required DateTime createdAt,
    String? targetEmail,
  }) = _ReminderImpl;

  factory Reminder.fromJson(Map<String, dynamic> jsonSerialization) {
    return Reminder(
      id: jsonSerialization['id'] as int?,
      shoppingListId: jsonSerialization['shoppingListId'] as int,
      createdByUserId: jsonSerialization['createdByUserId'] as String,
      title: jsonSerialization['title'] as String,
      dueAt: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['dueAt']),
      isDone: jsonSerialization['isDone'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      targetEmail: jsonSerialization['targetEmail'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int shoppingListId;

  String createdByUserId;

  String title;

  DateTime dueAt;

  bool isDone;

  DateTime createdAt;

  String? targetEmail;

  /// Returns a shallow copy of this [Reminder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Reminder copyWith({
    int? id,
    int? shoppingListId,
    String? createdByUserId,
    String? title,
    DateTime? dueAt,
    bool? isDone,
    DateTime? createdAt,
    String? targetEmail,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Reminder',
      if (id != null) 'id': id,
      'shoppingListId': shoppingListId,
      'createdByUserId': createdByUserId,
      'title': title,
      'dueAt': dueAt.toJson(),
      'isDone': isDone,
      'createdAt': createdAt.toJson(),
      if (targetEmail != null) 'targetEmail': targetEmail,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReminderImpl extends Reminder {
  _ReminderImpl({
    int? id,
    required int shoppingListId,
    required String createdByUserId,
    required String title,
    required DateTime dueAt,
    required bool isDone,
    required DateTime createdAt,
    String? targetEmail,
  }) : super._(
         id: id,
         shoppingListId: shoppingListId,
         createdByUserId: createdByUserId,
         title: title,
         dueAt: dueAt,
         isDone: isDone,
         createdAt: createdAt,
         targetEmail: targetEmail,
       );

  /// Returns a shallow copy of this [Reminder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Reminder copyWith({
    Object? id = _Undefined,
    int? shoppingListId,
    String? createdByUserId,
    String? title,
    DateTime? dueAt,
    bool? isDone,
    DateTime? createdAt,
    Object? targetEmail = _Undefined,
  }) {
    return Reminder(
      id: id is int? ? id : this.id,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      title: title ?? this.title,
      dueAt: dueAt ?? this.dueAt,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
      targetEmail: targetEmail is String? ? targetEmail : this.targetEmail,
    );
  }
}
