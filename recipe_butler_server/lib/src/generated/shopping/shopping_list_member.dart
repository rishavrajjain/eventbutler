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

abstract class ShoppingListMember
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ShoppingListMember._({
    this.id,
    required this.shoppingListId,
    required this.userId,
    required this.role,
  });

  factory ShoppingListMember({
    int? id,
    required int shoppingListId,
    required String userId,
    required String role,
  }) = _ShoppingListMemberImpl;

  factory ShoppingListMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return ShoppingListMember(
      id: jsonSerialization['id'] as int?,
      shoppingListId: jsonSerialization['shoppingListId'] as int,
      userId: jsonSerialization['userId'] as String,
      role: jsonSerialization['role'] as String,
    );
  }

  static final t = ShoppingListMemberTable();

  static const db = ShoppingListMemberRepository._();

  @override
  int? id;

  int shoppingListId;

  String userId;

  String role;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ShoppingListMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShoppingListMember copyWith({
    int? id,
    int? shoppingListId,
    String? userId,
    String? role,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShoppingListMember',
      if (id != null) 'id': id,
      'shoppingListId': shoppingListId,
      'userId': userId,
      'role': role,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShoppingListMember',
      if (id != null) 'id': id,
      'shoppingListId': shoppingListId,
      'userId': userId,
      'role': role,
    };
  }

  static ShoppingListMemberInclude include() {
    return ShoppingListMemberInclude._();
  }

  static ShoppingListMemberIncludeList includeList({
    _i1.WhereExpressionBuilder<ShoppingListMemberTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoppingListMemberTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoppingListMemberTable>? orderByList,
    ShoppingListMemberInclude? include,
  }) {
    return ShoppingListMemberIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoppingListMember.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ShoppingListMember.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShoppingListMemberImpl extends ShoppingListMember {
  _ShoppingListMemberImpl({
    int? id,
    required int shoppingListId,
    required String userId,
    required String role,
  }) : super._(
         id: id,
         shoppingListId: shoppingListId,
         userId: userId,
         role: role,
       );

  /// Returns a shallow copy of this [ShoppingListMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ShoppingListMember copyWith({
    Object? id = _Undefined,
    int? shoppingListId,
    String? userId,
    String? role,
  }) {
    return ShoppingListMember(
      id: id is int? ? id : this.id,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
    );
  }
}

class ShoppingListMemberUpdateTable
    extends _i1.UpdateTable<ShoppingListMemberTable> {
  ShoppingListMemberUpdateTable(super.table);

  _i1.ColumnValue<int, int> shoppingListId(int value) => _i1.ColumnValue(
    table.shoppingListId,
    value,
  );

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> role(String value) => _i1.ColumnValue(
    table.role,
    value,
  );
}

class ShoppingListMemberTable extends _i1.Table<int?> {
  ShoppingListMemberTable({super.tableRelation})
    : super(tableName: 'shopping_list_member') {
    updateTable = ShoppingListMemberUpdateTable(this);
    shoppingListId = _i1.ColumnInt(
      'shoppingListId',
      this,
    );
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    role = _i1.ColumnString(
      'role',
      this,
    );
  }

  late final ShoppingListMemberUpdateTable updateTable;

  late final _i1.ColumnInt shoppingListId;

  late final _i1.ColumnString userId;

  late final _i1.ColumnString role;

  @override
  List<_i1.Column> get columns => [
    id,
    shoppingListId,
    userId,
    role,
  ];
}

class ShoppingListMemberInclude extends _i1.IncludeObject {
  ShoppingListMemberInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ShoppingListMember.t;
}

class ShoppingListMemberIncludeList extends _i1.IncludeList {
  ShoppingListMemberIncludeList._({
    _i1.WhereExpressionBuilder<ShoppingListMemberTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ShoppingListMember.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ShoppingListMember.t;
}

class ShoppingListMemberRepository {
  const ShoppingListMemberRepository._();

  /// Returns a list of [ShoppingListMember]s matching the given query parameters.
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
  Future<List<ShoppingListMember>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoppingListMemberTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoppingListMemberTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoppingListMemberTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ShoppingListMember>(
      where: where?.call(ShoppingListMember.t),
      orderBy: orderBy?.call(ShoppingListMember.t),
      orderByList: orderByList?.call(ShoppingListMember.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ShoppingListMember] matching the given query parameters.
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
  Future<ShoppingListMember?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoppingListMemberTable>? where,
    int? offset,
    _i1.OrderByBuilder<ShoppingListMemberTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoppingListMemberTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ShoppingListMember>(
      where: where?.call(ShoppingListMember.t),
      orderBy: orderBy?.call(ShoppingListMember.t),
      orderByList: orderByList?.call(ShoppingListMember.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ShoppingListMember] by its [id] or null if no such row exists.
  Future<ShoppingListMember?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ShoppingListMember>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ShoppingListMember]s in the list and returns the inserted rows.
  ///
  /// The returned [ShoppingListMember]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ShoppingListMember>> insert(
    _i1.Session session,
    List<ShoppingListMember> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ShoppingListMember>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ShoppingListMember] and returns the inserted row.
  ///
  /// The returned [ShoppingListMember] will have its `id` field set.
  Future<ShoppingListMember> insertRow(
    _i1.Session session,
    ShoppingListMember row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ShoppingListMember>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ShoppingListMember]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ShoppingListMember>> update(
    _i1.Session session,
    List<ShoppingListMember> rows, {
    _i1.ColumnSelections<ShoppingListMemberTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ShoppingListMember>(
      rows,
      columns: columns?.call(ShoppingListMember.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShoppingListMember]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ShoppingListMember> updateRow(
    _i1.Session session,
    ShoppingListMember row, {
    _i1.ColumnSelections<ShoppingListMemberTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ShoppingListMember>(
      row,
      columns: columns?.call(ShoppingListMember.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShoppingListMember] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ShoppingListMember?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ShoppingListMemberUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ShoppingListMember>(
      id,
      columnValues: columnValues(ShoppingListMember.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ShoppingListMember]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ShoppingListMember>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ShoppingListMemberUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ShoppingListMemberTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoppingListMemberTable>? orderBy,
    _i1.OrderByListBuilder<ShoppingListMemberTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ShoppingListMember>(
      columnValues: columnValues(ShoppingListMember.t.updateTable),
      where: where(ShoppingListMember.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoppingListMember.t),
      orderByList: orderByList?.call(ShoppingListMember.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ShoppingListMember]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ShoppingListMember>> delete(
    _i1.Session session,
    List<ShoppingListMember> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ShoppingListMember>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ShoppingListMember].
  Future<ShoppingListMember> deleteRow(
    _i1.Session session,
    ShoppingListMember row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ShoppingListMember>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ShoppingListMember>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ShoppingListMemberTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ShoppingListMember>(
      where: where(ShoppingListMember.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoppingListMemberTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ShoppingListMember>(
      where: where?.call(ShoppingListMember.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
