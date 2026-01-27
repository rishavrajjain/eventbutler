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

abstract class ShoppingItem
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = ShoppingItemTable();

  static const db = ShoppingItemRepository._();

  @override
  int? id;

  int shoppingListId;

  String text;

  bool isChecked;

  String? category;

  DateTime updatedAt;

  String? updatedByUserId;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static ShoppingItemInclude include() {
    return ShoppingItemInclude._();
  }

  static ShoppingItemIncludeList includeList({
    _i1.WhereExpressionBuilder<ShoppingItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoppingItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoppingItemTable>? orderByList,
    ShoppingItemInclude? include,
  }) {
    return ShoppingItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoppingItem.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ShoppingItem.t),
      include: include,
    );
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

class ShoppingItemUpdateTable extends _i1.UpdateTable<ShoppingItemTable> {
  ShoppingItemUpdateTable(super.table);

  _i1.ColumnValue<int, int> shoppingListId(int value) => _i1.ColumnValue(
    table.shoppingListId,
    value,
  );

  _i1.ColumnValue<String, String> text(String value) => _i1.ColumnValue(
    table.text,
    value,
  );

  _i1.ColumnValue<bool, bool> isChecked(bool value) => _i1.ColumnValue(
    table.isChecked,
    value,
  );

  _i1.ColumnValue<String, String> category(String? value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );

  _i1.ColumnValue<String, String> updatedByUserId(String? value) =>
      _i1.ColumnValue(
        table.updatedByUserId,
        value,
      );
}

class ShoppingItemTable extends _i1.Table<int?> {
  ShoppingItemTable({super.tableRelation}) : super(tableName: 'shopping_item') {
    updateTable = ShoppingItemUpdateTable(this);
    shoppingListId = _i1.ColumnInt(
      'shoppingListId',
      this,
    );
    text = _i1.ColumnString(
      'text',
      this,
    );
    isChecked = _i1.ColumnBool(
      'isChecked',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
    updatedByUserId = _i1.ColumnString(
      'updatedByUserId',
      this,
    );
  }

  late final ShoppingItemUpdateTable updateTable;

  late final _i1.ColumnInt shoppingListId;

  late final _i1.ColumnString text;

  late final _i1.ColumnBool isChecked;

  late final _i1.ColumnString category;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnString updatedByUserId;

  @override
  List<_i1.Column> get columns => [
    id,
    shoppingListId,
    text,
    isChecked,
    category,
    updatedAt,
    updatedByUserId,
  ];
}

class ShoppingItemInclude extends _i1.IncludeObject {
  ShoppingItemInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ShoppingItem.t;
}

class ShoppingItemIncludeList extends _i1.IncludeList {
  ShoppingItemIncludeList._({
    _i1.WhereExpressionBuilder<ShoppingItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ShoppingItem.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ShoppingItem.t;
}

class ShoppingItemRepository {
  const ShoppingItemRepository._();

  /// Returns a list of [ShoppingItem]s matching the given query parameters.
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
  Future<List<ShoppingItem>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoppingItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoppingItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoppingItemTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ShoppingItem>(
      where: where?.call(ShoppingItem.t),
      orderBy: orderBy?.call(ShoppingItem.t),
      orderByList: orderByList?.call(ShoppingItem.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ShoppingItem] matching the given query parameters.
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
  Future<ShoppingItem?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoppingItemTable>? where,
    int? offset,
    _i1.OrderByBuilder<ShoppingItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ShoppingItemTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ShoppingItem>(
      where: where?.call(ShoppingItem.t),
      orderBy: orderBy?.call(ShoppingItem.t),
      orderByList: orderByList?.call(ShoppingItem.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ShoppingItem] by its [id] or null if no such row exists.
  Future<ShoppingItem?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ShoppingItem>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ShoppingItem]s in the list and returns the inserted rows.
  ///
  /// The returned [ShoppingItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ShoppingItem>> insert(
    _i1.Session session,
    List<ShoppingItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ShoppingItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ShoppingItem] and returns the inserted row.
  ///
  /// The returned [ShoppingItem] will have its `id` field set.
  Future<ShoppingItem> insertRow(
    _i1.Session session,
    ShoppingItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ShoppingItem>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ShoppingItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ShoppingItem>> update(
    _i1.Session session,
    List<ShoppingItem> rows, {
    _i1.ColumnSelections<ShoppingItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ShoppingItem>(
      rows,
      columns: columns?.call(ShoppingItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShoppingItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ShoppingItem> updateRow(
    _i1.Session session,
    ShoppingItem row, {
    _i1.ColumnSelections<ShoppingItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ShoppingItem>(
      row,
      columns: columns?.call(ShoppingItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShoppingItem] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ShoppingItem?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ShoppingItemUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ShoppingItem>(
      id,
      columnValues: columnValues(ShoppingItem.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ShoppingItem]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ShoppingItem>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ShoppingItemUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ShoppingItemTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ShoppingItemTable>? orderBy,
    _i1.OrderByListBuilder<ShoppingItemTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ShoppingItem>(
      columnValues: columnValues(ShoppingItem.t.updateTable),
      where: where(ShoppingItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoppingItem.t),
      orderByList: orderByList?.call(ShoppingItem.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ShoppingItem]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ShoppingItem>> delete(
    _i1.Session session,
    List<ShoppingItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ShoppingItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ShoppingItem].
  Future<ShoppingItem> deleteRow(
    _i1.Session session,
    ShoppingItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ShoppingItem>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ShoppingItem>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ShoppingItemTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ShoppingItem>(
      where: where(ShoppingItem.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ShoppingItemTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ShoppingItem>(
      where: where?.call(ShoppingItem.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
