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

abstract class RecipeStep implements _i1.SerializableModel {
  RecipeStep._({
    this.id,
    required this.recipeId,
    required this.orderIndex,
    required this.text,
  });

  factory RecipeStep({
    int? id,
    required int recipeId,
    required int orderIndex,
    required String text,
  }) = _RecipeStepImpl;

  factory RecipeStep.fromJson(Map<String, dynamic> jsonSerialization) {
    return RecipeStep(
      id: jsonSerialization['id'] as int?,
      recipeId: jsonSerialization['recipeId'] as int,
      orderIndex: jsonSerialization['orderIndex'] as int,
      text: jsonSerialization['text'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int recipeId;

  int orderIndex;

  String text;

  /// Returns a shallow copy of this [RecipeStep]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RecipeStep copyWith({
    int? id,
    int? recipeId,
    int? orderIndex,
    String? text,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RecipeStep',
      if (id != null) 'id': id,
      'recipeId': recipeId,
      'orderIndex': orderIndex,
      'text': text,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RecipeStepImpl extends RecipeStep {
  _RecipeStepImpl({
    int? id,
    required int recipeId,
    required int orderIndex,
    required String text,
  }) : super._(
         id: id,
         recipeId: recipeId,
         orderIndex: orderIndex,
         text: text,
       );

  /// Returns a shallow copy of this [RecipeStep]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RecipeStep copyWith({
    Object? id = _Undefined,
    int? recipeId,
    int? orderIndex,
    String? text,
  }) {
    return RecipeStep(
      id: id is int? ? id : this.id,
      recipeId: recipeId ?? this.recipeId,
      orderIndex: orderIndex ?? this.orderIndex,
      text: text ?? this.text,
    );
  }
}
