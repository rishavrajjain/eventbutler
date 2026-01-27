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

abstract class TaskMessage
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  TaskMessage._({
    this.id,
    required this.shoppingListId,
    required this.userId,
    required this.text,
    required this.createdAt,
  });

  factory TaskMessage({
    int? id,
    required int shoppingListId,
    required String userId,
    required String text,
    required DateTime createdAt,
  }) = _TaskMessageImpl;

  factory TaskMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return TaskMessage(
      id: jsonSerialization['id'] as int?,
      shoppingListId: jsonSerialization['shoppingListId'] as int,
      userId: jsonSerialization['userId'] as String,
      text: jsonSerialization['text'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = TaskMessageTable();

  static const db = TaskMessageRepository._();

  @override
  int? id;

  int shoppingListId;

  String userId;

  String text;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TaskMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TaskMessage copyWith({
    int? id,
    int? shoppingListId,
    String? userId,
    String? text,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TaskMessage',
      if (id != null) 'id': id,
      'shoppingListId': shoppingListId,
      'userId': userId,
      'text': text,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TaskMessage',
      if (id != null) 'id': id,
      'shoppingListId': shoppingListId,
      'userId': userId,
      'text': text,
      'createdAt': createdAt.toJson(),
    };
  }

  static TaskMessageInclude include() {
    return TaskMessageInclude._();
  }

  static TaskMessageIncludeList includeList({
    _i1.WhereExpressionBuilder<TaskMessageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TaskMessageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TaskMessageTable>? orderByList,
    TaskMessageInclude? include,
  }) {
    return TaskMessageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TaskMessage.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TaskMessage.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaskMessageImpl extends TaskMessage {
  _TaskMessageImpl({
    int? id,
    required int shoppingListId,
    required String userId,
    required String text,
    required DateTime createdAt,
  }) : super._(
         id: id,
         shoppingListId: shoppingListId,
         userId: userId,
         text: text,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TaskMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TaskMessage copyWith({
    Object? id = _Undefined,
    int? shoppingListId,
    String? userId,
    String? text,
    DateTime? createdAt,
  }) {
    return TaskMessage(
      id: id is int? ? id : this.id,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      userId: userId ?? this.userId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TaskMessageUpdateTable extends _i1.UpdateTable<TaskMessageTable> {
  TaskMessageUpdateTable(super.table);

  _i1.ColumnValue<int, int> shoppingListId(int value) => _i1.ColumnValue(
    table.shoppingListId,
    value,
  );

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> text(String value) => _i1.ColumnValue(
    table.text,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class TaskMessageTable extends _i1.Table<int?> {
  TaskMessageTable({super.tableRelation}) : super(tableName: 'task_message') {
    updateTable = TaskMessageUpdateTable(this);
    shoppingListId = _i1.ColumnInt(
      'shoppingListId',
      this,
    );
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    text = _i1.ColumnString(
      'text',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final TaskMessageUpdateTable updateTable;

  late final _i1.ColumnInt shoppingListId;

  late final _i1.ColumnString userId;

  late final _i1.ColumnString text;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    shoppingListId,
    userId,
    text,
    createdAt,
  ];
}

class TaskMessageInclude extends _i1.IncludeObject {
  TaskMessageInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => TaskMessage.t;
}

class TaskMessageIncludeList extends _i1.IncludeList {
  TaskMessageIncludeList._({
    _i1.WhereExpressionBuilder<TaskMessageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TaskMessage.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TaskMessage.t;
}

class TaskMessageRepository {
  const TaskMessageRepository._();

  /// Returns a list of [TaskMessage]s matching the given query parameters.
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
  Future<List<TaskMessage>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TaskMessageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TaskMessageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TaskMessageTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<TaskMessage>(
      where: where?.call(TaskMessage.t),
      orderBy: orderBy?.call(TaskMessage.t),
      orderByList: orderByList?.call(TaskMessage.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [TaskMessage] matching the given query parameters.
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
  Future<TaskMessage?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TaskMessageTable>? where,
    int? offset,
    _i1.OrderByBuilder<TaskMessageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TaskMessageTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<TaskMessage>(
      where: where?.call(TaskMessage.t),
      orderBy: orderBy?.call(TaskMessage.t),
      orderByList: orderByList?.call(TaskMessage.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [TaskMessage] by its [id] or null if no such row exists.
  Future<TaskMessage?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<TaskMessage>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [TaskMessage]s in the list and returns the inserted rows.
  ///
  /// The returned [TaskMessage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TaskMessage>> insert(
    _i1.Session session,
    List<TaskMessage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<TaskMessage>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TaskMessage] and returns the inserted row.
  ///
  /// The returned [TaskMessage] will have its `id` field set.
  Future<TaskMessage> insertRow(
    _i1.Session session,
    TaskMessage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TaskMessage>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TaskMessage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TaskMessage>> update(
    _i1.Session session,
    List<TaskMessage> rows, {
    _i1.ColumnSelections<TaskMessageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TaskMessage>(
      rows,
      columns: columns?.call(TaskMessage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TaskMessage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TaskMessage> updateRow(
    _i1.Session session,
    TaskMessage row, {
    _i1.ColumnSelections<TaskMessageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TaskMessage>(
      row,
      columns: columns?.call(TaskMessage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TaskMessage] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TaskMessage?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<TaskMessageUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TaskMessage>(
      id,
      columnValues: columnValues(TaskMessage.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TaskMessage]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TaskMessage>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<TaskMessageUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<TaskMessageTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TaskMessageTable>? orderBy,
    _i1.OrderByListBuilder<TaskMessageTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TaskMessage>(
      columnValues: columnValues(TaskMessage.t.updateTable),
      where: where(TaskMessage.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TaskMessage.t),
      orderByList: orderByList?.call(TaskMessage.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TaskMessage]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TaskMessage>> delete(
    _i1.Session session,
    List<TaskMessage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TaskMessage>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TaskMessage].
  Future<TaskMessage> deleteRow(
    _i1.Session session,
    TaskMessage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TaskMessage>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TaskMessage>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TaskMessageTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TaskMessage>(
      where: where(TaskMessage.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TaskMessageTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TaskMessage>(
      where: where?.call(TaskMessage.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
