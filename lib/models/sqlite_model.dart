import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:flutter/material.dart';


part 'sqlite_model.g.dart';

const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
);

const tableTasks = SqfEntityTable(
    tableName: 'tasks',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    fields: [
      SqfEntityField('title', DbType.text),
      SqfEntityField('description', DbType.text),
      SqfEntityField('date', DbType.date),
      SqfEntityField('time_do_at', DbType.datetime),
      SqfEntityField('is_done', DbType.bool, defaultValue: false),
    ]
);

const tableTaskChecklists = SqfEntityTable(
  tableName: 'taskchecklists',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: null,
  fields: [
    SqfEntityField('name', DbType.text),
    SqfEntityFieldRelationship(
        parentTable: tableTasks,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: 0),
    SqfEntityField('is_done', DbType.bool, defaultValue: false),
  ]
);

@SqfEntityBuilder(potomoDB)
const potomoDB = SqfEntityModel(
  sequences: [seqIdentity],
  databaseName: "potomo.db",
  databaseTables: [tableTasks, tableTaskChecklists]
);