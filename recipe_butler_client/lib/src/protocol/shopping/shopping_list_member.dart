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

abstract class ShoppingListMember implements _i1.SerializableModel {
  ShoppingListMember._({
    this.id,
    required this.shoppingListId,
    required this.userId,
    required this.role,
  });

  factory ShoppingListMember({
    int? id,
    required int shoppingListId,
    required String userId,
    required String role,
  }) = _ShoppingListMemberImpl;

  factory ShoppingListMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return ShoppingListMember(
      id: jsonSerialization['id'] as int?,
      shoppingListId: jsonSerialization['shoppingListId'] as int,
      userId: jsonSerialization['userId'] as String,
      role: jsonSerialization['role'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int shoppingListId;

  String userId;

  String role;

  /// Returns a shallow copy of this [ShoppingListMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShoppingListMember copyWith({
    int? id,
    int? shoppingListId,
    String? userId,
    String? role,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShoppingListMember',
      if (id != null) 'id': id,
      'shoppingListId': shoppingListId,
      'userId': userId,
      'role': role,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShoppingListMemberImpl extends ShoppingListMember {
  _ShoppingListMemberImpl({
    int? id,
    required int shoppingListId,
    required String userId,
    required String role,
  }) : super._(
         id: id,
         shoppingListId: shoppingListId,
         userId: userId,
         role: role,
       );

  /// Returns a shallow copy of this [ShoppingListMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ShoppingListMember copyWith({
    Object? id = _Undefined,
    int? shoppingListId,
    String? userId,
    String? role,
  }) {
    return ShoppingListMember(
      id: id is int? ? id : this.id,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
    );
  }
}
