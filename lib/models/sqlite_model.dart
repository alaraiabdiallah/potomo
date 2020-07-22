import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:sqfentity/sqfentity.dart';

part 'sqlite_model.g.dart';

const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
);

const tableTaks = SqfEntityTable(
    tableName: 'tasks',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    fields: [
      SqfEntityField('title', DbType.text),
      SqfEntityField('description', DbType.text),
      SqfEntityField('date', DbType.date),
      SqfEntityField('time_do_at', DbType.datetime)
    ]
);

@SqfEntityBuilder(potomoDB)
const potomoDB = SqfEntityModel(
  sequences: [seqIdentity],
  databaseName: "potomo.db",
  databaseTables: [tableTaks]
);