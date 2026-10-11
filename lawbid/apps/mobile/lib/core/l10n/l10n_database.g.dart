// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'l10n_database.dart';

// ignore_for_file: type=lint
class $L10nTranslationsTable extends L10nTranslations
    with TableInfo<$L10nTranslationsTable, L10nTranslation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $L10nTranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _langMeta = const VerificationMeta('lang');
  @override
  late final GeneratedColumn<String> lang = GeneratedColumn<String>(
      'lang', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entryKeyMeta =
      const VerificationMeta('entryKey');
  @override
  late final GeneratedColumn<String> entryKey = GeneratedColumn<String>(
      'entry_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [lang, entryKey, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'l10n_translations';
  @override
  VerificationContext validateIntegrity(Insertable<L10nTranslation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lang')) {
      context.handle(
          _langMeta, lang.isAcceptableOrUnknown(data['lang']!, _langMeta));
    } else if (isInserting) {
      context.missing(_langMeta);
    }
    if (data.containsKey('entry_key')) {
      context.handle(_entryKeyMeta,
          entryKey.isAcceptableOrUnknown(data['entry_key']!, _entryKeyMeta));
    } else if (isInserting) {
      context.missing(_entryKeyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lang, entryKey};
  @override
  L10nTranslation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return L10nTranslation(
      lang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lang'])!,
      entryKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entry_key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $L10nTranslationsTable createAlias(String alias) {
    return $L10nTranslationsTable(attachedDatabase, alias);
  }
}

class L10nTranslation extends DataClass implements Insertable<L10nTranslation> {
  final String lang;
  final String entryKey;
  final String value;
  const L10nTranslation(
      {required this.lang, required this.entryKey, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lang'] = Variable<String>(lang);
    map['entry_key'] = Variable<String>(entryKey);
    map['value'] = Variable<String>(value);
    return map;
  }

  L10nTranslationsCompanion toCompanion(bool nullToAbsent) {
    return L10nTranslationsCompanion(
      lang: Value(lang),
      entryKey: Value(entryKey),
      value: Value(value),
    );
  }

  factory L10nTranslation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return L10nTranslation(
      lang: serializer.fromJson<String>(json['lang']),
      entryKey: serializer.fromJson<String>(json['entryKey']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lang': serializer.toJson<String>(lang),
      'entryKey': serializer.toJson<String>(entryKey),
      'value': serializer.toJson<String>(value),
    };
  }

  L10nTranslation copyWith({String? lang, String? entryKey, String? value}) =>
      L10nTranslation(
        lang: lang ?? this.lang,
        entryKey: entryKey ?? this.entryKey,
        value: value ?? this.value,
      );
  L10nTranslation copyWithCompanion(L10nTranslationsCompanion data) {
    return L10nTranslation(
      lang: data.lang.present ? data.lang.value : this.lang,
      entryKey: data.entryKey.present ? data.entryKey.value : this.entryKey,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('L10nTranslation(')
          ..write('lang: $lang, ')
          ..write('entryKey: $entryKey, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(lang, entryKey, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is L10nTranslation &&
          other.lang == this.lang &&
          other.entryKey == this.entryKey &&
          other.value == this.value);
}

class L10nTranslationsCompanion extends UpdateCompanion<L10nTranslation> {
  final Value<String> lang;
  final Value<String> entryKey;
  final Value<String> value;
  final Value<int> rowid;
  const L10nTranslationsCompanion({
    this.lang = const Value.absent(),
    this.entryKey = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  L10nTranslationsCompanion.insert({
    required String lang,
    required String entryKey,
    required String value,
    this.rowid = const Value.absent(),
  })  : lang = Value(lang),
        entryKey = Value(entryKey),
        value = Value(value);
  static Insertable<L10nTranslation> custom({
    Expression<String>? lang,
    Expression<String>? entryKey,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lang != null) 'lang': lang,
      if (entryKey != null) 'entry_key': entryKey,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  L10nTranslationsCompanion copyWith(
      {Value<String>? lang,
      Value<String>? entryKey,
      Value<String>? value,
      Value<int>? rowid}) {
    return L10nTranslationsCompanion(
      lang: lang ?? this.lang,
      entryKey: entryKey ?? this.entryKey,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lang.present) {
      map['lang'] = Variable<String>(lang.value);
    }
    if (entryKey.present) {
      map['entry_key'] = Variable<String>(entryKey.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('L10nTranslationsCompanion(')
          ..write('lang: $lang, ')
          ..write('entryKey: $entryKey, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $L10nBundleMetaTable extends L10nBundleMeta
    with TableInfo<$L10nBundleMetaTable, L10nBundleMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $L10nBundleMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _langMeta = const VerificationMeta('lang');
  @override
  late final GeneratedColumn<String> lang = GeneratedColumn<String>(
      'lang', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [lang, version];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'l10n_bundle_meta';
  @override
  VerificationContext validateIntegrity(Insertable<L10nBundleMetaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lang')) {
      context.handle(
          _langMeta, lang.isAcceptableOrUnknown(data['lang']!, _langMeta));
    } else if (isInserting) {
      context.missing(_langMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lang};
  @override
  L10nBundleMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return L10nBundleMetaData(
      lang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lang'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $L10nBundleMetaTable createAlias(String alias) {
    return $L10nBundleMetaTable(attachedDatabase, alias);
  }
}

class L10nBundleMetaData extends DataClass
    implements Insertable<L10nBundleMetaData> {
  final String lang;
  final int version;
  const L10nBundleMetaData({required this.lang, required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lang'] = Variable<String>(lang);
    map['version'] = Variable<int>(version);
    return map;
  }

  L10nBundleMetaCompanion toCompanion(bool nullToAbsent) {
    return L10nBundleMetaCompanion(
      lang: Value(lang),
      version: Value(version),
    );
  }

  factory L10nBundleMetaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return L10nBundleMetaData(
      lang: serializer.fromJson<String>(json['lang']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lang': serializer.toJson<String>(lang),
      'version': serializer.toJson<int>(version),
    };
  }

  L10nBundleMetaData copyWith({String? lang, int? version}) =>
      L10nBundleMetaData(
        lang: lang ?? this.lang,
        version: version ?? this.version,
      );
  L10nBundleMetaData copyWithCompanion(L10nBundleMetaCompanion data) {
    return L10nBundleMetaData(
      lang: data.lang.present ? data.lang.value : this.lang,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('L10nBundleMetaData(')
          ..write('lang: $lang, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(lang, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is L10nBundleMetaData &&
          other.lang == this.lang &&
          other.version == this.version);
}

class L10nBundleMetaCompanion extends UpdateCompanion<L10nBundleMetaData> {
  final Value<String> lang;
  final Value<int> version;
  final Value<int> rowid;
  const L10nBundleMetaCompanion({
    this.lang = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  L10nBundleMetaCompanion.insert({
    required String lang,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : lang = Value(lang);
  static Insertable<L10nBundleMetaData> custom({
    Expression<String>? lang,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lang != null) 'lang': lang,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  L10nBundleMetaCompanion copyWith(
      {Value<String>? lang, Value<int>? version, Value<int>? rowid}) {
    return L10nBundleMetaCompanion(
      lang: lang ?? this.lang,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lang.present) {
      map['lang'] = Variable<String>(lang.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('L10nBundleMetaCompanion(')
          ..write('lang: $lang, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$L10nDatabase extends GeneratedDatabase {
  _$L10nDatabase(QueryExecutor e) : super(e);
  $L10nDatabaseManager get managers => $L10nDatabaseManager(this);
  late final $L10nTranslationsTable l10nTranslations =
      $L10nTranslationsTable(this);
  late final $L10nBundleMetaTable l10nBundleMeta = $L10nBundleMetaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [l10nTranslations, l10nBundleMeta];
}

typedef $$L10nTranslationsTableCreateCompanionBuilder
    = L10nTranslationsCompanion Function({
  required String lang,
  required String entryKey,
  required String value,
  Value<int> rowid,
});
typedef $$L10nTranslationsTableUpdateCompanionBuilder
    = L10nTranslationsCompanion Function({
  Value<String> lang,
  Value<String> entryKey,
  Value<String> value,
  Value<int> rowid,
});

class $$L10nTranslationsTableFilterComposer
    extends Composer<_$L10nDatabase, $L10nTranslationsTable> {
  $$L10nTranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get lang => $composableBuilder(
      column: $table.lang, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entryKey => $composableBuilder(
      column: $table.entryKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$L10nTranslationsTableOrderingComposer
    extends Composer<_$L10nDatabase, $L10nTranslationsTable> {
  $$L10nTranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get lang => $composableBuilder(
      column: $table.lang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entryKey => $composableBuilder(
      column: $table.entryKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$L10nTranslationsTableAnnotationComposer
    extends Composer<_$L10nDatabase, $L10nTranslationsTable> {
  $$L10nTranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get lang =>
      $composableBuilder(column: $table.lang, builder: (column) => column);

  GeneratedColumn<String> get entryKey =>
      $composableBuilder(column: $table.entryKey, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$L10nTranslationsTableTableManager extends RootTableManager<
    _$L10nDatabase,
    $L10nTranslationsTable,
    L10nTranslation,
    $$L10nTranslationsTableFilterComposer,
    $$L10nTranslationsTableOrderingComposer,
    $$L10nTranslationsTableAnnotationComposer,
    $$L10nTranslationsTableCreateCompanionBuilder,
    $$L10nTranslationsTableUpdateCompanionBuilder,
    (
      L10nTranslation,
      BaseReferences<_$L10nDatabase, $L10nTranslationsTable, L10nTranslation>
    ),
    L10nTranslation,
    PrefetchHooks Function()> {
  $$L10nTranslationsTableTableManager(
      _$L10nDatabase db, $L10nTranslationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$L10nTranslationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$L10nTranslationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$L10nTranslationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> lang = const Value.absent(),
            Value<String> entryKey = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              L10nTranslationsCompanion(
            lang: lang,
            entryKey: entryKey,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String lang,
            required String entryKey,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              L10nTranslationsCompanion.insert(
            lang: lang,
            entryKey: entryKey,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$L10nTranslationsTable, L10nTranslation>(table),
                    BaseReferences<_$L10nDatabase, $L10nTranslationsTable,
                        L10nTranslation>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$L10nTranslationsTableProcessedTableManager = ProcessedTableManager<
    _$L10nDatabase,
    $L10nTranslationsTable,
    L10nTranslation,
    $$L10nTranslationsTableFilterComposer,
    $$L10nTranslationsTableOrderingComposer,
    $$L10nTranslationsTableAnnotationComposer,
    $$L10nTranslationsTableCreateCompanionBuilder,
    $$L10nTranslationsTableUpdateCompanionBuilder,
    (
      L10nTranslation,
      BaseReferences<_$L10nDatabase, $L10nTranslationsTable, L10nTranslation>
    ),
    L10nTranslation,
    PrefetchHooks Function()>;
typedef $$L10nBundleMetaTableCreateCompanionBuilder = L10nBundleMetaCompanion
    Function({
  required String lang,
  Value<int> version,
  Value<int> rowid,
});
typedef $$L10nBundleMetaTableUpdateCompanionBuilder = L10nBundleMetaCompanion
    Function({
  Value<String> lang,
  Value<int> version,
  Value<int> rowid,
});

class $$L10nBundleMetaTableFilterComposer
    extends Composer<_$L10nDatabase, $L10nBundleMetaTable> {
  $$L10nBundleMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get lang => $composableBuilder(
      column: $table.lang, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$L10nBundleMetaTableOrderingComposer
    extends Composer<_$L10nDatabase, $L10nBundleMetaTable> {
  $$L10nBundleMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get lang => $composableBuilder(
      column: $table.lang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$L10nBundleMetaTableAnnotationComposer
    extends Composer<_$L10nDatabase, $L10nBundleMetaTable> {
  $$L10nBundleMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get lang =>
      $composableBuilder(column: $table.lang, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$L10nBundleMetaTableTableManager extends RootTableManager<
    _$L10nDatabase,
    $L10nBundleMetaTable,
    L10nBundleMetaData,
    $$L10nBundleMetaTableFilterComposer,
    $$L10nBundleMetaTableOrderingComposer,
    $$L10nBundleMetaTableAnnotationComposer,
    $$L10nBundleMetaTableCreateCompanionBuilder,
    $$L10nBundleMetaTableUpdateCompanionBuilder,
    (
      L10nBundleMetaData,
      BaseReferences<_$L10nDatabase, $L10nBundleMetaTable, L10nBundleMetaData>
    ),
    L10nBundleMetaData,
    PrefetchHooks Function()> {
  $$L10nBundleMetaTableTableManager(
      _$L10nDatabase db, $L10nBundleMetaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$L10nBundleMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$L10nBundleMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$L10nBundleMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> lang = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              L10nBundleMetaCompanion(
            lang: lang,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String lang,
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              L10nBundleMetaCompanion.insert(
            lang: lang,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$L10nBundleMetaTable, L10nBundleMetaData>(
                        table),
                    BaseReferences<_$L10nDatabase, $L10nBundleMetaTable,
                        L10nBundleMetaData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$L10nBundleMetaTableProcessedTableManager = ProcessedTableManager<
    _$L10nDatabase,
    $L10nBundleMetaTable,
    L10nBundleMetaData,
    $$L10nBundleMetaTableFilterComposer,
    $$L10nBundleMetaTableOrderingComposer,
    $$L10nBundleMetaTableAnnotationComposer,
    $$L10nBundleMetaTableCreateCompanionBuilder,
    $$L10nBundleMetaTableUpdateCompanionBuilder,
    (
      L10nBundleMetaData,
      BaseReferences<_$L10nDatabase, $L10nBundleMetaTable, L10nBundleMetaData>
    ),
    L10nBundleMetaData,
    PrefetchHooks Function()>;

class $L10nDatabaseManager {
  final _$L10nDatabase _db;
  $L10nDatabaseManager(this._db);
  $$L10nTranslationsTableTableManager get l10nTranslations =>
      $$L10nTranslationsTableTableManager(_db, _db.l10nTranslations);
  $$L10nBundleMetaTableTableManager get l10nBundleMeta =>
      $$L10nBundleMetaTableTableManager(_db, _db.l10nBundleMeta);
}
