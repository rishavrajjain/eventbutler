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
import '../ai/butler_shopping.dart' as _i2;
import '../ai/butler_reminder.dart' as _i3;
import 'package:recipe_butler_client/src/protocol/protocol.dart' as _i4;

abstract class ButlerSuggestion implements _i1.SerializableModel {
  ButlerSuggestion._({
    required this.message,
    required this.shopping,
    required this.reminders,
  });

  factory ButlerSuggestion({
    required String message,
    required List<_i2.ButlerShopping> shopping,
    required List<_i3.ButlerReminder> reminders,
  }) = _ButlerSuggestionImpl;

  factory ButlerSuggestion.fromJson(Map<String, dynamic> jsonSerialization) {
    return ButlerSuggestion(
      message: jsonSerialization['message'] as String,
      shopping: _i4.Protocol().deserialize<List<_i2.ButlerShopping>>(
        jsonSerialization['shopping'],
      ),
      reminders: _i4.Protocol().deserialize<List<_i3.ButlerReminder>>(
        jsonSerialization['reminders'],
      ),
    );
  }

  String message;

  List<_i2.ButlerShopping> shopping;

  List<_i3.ButlerReminder> reminders;

  /// Returns a shallow copy of this [ButlerSuggestion]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ButlerSuggestion copyWith({
    String? message,
    List<_i2.ButlerShopping>? shopping,
    List<_i3.ButlerReminder>? reminders,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ButlerSuggestion',
      'message': message,
      'shopping': shopping.toJson(valueToJson: (v) => v.toJson()),
      'reminders': reminders.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ButlerSuggestionImpl extends ButlerSuggestion {
  _ButlerSuggestionImpl({
    required String message,
    required List<_i2.ButlerShopping> shopping,
    required List<_i3.ButlerReminder> reminders,
  }) : super._(
         message: message,
         shopping: shopping,
         reminders: reminders,
       );

  /// Returns a shallow copy of this [ButlerSuggestion]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ButlerSuggestion copyWith({
    String? message,
    List<_i2.ButlerShopping>? shopping,
    List<_i3.ButlerReminder>? reminders,
  }) {
    return ButlerSuggestion(
      message: message ?? this.message,
      shopping: shopping ?? this.shopping.map((e0) => e0.copyWith()).toList(),
      reminders:
          reminders ?? this.reminders.map((e0) => e0.copyWith()).toList(),
    );
  }
}
