// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cases_local_database.dart';

// ignore_for_file: type=lint
class $CaseDraftsTable extends CaseDrafts
    with TableInfo<$CaseDraftsTable, CaseDraftRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CaseDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
      'json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [ownerId, json, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'case_drafts';
  @override
  VerificationContext validateIntegrity(Insertable<CaseDraftRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
          _jsonMeta, json.isAcceptableOrUnknown(data['json']!, _jsonMeta));
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ownerId};
  @override
  CaseDraftRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CaseDraftRow(
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      json: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}json'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CaseDraftsTable createAlias(String alias) {
    return $CaseDraftsTable(attachedDatabase, alias);
  }
}

class CaseDraftRow extends DataClass implements Insertable<CaseDraftRow> {
  final String ownerId;
  final String json;
  final DateTime updatedAt;
  const CaseDraftRow(
      {required this.ownerId, required this.json, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['owner_id'] = Variable<String>(ownerId);
    map['json'] = Variable<String>(json);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CaseDraftsCompanion toCompanion(bool nullToAbsent) {
    return CaseDraftsCompanion(
      ownerId: Value(ownerId),
      json: Value(json),
      updatedAt: Value(updatedAt),
    );
  }

  factory CaseDraftRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CaseDraftRow(
      ownerId: serializer.fromJson<String>(json['ownerId']),
      json: serializer.fromJson<String>(json['json']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ownerId': serializer.toJson<String>(ownerId),
      'json': serializer.toJson<String>(json),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CaseDraftRow copyWith({String? ownerId, String? json, DateTime? updatedAt}) =>
      CaseDraftRow(
        ownerId: ownerId ?? this.ownerId,
        json: json ?? this.json,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CaseDraftRow copyWithCompanion(CaseDraftsCompanion data) {
    return CaseDraftRow(
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      json: data.json.present ? data.json.value : this.json,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CaseDraftRow(')
          ..write('ownerId: $ownerId, ')
          ..write('json: $json, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ownerId, json, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CaseDraftRow &&
          other.ownerId == this.ownerId &&
          other.json == this.json &&
          other.updatedAt == this.updatedAt);
}

class CaseDraftsCompanion extends UpdateCompanion<CaseDraftRow> {
  final Value<String> ownerId;
  final Value<String> json;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CaseDraftsCompanion({
    this.ownerId = const Value.absent(),
    this.json = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CaseDraftsCompanion.insert({
    required String ownerId,
    required String json,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : ownerId = Value(ownerId),
        json = Value(json),
        updatedAt = Value(updatedAt);
  static Insertable<CaseDraftRow> custom({
    Expression<String>? ownerId,
    Expression<String>? json,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ownerId != null) 'owner_id': ownerId,
      if (json != null) 'json': json,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CaseDraftsCompanion copyWith(
      {Value<String>? ownerId,
      Value<String>? json,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return CaseDraftsCompanion(
      ownerId: ownerId ?? this.ownerId,
      json: json ?? this.json,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CaseDraftsCompanion(')
          ..write('ownerId: $ownerId, ')
          ..write('json: $json, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SeenBidsTable extends SeenBids
    with TableInfo<$SeenBidsTable, SeenBidRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeenBidsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _caseIdMeta = const VerificationMeta('caseId');
  @override
  late final GeneratedColumn<String> caseId = GeneratedColumn<String>(
      'case_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bidIdMeta = const VerificationMeta('bidId');
  @override
  late final GeneratedColumn<String> bidId = GeneratedColumn<String>(
      'bid_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [caseId, bidId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'seen_bids';
  @override
  VerificationContext validateIntegrity(Insertable<SeenBidRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('case_id')) {
      context.handle(_caseIdMeta,
          caseId.isAcceptableOrUnknown(data['case_id']!, _caseIdMeta));
    } else if (isInserting) {
      context.missing(_caseIdMeta);
    }
    if (data.containsKey('bid_id')) {
      context.handle(
          _bidIdMeta, bidId.isAcceptableOrUnknown(data['bid_id']!, _bidIdMeta));
    } else if (isInserting) {
      context.missing(_bidIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {caseId, bidId};
  @override
  SeenBidRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SeenBidRow(
      caseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}case_id'])!,
      bidId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bid_id'])!,
    );
  }

  @override
  $SeenBidsTable createAlias(String alias) {
    return $SeenBidsTable(attachedDatabase, alias);
  }
}

class SeenBidRow extends DataClass implements Insertable<SeenBidRow> {
  final String caseId;
  final String bidId;
  const SeenBidRow({required this.caseId, required this.bidId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['case_id'] = Variable<String>(caseId);
    map['bid_id'] = Variable<String>(bidId);
    return map;
  }

  SeenBidsCompanion toCompanion(bool nullToAbsent) {
    return SeenBidsCompanion(
      caseId: Value(caseId),
      bidId: Value(bidId),
    );
  }

  factory SeenBidRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SeenBidRow(
      caseId: serializer.fromJson<String>(json['caseId']),
      bidId: serializer.fromJson<String>(json['bidId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'caseId': serializer.toJson<String>(caseId),
      'bidId': serializer.toJson<String>(bidId),
    };
  }

  SeenBidRow copyWith({String? caseId, String? bidId}) => SeenBidRow(
        caseId: caseId ?? this.caseId,
        bidId: bidId ?? this.bidId,
      );
  SeenBidRow copyWithCompanion(SeenBidsCompanion data) {
    return SeenBidRow(
      caseId: data.caseId.present ? data.caseId.value : this.caseId,
      bidId: data.bidId.present ? data.bidId.value : this.bidId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SeenBidRow(')
          ..write('caseId: $caseId, ')
          ..write('bidId: $bidId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(caseId, bidId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SeenBidRow &&
          other.caseId == this.caseId &&
          other.bidId == this.bidId);
}

class SeenBidsCompanion extends UpdateCompanion<SeenBidRow> {
  final Value<String> caseId;
  final Value<String> bidId;
  final Value<int> rowid;
  const SeenBidsCompanion({
    this.caseId = const Value.absent(),
    this.bidId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SeenBidsCompanion.insert({
    required String caseId,
    required String bidId,
    this.rowid = const Value.absent(),
  })  : caseId = Value(caseId),
        bidId = Value(bidId);
  static Insertable<SeenBidRow> custom({
    Expression<String>? caseId,
    Expression<String>? bidId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (caseId != null) 'case_id': caseId,
      if (bidId != null) 'bid_id': bidId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SeenBidsCompanion copyWith(
      {Value<String>? caseId, Value<String>? bidId, Value<int>? rowid}) {
    return SeenBidsCompanion(
      caseId: caseId ?? this.caseId,
      bidId: bidId ?? this.bidId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (caseId.present) {
      map['case_id'] = Variable<String>(caseId.value);
    }
    if (bidId.present) {
      map['bid_id'] = Variable<String>(bidId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeenBidsCompanion(')
          ..write('caseId: $caseId, ')
          ..write('bidId: $bidId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$CasesLocalDatabase extends GeneratedDatabase {
  _$CasesLocalDatabase(QueryExecutor e) : super(e);
  $CasesLocalDatabaseManager get managers => $CasesLocalDatabaseManager(this);
  late final $CaseDraftsTable caseDrafts = $CaseDraftsTable(this);
  late final $SeenBidsTable seenBids = $SeenBidsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [caseDrafts, seenBids];
}

typedef $$CaseDraftsTableCreateCompanionBuilder = CaseDraftsCompanion Function({
  required String ownerId,
  required String json,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$CaseDraftsTableUpdateCompanionBuilder = CaseDraftsCompanion Function({
  Value<String> ownerId,
  Value<String> json,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$CaseDraftsTableFilterComposer
    extends Composer<_$CasesLocalDatabase, $CaseDraftsTable> {
  $$CaseDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get json => $composableBuilder(
      column: $table.json, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$CaseDraftsTableOrderingComposer
    extends Composer<_$CasesLocalDatabase, $CaseDraftsTable> {
  $$CaseDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get json => $composableBuilder(
      column: $table.json, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CaseDraftsTableAnnotationComposer
    extends Composer<_$CasesLocalDatabase, $CaseDraftsTable> {
  $$CaseDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CaseDraftsTableTableManager extends RootTableManager<
    _$CasesLocalDatabase,
    $CaseDraftsTable,
    CaseDraftRow,
    $$CaseDraftsTableFilterComposer,
    $$CaseDraftsTableOrderingComposer,
    $$CaseDraftsTableAnnotationComposer,
    $$CaseDraftsTableCreateCompanionBuilder,
    $$CaseDraftsTableUpdateCompanionBuilder,
    (
      CaseDraftRow,
      BaseReferences<_$CasesLocalDatabase, $CaseDraftsTable, CaseDraftRow>
    ),
    CaseDraftRow,
    PrefetchHooks Function()> {
  $$CaseDraftsTableTableManager(_$CasesLocalDatabase db, $CaseDraftsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CaseDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CaseDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CaseDraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> ownerId = const Value.absent(),
            Value<String> json = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CaseDraftsCompanion(
            ownerId: ownerId,
            json: json,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String ownerId,
            required String json,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CaseDraftsCompanion.insert(
            ownerId: ownerId,
            json: json,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$CaseDraftsTable, CaseDraftRow>(table),
                    BaseReferences<_$CasesLocalDatabase, $CaseDraftsTable,
                        CaseDraftRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CaseDraftsTableProcessedTableManager = ProcessedTableManager<
    _$CasesLocalDatabase,
    $CaseDraftsTable,
    CaseDraftRow,
    $$CaseDraftsTableFilterComposer,
    $$CaseDraftsTableOrderingComposer,
    $$CaseDraftsTableAnnotationComposer,
    $$CaseDraftsTableCreateCompanionBuilder,
    $$CaseDraftsTableUpdateCompanionBuilder,
    (
      CaseDraftRow,
      BaseReferences<_$CasesLocalDatabase, $CaseDraftsTable, CaseDraftRow>
    ),
    CaseDraftRow,
    PrefetchHooks Function()>;
typedef $$SeenBidsTableCreateCompanionBuilder = SeenBidsCompanion Function({
  required String caseId,
  required String bidId,
  Value<int> rowid,
});
typedef $$SeenBidsTableUpdateCompanionBuilder = SeenBidsCompanion Function({
  Value<String> caseId,
  Value<String> bidId,
  Value<int> rowid,
});

class $$SeenBidsTableFilterComposer
    extends Composer<_$CasesLocalDatabase, $SeenBidsTable> {
  $$SeenBidsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get caseId => $composableBuilder(
      column: $table.caseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bidId => $composableBuilder(
      column: $table.bidId, builder: (column) => ColumnFilters(column));
}

class $$SeenBidsTableOrderingComposer
    extends Composer<_$CasesLocalDatabase, $SeenBidsTable> {
  $$SeenBidsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get caseId => $composableBuilder(
      column: $table.caseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bidId => $composableBuilder(
      column: $table.bidId, builder: (column) => ColumnOrderings(column));
}

class $$SeenBidsTableAnnotationComposer
    extends Composer<_$CasesLocalDatabase, $SeenBidsTable> {
  $$SeenBidsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get caseId =>
      $composableBuilder(column: $table.caseId, builder: (column) => column);

  GeneratedColumn<String> get bidId =>
      $composableBuilder(column: $table.bidId, builder: (column) => column);
}

class $$SeenBidsTableTableManager extends RootTableManager<
    _$CasesLocalDatabase,
    $SeenBidsTable,
    SeenBidRow,
    $$SeenBidsTableFilterComposer,
    $$SeenBidsTableOrderingComposer,
    $$SeenBidsTableAnnotationComposer,
    $$SeenBidsTableCreateCompanionBuilder,
    $$SeenBidsTableUpdateCompanionBuilder,
    (
      SeenBidRow,
      BaseReferences<_$CasesLocalDatabase, $SeenBidsTable, SeenBidRow>
    ),
    SeenBidRow,
    PrefetchHooks Function()> {
  $$SeenBidsTableTableManager(_$CasesLocalDatabase db, $SeenBidsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SeenBidsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SeenBidsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SeenBidsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> caseId = const Value.absent(),
            Value<String> bidId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SeenBidsCompanion(
            caseId: caseId,
            bidId: bidId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String caseId,
            required String bidId,
            Value<int> rowid = const Value.absent(),
          }) =>
              SeenBidsCompanion.insert(
            caseId: caseId,
            bidId: bidId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SeenBidsTable, SeenBidRow>(table),
                    BaseReferences<_$CasesLocalDatabase, $SeenBidsTable,
                        SeenBidRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SeenBidsTableProcessedTableManager = ProcessedTableManager<
    _$CasesLocalDatabase,
    $SeenBidsTable,
    SeenBidRow,
    $$SeenBidsTableFilterComposer,
    $$SeenBidsTableOrderingComposer,
    $$SeenBidsTableAnnotationComposer,
    $$SeenBidsTableCreateCompanionBuilder,
    $$SeenBidsTableUpdateCompanionBuilder,
    (
      SeenBidRow,
      BaseReferences<_$CasesLocalDatabase, $SeenBidsTable, SeenBidRow>
    ),
    SeenBidRow,
    PrefetchHooks Function()>;

class $CasesLocalDatabaseManager {
  final _$CasesLocalDatabase _db;
  $CasesLocalDatabaseManager(this._db);
  $$CaseDraftsTableTableManager get caseDrafts =>
      $$CaseDraftsTableTableManager(_db, _db.caseDrafts);
  $$SeenBidsTableTableManager get seenBids =>
      $$SeenBidsTableTableManager(_db, _db.seenBids);
}
