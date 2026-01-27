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

abstract class Invite implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Invite._({
    this.id,
    required this.targetType,
    required this.targetId,
    required this.token,
    required this.role,
    this.expiresAt,
    this.acceptedAt,
  });

  factory Invite({
    int? id,
    required String targetType,
    required int targetId,
    required String token,
    required String role,
    DateTime? expiresAt,
    DateTime? acceptedAt,
  }) = _InviteImpl;

  factory Invite.fromJson(Map<String, dynamic> jsonSerialization) {
    return Invite(
      id: jsonSerialization['id'] as int?,
      targetType: jsonSerialization['targetType'] as String,
      targetId: jsonSerialization['targetId'] as int,
      token: jsonSerialization['token'] as String,
      role: jsonSerialization['role'] as String,
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      acceptedAt: jsonSerialization['acceptedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['acceptedAt']),
    );
  }

  static final t = InviteTable();

  static const db = InviteRepository._();

  @override
  int? id;

  String targetType;

  int targetId;

  String token;

  String role;

  DateTime? expiresAt;

  DateTime? acceptedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Invite]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Invite copyWith({
    int? id,
    String? targetType,
    int? targetId,
    String? token,
    String? role,
    DateTime? expiresAt,
    DateTime? acceptedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Invite',
      if (id != null) 'id': id,
      'targetType': targetType,
      'targetId': targetId,
      'token': token,
      'role': role,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      if (acceptedAt != null) 'acceptedAt': acceptedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Invite',
      if (id != null) 'id': id,
      'targetType': targetType,
      'targetId': targetId,
      'token': token,
      'role': role,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      if (acceptedAt != null) 'acceptedAt': acceptedAt?.toJson(),
    };
  }

  static InviteInclude include() {
    return InviteInclude._();
  }

  static InviteIncludeList includeList({
    _i1.WhereExpressionBuilder<InviteTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<InviteTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<InviteTable>? orderByList,
    InviteInclude? include,
  }) {
    return InviteIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Invite.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Invite.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InviteImpl extends Invite {
  _InviteImpl({
    int? id,
    required String targetType,
    required int targetId,
    required String token,
    required String role,
    DateTime? expiresAt,
    DateTime? acceptedAt,
  }) : super._(
         id: id,
         targetType: targetType,
         targetId: targetId,
         token: token,
         role: role,
         expiresAt: expiresAt,
         acceptedAt: acceptedAt,
       );

  /// Returns a shallow copy of this [Invite]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Invite copyWith({
    Object? id = _Undefined,
    String? targetType,
    int? targetId,
    String? token,
    String? role,
    Object? expiresAt = _Undefined,
    Object? acceptedAt = _Undefined,
  }) {
    return Invite(
      id: id is int? ? id : this.id,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      token: token ?? this.token,
      role: role ?? this.role,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      acceptedAt: acceptedAt is DateTime? ? acceptedAt : this.acceptedAt,
    );
  }
}

class InviteUpdateTable extends _i1.UpdateTable<InviteTable> {
  InviteUpdateTable(super.table);

  _i1.ColumnValue<String, String> targetType(String value) => _i1.ColumnValue(
    table.targetType,
    value,
  );

  _i1.ColumnValue<int, int> targetId(int value) => _i1.ColumnValue(
    table.targetId,
    value,
  );

  _i1.ColumnValue<String, String> token(String value) => _i1.ColumnValue(
    table.token,
    value,
  );

  _i1.ColumnValue<String, String> role(String value) => _i1.ColumnValue(
    table.role,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> expiresAt(DateTime? value) =>
      _i1.ColumnValue(
        table.expiresAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> acceptedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.acceptedAt,
        value,
      );
}

class InviteTable extends _i1.Table<int?> {
  InviteTable({super.tableRelation}) : super(tableName: 'invite') {
    updateTable = InviteUpdateTable(this);
    targetType = _i1.ColumnString(
      'targetType',
      this,
    );
    targetId = _i1.ColumnInt(
      'targetId',
      this,
    );
    token = _i1.ColumnString(
      'token',
      this,
    );
    role = _i1.ColumnString(
      'role',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    acceptedAt = _i1.ColumnDateTime(
      'acceptedAt',
      this,
    );
  }

  late final InviteUpdateTable updateTable;

  late final _i1.ColumnString targetType;

  late final _i1.ColumnInt targetId;

  late final _i1.ColumnString token;

  late final _i1.ColumnString role;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnDateTime acceptedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    targetType,
    targetId,
    token,
    role,
    expiresAt,
    acceptedAt,
  ];
}

class InviteInclude extends _i1.IncludeObject {
  InviteInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Invite.t;
}

class InviteIncludeList extends _i1.IncludeList {
  InviteIncludeList._({
    _i1.WhereExpressionBuilder<InviteTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Invite.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Invite.t;
}

class InviteRepository {
  const InviteRepository._();

  /// Returns a list of [Invite]s matching the given query parameters.
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
  Future<List<Invite>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<InviteTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<InviteTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<InviteTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Invite>(
      where: where?.call(Invite.t),
      orderBy: orderBy?.call(Invite.t),
      orderByList: orderByList?.call(Invite.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Invite] matching the given query parameters.
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
  Future<Invite?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<InviteTable>? where,
    int? offset,
    _i1.OrderByBuilder<InviteTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<InviteTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Invite>(
      where: where?.call(Invite.t),
      orderBy: orderBy?.call(Invite.t),
      orderByList: orderByList?.call(Invite.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Invite] by its [id] or null if no such row exists.
  Future<Invite?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Invite>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Invite]s in the list and returns the inserted rows.
  ///
  /// The returned [Invite]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Invite>> insert(
    _i1.Session session,
    List<Invite> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Invite>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Invite] and returns the inserted row.
  ///
  /// The returned [Invite] will have its `id` field set.
  Future<Invite> insertRow(
    _i1.Session session,
    Invite row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Invite>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Invite]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Invite>> update(
    _i1.Session session,
    List<Invite> rows, {
    _i1.ColumnSelections<InviteTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Invite>(
      rows,
      columns: columns?.call(Invite.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Invite]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Invite> updateRow(
    _i1.Session session,
    Invite row, {
    _i1.ColumnSelections<InviteTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Invite>(
      row,
      columns: columns?.call(Invite.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Invite] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Invite?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<InviteUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Invite>(
      id,
      columnValues: columnValues(Invite.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Invite]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Invite>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<InviteUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<InviteTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<InviteTable>? orderBy,
    _i1.OrderByListBuilder<InviteTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Invite>(
      columnValues: columnValues(Invite.t.updateTable),
      where: where(Invite.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Invite.t),
      orderByList: orderByList?.call(Invite.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Invite]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Invite>> delete(
    _i1.Session session,
    List<Invite> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Invite>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Invite].
  Future<Invite> deleteRow(
    _i1.Session session,
    Invite row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Invite>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Invite>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<InviteTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Invite>(
      where: where(Invite.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<InviteTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Invite>(
      where: where?.call(Invite.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
