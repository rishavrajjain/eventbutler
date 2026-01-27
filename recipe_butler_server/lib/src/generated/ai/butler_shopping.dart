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

abstract class ButlerShopping
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ButlerShopping._({
    required this.title,
    this.qty,
    this.notes,
  });

  factory ButlerShopping({
    required String title,
    String? qty,
    String? notes,
  }) = _ButlerShoppingImpl;

  factory ButlerShopping.fromJson(Map<String, dynamic> jsonSerialization) {
    return ButlerShopping(
      title: jsonSerialization['title'] as String,
      qty: jsonSerialization['qty'] as String?,
      notes: jsonSerialization['notes'] as String?,
    );
  }

  String title;

  String? qty;

  String? notes;

  /// Returns a shallow copy of this [ButlerShopping]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ButlerShopping copyWith({
    String? title,
    String? qty,
    String? notes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ButlerShopping',
      'title': title,
      if (qty != null) 'qty': qty,
      if (notes != null) 'notes': notes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ButlerShopping',
      'title': title,
      if (qty != null) 'qty': qty,
      if (notes != null) 'notes': notes,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ButlerShoppingImpl extends ButlerShopping {
  _ButlerShoppingImpl({
    required String title,
    String? qty,
    String? notes,
  }) : super._(
         title: title,
         qty: qty,
         notes: notes,
       );

  /// Returns a shallow copy of this [ButlerShopping]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ButlerShopping copyWith({
    String? title,
    Object? qty = _Undefined,
    Object? notes = _Undefined,
  }) {
    return ButlerShopping(
      title: title ?? this.title,
      qty: qty is String? ? qty : this.qty,
      notes: notes is String? ? notes : this.notes,
    );
  }
}
