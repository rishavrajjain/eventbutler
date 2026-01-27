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

abstract class Ingredient
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = IngredientTable();

  static const db = IngredientRepository._();

  @override
  int? id;

  int recipeId;

  String text;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Ingredient',
      if (id != null) 'id': id,
      'recipeId': recipeId,
      'text': text,
    };
  }

  static IngredientInclude include() {
    return IngredientInclude._();
  }

  static IngredientIncludeList includeList({
    _i1.WhereExpressionBuilder<IngredientTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IngredientTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IngredientTable>? orderByList,
    IngredientInclude? include,
  }) {
    return IngredientIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Ingredient.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Ingredient.t),
      include: include,
    );
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

class IngredientUpdateTable extends _i1.UpdateTable<IngredientTable> {
  IngredientUpdateTable(super.table);

  _i1.ColumnValue<int, int> recipeId(int value) => _i1.ColumnValue(
    table.recipeId,
    value,
  );

  _i1.ColumnValue<String, String> text(String value) => _i1.ColumnValue(
    table.text,
    value,
  );
}

class IngredientTable extends _i1.Table<int?> {
  IngredientTable({super.tableRelation}) : super(tableName: 'ingredient') {
    updateTable = IngredientUpdateTable(this);
    recipeId = _i1.ColumnInt(
      'recipeId',
      this,
    );
    text = _i1.ColumnString(
      'text',
      this,
    );
  }

  late final IngredientUpdateTable updateTable;

  late final _i1.ColumnInt recipeId;

  late final _i1.ColumnString text;

  @override
  List<_i1.Column> get columns => [
    id,
    recipeId,
    text,
  ];
}

class IngredientInclude extends _i1.IncludeObject {
  IngredientInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Ingredient.t;
}

class IngredientIncludeList extends _i1.IncludeList {
  IngredientIncludeList._({
    _i1.WhereExpressionBuilder<IngredientTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Ingredient.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Ingredient.t;
}

class IngredientRepository {
  const IngredientRepository._();

  /// Returns a list of [Ingredient]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Ingredient>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IngredientTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IngredientTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IngredientTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Ingredient>(
      where: where?.call(Ingredient.t),
      orderBy: orderBy?.call(Ingredient.t),
      orderByList: orderByList?.call(Ingredient.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Ingredient] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Ingredient?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IngredientTable>? where,
    int? offset,
    _i1.OrderByBuilder<IngredientTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IngredientTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Ingredient>(
      where: where?.call(Ingredient.t),
      orderBy: orderBy?.call(Ingredient.t),
      orderByList: orderByList?.call(Ingredient.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Ingredient] by its [id] or null if no such row exists.
  Future<Ingredient?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Ingredient>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Ingredient]s in the list and returns the inserted rows.
  ///
  /// The returned [Ingredient]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Ingredient>> insert(
    _i1.Session session,
    List<Ingredient> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Ingredient>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Ingredient] and returns the inserted row.
  ///
  /// The returned [Ingredient] will have its `id` field set.
  Future<Ingredient> insertRow(
    _i1.Session session,
    Ingredient row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Ingredient>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Ingredient]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Ingredient>> update(
    _i1.Session session,
    List<Ingredient> rows, {
    _i1.ColumnSelections<IngredientTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Ingredient>(
      rows,
      columns: columns?.call(Ingredient.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Ingredient]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Ingredient> updateRow(
    _i1.Session session,
    Ingredient row, {
    _i1.ColumnSelections<IngredientTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Ingredient>(
      row,
      columns: columns?.call(Ingredient.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Ingredient] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Ingredient?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<IngredientUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Ingredient>(
      id,
      columnValues: columnValues(Ingredient.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Ingredient]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Ingredient>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<IngredientUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<IngredientTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IngredientTable>? orderBy,
    _i1.OrderByListBuilder<IngredientTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Ingredient>(
      columnValues: columnValues(Ingredient.t.updateTable),
      where: where(Ingredient.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Ingredient.t),
      orderByList: orderByList?.call(Ingredient.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Ingredient]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Ingredient>> delete(
    _i1.Session session,
    List<Ingredient> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Ingredient>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Ingredient].
  Future<Ingredient> deleteRow(
    _i1.Session session,
    Ingredient row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Ingredient>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Ingredient>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<IngredientTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Ingredient>(
      where: where(Ingredient.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IngredientTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Ingredient>(
      where: where?.call(Ingredient.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
