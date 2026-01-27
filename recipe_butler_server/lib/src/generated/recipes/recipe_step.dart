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

abstract class RecipeStep
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = RecipeStepTable();

  static const db = RecipeStepRepository._();

  @override
  int? id;

  int recipeId;

  int orderIndex;

  String text;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RecipeStep',
      if (id != null) 'id': id,
      'recipeId': recipeId,
      'orderIndex': orderIndex,
      'text': text,
    };
  }

  static RecipeStepInclude include() {
    return RecipeStepInclude._();
  }

  static RecipeStepIncludeList includeList({
    _i1.WhereExpressionBuilder<RecipeStepTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RecipeStepTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RecipeStepTable>? orderByList,
    RecipeStepInclude? include,
  }) {
    return RecipeStepIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RecipeStep.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RecipeStep.t),
      include: include,
    );
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

class RecipeStepUpdateTable extends _i1.UpdateTable<RecipeStepTable> {
  RecipeStepUpdateTable(super.table);

  _i1.ColumnValue<int, int> recipeId(int value) => _i1.ColumnValue(
    table.recipeId,
    value,
  );

  _i1.ColumnValue<int, int> orderIndex(int value) => _i1.ColumnValue(
    table.orderIndex,
    value,
  );

  _i1.ColumnValue<String, String> text(String value) => _i1.ColumnValue(
    table.text,
    value,
  );
}

class RecipeStepTable extends _i1.Table<int?> {
  RecipeStepTable({super.tableRelation}) : super(tableName: 'recipe_step') {
    updateTable = RecipeStepUpdateTable(this);
    recipeId = _i1.ColumnInt(
      'recipeId',
      this,
    );
    orderIndex = _i1.ColumnInt(
      'orderIndex',
      this,
    );
    text = _i1.ColumnString(
      'text',
      this,
    );
  }

  late final RecipeStepUpdateTable updateTable;

  late final _i1.ColumnInt recipeId;

  late final _i1.ColumnInt orderIndex;

  late final _i1.ColumnString text;

  @override
  List<_i1.Column> get columns => [
    id,
    recipeId,
    orderIndex,
    text,
  ];
}

class RecipeStepInclude extends _i1.IncludeObject {
  RecipeStepInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => RecipeStep.t;
}

class RecipeStepIncludeList extends _i1.IncludeList {
  RecipeStepIncludeList._({
    _i1.WhereExpressionBuilder<RecipeStepTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RecipeStep.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RecipeStep.t;
}

class RecipeStepRepository {
  const RecipeStepRepository._();

  /// Returns a list of [RecipeStep]s matching the given query parameters.
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
  Future<List<RecipeStep>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RecipeStepTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RecipeStepTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RecipeStepTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<RecipeStep>(
      where: where?.call(RecipeStep.t),
      orderBy: orderBy?.call(RecipeStep.t),
      orderByList: orderByList?.call(RecipeStep.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [RecipeStep] matching the given query parameters.
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
  Future<RecipeStep?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RecipeStepTable>? where,
    int? offset,
    _i1.OrderByBuilder<RecipeStepTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RecipeStepTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<RecipeStep>(
      where: where?.call(RecipeStep.t),
      orderBy: orderBy?.call(RecipeStep.t),
      orderByList: orderByList?.call(RecipeStep.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [RecipeStep] by its [id] or null if no such row exists.
  Future<RecipeStep?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<RecipeStep>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [RecipeStep]s in the list and returns the inserted rows.
  ///
  /// The returned [RecipeStep]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<RecipeStep>> insert(
    _i1.Session session,
    List<RecipeStep> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<RecipeStep>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [RecipeStep] and returns the inserted row.
  ///
  /// The returned [RecipeStep] will have its `id` field set.
  Future<RecipeStep> insertRow(
    _i1.Session session,
    RecipeStep row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RecipeStep>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RecipeStep]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RecipeStep>> update(
    _i1.Session session,
    List<RecipeStep> rows, {
    _i1.ColumnSelections<RecipeStepTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RecipeStep>(
      rows,
      columns: columns?.call(RecipeStep.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RecipeStep]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RecipeStep> updateRow(
    _i1.Session session,
    RecipeStep row, {
    _i1.ColumnSelections<RecipeStepTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RecipeStep>(
      row,
      columns: columns?.call(RecipeStep.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RecipeStep] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RecipeStep?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<RecipeStepUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RecipeStep>(
      id,
      columnValues: columnValues(RecipeStep.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RecipeStep]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RecipeStep>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<RecipeStepUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RecipeStepTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RecipeStepTable>? orderBy,
    _i1.OrderByListBuilder<RecipeStepTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RecipeStep>(
      columnValues: columnValues(RecipeStep.t.updateTable),
      where: where(RecipeStep.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RecipeStep.t),
      orderByList: orderByList?.call(RecipeStep.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RecipeStep]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RecipeStep>> delete(
    _i1.Session session,
    List<RecipeStep> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RecipeStep>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RecipeStep].
  Future<RecipeStep> deleteRow(
    _i1.Session session,
    RecipeStep row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RecipeStep>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RecipeStep>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RecipeStepTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RecipeStep>(
      where: where(RecipeStep.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RecipeStepTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RecipeStep>(
      where: where?.call(RecipeStep.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
