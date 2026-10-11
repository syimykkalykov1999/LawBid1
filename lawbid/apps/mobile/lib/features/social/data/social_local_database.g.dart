// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_local_database.dart';

// ignore_for_file: type=lint
class $CachedPagesTable extends CachedPages
    with TableInfo<$CachedPagesTable, CachedPageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedPagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
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
  List<GeneratedColumn> get $columns => [key, json, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_pages';
  @override
  VerificationContext validateIntegrity(Insertable<CachedPageRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
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
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  CachedPageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedPageRow(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      json: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}json'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CachedPagesTable createAlias(String alias) {
    return $CachedPagesTable(attachedDatabase, alias);
  }
}

class CachedPageRow extends DataClass implements Insertable<CachedPageRow> {
  final String key;
  final String json;
  final DateTime updatedAt;
  const CachedPageRow(
      {required this.key, required this.json, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['json'] = Variable<String>(json);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CachedPagesCompanion toCompanion(bool nullToAbsent) {
    return CachedPagesCompanion(
      key: Value(key),
      json: Value(json),
      updatedAt: Value(updatedAt),
    );
  }

  factory CachedPageRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedPageRow(
      key: serializer.fromJson<String>(json['key']),
      json: serializer.fromJson<String>(json['json']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'json': serializer.toJson<String>(json),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CachedPageRow copyWith({String? key, String? json, DateTime? updatedAt}) =>
      CachedPageRow(
        key: key ?? this.key,
        json: json ?? this.json,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CachedPageRow copyWithCompanion(CachedPagesCompanion data) {
    return CachedPageRow(
      key: data.key.present ? data.key.value : this.key,
      json: data.json.present ? data.json.value : this.json,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedPageRow(')
          ..write('key: $key, ')
          ..write('json: $json, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, json, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedPageRow &&
          other.key == this.key &&
          other.json == this.json &&
          other.updatedAt == this.updatedAt);
}

class CachedPagesCompanion extends UpdateCompanion<CachedPageRow> {
  final Value<String> key;
  final Value<String> json;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CachedPagesCompanion({
    this.key = const Value.absent(),
    this.json = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedPagesCompanion.insert({
    required String key,
    required String json,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        json = Value(json),
        updatedAt = Value(updatedAt);
  static Insertable<CachedPageRow> custom({
    Expression<String>? key,
    Expression<String>? json,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (json != null) 'json': json,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedPagesCompanion copyWith(
      {Value<String>? key,
      Value<String>? json,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return CachedPagesCompanion(
      key: key ?? this.key,
      json: json ?? this.json,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
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
    return (StringBuffer('CachedPagesCompanion(')
          ..write('key: $key, ')
          ..write('json: $json, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatOutboxTable extends ChatOutbox
    with TableInfo<$ChatOutboxTable, OutboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientMessageIdMeta =
      const VerificationMeta('clientMessageId');
  @override
  late final GeneratedColumn<String> clientMessageId = GeneratedColumn<String>(
      'client_message_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _conversationIdMeta =
      const VerificationMeta('conversationId');
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
      'conversation_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _failedCodeMeta =
      const VerificationMeta('failedCode');
  @override
  late final GeneratedColumn<String> failedCode = GeneratedColumn<String>(
      'failed_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        clientMessageId,
        ownerId,
        conversationId,
        body,
        createdAt,
        attempts,
        failedCode
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_outbox';
  @override
  VerificationContext validateIntegrity(Insertable<OutboxRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_message_id')) {
      context.handle(
          _clientMessageIdMeta,
          clientMessageId.isAcceptableOrUnknown(
              data['client_message_id']!, _clientMessageIdMeta));
    } else if (isInserting) {
      context.missing(_clientMessageIdMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
          _conversationIdMeta,
          conversationId.isAcceptableOrUnknown(
              data['conversation_id']!, _conversationIdMeta));
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    if (data.containsKey('failed_code')) {
      context.handle(
          _failedCodeMeta,
          failedCode.isAcceptableOrUnknown(
              data['failed_code']!, _failedCodeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientMessageId};
  @override
  OutboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxRow(
      clientMessageId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}client_message_id'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      conversationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}conversation_id'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      failedCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}failed_code']),
    );
  }

  @override
  $ChatOutboxTable createAlias(String alias) {
    return $ChatOutboxTable(attachedDatabase, alias);
  }
}

class OutboxRow extends DataClass implements Insertable<OutboxRow> {
  final String clientMessageId;
  final String ownerId;
  final String conversationId;
  final String body;
  final DateTime createdAt;
  final int attempts;

  /// Refused by the server for good (closed chat, too long …): kept to
  /// show "не отправлено", never retried automatically.
  final String? failedCode;
  const OutboxRow(
      {required this.clientMessageId,
      required this.ownerId,
      required this.conversationId,
      required this.body,
      required this.createdAt,
      required this.attempts,
      this.failedCode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_message_id'] = Variable<String>(clientMessageId);
    map['owner_id'] = Variable<String>(ownerId);
    map['conversation_id'] = Variable<String>(conversationId);
    map['body'] = Variable<String>(body);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || failedCode != null) {
      map['failed_code'] = Variable<String>(failedCode);
    }
    return map;
  }

  ChatOutboxCompanion toCompanion(bool nullToAbsent) {
    return ChatOutboxCompanion(
      clientMessageId: Value(clientMessageId),
      ownerId: Value(ownerId),
      conversationId: Value(conversationId),
      body: Value(body),
      createdAt: Value(createdAt),
      attempts: Value(attempts),
      failedCode: failedCode == null && nullToAbsent
          ? const Value.absent()
          : Value(failedCode),
    );
  }

  factory OutboxRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxRow(
      clientMessageId: serializer.fromJson<String>(json['clientMessageId']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      body: serializer.fromJson<String>(json['body']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      failedCode: serializer.fromJson<String?>(json['failedCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientMessageId': serializer.toJson<String>(clientMessageId),
      'ownerId': serializer.toJson<String>(ownerId),
      'conversationId': serializer.toJson<String>(conversationId),
      'body': serializer.toJson<String>(body),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attempts': serializer.toJson<int>(attempts),
      'failedCode': serializer.toJson<String?>(failedCode),
    };
  }

  OutboxRow copyWith(
          {String? clientMessageId,
          String? ownerId,
          String? conversationId,
          String? body,
          DateTime? createdAt,
          int? attempts,
          Value<String?> failedCode = const Value.absent()}) =>
      OutboxRow(
        clientMessageId: clientMessageId ?? this.clientMessageId,
        ownerId: ownerId ?? this.ownerId,
        conversationId: conversationId ?? this.conversationId,
        body: body ?? this.body,
        createdAt: createdAt ?? this.createdAt,
        attempts: attempts ?? this.attempts,
        failedCode: failedCode.present ? failedCode.value : this.failedCode,
      );
  OutboxRow copyWithCompanion(ChatOutboxCompanion data) {
    return OutboxRow(
      clientMessageId: data.clientMessageId.present
          ? data.clientMessageId.value
          : this.clientMessageId,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      body: data.body.present ? data.body.value : this.body,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      failedCode:
          data.failedCode.present ? data.failedCode.value : this.failedCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxRow(')
          ..write('clientMessageId: $clientMessageId, ')
          ..write('ownerId: $ownerId, ')
          ..write('conversationId: $conversationId, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('failedCode: $failedCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(clientMessageId, ownerId, conversationId,
      body, createdAt, attempts, failedCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxRow &&
          other.clientMessageId == this.clientMessageId &&
          other.ownerId == this.ownerId &&
          other.conversationId == this.conversationId &&
          other.body == this.body &&
          other.createdAt == this.createdAt &&
          other.attempts == this.attempts &&
          other.failedCode == this.failedCode);
}

class ChatOutboxCompanion extends UpdateCompanion<OutboxRow> {
  final Value<String> clientMessageId;
  final Value<String> ownerId;
  final Value<String> conversationId;
  final Value<String> body;
  final Value<DateTime> createdAt;
  final Value<int> attempts;
  final Value<String?> failedCode;
  final Value<int> rowid;
  const ChatOutboxCompanion({
    this.clientMessageId = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.failedCode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatOutboxCompanion.insert({
    required String clientMessageId,
    required String ownerId,
    required String conversationId,
    required String body,
    required DateTime createdAt,
    this.attempts = const Value.absent(),
    this.failedCode = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : clientMessageId = Value(clientMessageId),
        ownerId = Value(ownerId),
        conversationId = Value(conversationId),
        body = Value(body),
        createdAt = Value(createdAt);
  static Insertable<OutboxRow> custom({
    Expression<String>? clientMessageId,
    Expression<String>? ownerId,
    Expression<String>? conversationId,
    Expression<String>? body,
    Expression<DateTime>? createdAt,
    Expression<int>? attempts,
    Expression<String>? failedCode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientMessageId != null) 'client_message_id': clientMessageId,
      if (ownerId != null) 'owner_id': ownerId,
      if (conversationId != null) 'conversation_id': conversationId,
      if (body != null) 'body': body,
      if (createdAt != null) 'created_at': createdAt,
      if (attempts != null) 'attempts': attempts,
      if (failedCode != null) 'failed_code': failedCode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatOutboxCompanion copyWith(
      {Value<String>? clientMessageId,
      Value<String>? ownerId,
      Value<String>? conversationId,
      Value<String>? body,
      Value<DateTime>? createdAt,
      Value<int>? attempts,
      Value<String?>? failedCode,
      Value<int>? rowid}) {
    return ChatOutboxCompanion(
      clientMessageId: clientMessageId ?? this.clientMessageId,
      ownerId: ownerId ?? this.ownerId,
      conversationId: conversationId ?? this.conversationId,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      attempts: attempts ?? this.attempts,
      failedCode: failedCode ?? this.failedCode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientMessageId.present) {
      map['client_message_id'] = Variable<String>(clientMessageId.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (failedCode.present) {
      map['failed_code'] = Variable<String>(failedCode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatOutboxCompanion(')
          ..write('clientMessageId: $clientMessageId, ')
          ..write('ownerId: $ownerId, ')
          ..write('conversationId: $conversationId, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('failedCode: $failedCode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecentSearchesTable extends RecentSearches
    with TableInfo<$RecentSearchesTable, RecentSearchRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecentSearchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _queryMeta = const VerificationMeta('query');
  @override
  late final GeneratedColumn<String> query = GeneratedColumn<String>(
      'query', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usedAtMeta = const VerificationMeta('usedAt');
  @override
  late final GeneratedColumn<DateTime> usedAt = GeneratedColumn<DateTime>(
      'used_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [ownerId, query, usedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recent_searches';
  @override
  VerificationContext validateIntegrity(Insertable<RecentSearchRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('query')) {
      context.handle(
          _queryMeta, query.isAcceptableOrUnknown(data['query']!, _queryMeta));
    } else if (isInserting) {
      context.missing(_queryMeta);
    }
    if (data.containsKey('used_at')) {
      context.handle(_usedAtMeta,
          usedAt.isAcceptableOrUnknown(data['used_at']!, _usedAtMeta));
    } else if (isInserting) {
      context.missing(_usedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ownerId, query};
  @override
  RecentSearchRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecentSearchRow(
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      query: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}query'])!,
      usedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}used_at'])!,
    );
  }

  @override
  $RecentSearchesTable createAlias(String alias) {
    return $RecentSearchesTable(attachedDatabase, alias);
  }
}

class RecentSearchRow extends DataClass implements Insertable<RecentSearchRow> {
  final String ownerId;
  final String query;
  final DateTime usedAt;
  const RecentSearchRow(
      {required this.ownerId, required this.query, required this.usedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['owner_id'] = Variable<String>(ownerId);
    map['query'] = Variable<String>(query);
    map['used_at'] = Variable<DateTime>(usedAt);
    return map;
  }

  RecentSearchesCompanion toCompanion(bool nullToAbsent) {
    return RecentSearchesCompanion(
      ownerId: Value(ownerId),
      query: Value(query),
      usedAt: Value(usedAt),
    );
  }

  factory RecentSearchRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecentSearchRow(
      ownerId: serializer.fromJson<String>(json['ownerId']),
      query: serializer.fromJson<String>(json['query']),
      usedAt: serializer.fromJson<DateTime>(json['usedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ownerId': serializer.toJson<String>(ownerId),
      'query': serializer.toJson<String>(query),
      'usedAt': serializer.toJson<DateTime>(usedAt),
    };
  }

  RecentSearchRow copyWith(
          {String? ownerId, String? query, DateTime? usedAt}) =>
      RecentSearchRow(
        ownerId: ownerId ?? this.ownerId,
        query: query ?? this.query,
        usedAt: usedAt ?? this.usedAt,
      );
  RecentSearchRow copyWithCompanion(RecentSearchesCompanion data) {
    return RecentSearchRow(
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      query: data.query.present ? data.query.value : this.query,
      usedAt: data.usedAt.present ? data.usedAt.value : this.usedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecentSearchRow(')
          ..write('ownerId: $ownerId, ')
          ..write('query: $query, ')
          ..write('usedAt: $usedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ownerId, query, usedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecentSearchRow &&
          other.ownerId == this.ownerId &&
          other.query == this.query &&
          other.usedAt == this.usedAt);
}

class RecentSearchesCompanion extends UpdateCompanion<RecentSearchRow> {
  final Value<String> ownerId;
  final Value<String> query;
  final Value<DateTime> usedAt;
  final Value<int> rowid;
  const RecentSearchesCompanion({
    this.ownerId = const Value.absent(),
    this.query = const Value.absent(),
    this.usedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecentSearchesCompanion.insert({
    required String ownerId,
    required String query,
    required DateTime usedAt,
    this.rowid = const Value.absent(),
  })  : ownerId = Value(ownerId),
        query = Value(query),
        usedAt = Value(usedAt);
  static Insertable<RecentSearchRow> custom({
    Expression<String>? ownerId,
    Expression<String>? query,
    Expression<DateTime>? usedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ownerId != null) 'owner_id': ownerId,
      if (query != null) 'query': query,
      if (usedAt != null) 'used_at': usedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecentSearchesCompanion copyWith(
      {Value<String>? ownerId,
      Value<String>? query,
      Value<DateTime>? usedAt,
      Value<int>? rowid}) {
    return RecentSearchesCompanion(
      ownerId: ownerId ?? this.ownerId,
      query: query ?? this.query,
      usedAt: usedAt ?? this.usedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (query.present) {
      map['query'] = Variable<String>(query.value);
    }
    if (usedAt.present) {
      map['used_at'] = Variable<DateTime>(usedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecentSearchesCompanion(')
          ..write('ownerId: $ownerId, ')
          ..write('query: $query, ')
          ..write('usedAt: $usedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$SocialLocalDatabase extends GeneratedDatabase {
  _$SocialLocalDatabase(QueryExecutor e) : super(e);
  $SocialLocalDatabaseManager get managers => $SocialLocalDatabaseManager(this);
  late final $CachedPagesTable cachedPages = $CachedPagesTable(this);
  late final $ChatOutboxTable chatOutbox = $ChatOutboxTable(this);
  late final $RecentSearchesTable recentSearches = $RecentSearchesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [cachedPages, chatOutbox, recentSearches];
}

typedef $$CachedPagesTableCreateCompanionBuilder = CachedPagesCompanion
    Function({
  required String key,
  required String json,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$CachedPagesTableUpdateCompanionBuilder = CachedPagesCompanion
    Function({
  Value<String> key,
  Value<String> json,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$CachedPagesTableFilterComposer
    extends Composer<_$SocialLocalDatabase, $CachedPagesTable> {
  $$CachedPagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get json => $composableBuilder(
      column: $table.json, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$CachedPagesTableOrderingComposer
    extends Composer<_$SocialLocalDatabase, $CachedPagesTable> {
  $$CachedPagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get json => $composableBuilder(
      column: $table.json, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CachedPagesTableAnnotationComposer
    extends Composer<_$SocialLocalDatabase, $CachedPagesTable> {
  $$CachedPagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CachedPagesTableTableManager extends RootTableManager<
    _$SocialLocalDatabase,
    $CachedPagesTable,
    CachedPageRow,
    $$CachedPagesTableFilterComposer,
    $$CachedPagesTableOrderingComposer,
    $$CachedPagesTableAnnotationComposer,
    $$CachedPagesTableCreateCompanionBuilder,
    $$CachedPagesTableUpdateCompanionBuilder,
    (
      CachedPageRow,
      BaseReferences<_$SocialLocalDatabase, $CachedPagesTable, CachedPageRow>
    ),
    CachedPageRow,
    PrefetchHooks Function()> {
  $$CachedPagesTableTableManager(
      _$SocialLocalDatabase db, $CachedPagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedPagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedPagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedPagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> json = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedPagesCompanion(
            key: key,
            json: json,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String json,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedPagesCompanion.insert(
            key: key,
            json: json,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$CachedPagesTable, CachedPageRow>(table),
                    BaseReferences<_$SocialLocalDatabase, $CachedPagesTable,
                        CachedPageRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedPagesTableProcessedTableManager = ProcessedTableManager<
    _$SocialLocalDatabase,
    $CachedPagesTable,
    CachedPageRow,
    $$CachedPagesTableFilterComposer,
    $$CachedPagesTableOrderingComposer,
    $$CachedPagesTableAnnotationComposer,
    $$CachedPagesTableCreateCompanionBuilder,
    $$CachedPagesTableUpdateCompanionBuilder,
    (
      CachedPageRow,
      BaseReferences<_$SocialLocalDatabase, $CachedPagesTable, CachedPageRow>
    ),
    CachedPageRow,
    PrefetchHooks Function()>;
typedef $$ChatOutboxTableCreateCompanionBuilder = ChatOutboxCompanion Function({
  required String clientMessageId,
  required String ownerId,
  required String conversationId,
  required String body,
  required DateTime createdAt,
  Value<int> attempts,
  Value<String?> failedCode,
  Value<int> rowid,
});
typedef $$ChatOutboxTableUpdateCompanionBuilder = ChatOutboxCompanion Function({
  Value<String> clientMessageId,
  Value<String> ownerId,
  Value<String> conversationId,
  Value<String> body,
  Value<DateTime> createdAt,
  Value<int> attempts,
  Value<String?> failedCode,
  Value<int> rowid,
});

class $$ChatOutboxTableFilterComposer
    extends Composer<_$SocialLocalDatabase, $ChatOutboxTable> {
  $$ChatOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientMessageId => $composableBuilder(
      column: $table.clientMessageId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conversationId => $composableBuilder(
      column: $table.conversationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get failedCode => $composableBuilder(
      column: $table.failedCode, builder: (column) => ColumnFilters(column));
}

class $$ChatOutboxTableOrderingComposer
    extends Composer<_$SocialLocalDatabase, $ChatOutboxTable> {
  $$ChatOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientMessageId => $composableBuilder(
      column: $table.clientMessageId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conversationId => $composableBuilder(
      column: $table.conversationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get failedCode => $composableBuilder(
      column: $table.failedCode, builder: (column) => ColumnOrderings(column));
}

class $$ChatOutboxTableAnnotationComposer
    extends Composer<_$SocialLocalDatabase, $ChatOutboxTable> {
  $$ChatOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientMessageId => $composableBuilder(
      column: $table.clientMessageId, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
      column: $table.conversationId, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get failedCode => $composableBuilder(
      column: $table.failedCode, builder: (column) => column);
}

class $$ChatOutboxTableTableManager extends RootTableManager<
    _$SocialLocalDatabase,
    $ChatOutboxTable,
    OutboxRow,
    $$ChatOutboxTableFilterComposer,
    $$ChatOutboxTableOrderingComposer,
    $$ChatOutboxTableAnnotationComposer,
    $$ChatOutboxTableCreateCompanionBuilder,
    $$ChatOutboxTableUpdateCompanionBuilder,
    (
      OutboxRow,
      BaseReferences<_$SocialLocalDatabase, $ChatOutboxTable, OutboxRow>
    ),
    OutboxRow,
    PrefetchHooks Function()> {
  $$ChatOutboxTableTableManager(
      _$SocialLocalDatabase db, $ChatOutboxTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> clientMessageId = const Value.absent(),
            Value<String> ownerId = const Value.absent(),
            Value<String> conversationId = const Value.absent(),
            Value<String> body = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<String?> failedCode = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatOutboxCompanion(
            clientMessageId: clientMessageId,
            ownerId: ownerId,
            conversationId: conversationId,
            body: body,
            createdAt: createdAt,
            attempts: attempts,
            failedCode: failedCode,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String clientMessageId,
            required String ownerId,
            required String conversationId,
            required String body,
            required DateTime createdAt,
            Value<int> attempts = const Value.absent(),
            Value<String?> failedCode = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatOutboxCompanion.insert(
            clientMessageId: clientMessageId,
            ownerId: ownerId,
            conversationId: conversationId,
            body: body,
            createdAt: createdAt,
            attempts: attempts,
            failedCode: failedCode,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ChatOutboxTable, OutboxRow>(table),
                    BaseReferences<_$SocialLocalDatabase, $ChatOutboxTable,
                        OutboxRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChatOutboxTableProcessedTableManager = ProcessedTableManager<
    _$SocialLocalDatabase,
    $ChatOutboxTable,
    OutboxRow,
    $$ChatOutboxTableFilterComposer,
    $$ChatOutboxTableOrderingComposer,
    $$ChatOutboxTableAnnotationComposer,
    $$ChatOutboxTableCreateCompanionBuilder,
    $$ChatOutboxTableUpdateCompanionBuilder,
    (
      OutboxRow,
      BaseReferences<_$SocialLocalDatabase, $ChatOutboxTable, OutboxRow>
    ),
    OutboxRow,
    PrefetchHooks Function()>;
typedef $$RecentSearchesTableCreateCompanionBuilder = RecentSearchesCompanion
    Function({
  required String ownerId,
  required String query,
  required DateTime usedAt,
  Value<int> rowid,
});
typedef $$RecentSearchesTableUpdateCompanionBuilder = RecentSearchesCompanion
    Function({
  Value<String> ownerId,
  Value<String> query,
  Value<DateTime> usedAt,
  Value<int> rowid,
});

class $$RecentSearchesTableFilterComposer
    extends Composer<_$SocialLocalDatabase, $RecentSearchesTable> {
  $$RecentSearchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get query => $composableBuilder(
      column: $table.query, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get usedAt => $composableBuilder(
      column: $table.usedAt, builder: (column) => ColumnFilters(column));
}

class $$RecentSearchesTableOrderingComposer
    extends Composer<_$SocialLocalDatabase, $RecentSearchesTable> {
  $$RecentSearchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get query => $composableBuilder(
      column: $table.query, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get usedAt => $composableBuilder(
      column: $table.usedAt, builder: (column) => ColumnOrderings(column));
}

class $$RecentSearchesTableAnnotationComposer
    extends Composer<_$SocialLocalDatabase, $RecentSearchesTable> {
  $$RecentSearchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get query =>
      $composableBuilder(column: $table.query, builder: (column) => column);

  GeneratedColumn<DateTime> get usedAt =>
      $composableBuilder(column: $table.usedAt, builder: (column) => column);
}

class $$RecentSearchesTableTableManager extends RootTableManager<
    _$SocialLocalDatabase,
    $RecentSearchesTable,
    RecentSearchRow,
    $$RecentSearchesTableFilterComposer,
    $$RecentSearchesTableOrderingComposer,
    $$RecentSearchesTableAnnotationComposer,
    $$RecentSearchesTableCreateCompanionBuilder,
    $$RecentSearchesTableUpdateCompanionBuilder,
    (
      RecentSearchRow,
      BaseReferences<_$SocialLocalDatabase, $RecentSearchesTable,
          RecentSearchRow>
    ),
    RecentSearchRow,
    PrefetchHooks Function()> {
  $$RecentSearchesTableTableManager(
      _$SocialLocalDatabase db, $RecentSearchesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecentSearchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecentSearchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecentSearchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> ownerId = const Value.absent(),
            Value<String> query = const Value.absent(),
            Value<DateTime> usedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecentSearchesCompanion(
            ownerId: ownerId,
            query: query,
            usedAt: usedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String ownerId,
            required String query,
            required DateTime usedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RecentSearchesCompanion.insert(
            ownerId: ownerId,
            query: query,
            usedAt: usedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$RecentSearchesTable, RecentSearchRow>(table),
                    BaseReferences<_$SocialLocalDatabase, $RecentSearchesTable,
                        RecentSearchRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecentSearchesTableProcessedTableManager = ProcessedTableManager<
    _$SocialLocalDatabase,
    $RecentSearchesTable,
    RecentSearchRow,
    $$RecentSearchesTableFilterComposer,
    $$RecentSearchesTableOrderingComposer,
    $$RecentSearchesTableAnnotationComposer,
    $$RecentSearchesTableCreateCompanionBuilder,
    $$RecentSearchesTableUpdateCompanionBuilder,
    (
      RecentSearchRow,
      BaseReferences<_$SocialLocalDatabase, $RecentSearchesTable,
          RecentSearchRow>
    ),
    RecentSearchRow,
    PrefetchHooks Function()>;

class $SocialLocalDatabaseManager {
  final _$SocialLocalDatabase _db;
  $SocialLocalDatabaseManager(this._db);
  $$CachedPagesTableTableManager get cachedPages =>
      $$CachedPagesTableTableManager(_db, _db.cachedPages);
  $$ChatOutboxTableTableManager get chatOutbox =>
      $$ChatOutboxTableTableManager(_db, _db.chatOutbox);
  $$RecentSearchesTableTableManager get recentSearches =>
      $$RecentSearchesTableTableManager(_db, _db.recentSearches);
}
