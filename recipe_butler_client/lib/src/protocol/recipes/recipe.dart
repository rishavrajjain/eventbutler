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

/// Recipe model
abstract class Recipe implements _i1.SerializableModel {
  Recipe._({
    this.id,
    required this.ownerUserId,
    required this.title,
    this.sourceUrl,
    required this.createdAt,
  });

  factory Recipe({
    int? id,
    required String ownerUserId,
    required String title,
    String? sourceUrl,
    required DateTime createdAt,
  }) = _RecipeImpl;

  factory Recipe.fromJson(Map<String, dynamic> jsonSerialization) {
    return Recipe(
      id: jsonSerialization['id'] as int?,
      ownerUserId: jsonSerialization['ownerUserId'] as String,
      title: jsonSerialization['title'] as String,
      sourceUrl: jsonSerialization['sourceUrl'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String ownerUserId;

  String title;

  String? sourceUrl;

  DateTime createdAt;

  /// Returns a shallow copy of this [Recipe]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Recipe copyWith({
    int? id,
    String? ownerUserId,
    String? title,
    String? sourceUrl,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Recipe',
      if (id != null) 'id': id,
      'ownerUserId': ownerUserId,
      'title': title,
      if (sourceUrl != null) 'sourceUrl': sourceUrl,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RecipeImpl extends Recipe {
  _RecipeImpl({
    int? id,
    required String ownerUserId,
    required String title,
    String? sourceUrl,
    required DateTime createdAt,
  }) : super._(
         id: id,
         ownerUserId: ownerUserId,
         title: title,
         sourceUrl: sourceUrl,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Recipe]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Recipe copyWith({
    Object? id = _Undefined,
    String? ownerUserId,
    String? title,
    Object? sourceUrl = _Undefined,
    DateTime? createdAt,
  }) {
    return Recipe(
      id: id is int? ? id : this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      title: title ?? this.title,
      sourceUrl: sourceUrl is String? ? sourceUrl : this.sourceUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
