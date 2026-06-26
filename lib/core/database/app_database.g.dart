// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GeneratedDesignsTable extends GeneratedDesigns
    with TableInfo<$GeneratedDesignsTable, GeneratedDesign> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GeneratedDesignsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _beforePathMeta = const VerificationMeta(
    'beforePath',
  );
  @override
  late final GeneratedColumn<String> beforePath = GeneratedColumn<String>(
    'before_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _afterPathMeta = const VerificationMeta(
    'afterPath',
  );
  @override
  late final GeneratedColumn<String> afterPath = GeneratedColumn<String>(
    'after_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _styleIdMeta = const VerificationMeta(
    'styleId',
  );
  @override
  late final GeneratedColumn<String> styleId = GeneratedColumn<String>(
    'style_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paletteIdMeta = const VerificationMeta(
    'paletteId',
  );
  @override
  late final GeneratedColumn<String> paletteId = GeneratedColumn<String>(
    'palette_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wishesMeta = const VerificationMeta('wishes');
  @override
  late final GeneratedColumn<String> wishes = GeneratedColumn<String>(
    'wishes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    beforePath,
    afterPath,
    styleId,
    paletteId,
    wishes,
    createdAt,
    isFavorite,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'generated_designs';
  @override
  VerificationContext validateIntegrity(
    Insertable<GeneratedDesign> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('before_path')) {
      context.handle(
        _beforePathMeta,
        beforePath.isAcceptableOrUnknown(data['before_path']!, _beforePathMeta),
      );
    } else if (isInserting) {
      context.missing(_beforePathMeta);
    }
    if (data.containsKey('after_path')) {
      context.handle(
        _afterPathMeta,
        afterPath.isAcceptableOrUnknown(data['after_path']!, _afterPathMeta),
      );
    } else if (isInserting) {
      context.missing(_afterPathMeta);
    }
    if (data.containsKey('style_id')) {
      context.handle(
        _styleIdMeta,
        styleId.isAcceptableOrUnknown(data['style_id']!, _styleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_styleIdMeta);
    }
    if (data.containsKey('palette_id')) {
      context.handle(
        _paletteIdMeta,
        paletteId.isAcceptableOrUnknown(data['palette_id']!, _paletteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_paletteIdMeta);
    }
    if (data.containsKey('wishes')) {
      context.handle(
        _wishesMeta,
        wishes.isAcceptableOrUnknown(data['wishes']!, _wishesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GeneratedDesign map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GeneratedDesign(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      beforePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}before_path'],
      )!,
      afterPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}after_path'],
      )!,
      styleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}style_id'],
      )!,
      paletteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}palette_id'],
      )!,
      wishes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wishes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
    );
  }

  @override
  $GeneratedDesignsTable createAlias(String alias) {
    return $GeneratedDesignsTable(attachedDatabase, alias);
  }
}

class GeneratedDesign extends DataClass implements Insertable<GeneratedDesign> {
  final int id;
  final String category;
  final String beforePath;
  final String afterPath;
  final String styleId;
  final String paletteId;
  final String wishes;
  final DateTime createdAt;
  final bool isFavorite;
  const GeneratedDesign({
    required this.id,
    required this.category,
    required this.beforePath,
    required this.afterPath,
    required this.styleId,
    required this.paletteId,
    required this.wishes,
    required this.createdAt,
    required this.isFavorite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category'] = Variable<String>(category);
    map['before_path'] = Variable<String>(beforePath);
    map['after_path'] = Variable<String>(afterPath);
    map['style_id'] = Variable<String>(styleId);
    map['palette_id'] = Variable<String>(paletteId);
    map['wishes'] = Variable<String>(wishes);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  GeneratedDesignsCompanion toCompanion(bool nullToAbsent) {
    return GeneratedDesignsCompanion(
      id: Value(id),
      category: Value(category),
      beforePath: Value(beforePath),
      afterPath: Value(afterPath),
      styleId: Value(styleId),
      paletteId: Value(paletteId),
      wishes: Value(wishes),
      createdAt: Value(createdAt),
      isFavorite: Value(isFavorite),
    );
  }

  factory GeneratedDesign.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GeneratedDesign(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      beforePath: serializer.fromJson<String>(json['beforePath']),
      afterPath: serializer.fromJson<String>(json['afterPath']),
      styleId: serializer.fromJson<String>(json['styleId']),
      paletteId: serializer.fromJson<String>(json['paletteId']),
      wishes: serializer.fromJson<String>(json['wishes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(category),
      'beforePath': serializer.toJson<String>(beforePath),
      'afterPath': serializer.toJson<String>(afterPath),
      'styleId': serializer.toJson<String>(styleId),
      'paletteId': serializer.toJson<String>(paletteId),
      'wishes': serializer.toJson<String>(wishes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  GeneratedDesign copyWith({
    int? id,
    String? category,
    String? beforePath,
    String? afterPath,
    String? styleId,
    String? paletteId,
    String? wishes,
    DateTime? createdAt,
    bool? isFavorite,
  }) => GeneratedDesign(
    id: id ?? this.id,
    category: category ?? this.category,
    beforePath: beforePath ?? this.beforePath,
    afterPath: afterPath ?? this.afterPath,
    styleId: styleId ?? this.styleId,
    paletteId: paletteId ?? this.paletteId,
    wishes: wishes ?? this.wishes,
    createdAt: createdAt ?? this.createdAt,
    isFavorite: isFavorite ?? this.isFavorite,
  );
  GeneratedDesign copyWithCompanion(GeneratedDesignsCompanion data) {
    return GeneratedDesign(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      beforePath: data.beforePath.present
          ? data.beforePath.value
          : this.beforePath,
      afterPath: data.afterPath.present ? data.afterPath.value : this.afterPath,
      styleId: data.styleId.present ? data.styleId.value : this.styleId,
      paletteId: data.paletteId.present ? data.paletteId.value : this.paletteId,
      wishes: data.wishes.present ? data.wishes.value : this.wishes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GeneratedDesign(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('beforePath: $beforePath, ')
          ..write('afterPath: $afterPath, ')
          ..write('styleId: $styleId, ')
          ..write('paletteId: $paletteId, ')
          ..write('wishes: $wishes, ')
          ..write('createdAt: $createdAt, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    category,
    beforePath,
    afterPath,
    styleId,
    paletteId,
    wishes,
    createdAt,
    isFavorite,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GeneratedDesign &&
          other.id == this.id &&
          other.category == this.category &&
          other.beforePath == this.beforePath &&
          other.afterPath == this.afterPath &&
          other.styleId == this.styleId &&
          other.paletteId == this.paletteId &&
          other.wishes == this.wishes &&
          other.createdAt == this.createdAt &&
          other.isFavorite == this.isFavorite);
}

class GeneratedDesignsCompanion extends UpdateCompanion<GeneratedDesign> {
  final Value<int> id;
  final Value<String> category;
  final Value<String> beforePath;
  final Value<String> afterPath;
  final Value<String> styleId;
  final Value<String> paletteId;
  final Value<String> wishes;
  final Value<DateTime> createdAt;
  final Value<bool> isFavorite;
  const GeneratedDesignsCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.beforePath = const Value.absent(),
    this.afterPath = const Value.absent(),
    this.styleId = const Value.absent(),
    this.paletteId = const Value.absent(),
    this.wishes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isFavorite = const Value.absent(),
  });
  GeneratedDesignsCompanion.insert({
    this.id = const Value.absent(),
    required String category,
    required String beforePath,
    required String afterPath,
    required String styleId,
    required String paletteId,
    this.wishes = const Value.absent(),
    required DateTime createdAt,
    this.isFavorite = const Value.absent(),
  }) : category = Value(category),
       beforePath = Value(beforePath),
       afterPath = Value(afterPath),
       styleId = Value(styleId),
       paletteId = Value(paletteId),
       createdAt = Value(createdAt);
  static Insertable<GeneratedDesign> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<String>? beforePath,
    Expression<String>? afterPath,
    Expression<String>? styleId,
    Expression<String>? paletteId,
    Expression<String>? wishes,
    Expression<DateTime>? createdAt,
    Expression<bool>? isFavorite,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (beforePath != null) 'before_path': beforePath,
      if (afterPath != null) 'after_path': afterPath,
      if (styleId != null) 'style_id': styleId,
      if (paletteId != null) 'palette_id': paletteId,
      if (wishes != null) 'wishes': wishes,
      if (createdAt != null) 'created_at': createdAt,
      if (isFavorite != null) 'is_favorite': isFavorite,
    });
  }

  GeneratedDesignsCompanion copyWith({
    Value<int>? id,
    Value<String>? category,
    Value<String>? beforePath,
    Value<String>? afterPath,
    Value<String>? styleId,
    Value<String>? paletteId,
    Value<String>? wishes,
    Value<DateTime>? createdAt,
    Value<bool>? isFavorite,
  }) {
    return GeneratedDesignsCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      beforePath: beforePath ?? this.beforePath,
      afterPath: afterPath ?? this.afterPath,
      styleId: styleId ?? this.styleId,
      paletteId: paletteId ?? this.paletteId,
      wishes: wishes ?? this.wishes,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (beforePath.present) {
      map['before_path'] = Variable<String>(beforePath.value);
    }
    if (afterPath.present) {
      map['after_path'] = Variable<String>(afterPath.value);
    }
    if (styleId.present) {
      map['style_id'] = Variable<String>(styleId.value);
    }
    if (paletteId.present) {
      map['palette_id'] = Variable<String>(paletteId.value);
    }
    if (wishes.present) {
      map['wishes'] = Variable<String>(wishes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GeneratedDesignsCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('beforePath: $beforePath, ')
          ..write('afterPath: $afterPath, ')
          ..write('styleId: $styleId, ')
          ..write('paletteId: $paletteId, ')
          ..write('wishes: $wishes, ')
          ..write('createdAt: $createdAt, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GeneratedDesignsTable generatedDesigns = $GeneratedDesignsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [generatedDesigns];
}

typedef $$GeneratedDesignsTableCreateCompanionBuilder =
    GeneratedDesignsCompanion Function({
      Value<int> id,
      required String category,
      required String beforePath,
      required String afterPath,
      required String styleId,
      required String paletteId,
      Value<String> wishes,
      required DateTime createdAt,
      Value<bool> isFavorite,
    });
typedef $$GeneratedDesignsTableUpdateCompanionBuilder =
    GeneratedDesignsCompanion Function({
      Value<int> id,
      Value<String> category,
      Value<String> beforePath,
      Value<String> afterPath,
      Value<String> styleId,
      Value<String> paletteId,
      Value<String> wishes,
      Value<DateTime> createdAt,
      Value<bool> isFavorite,
    });

class $$GeneratedDesignsTableFilterComposer
    extends Composer<_$AppDatabase, $GeneratedDesignsTable> {
  $$GeneratedDesignsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get beforePath => $composableBuilder(
    column: $table.beforePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get afterPath => $composableBuilder(
    column: $table.afterPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get styleId => $composableBuilder(
    column: $table.styleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paletteId => $composableBuilder(
    column: $table.paletteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wishes => $composableBuilder(
    column: $table.wishes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GeneratedDesignsTableOrderingComposer
    extends Composer<_$AppDatabase, $GeneratedDesignsTable> {
  $$GeneratedDesignsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get beforePath => $composableBuilder(
    column: $table.beforePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get afterPath => $composableBuilder(
    column: $table.afterPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get styleId => $composableBuilder(
    column: $table.styleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paletteId => $composableBuilder(
    column: $table.paletteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wishes => $composableBuilder(
    column: $table.wishes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GeneratedDesignsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GeneratedDesignsTable> {
  $$GeneratedDesignsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get beforePath => $composableBuilder(
    column: $table.beforePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get afterPath =>
      $composableBuilder(column: $table.afterPath, builder: (column) => column);

  GeneratedColumn<String> get styleId =>
      $composableBuilder(column: $table.styleId, builder: (column) => column);

  GeneratedColumn<String> get paletteId =>
      $composableBuilder(column: $table.paletteId, builder: (column) => column);

  GeneratedColumn<String> get wishes =>
      $composableBuilder(column: $table.wishes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );
}

class $$GeneratedDesignsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GeneratedDesignsTable,
          GeneratedDesign,
          $$GeneratedDesignsTableFilterComposer,
          $$GeneratedDesignsTableOrderingComposer,
          $$GeneratedDesignsTableAnnotationComposer,
          $$GeneratedDesignsTableCreateCompanionBuilder,
          $$GeneratedDesignsTableUpdateCompanionBuilder,
          (
            GeneratedDesign,
            BaseReferences<
              _$AppDatabase,
              $GeneratedDesignsTable,
              GeneratedDesign
            >,
          ),
          GeneratedDesign,
          PrefetchHooks Function()
        > {
  $$GeneratedDesignsTableTableManager(
    _$AppDatabase db,
    $GeneratedDesignsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GeneratedDesignsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GeneratedDesignsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GeneratedDesignsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> beforePath = const Value.absent(),
                Value<String> afterPath = const Value.absent(),
                Value<String> styleId = const Value.absent(),
                Value<String> paletteId = const Value.absent(),
                Value<String> wishes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
              }) => GeneratedDesignsCompanion(
                id: id,
                category: category,
                beforePath: beforePath,
                afterPath: afterPath,
                styleId: styleId,
                paletteId: paletteId,
                wishes: wishes,
                createdAt: createdAt,
                isFavorite: isFavorite,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String category,
                required String beforePath,
                required String afterPath,
                required String styleId,
                required String paletteId,
                Value<String> wishes = const Value.absent(),
                required DateTime createdAt,
                Value<bool> isFavorite = const Value.absent(),
              }) => GeneratedDesignsCompanion.insert(
                id: id,
                category: category,
                beforePath: beforePath,
                afterPath: afterPath,
                styleId: styleId,
                paletteId: paletteId,
                wishes: wishes,
                createdAt: createdAt,
                isFavorite: isFavorite,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GeneratedDesignsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GeneratedDesignsTable,
      GeneratedDesign,
      $$GeneratedDesignsTableFilterComposer,
      $$GeneratedDesignsTableOrderingComposer,
      $$GeneratedDesignsTableAnnotationComposer,
      $$GeneratedDesignsTableCreateCompanionBuilder,
      $$GeneratedDesignsTableUpdateCompanionBuilder,
      (
        GeneratedDesign,
        BaseReferences<_$AppDatabase, $GeneratedDesignsTable, GeneratedDesign>,
      ),
      GeneratedDesign,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GeneratedDesignsTableTableManager get generatedDesigns =>
      $$GeneratedDesignsTableTableManager(_db, _db.generatedDesigns);
}
