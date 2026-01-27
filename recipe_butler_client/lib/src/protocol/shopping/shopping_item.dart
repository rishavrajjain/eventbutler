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

abstract class ShoppingItem implements _i1.SerializableModel {
  ShoppingItem._({
    this.id,
    required this.shoppingListId,
    required this.text,
    required this.isChecked,
    this.category,
    required this.updatedAt,
    this.updatedByUserId,
  });

  factory ShoppingItem({
    int? id,
    required int shoppingListId,
    required String text,
    required bool isChecked,
    String? category,
    required DateTime updatedAt,
    String? updatedByUserId,
  }) = _ShoppingItemImpl;

  factory ShoppingItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return ShoppingItem(
      id: jsonSerialization['id'] as int?,
      shoppingListId: jsonSerialization['shoppingListId'] as int,
      text: jsonSerialization['text'] as String,
      isChecked: jsonSerialization['isChecked'] as bool,
      category: jsonSerialization['category'] as String?,
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      updatedByUserId: jsonSerialization['updatedByUserId'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int shoppingListId;

  String text;

  bool isChecked;

  String? category;

  DateTime updatedAt;

  String? updatedByUserId;

  /// Returns a shallow copy of this [ShoppingItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShoppingItem copyWith({
    int? id,
    int? shoppingListId,
    String? text,
    bool? isChecked,
    String? category,
    DateTime? updatedAt,
    String? updatedByUserId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShoppingItem',
      if (id != null) 'id': id,
      'shoppingListId': shoppingListId,
      'text': text,
      'isChecked': isChecked,
      if (category != null) 'category': category,
      'updatedAt': updatedAt.toJson(),
      if (updatedByUserId != null) 'updatedByUserId': updatedByUserId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShoppingItemImpl extends ShoppingItem {
  _ShoppingItemImpl({
    int? id,
    required int shoppingListId,
    required String text,
    required bool isChecked,
    String? category,
    required DateTime updatedAt,
    String? updatedByUserId,
  }) : super._(
         id: id,
         shoppingListId: shoppingListId,
         text: text,
         isChecked: isChecked,
         category: category,
         updatedAt: updatedAt,
         updatedByUserId: updatedByUserId,
       );

  /// Returns a shallow copy of this [ShoppingItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ShoppingItem copyWith({
    Object? id = _Undefined,
    int? shoppingListId,
    String? text,
    bool? isChecked,
    Object? category = _Undefined,
    DateTime? updatedAt,
    Object? updatedByUserId = _Undefined,
  }) {
    return ShoppingItem(
      id: id is int? ? id : this.id,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      text: text ?? this.text,
      isChecked: isChecked ?? this.isChecked,
      category: category is String? ? category : this.category,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedByUserId: updatedByUserId is String?
          ? updatedByUserId
          : this.updatedByUserId,
    );
  }
}
