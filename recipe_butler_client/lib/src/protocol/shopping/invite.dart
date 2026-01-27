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

abstract class Invite implements _i1.SerializableModel {
  Invite._({
    this.id,
    required this.targetType,
    required this.targetId,
    required this.token,
    required this.role,
    this.expiresAt,
    this.acceptedAt,
  });

  factory Invite({
    int? id,
    required String targetType,
    required int targetId,
    required String token,
    required String role,
    DateTime? expiresAt,
    DateTime? acceptedAt,
  }) = _InviteImpl;

  factory Invite.fromJson(Map<String, dynamic> jsonSerialization) {
    return Invite(
      id: jsonSerialization['id'] as int?,
      targetType: jsonSerialization['targetType'] as String,
      targetId: jsonSerialization['targetId'] as int,
      token: jsonSerialization['token'] as String,
      role: jsonSerialization['role'] as String,
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      acceptedAt: jsonSerialization['acceptedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['acceptedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String targetType;

  int targetId;

  String token;

  String role;

  DateTime? expiresAt;

  DateTime? acceptedAt;

  /// Returns a shallow copy of this [Invite]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Invite copyWith({
    int? id,
    String? targetType,
    int? targetId,
    String? token,
    String? role,
    DateTime? expiresAt,
    DateTime? acceptedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Invite',
      if (id != null) 'id': id,
      'targetType': targetType,
      'targetId': targetId,
      'token': token,
      'role': role,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      if (acceptedAt != null) 'acceptedAt': acceptedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InviteImpl extends Invite {
  _InviteImpl({
    int? id,
    required String targetType,
    required int targetId,
    required String token,
    required String role,
    DateTime? expiresAt,
    DateTime? acceptedAt,
  }) : super._(
         id: id,
         targetType: targetType,
         targetId: targetId,
         token: token,
         role: role,
         expiresAt: expiresAt,
         acceptedAt: acceptedAt,
       );

  /// Returns a shallow copy of this [Invite]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Invite copyWith({
    Object? id = _Undefined,
    String? targetType,
    int? targetId,
    String? token,
    String? role,
    Object? expiresAt = _Undefined,
    Object? acceptedAt = _Undefined,
  }) {
    return Invite(
      id: id is int? ? id : this.id,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      token: token ?? this.token,
      role: role ?? this.role,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      acceptedAt: acceptedAt is DateTime? ? acceptedAt : this.acceptedAt,
    );
  }
}
