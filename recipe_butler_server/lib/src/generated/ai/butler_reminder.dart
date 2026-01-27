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

abstract class ButlerReminder
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ButlerReminder._({
    required this.title,
    this.dueIso,
    this.item,
  });

  factory ButlerReminder({
    required String title,
    String? dueIso,
    String? item,
  }) = _ButlerReminderImpl;

  factory ButlerReminder.fromJson(Map<String, dynamic> jsonSerialization) {
    return ButlerReminder(
      title: jsonSerialization['title'] as String,
      dueIso: jsonSerialization['dueIso'] as String?,
      item: jsonSerialization['item'] as String?,
    );
  }

  String title;

  String? dueIso;

  String? item;

  /// Returns a shallow copy of this [ButlerReminder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ButlerReminder copyWith({
    String? title,
    String? dueIso,
    String? item,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ButlerReminder',
      'title': title,
      if (dueIso != null) 'dueIso': dueIso,
      if (item != null) 'item': item,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ButlerReminder',
      'title': title,
      if (dueIso != null) 'dueIso': dueIso,
      if (item != null) 'item': item,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ButlerReminderImpl extends ButlerReminder {
  _ButlerReminderImpl({
    required String title,
    String? dueIso,
    String? item,
  }) : super._(
         title: title,
         dueIso: dueIso,
         item: item,
       );

  /// Returns a shallow copy of this [ButlerReminder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ButlerReminder copyWith({
    String? title,
    Object? dueIso = _Undefined,
    Object? item = _Undefined,
  }) {
    return ButlerReminder(
      title: title ?? this.title,
      dueIso: dueIso is String? ? dueIso : this.dueIso,
      item: item is String? ? item : this.item,
    );
  }
}
