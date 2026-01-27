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

abstract class Ingredient implements _i1.SerializableModel {
  Ingredient._({
    this.id,
    required this.recipeId,
    required this.text,
  });

  factory Ingredient({
    int? id,
    required int recipeId,
    required String text,
  }) = _IngredientImpl;

  factory Ingredient.fromJson(Map<String, dynamic> jsonSerialization) {
    return Ingredient(
      id: jsonSerialization['id'] as int?,
      recipeId: jsonSerialization['recipeId'] as int,
      text: jsonSerialization['text'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int recipeId;

  String text;

  /// Returns a shallow copy of this [Ingredient]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Ingredient copyWith({
    int? id,
    int? recipeId,
    String? text,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Ingredient',
      if (id != null) 'id': id,
      'recipeId': recipeId,
      'text': text,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IngredientImpl extends Ingredient {
  _IngredientImpl({
    int? id,
    required int recipeId,
    required String text,
  }) : super._(
         id: id,
         recipeId: recipeId,
         text: text,
       );

  /// Returns a shallow copy of this [Ingredient]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Ingredient copyWith({
    Object? id = _Undefined,
    int? recipeId,
    String? text,
  }) {
    return Ingredient(
      id: id is int? ? id : this.id,
      recipeId: recipeId ?? this.recipeId,
      text: text ?? this.text,
    );
  }
}
