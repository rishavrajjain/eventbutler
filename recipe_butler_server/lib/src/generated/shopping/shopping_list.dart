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

abstract class ShoppingList
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ShoppingList._({
    this.id,
    required this.ownerUserId,
    required this.name,
    required this.createdAt,
  });

  factory ShoppingList({
    int? id,
    required String ownerUserId,
    required String name,
    required DateTime createdAt,
  }) = _ShoppingListImpl;

  factory ShoppingList.fromJson(Map<String, dynamic> jsonSerialization) {
    return ShoppingList(
      id: jsonSerialization['id'] as int?,
      ownerUserId: jsonSerialization['ownerUserId'] as String,
      name: jsonSerialization['name'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = ShoppingListTable();

  static const db = ShoppingListRepository._();

  @override
  int? id;

  String ownerUserId;

  String name;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ShoppingList]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShoppingList copyWith({
    int? id,
    String? ownerUserId,
    String? name,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShoppingList',
      if (id != null) 'id': id,
      'ownerUserId': ownerUserId,
      'name': name,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShoppingList',
      if (id != null) 'id': id,
      'ownerUserId': ownerUserId,
      'name': name,
      'createdAt': createdAt.toJson(),
    };
  }

  static ShoppingListInclude include() {
    return ShoppingListInclude._();
  }

  static ShoppingListIncludeList includeList({
    _i1.WhereExpressionBuilder<ShoppingListTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoppingListTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoppingListTable>? orderByList,
    ShoppingListInclude? include,
  }) {
    return ShoppingListIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoppingList.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ShoppingList.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShoppingListImpl extends ShoppingList {
  _ShoppingListImpl({
    int? id,
    required String ownerUserId,
    required String name,
    required DateTime createdAt,
  }) : super._(
         id: id,
         ownerUserId: ownerUserId,
         name: name,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ShoppingList]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ShoppingList copyWith({
    Object? id = _Undefined,
    String? ownerUserId,
    String? name,
    DateTime? createdAt,
  }) {
    return ShoppingList(
      id: id is int? ? id : this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ShoppingListUpdateTable extends _i1.UpdateTable<ShoppingListTable> {
  ShoppingListUpdateTable(super.table);

  _i1.ColumnValue<String, String> ownerUserId(String value) => _i1.ColumnValue(
    table.ownerUserId,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class ShoppingListTable extends _i1.Table<int?> {
  ShoppingListTable({super.tableRelation}) : super(tableName: 'shopping_list') {
    updateTable = ShoppingListUpdateTable(this);
    ownerUserId = _i1.ColumnString(
      'ownerUserId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final ShoppingListUpdateTable updateTable;

  late final _i1.ColumnString ownerUserId;

  late final _i1.ColumnString name;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    ownerUserId,
    name,
    createdAt,
  ];
}

class ShoppingListInclude extends _i1.IncludeObject {
  ShoppingListInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ShoppingList.t;
}

class ShoppingListIncludeList extends _i1.IncludeList {
  ShoppingListIncludeList._({
    _i1.WhereExpressionBuilder<ShoppingListTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ShoppingList.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ShoppingList.t;
}

class ShoppingListRepository {
  const ShoppingListRepository._();

  /// Returns a list of [ShoppingList]s matching the given query parameters.
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
  Future<List<ShoppingList>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoppingListTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoppingListTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoppingListTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ShoppingList>(
      where: where?.call(ShoppingList.t),
      orderBy: orderBy?.call(ShoppingList.t),
      orderByList: orderByList?.call(ShoppingList.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ShoppingList] matching the given query parameters.
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
  Future<ShoppingList?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoppingListTable>? where,
    int? offset,
    _i1.OrderByBuilder<ShoppingListTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoppingListTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ShoppingList>(
      where: where?.call(ShoppingList.t),
      orderBy: orderBy?.call(ShoppingList.t),
      orderByList: orderByList?.call(ShoppingList.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ShoppingList] by its [id] or null if no such row exists.
  Future<ShoppingList?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ShoppingList>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ShoppingList]s in the list and returns the inserted rows.
  ///
  /// The returned [ShoppingList]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ShoppingList>> insert(
    _i1.Session session,
    List<ShoppingList> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ShoppingList>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ShoppingList] and returns the inserted row.
  ///
  /// The returned [ShoppingList] will have its `id` field set.
  Future<ShoppingList> insertRow(
    _i1.Session session,
    ShoppingList row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ShoppingList>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ShoppingList]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ShoppingList>> update(
    _i1.Session session,
    List<ShoppingList> rows, {
    _i1.ColumnSelections<ShoppingListTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ShoppingList>(
      rows,
      columns: columns?.call(ShoppingList.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShoppingList]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ShoppingList> updateRow(
    _i1.Session session,
    ShoppingList row, {
    _i1.ColumnSelections<ShoppingListTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ShoppingList>(
      row,
      columns: columns?.call(ShoppingList.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShoppingList] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ShoppingList?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ShoppingListUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ShoppingList>(
      id,
      columnValues: columnValues(ShoppingList.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ShoppingList]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ShoppingList>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ShoppingListUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ShoppingListTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoppingListTable>? orderBy,
    _i1.OrderByListBuilder<ShoppingListTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ShoppingList>(
      columnValues: columnValues(ShoppingList.t.updateTable),
      where: where(ShoppingList.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoppingList.t),
      orderByList: orderByList?.call(ShoppingList.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ShoppingList]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ShoppingList>> delete(
    _i1.Session session,
    List<ShoppingList> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ShoppingList>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ShoppingList].
  Future<ShoppingList> deleteRow(
    _i1.Session session,
    ShoppingList row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ShoppingList>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ShoppingList>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ShoppingListTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ShoppingList>(
      where: where(ShoppingList.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoppingListTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ShoppingList>(
      where: where?.call(ShoppingList.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
